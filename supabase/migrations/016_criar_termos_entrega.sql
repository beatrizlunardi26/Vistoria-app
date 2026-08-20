-- ============================================================
-- Termo de Entrega/Aceite: registro assinado pelo cliente (dedo no
-- celular) + foto de rosto, por unidade. Acessado por um link público
-- com token (sem login) que só mostra aquele termo específico — nunca
-- o resto do sistema.
--
-- Segurança: a tabela NÃO tem policy nenhuma pra "anon" (usuário não
-- logado) — de propósito. Ela guarda nome, assinatura e foto de
-- rosto de terceiros, dado sensível. Todo acesso público (ler o termo
-- pelo link, ou enviar a assinatura) passa pela Edge Function
-- termo-entrega, que usa a chave de serviço no servidor e só libera o
-- registro que bate exatamente com o token da URL — o anon key sozinho
-- (que já fica exposto no HTML) não dá acesso nenhum a essa tabela.
-- ============================================================
CREATE TABLE IF NOT EXISTS termos_entrega (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  obra_id uuid NOT NULL REFERENCES obras(id) ON DELETE CASCADE,
  unidade_id uuid REFERENCES unidades(id) ON DELETE CASCADE,
  token uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  status text NOT NULL DEFAULT 'pendente',
  nome_signatario text DEFAULT '',
  assinatura_url text DEFAULT '',
  foto_rosto_url text DEFAULT '',
  declaracoes jsonb DEFAULT '[]'::jsonb,
  criado_por uuid,
  criado_em timestamptz DEFAULT now(),
  assinado_em timestamptz
);

ALTER TABLE termos_entrega ENABLE ROW LEVEL SECURITY;

-- Só a equipe (autenticada) acessa esta tabela direto pela API do
-- Supabase. Nenhuma policy pra "anon" -- isso bloqueia acesso público
-- por padrão no Postgres/RLS.
CREATE POLICY "authenticated_select" ON termos_entrega FOR SELECT TO authenticated USING (true);
CREATE POLICY "authenticated_insert" ON termos_entrega FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "authenticated_update" ON termos_entrega FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "admin_delete" ON termos_entrega FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM engenheiras WHERE email = auth.email() AND role = 'admin'));

-- Conferir
SELECT tablename, policyname, cmd FROM pg_policies WHERE tablename = 'termos_entrega';
