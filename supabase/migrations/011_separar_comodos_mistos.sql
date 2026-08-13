-- ============================================================
-- Separa dois cômodos do modelo "Áreas Comuns e Sistemas" que
-- misturavam sistemas sem relação entre si:
--   "Gás, interfone e acessos automatizados" -> "Gás" +
--     "Interfone e acessos automatizados"
--   "Elevadores e PPCI" -> "Elevadores" + "PPCI"
--
-- Motivo: além de deixar o checklist mais claro pra quem preenche,
-- esse mesmo mix de assuntos já tinha causado um bug real na
-- classificação automática de "frente de serviço" (um item de gás
-- sendo classificado como Elétrica só por causa da palavra
-- "interfone" no nome do cômodo — ver classificarEquipe no app).
--
-- Não afeta respostas já registradas nem vistorias em andamento: os
-- itens só trocam de comodo_id (continuam com o mesmo id), então
-- respostas_itens permanece vinculada certinha — o item só passa a
-- aparecer agrupado numa seção diferente na tela.
-- ============================================================
DO $$
DECLARE
  v_modelo_id uuid;
  v_comodo_gas uuid;
  v_comodo_interfone uuid;
  v_comodo_elevadores uuid;
  v_comodo_ppci uuid;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_checklist WHERE nome = 'Áreas Comuns e Sistemas' LIMIT 1;
  IF v_modelo_id IS NULL THEN
    RAISE EXCEPTION 'Modelo % nao encontrado', 'Áreas Comuns e Sistemas';
  END IF;

  -- Gás  x  Interfone e acessos automatizados
  SELECT id INTO v_comodo_gas FROM comodos
    WHERE modelo_checklist_id = v_modelo_id AND nome = 'Gás, interfone e acessos automatizados' LIMIT 1;
  IF v_comodo_gas IS NULL THEN
    RAISE EXCEPTION 'Comodo % nao encontrado', 'Gás, interfone e acessos automatizados';
  END IF;
  UPDATE comodos SET nome = 'Gás', ordem = 6 WHERE id = v_comodo_gas;

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Interfone e acessos automatizados', '🔔', 7)
    RETURNING id INTO v_comodo_interfone;

  UPDATE itens_checklist SET comodo_id = v_comodo_interfone, ordem = 1 WHERE comodo_id = v_comodo_gas AND nome = 'Interfone';
  UPDATE itens_checklist SET comodo_id = v_comodo_interfone, ordem = 2 WHERE comodo_id = v_comodo_gas AND nome = 'Central de interfone';
  UPDATE itens_checklist SET comodo_id = v_comodo_interfone, ordem = 3 WHERE comodo_id = v_comodo_gas AND nome = 'Portões automáticos';

  -- Elevadores  x  PPCI
  SELECT id INTO v_comodo_elevadores FROM comodos
    WHERE modelo_checklist_id = v_modelo_id AND nome = 'Elevadores e PPCI' LIMIT 1;
  IF v_comodo_elevadores IS NULL THEN
    RAISE EXCEPTION 'Comodo % nao encontrado', 'Elevadores e PPCI';
  END IF;
  UPDATE comodos SET nome = 'Elevadores', ordem = 8 WHERE id = v_comodo_elevadores;

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'PPCI', '🧯', 9)
    RETURNING id INTO v_comodo_ppci;

  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 1 WHERE comodo_id = v_comodo_elevadores AND nome = 'Extintores';
  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 2 WHERE comodo_id = v_comodo_elevadores AND nome = 'Sinalização PPCI';
  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 3 WHERE comodo_id = v_comodo_elevadores AND nome = 'Luz de emergência';
  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 4 WHERE comodo_id = v_comodo_elevadores AND nome = 'Portas corta-fogo';
  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 5 WHERE comodo_id = v_comodo_elevadores AND nome = 'Hidrantes / mangotinhos';
  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 6 WHERE comodo_id = v_comodo_elevadores AND nome = 'Alarme/detecção, se houver';
  UPDATE itens_checklist SET comodo_id = v_comodo_ppci, ordem = 7 WHERE comodo_id = v_comodo_elevadores AND nome = 'Rotas de fuga';
END $$;

-- Conferir resultado (deve mostrar 9 cômodos, cada item no cômodo certo)
SELECT c.nome AS comodo, c.ordem AS comodo_ordem, i.nome AS item, i.ordem AS item_ordem
FROM comodos c JOIN itens_checklist i ON i.comodo_id = c.id
WHERE c.modelo_checklist_id = (SELECT id FROM modelos_checklist WHERE nome = 'Áreas Comuns e Sistemas')
ORDER BY c.ordem, i.ordem;
