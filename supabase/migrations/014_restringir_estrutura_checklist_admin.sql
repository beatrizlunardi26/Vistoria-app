-- ============================================================
-- Restringe alteração da ESTRUTURA dos checklists (modelos_checklist,
-- comodos, itens_checklist) a administradores.
--
-- Até agora, qualquer usuária autenticada podia INSERT/UPDATE (e, no
-- caso de modelos_checklist/comodos, até DELETE) essas tabelas direto
-- pela API do Supabase — a tela "Modelos de Checklist" nem escondia
-- os campos de edição pra quem não é admin. Um usuário mexendo sem
-- querer num dropdown (ex: "Frente de serviço") alterava o modelo de
-- fábrica, afetando todas as obras que usam aquele modelo.
--
-- Dados de trabalho (respostas_itens, vistorias, obras, unidades)
-- continuam abertos a qualquer usuária autenticada — só a ESTRUTURA
-- do checklist em si (o que existe, não as respostas dadas) fica
-- restrita a admin. Leitura (SELECT) continua liberada pra todo mundo,
-- já que toda vistoria precisa carregar o modelo pra funcionar.
-- ============================================================
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['modelos_checklist', 'comodos', 'itens_checklist']
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_full_access" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_select" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_insert" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_update" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "admin_delete" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "admin_insert" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "admin_update" ON public.%I;', t);

    EXECUTE format('CREATE POLICY "authenticated_select" ON public.%I FOR SELECT TO authenticated USING (true);', t);
    EXECUTE format(
      'CREATE POLICY "admin_insert" ON public.%I FOR INSERT TO authenticated WITH CHECK (EXISTS (SELECT 1 FROM engenheiras WHERE email = auth.email() AND role = ''admin''));',
      t
    );
    EXECUTE format(
      'CREATE POLICY "admin_update" ON public.%I FOR UPDATE TO authenticated USING (EXISTS (SELECT 1 FROM engenheiras WHERE email = auth.email() AND role = ''admin'')) WITH CHECK (EXISTS (SELECT 1 FROM engenheiras WHERE email = auth.email() AND role = ''admin''));',
      t
    );
    EXECUTE format(
      'CREATE POLICY "admin_delete" ON public.%I FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM engenheiras WHERE email = auth.email() AND role = ''admin''));',
      t
    );
  END LOOP;
END $$;

-- Conferir: cada tabela deve ter select aberto + insert/update/delete só admin
SELECT tablename, policyname, cmd FROM pg_policies
WHERE tablename IN ('modelos_checklist','comodos','itens_checklist')
ORDER BY tablename, cmd;
