-- ============================================================
-- Reforça as permissões da tabela engenheiras agora que existe
-- um jeito de mudar o perfil (role) de qualquer usuário.
--
-- Hoje ela ainda usa a política antiga "liberado pra qualquer
-- autenticado fazer tudo" — o que significa que, tecnicamente,
-- qualquer usuário comum poderia se promover a admin direto pela
-- API do Supabase (não pela interface, mas pela API). Esta migração
-- fecha essa brecha: cada um só pode editar a própria linha (nome),
-- e só admin pode editar/apagar a linha de outra pessoa (perfil).
-- ============================================================

DROP POLICY IF EXISTS "authenticated_full_access" ON public.engenheiras;
DROP POLICY IF EXISTS "authenticated_select" ON public.engenheiras;
DROP POLICY IF EXISTS "authenticated_insert" ON public.engenheiras;
DROP POLICY IF EXISTS "self_or_admin_update" ON public.engenheiras;
DROP POLICY IF EXISTS "admin_delete" ON public.engenheiras;

-- Qualquer autenticado pode ver a lista (nome/e-mail/perfil de todos)
CREATE POLICY "authenticated_select" ON public.engenheiras
  FOR SELECT TO authenticated USING (true);

-- Necessário para o auto-cadastro no primeiro login (cria a própria linha)
CREATE POLICY "authenticated_insert" ON public.engenheiras
  FOR INSERT TO authenticated WITH CHECK (true);

-- Cada um só edita a própria linha (nome); admin edita qualquer uma (perfil)
CREATE POLICY "self_or_admin_update" ON public.engenheiras
  FOR UPDATE TO authenticated
  USING (
    email = auth.email()
    OR EXISTS (SELECT 1 FROM public.engenheiras e2 WHERE e2.email = auth.email() AND e2.role = 'admin')
  )
  WITH CHECK (
    email = auth.email()
    OR EXISTS (SELECT 1 FROM public.engenheiras e2 WHERE e2.email = auth.email() AND e2.role = 'admin')
  );

-- Só admin apaga registros de engenheiras
CREATE POLICY "admin_delete" ON public.engenheiras
  FOR DELETE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.engenheiras e2 WHERE e2.email = auth.email() AND e2.role = 'admin'));
