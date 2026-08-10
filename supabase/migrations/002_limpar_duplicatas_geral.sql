-- ============================================================
-- Limpeza das respostas duplicadas criadas pelo bug do "sem unidade (geral)"
--
-- Causa: no Postgres, NULL nunca é igual a outro NULL para fins de
-- UNIQUE (vistoria_id, item_id, unidade_id). Toda vez que uma resposta
-- era salva com unidade_id = NULL (modo "geral"), o upsert do app não
-- encontrava conflito e criava uma linha NOVA a cada tecla digitada,
-- em vez de atualizar a existente.
--
-- Este script mantém, para cada (vistoria_id, item_id) com unidade_id
-- NULL, apenas a linha mais recente (maior atualizado_em) e apaga o resto.
-- Rode uma vez, antes de popular novas vistorias.
-- ============================================================

-- 1) Conferir quantas linhas duplicadas existem (rode antes de apagar, se quiser ver o tamanho do estrago)
SELECT vistoria_id, item_id, COUNT(*) AS duplicatas
FROM respostas_itens
WHERE unidade_id IS NULL
GROUP BY vistoria_id, item_id
HAVING COUNT(*) > 1
ORDER BY duplicatas DESC;

-- 2) Apagar as duplicatas, mantendo apenas a mais recente de cada grupo
DELETE FROM respostas_itens r
USING respostas_itens r2
WHERE r.unidade_id IS NULL
  AND r2.unidade_id IS NULL
  AND r.vistoria_id = r2.vistoria_id
  AND r.item_id = r2.item_id
  AND (
    r.atualizado_em < r2.atualizado_em
    OR (r.atualizado_em = r2.atualizado_em AND r.id < r2.id)
  );

-- 3) Conferir que sobrou só 1 linha por (vistoria_id, item_id) com unidade_id NULL
SELECT vistoria_id, item_id, COUNT(*) AS restantes
FROM respostas_itens
WHERE unidade_id IS NULL
GROUP BY vistoria_id, item_id
HAVING COUNT(*) > 1;
-- (deve retornar 0 linhas)
