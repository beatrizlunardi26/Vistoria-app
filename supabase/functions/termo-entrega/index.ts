// ============================================================
// Edge Function: termo-entrega
//
// Atende a página pública do Termo de Entrega (o link que vai pro
// cliente). Ninguém acessa a tabela termos_entrega direto pela API —
// ela guarda nome, assinatura e foto de rosto (dado sensível), e não
// tem nenhuma policy de RLS liberada pra "anon". Essa função usa a
// chave de serviço no servidor e só libera o registro que bate
// exatamente com o token da URL, nada além disso.
//
// Duas ações (no corpo da requisição, JSON):
//   { action: 'buscar', token }
//     -> devolve nome da obra/construtora/unidade e status, se o
//        token existir. Não expõe nenhum outro dado.
//   { action: 'assinar', token, nome, assinaturaBase64, fotoBase64, declaracoes }
//     -> só funciona se o termo ainda estiver "pendente". Sobe a
//        assinatura e a foto pro Storage, marca como "assinado".
//
// COMO PUBLICAR (sem precisar instalar nada no computador):
// 1. No painel do Supabase, menu lateral → "Edge Functions"
// 2. "Deploy a new function" / "Create a new function"
// 3. Nome da função: termo-entrega (tem que ser exatamente esse)
// 4. Cole este arquivo inteiro no editor
// 5. Deploy / Publicar
// ============================================================
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const BUCKET = 'vistoria-fotos'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function base64ParaBytes(dataUri: string) {
  const base64 = dataUri.split(',').pop() || ''
  const bin = atob(base64)
  const bytes = new Uint8Array(bin.length)
  for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i)
  return bytes
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  try {
    const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY)
    const body = await req.json()
    const token = body.token
    if (!token) throw new Error('Token não informado')

    const { data: termo, error: termoErr } = await admin
      .from('termos_entrega')
      .select('*, obras(nome, construtora), unidades(nome)')
      .eq('token', token)
      .maybeSingle()
    if (termoErr) throw new Error(termoErr.message)
    if (!termo) throw new Error('Link inválido ou expirado')

    if (body.action === 'buscar') {
      return new Response(JSON.stringify({
        ok: true,
        status: termo.status,
        obra: termo.obras?.nome || '',
        construtora: termo.obras?.construtora || '',
        unidade: termo.unidades?.nome || '',
        assinadoEm: termo.assinado_em,
      }), { headers: { ...corsHeaders, 'Content-Type': 'application/json' } })
    }

    if (body.action === 'assinar') {
      if (termo.status === 'assinado') throw new Error('Este termo já foi assinado')

      const nome = (body.nome || '').trim()
      if (!nome) throw new Error('Informe seu nome completo')
      if (!body.avaliacao) throw new Error('Avalie o imóvel antes de enviar')
      if (body.avaliacao === 'ressalvas' && !(body.observacoesRessalvas || '').trim()) throw new Error('Descreva as ressalvas encontradas')
      if (!body.assinaturaBase64) throw new Error('Assinatura obrigatória')
      if (!body.fotoBase64) throw new Error('Foto obrigatória')

      const assinaturaPath = `termos/${token}/assinatura.png`
      const fotoPath = `termos/${token}/rosto.jpg`

      const { error: upErr1 } = await admin.storage.from(BUCKET)
        .upload(assinaturaPath, base64ParaBytes(body.assinaturaBase64), { contentType: 'image/png', upsert: true })
      if (upErr1) throw new Error(upErr1.message)

      const { error: upErr2 } = await admin.storage.from(BUCKET)
        .upload(fotoPath, base64ParaBytes(body.fotoBase64), { contentType: 'image/jpeg', upsert: true })
      if (upErr2) throw new Error(upErr2.message)

      const { data: pubAss } = admin.storage.from(BUCKET).getPublicUrl(assinaturaPath)
      const { data: pubFoto } = admin.storage.from(BUCKET).getPublicUrl(fotoPath)

      const { error: updErr } = await admin.from('termos_entrega').update({
        status: 'assinado',
        nome_signatario: nome,
        avaliacao: body.avaliacao,
        observacoes_ressalvas: body.avaliacao === 'ressalvas' ? (body.observacoesRessalvas || '').trim() : '',
        assinatura_url: pubAss.publicUrl + '?t=' + Date.now(),
        foto_rosto_url: pubFoto.publicUrl + '?t=' + Date.now(),
        declaracoes: body.declaracoes || [],
        assinado_em: new Date().toISOString(),
      }).eq('token', token)
      if (updErr) throw new Error(updErr.message)

      return new Response(JSON.stringify({ ok: true }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    throw new Error('Ação inválida')
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
