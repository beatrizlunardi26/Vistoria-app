-- ============================================================
-- Habilita Row Level Security em todas as tabelas e libera acesso
-- total apenas para usuários autenticados (login real do Supabase Auth).
--
-- Efeito: a chave anônima (sb_publishable_...), que já está exposta
-- no HTML do site, deixa de servir para ler/escrever dados sozinha —
-- só funciona combinada com uma sessão de login válida. Isso fecha o
-- acesso direto via API do Supabase para quem não estiver logado no app.
--
-- Modelo escolhido: TODOS os usuários autenticados compartilham acesso
-- total às mesmas obras (sem separação por engenheira_id, por enquanto).
-- ============================================================

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'engenheiras','obras','modelos_checklist','comodos','itens_checklist',
    'vistorias','respostas_itens','unidades','fotos','relatorios'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_full_access" ON public.%I;', t);
    EXECUTE format(
      'CREATE POLICY "authenticated_full_access" ON public.%I FOR ALL TO authenticated USING (true) WITH CHECK (true);',
      t
    );
  END LOOP;
END $$;

-- Conferir que RLS ficou ligado em todas (deve retornar rowsecurity = true em todas as linhas)
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
