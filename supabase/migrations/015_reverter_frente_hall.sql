-- ============================================================
-- Reverte a "Frente de serviço" de "Hall social" e "Hall de serviço"
-- (modelo Áreas Comuns e Sistemas) que foi alterada sem querer pra
-- "Pintura" enquanto a tela de edição ainda estava aberta pra
-- qualquer usuária. Volta pro valor vazio, que faz a classificação
-- automática assumir de novo -- pelo texto do item/serviço
-- ("Acabamento/limpeza"), ela cai em "Limpeza".
-- ============================================================
UPDATE itens_checklist SET equipe = ''
WHERE nome IN ('Hall social', 'Hall de serviço')
  AND servico = 'Acabamento/limpeza';

-- Conferir (equipe deve estar vazia nas duas linhas)
SELECT nome, servico, equipe FROM itens_checklist
WHERE nome IN ('Hall social', 'Hall de serviço');
