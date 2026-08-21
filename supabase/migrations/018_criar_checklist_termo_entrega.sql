-- ============================================================
-- Torna o Termo de Entrega um checklist de verdade, editável na
-- mesma tela "Modelos de Checklist" dos outros dois modelos — só
-- que bem mais simplificado (poucos itens, critério curto, sem os
-- sub-detalhes do checklist interno).
--
-- `eh_termo_entrega` marca esse modelo como especial: ele continua
-- aparecendo em "Modelos de Checklist" pra editar, mas NÃO aparece
-- como opção ao criar uma obra nem no "Trocar modelo" da vistoria
-- interna — só é usado pela página pública do Termo de Entrega.
-- ============================================================
ALTER TABLE modelos_checklist ADD COLUMN IF NOT EXISTS eh_termo_entrega boolean DEFAULT false;
ALTER TABLE termos_entrega ADD COLUMN IF NOT EXISTS checklist_respostas jsonb DEFAULT '[]'::jsonb;

DO $$
DECLARE
  v_modelo_id uuid;
  v_comodo_id uuid;
BEGIN
  IF EXISTS (SELECT 1 FROM modelos_checklist WHERE eh_termo_entrega = true) THEN
    RETURN;
  END IF;

  INSERT INTO modelos_checklist (nome, descricao, por_unidade, eh_termo_entrega)
    VALUES ('Termo de Entrega — Simplificado', 'Checklist reduzido preenchido pelo próprio cliente antes de assinar o termo de entrega.', true, true)
    RETURNING id INTO v_modelo_id;

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Verificação Geral', '✅', 1)
    RETURNING id INTO v_comodo_id;

  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_id, 'Revestimentos (pisos e paredes)', 'Revestimento', 'Sem trincas, manchas ou peças soltas visíveis.', 1),
    (v_comodo_id, 'Pintura', 'Pintura', 'Sem falhas, manchas ou bolhas aparentes.', 2),
    (v_comodo_id, 'Portas e fechaduras', 'Esquadrias', 'Abrem, fecham e travam normalmente.', 3),
    (v_comodo_id, 'Janelas', 'Esquadrias', 'Abrem, fecham e vedam normalmente.', 4),
    (v_comodo_id, 'Instalações elétricas', 'Elétrica', 'Tomadas e interruptores funcionando.', 5),
    (v_comodo_id, 'Instalações hidráulicas', 'Hidráulica', 'Torneiras e registros sem vazamento aparente.', 6),
    (v_comodo_id, 'Louças e metais', 'Hidráulica', 'Vaso, pia e chuveiro fixados e funcionando normalmente.', 7),
    (v_comodo_id, 'Limpeza geral', 'Limpeza', 'Sem resíduos de obra ou sujeira aparente.', 8);
END $$;
