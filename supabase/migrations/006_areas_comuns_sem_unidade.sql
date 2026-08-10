-- ============================================================
-- Checklist de Áreas Comuns e Sistemas deixa de ser dividido por
-- unidade/apartamento — passa a ser preenchido uma única vez para
-- a obra inteira (garagem, fachada, elevador etc. só existem uma
-- vez no prédio). "Áreas Internas — Unidade Privativa" continua
-- dividido por apartamento normalmente.
-- ============================================================

-- 1) Novo campo no modelo de checklist: indica se ele é preenchido
--    por unidade (true, padrão) ou uma vez só para a obra (false)
ALTER TABLE modelos_checklist ADD COLUMN IF NOT EXISTS por_unidade boolean DEFAULT true;

UPDATE modelos_checklist SET por_unidade = false WHERE nome = 'Áreas Comuns e Sistemas';
UPDATE modelos_checklist SET por_unidade = true WHERE nome = 'Áreas Internas — Unidade Privativa';

-- 2) Índice único parcial: garante que, quando unidade_id é NULL
--    (checklist "por obra"), o upsert encontre a linha certa e
--    atualize em vez de duplicar a cada tecla digitada — o mesmo
--    bug que já corrigimos para o caso "com unidade", mas agora
--    coberto também para quando não há unidade nenhuma.
CREATE UNIQUE INDEX IF NOT EXISTS respostas_itens_vistoria_item_sem_unidade_key
  ON respostas_itens (vistoria_id, item_id)
  WHERE unidade_id IS NULL;

-- Conferir
SELECT nome, por_unidade FROM modelos_checklist ORDER BY criado_em;
