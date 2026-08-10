-- ============================================================
-- Modelo: Áreas Comuns e Sistemas
-- ============================================================
DO $$
DECLARE
  v_modelo_id uuid;
  v_comodo_0 uuid;
  v_comodo_1 uuid;
  v_comodo_2 uuid;
  v_comodo_3 uuid;
  v_comodo_4 uuid;
  v_comodo_5 uuid;
  v_comodo_6 uuid;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_checklist WHERE nome = 'Áreas Comuns e Sistemas' LIMIT 1;
  IF v_modelo_id IS NULL THEN
    RAISE EXCEPTION 'Modelo % nao encontrado', 'Áreas Comuns e Sistemas';
  END IF;

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Halls, escadas, garagem, acessos e áreas externas', '🚪', 1)
    RETURNING id INTO v_comodo_0;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_0, 'Hall social', 'Acabamento/limpeza', 'Pisos, paredes, forros, portas, iluminação, rodapés e limpeza em bom estado.', 1),
    (v_comodo_0, 'Hall de serviço', 'Acabamento/limpeza', 'Sem danos, sujeira, falhas de pintura, revestimento ou acabamento incompleto.', 2),
    (v_comodo_0, 'Escadas', 'Acabamento/segurança', 'Pisos, corrimãos, guarda-corpos, portas corta-fogo, pintura, sinalização e iluminação adequados.', 3),
    (v_comodo_0, 'Garagem', 'Piso/demarcação', 'Piso acabado, vagas demarcadas, sinalização e limpeza adequadas.', 4),
    (v_comodo_0, 'Rampas', 'Acabamento/drenagem', 'Piso regular, sem danos relevantes, com sinalização, inclinação e drenagem funcionando.', 5),
    (v_comodo_0, 'Passeios / calçadas', 'Acabamento/acessibilidade', 'Sem peças soltas, desníveis perigosos ou fissuras relevantes; rampas conforme projeto.', 6),
    (v_comodo_0, 'Áreas descobertas / jardins', 'Acabamento', 'Sem resíduos de obra, drenagem funcional, paisagismo e acabamento adequados.', 7),
    (v_comodo_0, 'Muros / gradis / portões', 'Acabamento/funcionamento', 'Sem ferrugem, falhas de pintura, danos, folgas ou funcionamento irregular.', 8),
    (v_comodo_0, 'Guarita', 'Acabamento/funcionamento', 'Civil, elétrica, interfone, esquadrias, iluminação e limpeza adequados.', 9),
    (v_comodo_0, 'Lazer / apoio', 'Integridade/segurança', 'Equipamentos fixos, íntegros, limpos, sem arestas perigosas, folgas ou acabamento irregular.', 10);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Fachadas', '🧱', 2)
    RETURNING id INTO v_comodo_1;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_1, 'Fachada pintada', 'Pintura', 'Sem manchas, falhas, fissuras aparentes, diferença de tonalidade ou acabamento irregular.', 1),
    (v_comodo_1, 'Fachada cerâmica', 'Revestimento', 'Sem peças soltas, ocas, trincadas, manchadas, desalinhadas ou rejunte falho.', 2),
    (v_comodo_1, 'Esquadrias externas', 'Vedação', 'Sem falhas de silicone/PU, frestas, rebarbas, sujeira ou sinais de infiltração.', 3),
    (v_comodo_1, 'Pingadeiras / peitoris', 'Caimento/acabamento', 'Íntegros, com caimento correto, sem trincas, quebras ou falhas de vedação.', 4),
    (v_comodo_1, 'Tubulações aparentes', 'Fixação/acabamento', 'Fixadas, alinhadas, identificadas e com pintura/acabamento atrás das tubulações.', 5),
    (v_comodo_1, 'Juntas e frisos', 'Acabamento', 'Uniformes, limpos, sem falhas, fissuras, descolamento ou acabamento incompleto.', 6);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Cobertura, platibandas e lajes impermeabilizadas', '🏗️', 3)
    RETURNING id INTO v_comodo_2;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_2, 'Telhas', 'Integridade/fixação', 'Sem telhas quebradas, soltas, microfissuradas, desalinhadas ou danificadas.', 1),
    (v_comodo_2, 'Calhas', 'Limpeza/funcionamento', 'Limpas, desobstruídas, sem água acumulada e com vedação adequada.', 2),
    (v_comodo_2, 'Rufos', 'Vedação/acabamento', 'Íntegros, bem fixados, sem falhas visíveis de vedação ou infiltração.', 3),
    (v_comodo_2, 'Platibandas', 'Impermeabilização/acabamento', 'Sem aço exposto, bicheiras, fissuras relevantes, falhas de impermeabilização ou umidade.', 4),
    (v_comodo_2, 'Lajes impermeabilizadas', 'Estanqueidade visual', 'Sem sinais de vazamento, umidade, falha de proteção mecânica ou acabamento incompleto.', 5),
    (v_comodo_2, 'Terminais / ventilação', 'Instalação', 'Terminais instalados, íntegros e posicionados corretamente.', 6);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Instalações elétricas, entrada de energia e central de medição', '⚡', 4)
    RETURNING id INTO v_comodo_3;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_3, 'Entrada de energia', 'Funcionamento', 'Entrada energizada, protegida, acessível e operando conforme previsto/projeto.', 1),
    (v_comodo_3, 'Central de medição', 'Organização/funcionamento', 'Medidores identificados, protegidos, acessíveis e com acabamento adequado.', 2),
    (v_comodo_3, 'Quadros elétricos', 'Identificação', 'Circuitos/disjuntores identificados conforme projeto e com quadro fixo.', 3),
    (v_comodo_3, 'Quadros elétricos', 'Segurança', 'Sem fiação exposta; espaços reserva protegidos; sem oxidação; tampa e parafusos adequados.', 4),
    (v_comodo_3, 'Aterramento', 'Conferência visual', 'Condutores de aterramento identificados e conectados visualmente.', 5),
    (v_comodo_3, 'Cabos / terminais', 'Acabamento interno', 'Cabos identificados por fase/neutro/terra, bitolas coerentes e terminais adequados.', 6),
    (v_comodo_3, 'Tomadas', 'Funcionamento', 'Testadas, firmes, alinhadas, com acabamento adequado e sem oxidação/sujeira.', 7),
    (v_comodo_3, 'Interruptores / sensores', 'Funcionamento', 'Acionamento e sensores funcionando, sem travamento, folga ou acabamento irregular.', 8),
    (v_comodo_3, 'Pontos de luz', 'Funcionamento', 'Pontos e luminárias funcionando, fiação protegida e acabamento adequado.', 9),
    (v_comodo_3, 'Iluminação comum', 'Funcionamento', 'Luminárias, sensores e pontos de luz funcionando nas áreas comuns.', 10),
    (v_comodo_3, 'Iluminação emergência', 'Funcionamento', 'Equipamentos instalados, sinalizados e funcionando no teste.', 11),
    (v_comodo_3, 'Grupo gerador, se houver', 'Funcionamento/documentos', 'Funcionamento testado; potência, startup, manual e garantia disponíveis.', 12);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Instalações hidráulicas, reservatórios, bombas e drenagem', '💧', 5)
    RETURNING id INTO v_comodo_4;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_4, 'Reservatórios', 'Estanqueidade/proteção', 'Sem vazamentos, com tampa/acesso protegido, ventilação e limpeza adequada.', 1),
    (v_comodo_4, 'Barrilete', 'Vazamentos', 'Sem vazamentos aparentes em conexões, registros, tubulações e suportes.', 2),
    (v_comodo_4, 'Casa de bombas', 'Civil/limpeza', 'Piso, pintura, portas, iluminação, ventilação, identificação e limpeza adequados.', 3),
    (v_comodo_4, 'Bombas de recalque', 'Funcionamento', 'Teste manual/automático realizado, base fixa e equipamento identificado.', 4),
    (v_comodo_4, 'Bombas pressurização', 'Funcionamento', 'Pressão/vazão funcionando e compatível com o sistema/projeto.', 5),
    (v_comodo_4, 'Bombas de incêndio', 'Funcionamento', 'Teste manual/automático, identificação, combustível quando aplicável e condições gerais ok.', 6),
    (v_comodo_4, 'Booster, se houver', 'Pressão/calibração', 'Pressão e funcionamento conferidos conforme projeto hidráulico.', 7),
    (v_comodo_4, 'Moto-bombas', 'Documentação', 'Manual, garantia e identificação disponíveis.', 8),
    (v_comodo_4, 'Drenagem/captação', 'Funcionamento', 'Caixas limpas, tampas íntegras, canaletas sem trincas/empossamento e grelhas instaladas.', 9),
    (v_comodo_4, 'Caixas inspeção/gordura', 'Conferência visual', 'Acabamento interno, limpeza, tampas, vedações e fluxo conforme projeto.', 10);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Gás, interfone e acessos automatizados', '🔥', 6)
    RETURNING id INTO v_comodo_5;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_5, 'Central de gás', 'Funcionamento/acabamento', 'Instalação identificada, protegida, ventilada e com acabamento adequado.', 1),
    (v_comodo_5, 'Central de gás', 'Estanqueidade/documentos', 'Laudo/teste disponível; manômetros e registros instalados e funcionando.', 2),
    (v_comodo_5, 'Tubulações de gás', 'Identificação/proteção', 'Tubulações identificadas, protegidas, sem danos aparentes e com suportação adequada.', 3),
    (v_comodo_5, 'Abrigos/registros', 'Acesso/acabamento', 'Abrigos acessíveis, protegidos, ventilados e com registros identificados.', 4),
    (v_comodo_5, 'Interfone', 'Funcionamento', 'Teste em pontos amostrais; central, circuitos, quadros e abrigo identificados/protegidos.', 5),
    (v_comodo_5, 'Central de interfone', 'Instalação', 'Circuitos identificados, quadros com terminais, nobreak/base e abrigo protegido.', 6),
    (v_comodo_5, 'Portões automáticos', 'Funcionamento', 'Abertura/fechamento, botoeiras, sensores, fechaduras e acabamento funcionando.', 7);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Elevadores e PPCI', '🛗', 7)
    RETURNING id INTO v_comodo_6;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_6, 'Elevadores', 'Funcionamento/acabamento', 'Operação, acabamento, limpeza, iluminação e documentação básica conferidos.', 1),
    (v_comodo_6, 'Extintores', 'Presença/validade', 'Instalados, sinalizados, com lacre, carga e validade adequados.', 2),
    (v_comodo_6, 'Sinalização PPCI', 'Placas', 'Placas instaladas, visíveis e compatíveis com projeto aprovado.', 3),
    (v_comodo_6, 'Luz de emergência', 'Funcionamento', 'Equipamentos instalados e funcionando no teste.', 4),
    (v_comodo_6, 'Portas corta-fogo', 'Funcionamento', 'Fechamento automático, ferragens, sinalização, pintura e acabamento adequados.', 5),
    (v_comodo_6, 'Hidrantes / mangotinhos', 'Conferência visual', 'Abrigos, mangueiras, registros, esguichos e sinalização presentes conforme projeto.', 6),
    (v_comodo_6, 'Alarme/detecção, se houver', 'Funcionamento', 'Sistema instalado, identificado e testado conforme documentação.', 7),
    (v_comodo_6, 'Rotas de fuga', 'Desobstrução', 'Circulações, escadas e acessos sem obstrução e com sinalização adequada.', 8);

END $$;

-- ============================================================
-- Modelo: Áreas Internas — Unidade Privativa
-- ============================================================
DO $$
DECLARE
  v_modelo_id uuid;
  v_comodo_0 uuid;
  v_comodo_1 uuid;
  v_comodo_2 uuid;
  v_comodo_3 uuid;
  v_comodo_4 uuid;
  v_comodo_5 uuid;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_checklist WHERE nome = 'Áreas Internas — Unidade Privativa' LIMIT 1;
  IF v_modelo_id IS NULL THEN
    RAISE EXCEPTION 'Modelo % nao encontrado', 'Áreas Internas — Unidade Privativa';
  END IF;

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Sala, quartos e circulação', '🛋️', 1)
    RETURNING id INTO v_comodo_0;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_0, 'Paredes', 'Planicidade e acabamento', 'Sem ondulações, dentes, marcas de forma, fissuras, trincas ou manchas.', 1),
    (v_comodo_0, 'Pintura', 'Acabamento geral', 'Sem manchas, bolhas, falhas, diferença de tonalidade/brilho, respingos ou mofo.', 2),
    (v_comodo_0, 'Teto / forro', 'Acabamento e pintura', 'Sem manchas, fissuras, ondulações, juntas aparentes ou sinais de umidade.', 3),
    (v_comodo_0, 'Piso / contrapiso', 'Nivelamento e aderência', 'Sem desníveis, trincas, buracos, som cavo, peças soltas, lascas ou manchas.', 4),
    (v_comodo_0, 'Rodapés', 'Fixação e acabamento', 'Bem aderidos, alinhados, sem frestas, trincas, quebras ou juntas abertas.', 5),
    (v_comodo_0, 'Soleiras / baguetes', 'Fixação e acabamento', 'Peças firmes, íntegras, sem trincas, manchas, quebras ou desníveis inadequados.', 6),
    (v_comodo_0, 'Portas', 'Funcionamento', 'Abrir e fechar sem raspar, travar, ruído excessivo ou efeito fantasma.', 7),
    (v_comodo_0, 'Portas', 'Ferragens/acabamento', 'Maçanetas, fechaduras, chaves e dobradiças funcionando; sem riscos ou oxidação.', 8),
    (v_comodo_0, 'Janelas / esquadrias', 'Funcionamento', 'Abrir, fechar e travar sem esforço excessivo, ruído, trepidação ou desalinhamento.', 9),
    (v_comodo_0, 'Janelas / esquadrias', 'Vedação/acabamento', 'Silicone íntegro, sem excesso de PU, frestas, amassados, riscos ou sujeira.', 10),
    (v_comodo_0, 'Vidros', 'Integridade e limpeza', 'Sem trincas, riscos relevantes, manchas, folgas ou má fixação.', 11),
    (v_comodo_0, 'Peitoris / pingadeiras', 'Caimento/acabamento', 'Caimento para fora, pingadeira funcional e sem trincas, manchas ou quebras.', 12),
    (v_comodo_0, 'Limpeza', 'Limpeza final', 'Sem resíduos de obra, poeira excessiva, respingos, massa ou materiais abandonados.', 13);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Cozinha', '🍳', 2)
    RETURNING id INTO v_comodo_1;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_1, 'Piso cerâmico', 'Aderência/acabamento', 'Sem som cavo, trincas, lascas, manchas, ressaltos ou peças desalinhadas, e com rejunte íntegro.', 1),
    (v_comodo_1, 'Revestimento parede', 'Assentamento/acabamento', 'Sem som cavo, trincas, lascas, com cantos alinhados, recortes bem executados e rejunte íntegro.', 2),
    (v_comodo_1, 'Caimento', 'Escoamento', 'Água direcionada ao local de escoamento, sem empoçamento ou retorno (nicho, box, calhas, áreas molhadas).', 3),
    (v_comodo_1, 'Ralos', 'Funcionamento/acabamento', 'Com grelha/tampa, limpos, sem entupimento, odor ou acabamento irregular.', 4),
    (v_comodo_1, 'Bancada / pia', 'Fixação e integridade', 'Firme, nivelada, sem trincas, manchas, riscos, lascas ou folgas.', 5),
    (v_comodo_1, 'Cuba', 'Fixação e vedação', 'Bem fixada e vedada, sem vazamentos, folgas ou acabamento grosseiro.', 6),
    (v_comodo_1, 'Torneiras / metais', 'Funcionamento', 'Boa vazão, fixação adequada, sem vazamento, oxidação, riscos ou folgas.', 7),
    (v_comodo_1, 'Sifão / válvulas / flexíveis', 'Estanqueidade', 'Conexões firmes, sem gotejamento, vazamento ou folgas.', 8),
    (v_comodo_1, 'Registros', 'Funcionamento/acabamento', 'Abrem e fecham corretamente, sem rebarbas, folgas ou vazamentos.', 9),
    (v_comodo_1, 'Ponto de gás', 'Identificação/acabamento', 'Ponto identificado, acessível, protegido, com acabamento adequado e sem obstruções.', 10),
    (v_comodo_1, 'Esquadrias', 'Funcionamento/vedação', 'Abertura, fechamento, travamento e vedação funcionando adequadamente.', 11),
    (v_comodo_1, 'Forro / teto', 'Acabamento', 'Sem manchas, fissuras, ondulações, juntas aparentes ou sinais de umidade.', 12),
    (v_comodo_1, 'Pintura', 'Acabamento', 'Sem falhas, bolhas, manchas, respingos, diferença de tonalidade ou massa acumulada.', 13),
    (v_comodo_1, 'Limpeza', 'Limpeza final', 'Sem resíduos, poeira, massa, rejunte, tinta, embalagens ou materiais de obra.', 14);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Área de serviço', '🧺', 3)
    RETURNING id INTO v_comodo_2;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_2, 'Piso cerâmico', 'Aderência/acabamento', 'Sem som cavo, trincas, lascas, manchas, ressaltos ou peças desalinhadas, e com rejunte íntegro.', 1),
    (v_comodo_2, 'Caimento', 'Escoamento', 'Água escoa para o ralo sem empoçamento ou direcionamento inadequado.', 2),
    (v_comodo_2, 'Ralos', 'Funcionamento', 'Limpos, com grelha/tampa, sem entupimento, odor ou acabamento irregular.', 3),
    (v_comodo_2, 'Tanque', 'Fixação/integridade', 'Firme, íntegro, sem trincas, manchas, folgas ou vazamentos.', 4),
    (v_comodo_2, 'Torneira', 'Funcionamento', 'Boa vazão, fixação adequada, sem vazamentos ou folgas.', 5),
    (v_comodo_2, 'Sifão / flexíveis', 'Estanqueidade', 'Conexões firmes, sem gotejamento, folgas ou vazamentos.', 6),
    (v_comodo_2, 'Registros', 'Funcionamento', 'Abrem e fecham corretamente, sem vazamento e com acabamento firme.', 7),
    (v_comodo_2, 'Ponto máquina lavar', 'Água e esgoto', 'Ponto acessível, identificado e com acabamento adequado.', 8),
    (v_comodo_2, 'Aquecedor, se houver', 'Instalação', 'Fixação, vedação, ventilação, acabamento e acesso conforme previsto.', 9),
    (v_comodo_2, 'Esquadrias', 'Funcionamento', 'Abrem, fecham, travam e vedam corretamente.', 10),
    (v_comodo_2, 'Limpeza', 'Limpeza final', 'Sem resíduos, manchas, poeira, massa, tinta ou materiais abandonados.', 11);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Banheiros', '🚿', 4)
    RETURNING id INTO v_comodo_3;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_3, 'Piso cerâmico', 'Aderência/acabamento', 'Sem som cavo, trincas, lascas, manchas, ressaltos ou peças desalinhadas, e com rejunte íntegro.', 1),
    (v_comodo_3, 'Revestimento parede', 'Acabamento', 'Sem som cavo, trincas, lascas, com cantos alinhados, recortes bem executados e rejunte íntegro.', 2),
    (v_comodo_3, 'Caimento', 'Escoamento', 'Água escoa para ralo/box sem empoçamento ou retorno.', 3),
    (v_comodo_3, 'Ralos', 'Funcionamento', 'Limpos, com grelha/tampa, sem entupimento ou falha de acabamento.', 4),
    (v_comodo_3, 'Box / área molhada', 'Vedação/acabamento', 'Sem falhas de rejunte, silicone, caimento ou pontos aparentes de infiltração.', 5),
    (v_comodo_3, 'Vaso sanitário', 'Fixação/funcionamento', 'Firme, íntegro, descarga funcionando, sem vazamentos, folgas ou danos.', 6),
    (v_comodo_3, 'Lavatório / cuba', 'Fixação/vedação', 'Firme, íntegro, sem trincas, folgas, vazamentos ou falha de vedação.', 7),
    (v_comodo_3, 'Bancada', 'Integridade', 'Sem riscos, lascas, manchas, trincas, folgas ou má fixação.', 8),
    (v_comodo_3, 'Torneiras / metais', 'Funcionamento', 'Boa vazão, fixação adequada, sem vazamentos, oxidação, riscos ou folgas.', 9),
    (v_comodo_3, 'Sifão / válvula / flexíveis', 'Estanqueidade', 'Conexões firmes, sem gotejamento, folgas, vazamentos ou instalação irregular.', 10),
    (v_comodo_3, 'Registros', 'Funcionamento/acabamento', 'Abrem e fecham corretamente, com acabamento firme e sem vazamento.', 11),
    (v_comodo_3, 'Porta / esquadrias', 'Funcionamento', 'Abrem, fecham, travam e vedam sem raspar, travar ou apresentar folgas inadequadas.', 12),
    (v_comodo_3, 'Forro / teto', 'Acabamento', 'Sem manchas, fissuras, umidade, mofo, ondulações ou diferença de tonalidade.', 13),
    (v_comodo_3, 'Limpeza', 'Limpeza final', 'Sem resíduos, rejunte, tinta, poeira, manchas ou materiais de obra.', 14);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Sacada / varanda, quando houver', '🌇', 5)
    RETURNING id INTO v_comodo_4;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_4, 'Piso', 'Acabamento/aderência', 'Sem som cavo, trincas, lascas, manchas, ressaltos ou peças desalinhadas, e com rejunte íntegro.', 1),
    (v_comodo_4, 'Caimento', 'Escoamento', 'Água direcionada ao ralo, sem empoçamento ou retorno para a unidade.', 2),
    (v_comodo_4, 'Ralo / drenagem', 'Funcionamento', 'Ralo limpo, com grelha/tampa, sem entupimento e com acabamento adequado.', 3),
    (v_comodo_4, 'Guarda-corpo', 'Fixação/integridade', 'Firme, sem folgas, ferrugem, falha de solda, amassados ou falha de pintura.', 4),
    (v_comodo_4, 'Vidros guarda-corpo', 'Integridade', 'Sem trincas, quebras, riscos relevantes, folgas ou fixação inadequada.', 5),
    (v_comodo_4, 'Soleira / porta acesso', 'Vedação/acabamento', 'Soleira íntegra, porta funcionando, vedação adequada e sem sinais de infiltração.', 6),
    (v_comodo_4, 'Pintura / revestimento', 'Acabamento', 'Sem manchas, fissuras, bolhas, falhas, diferença de tonalidade ou sujeira.', 7),
    (v_comodo_4, 'Limpeza', 'Limpeza final', 'Sem resíduos de obra, manchas, poeira, embalagens ou materiais abandonados.', 8);

  INSERT INTO comodos (modelo_checklist_id, nome, icone, ordem)
    VALUES (v_modelo_id, 'Instalações elétricas, pontos de luz, tomadas e interfone', '⚡', 6)
    RETURNING id INTO v_comodo_5;
  INSERT INTO itens_checklist (comodo_id, nome, servico, criterio, ordem) VALUES
    (v_comodo_5, 'Tomadas', 'Funcionamento', 'Energizadas, firmes, alinhadas, sem oxidação, sujeira, massa ou espelhos soltos.', 1),
    (v_comodo_5, 'Interruptores', 'Funcionamento', 'Acionamento fácil, sem travamento, módulos alinhados e bem fixados.', 2),
    (v_comodo_5, 'Pontos de luz', 'Funcionamento', 'Pontos testados, com fiação adequada e acabamento correto.', 3),
    (v_comodo_5, 'Quadro elétrico', 'Identificação', 'Disjuntores/circuitos identificados, compatíveis com os ambientes e conforme projeto.', 4),
    (v_comodo_5, 'Quadro elétrico', 'Segurança/acabamento', 'Quadro fixo, com tampa, sem fiação exposta, oxidação ou espaços reserva abertos.', 5),
    (v_comodo_5, 'Circuitos', 'Teste por disjuntor', 'Ligar/desligar circuitos e conferir correspondência com a identificação do quadro.', 6),
    (v_comodo_5, 'Pontos específicos', 'Funcionamento', 'Tomadas 220 V, ar-condicionado, equipamentos e pontos dedicados funcionando quando previstos.', 7),
    (v_comodo_5, 'Interfone, se houver', 'Funcionamento', 'Comunicação testada, campainha/acionamento funcionando e acabamento adequado.', 8);

END $$;

