-- ============================================================
-- Corrige dois textos de critério no modelo "Áreas Comuns e Sistemas":
--
-- 1) "Caimento" (comodo Cozinha, modelo Áreas Internas — Unidade
--    Privativa) tinha "(nicho, box, calhas, áreas molhadas)" no
--    parêntese — "nicho" e "box" são termos de banheiro, sobra de
--    copy-paste entre as seções do documento original.
--
-- 2) "Grupo gerador, se houver" (comodo Instalações elétricas,
--    entrada de energia e central de medição) usava "startup" no
--    meio de texto técnico em português.
-- ============================================================
UPDATE itens_checklist SET criterio =
  'Água direcionada ao local de escoamento, sem empoçamento ou retorno (pia, bancada, próximo aos ralos).'
WHERE nome = 'Caimento' AND servico = 'Escoamento'
  AND criterio = 'Água direcionada ao local de escoamento, sem empoçamento ou retorno (nicho, box, calhas, áreas molhadas).';

UPDATE itens_checklist SET criterio =
  'Funcionamento testado; potência, teste de partida, manual e garantia disponíveis.'
WHERE nome = 'Grupo gerador, se houver'
  AND criterio = 'Funcionamento testado; potência, startup, manual e garantia disponíveis.';

-- Conferir (deve retornar as 2 linhas já corrigidas)
SELECT nome, servico, criterio FROM itens_checklist
WHERE nome IN ('Caimento', 'Grupo gerador, se houver')
  AND (criterio LIKE '%próximo aos ralos%' OR criterio LIKE '%teste de partida%');
