-- ============================================================
-- Adiciona a coluna `equipe` (frente de serviço) em cada item do
-- checklist. Antes essa classificação só existia calculada na hora
-- de gerar o Excel (função classificarEquipe, por palavra-chave) —
-- agora fica editável direto no modelo, em "Modelos de Checklist",
-- com a classificação automática preenchida como sugestão inicial.
-- O Excel usa o valor salvo aqui se existir; senão cai de volta pra
-- classificação automática (itens antigos, criados antes desta coluna).
-- ============================================================
ALTER TABLE itens_checklist ADD COLUMN IF NOT EXISTS equipe text DEFAULT '';
