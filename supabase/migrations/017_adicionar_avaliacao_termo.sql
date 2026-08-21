-- ============================================================
-- Adiciona o resultado da "mini vistoria" que o cliente faz antes de
-- assinar o Termo de Entrega: aprovação (com ou sem ressalvas) +
-- descrição das ressalvas, quando houver.
-- ============================================================
ALTER TABLE termos_entrega ADD COLUMN IF NOT EXISTS avaliacao text DEFAULT '';
ALTER TABLE termos_entrega ADD COLUMN IF NOT EXISTS observacoes_ressalvas text DEFAULT '';
