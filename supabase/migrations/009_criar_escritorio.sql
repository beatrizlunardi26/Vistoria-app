-- ============================================================
-- Cria a tabela `escritorio`: dados da empresa (nome, CNPJ, cidade,
-- logo) mostrados na tela Configurações e usados no cabeçalho dos
-- relatórios em PDF. É uma linha única (id fixo = 1), compartilhada
-- por todas as engenheiras, no mesmo modelo de acesso total já usado
-- para as outras tabelas (sem separação por empresa ainda).
--
-- Corrige também um bug visível: o nome "BL Engenharia Civil" estava
-- fixo no código (tela de login e nos 3 relatórios em PDF) — nome
-- antigo/errado, os relatórios saíam para os clientes com a marca
-- errada. Essa tabela permite editar o nome real pela tela de
-- Configurações.
-- ============================================================

CREATE TABLE IF NOT EXISTS escritorio (
  id int PRIMARY KEY DEFAULT 1,
  nome text DEFAULT 'Puel Engenharia',
  cnpj text DEFAULT '',
  cidade text DEFAULT '',
  logo_url text DEFAULT '',
  CONSTRAINT escritorio_singleton CHECK (id = 1)
);

INSERT INTO escritorio (id, nome) VALUES (1, 'Puel Engenharia')
ON CONFLICT (id) DO NOTHING;

ALTER TABLE escritorio ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "authenticated_full_access" ON escritorio;
CREATE POLICY "authenticated_full_access" ON escritorio
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
