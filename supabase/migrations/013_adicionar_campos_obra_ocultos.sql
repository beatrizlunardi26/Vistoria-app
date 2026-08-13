-- ============================================================
-- Adiciona a lista de campos opcionais do formulário de obra que a
-- usuária escolheu esconder (ex: "Cliente", "Endereço") — clicando
-- no "x" ao lado do campo no modal "Editar obra". É compartilhada
-- (mesma linha única da tabela escritorio) porque é uma decisão de
-- processo do escritório, não uma preferência pessoal. Campos
-- escondidos também deixam de aparecer nos relatórios/PDF/Excel.
-- ============================================================
ALTER TABLE escritorio ADD COLUMN IF NOT EXISTS campos_obra_ocultos jsonb DEFAULT '[]'::jsonb;
