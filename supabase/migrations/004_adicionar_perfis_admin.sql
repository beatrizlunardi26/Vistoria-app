-- ============================================================
-- Perfis admin/usuário + restrição de exclusão a admins
--
-- Regra: qualquer usuário autenticado continua podendo ler, criar e
-- editar tudo (obras, itens de modelo, unidades). Só quem é 'admin'
-- pode EXCLUIR obras, itens de modelo e unidades — a mesma trava é
-- aplicada tanto na interface quanto aqui no banco (defesa em
-- profundidade: mesmo alguém driblando a interface não consegue
-- apagar via API direta do Supabase sem ser admin).
--
-- Quem já tem conta hoje vira admin automaticamente (você e quem
-- mais já logou). Contas novas entram como 'usuario' por padrão —
-- promova alguém a admin depois com:
--   UPDATE engenheiras SET role = 'admin' WHERE email = 'email@da/pessoa.com';
-- ============================================================

ALTER TABLE engenheiras ADD COLUMN IF NOT EXISTS role text DEFAULT 'usuario';
UPDATE engenheiras SET role = 'admin' WHERE role IS NULL OR role = 'usuario';

-- Substitui a política única "tudo liberado" por políticas separadas:
-- select/insert/update seguem abertos a qualquer autenticado, delete só admin.
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['obras', 'itens_checklist', 'unidades']
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_full_access" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_select" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_insert" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "authenticated_update" ON public.%I;', t);
    EXECUTE format('DROP POLICY IF EXISTS "admin_delete" ON public.%I;', t);

    EXECUTE format('CREATE POLICY "authenticated_select" ON public.%I FOR SELECT TO authenticated USING (true);', t);
    EXECUTE format('CREATE POLICY "authenticated_insert" ON public.%I FOR INSERT TO authenticated WITH CHECK (true);', t);
    EXECUTE format('CREATE POLICY "authenticated_update" ON public.%I FOR UPDATE TO authenticated USING (true) WITH CHECK (true);', t);
    EXECUTE format(
      'CREATE POLICY "admin_delete" ON public.%I FOR DELETE TO authenticated USING (EXISTS (SELECT 1 FROM engenheiras WHERE email = auth.email() AND role = ''admin''));',
      t
    );
  END LOOP;
END $$;

-- Conferir os papéis atuais
SELECT email, nome, role FROM engenheiras ORDER BY criado_em;
