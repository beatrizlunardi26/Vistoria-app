# Supabase — migrações e funções

Não existe CLI/migration runner configurado neste projeto. Os arquivos em
`migrations/` são aplicados manualmente, colando o conteúdo no SQL Editor
do painel do Supabase, na ordem numérica dos nomes.

`functions/criar-usuario/index.ts` é publicado manualmente também, colando
o conteúdo na aba "Edge Functions" do painel do Supabase (nome da função
tem que ser exatamente `criar-usuario`).

Este histórico existe pra rastreabilidade — não é garantido que todas as
migrações já tenham sido aplicadas ao projeto Supabase real; confirme com
quem administra o banco antes de assumir que uma tabela/coluna/política já
existe.
