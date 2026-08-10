-- ============================================================
-- Cria o bucket de Storage para as fotos da vistoria e libera acesso
--
-- Por quê: as fotos eram salvas como texto base64 dentro da tabela
-- respostas_itens (coluna fotos, jsonb). Isso funciona, mas cada foto
-- vira um texto de várias centenas de KB dentro da linha do banco —
-- com o tempo (muitas fotos por vistoria, várias obras) a tabela fica
-- pesada e toda consulta que faz "select *" nela (os relatórios, por
-- exemplo) passa a trafegar megabytes de fotos toda vez, mesmo quando
-- só precisa dos textos/status. Bucket de Storage guarda o arquivo da
-- foto à parte e a tabela guarda só uma URL (texto curto) — muito mais
-- leve para consultas e escala melhor conforme o uso cresce.
--
-- Bucket público: qualquer um com o link da foto consegue vê-la (sem
-- precisar de login), mas só usuários autenticados podem enviar,
-- sobrescrever ou apagar fotos. Isso é aceitável aqui porque as fotos
-- já eram enviadas para o navegador de qualquer jeito ao carregar a
-- vistoria; não há como adivinhar a URL de uma foto sem já ter acesso
-- à vistoria (o caminho inclui o id da vistoria e do item).
-- ============================================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('vistoria-fotos', 'vistoria-fotos', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "public_read_fotos" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_upload_fotos" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_update_fotos" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_delete_fotos" ON storage.objects;

CREATE POLICY "public_read_fotos" ON storage.objects
  FOR SELECT USING (bucket_id = 'vistoria-fotos');

CREATE POLICY "authenticated_upload_fotos" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'vistoria-fotos');

CREATE POLICY "authenticated_update_fotos" ON storage.objects
  FOR UPDATE TO authenticated USING (bucket_id = 'vistoria-fotos');

CREATE POLICY "authenticated_delete_fotos" ON storage.objects
  FOR DELETE TO authenticated USING (bucket_id = 'vistoria-fotos');

-- Conferir que o bucket foi criado
SELECT id, name, public FROM storage.buckets WHERE id = 'vistoria-fotos';
