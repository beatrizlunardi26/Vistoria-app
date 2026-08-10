// ============================================================
// Edge Function: criar-usuario
//
// Cria um novo usuário de login (Supabase Auth) + o registro
// correspondente na tabela engenheiras. Só funciona se quem está
// chamando já estiver logado como admin — a chave "service role"
// usada aqui nunca fica exposta ao navegador, só existe dentro
// desta função no servidor do Supabase.
//
// COMO PUBLICAR (sem precisar instalar nada no computador):
// 1. No painel do Supabase, menu lateral → "Edge Functions"
// 2. "Deploy a new function" / "Create a new function"
// 3. Nome da função: criar-usuario (tem que ser exatamente esse)
// 4. Cole este arquivo inteiro no editor
// 5. Deploy / Publicar
//
// Não precisa configurar nenhuma variável de ambiente manualmente —
// SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY já ficam disponíveis
// automaticamente dentro de toda Edge Function do projeto.
// ============================================================
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) throw new Error('Sem autorização — faça login novamente')

    const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)

    // Identifica quem está chamando a função a partir do token de login
    const jwt = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userErr } = await admin.auth.getUser(jwt)
    if (userErr || !user?.email) throw new Error('Sessão inválida — faça login novamente')

    // Só admin pode criar novos usuários
    const { data: engCaller } = await admin
      .from('engenheiras')
      .select('role')
      .eq('email', user.email)
      .single()

    if (!engCaller || engCaller.role !== 'admin') {
      return new Response(JSON.stringify({ error: 'Apenas administradores podem criar usuários' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { email, senha, nome, role } = await req.json()
    if (!email || !senha || !nome) throw new Error('Preencha nome, e-mail e senha')
    if (senha.length < 6) throw new Error('A senha precisa ter pelo menos 6 caracteres')

    const { data: novoUser, error: createErr } = await admin.auth.admin.createUser({
      email,
      password: senha,
      email_confirm: true, // não exige confirmação por e-mail, já entra confirmado
    })
    if (createErr) throw new Error(createErr.message)

    const { error: engErr } = await admin
      .from('engenheiras')
      .insert({ email, nome, role: role === 'admin' ? 'admin' : 'usuario' })
    if (engErr) throw new Error(engErr.message)

    return new Response(JSON.stringify({ ok: true, id: novoUser.user.id }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
