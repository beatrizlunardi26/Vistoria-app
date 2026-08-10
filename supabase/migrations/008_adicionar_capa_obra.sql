-- ============================================================
-- Adiciona a coluna de imagem de capa em cada obra (mostrada no
-- card da obra na tela Início). A imagem em si fica no mesmo bucket
-- de fotos já existente (vistoria-fotos), em capas/<obra_id>.jpg —
-- a tabela só guarda a URL.
-- ============================================================
ALTER TABLE obras ADD COLUMN IF NOT EXISTS capa_url text DEFAULT '';
