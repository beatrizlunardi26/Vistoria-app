# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

VistoriaApp is a construction final-inspection ("vistoria de entrega de obra") web app: a single HTML file (HTML + CSS + vanilla JS, no framework, no build step) using Supabase (Postgres + Auth + Storage) as the entire backend. It's used by a small engineering firm (Puel Engenharia) to run checklist-based inspections across construction sites before handover to clients, and export PDF/Excel reports.

## Critical structural gotcha — read this first

**The file in this folder is `index.html`, but that is NOT what's deployed.** The real GitHub repo (`github.com/beatrizlunardi26/Vistoria-app`) has two files:
- `vistoria-obra-app.html` — the actual application (what this local `index.html` is a working copy of).
- `index.html` — just a meta-refresh/JS redirect shim to `vistoria-obra-app.html`. Never put app logic here.

Deploy is GitHub → Vercel (auto-deploys on push to `main`). Workflow to ship a change:
1. Edit `index.html` in this folder.
2. Clone/pull the GitHub repo elsewhere, copy this file's contents into that clone's `vistoria-obra-app.html` (convert LF→CRLF first, e.g. `sed 's/$/\r/'`, to match the repo's existing line endings and keep diffs clean).
3. Commit with an explicit identity (no global git config exists for this): `git -c user.name="..." -c user.email="..." commit -m "..."`.
4. `git push origin main` — this requires an interactive GitHub OAuth device-flow prompt (Git Credential Manager) the first time in a session; it cannot be completed from a fully non-interactive shell, so if push hangs, hand the two commands to the user to run in their own terminal.

There is no build step, linter, or test suite — verify changes by opening `index.html` directly in a browser (or a headless browser tool) and checking the console for errors; there's nothing to "run" beyond that.

## Architecture

### Supabase schema
- `engenheiras` (id, email, nome, role) — `role` is `'admin' | 'usuario'`, default `'usuario'`. A row is auto-created on first login if none matches the authenticated email.
- `obras` (id, nome, construtora, cliente, endereco, email_const, whatsapp_cli, data_vistoria, modelo_checklist_id, icone, status, engenheira_id, ...) — `status`: `pendente | em_vistoria | concluida`.
- `modelos_checklist` (id, nome, descricao, engenheira_id, por_unidade) — `por_unidade` (boolean, default true) decides whether this checklist is filled once per apartment/unit or once for the whole obra (e.g. "Áreas Comuns e Sistemas" = building-wide, `por_unidade=false`; "Áreas Internas — Unidade Privativa" = per-apartment).
- `comodos` (id, modelo_checklist_id, nome, icone, ordem) — rooms/sections within a model.
- `itens_checklist` (id, comodo_id, nome, detalhe, criterio, servico, ordem) — individual checklist rows; `servico` is the trade/team tag used to group pendências in exports.
- `vistorias` (id, obra_id, engenheira_id, modelo_checklist_id, status) — one active inspection per obra.
- `respostas_itens` (id, vistoria_id, item_id, comodo_id, unidade_id, status, observacao, fotos jsonb, item_ativo, atualizado_em) — the actual answers. `status`: `pendente | conforme | nao_conforme | nao_aplicavel` in the DB (mapped to short `'' | conf | nc | na` in the JS — see `statusDbParaLocal`/`statusLocalParaDb`).
- `unidades` (id, obra_id, nome, ordem) — apartments/units within an obra.

Two unique constraints on `respostas_itens` matter and must both exist for `upsert` to work without creating duplicate rows:
- `UNIQUE (vistoria_id, item_id, unidade_id)` — for per-unit models.
- A **partial** unique index `ON (vistoria_id, item_id) WHERE unidade_id IS NULL` — for obra-wide models (`por_unidade=false`). This exists because Postgres never treats `NULL = NULL` as a conflict, so without the partial index, saving a per-obra checklist would silently insert a new row on every keystroke instead of updating. `salvarResposta()` picks the right `onConflict` target based on `modeloUsaUnidade(modeloAtivoId)`.

### Auth & authorization
Real Supabase Auth (email+password), no self-signup UI — accounts are created either via the Supabase Dashboard or via the in-app admin-only "Usuários" panel, which calls an Edge Function (`criar-usuario`, source kept in `edge_function_criar_usuario.ts` in this folder, deployed through the Supabase Dashboard's own Edge Function editor — no local CLI involved). The Edge Function holds the service-role key server-side and verifies the caller is `role='admin'` before creating a user; the browser never sees the service-role key.

RLS is enabled on every table. The general pattern: SELECT/INSERT/UPDATE open to any authenticated user (all engenheiras currently share all data — there is no per-company/tenant isolation yet), DELETE restricted to `role='admin'` via a subquery against `engenheiras`. The app also gates admin-only UI client-side (`isAdmin()`) as a UX nicety, but the RLS policies are the actual enforcement — don't assume a client-side check is sufficient when adding new destructive actions.

### Photo storage
Photos are uploaded to a Supabase Storage bucket (`vistoria-fotos`, public read / authenticated write), not stored as base64 in the DB — `respostas_itens.fotos` (jsonb array) holds `{url, path, legenda}` per photo. **Legacy fallback**: any photo saved before this migration has `{data: "<base64>", legenda}` instead; every render/PDF path checks `foto.url || foto.data`, and `fotoParaDataUri()` returns `foto.data` as-is if present (no fetch needed) or downloads+converts `foto.url` for jsPDF (which cannot embed a remote URL directly, only base64/loaded images). Editing a photo re-uploads to the same Storage path with `upsert:true` and cache-busts the URL.

### PDF generation (`pdfSetup()`)
A factory function returning a stateful helper object wrapping jsPDF, with shared building blocks (`cabecalho`, `blocoIdent`, `blocoResumo`, `blocoFotos`, `blocoAmbiente`, `blocoNCItem`, `tituloGrande`) used by the three report generators (`gerarPDF` = non-conformities only, `gerarPDFApto` = full checklist status per unit, `gerarPDFUnidade` = non-conformities grouped by unit). `blocoFotos`/`blocoNCItem` are `async` (they may need to fetch a photo from Storage), which is why several `forEach` loops in the report generators had to become `for...of` — mixing `forEach` with an awaited call inside it lets sibling iterations interleave and corrupt the shared `y` cursor position in the PDF.

### Client-side state
No framework — `modelos`, `obras`, `comodos`, `itens`, `respostas`, `unidades`, `unidadeAtiva`, `modeloAtivoId`, `vistoriaAtiva`, `engId`/`engRole` are module-level mutable globals, reassigned by the various `carregar*`/`abrir*` functions and read directly by render functions. There's no reactivity system — after mutating state, the relevant `render*`/`atualizar*` function must be called explicitly.

## Known pending setup steps
The SQL migrations and the Edge Function are version-controlled in the GitHub repo under `supabase/migrations/` (numbered, applied in order) and `supabase/functions/criar-usuario/index.ts`, but there is no CLI/migration runner wired up — each one is applied manually by pasting into the Supabase Dashboard's SQL Editor / Edge Functions editor. Not all of them are guaranteed to have been applied to the live project yet — check with the user before assuming a given feature (an RLS policy, the `por_unidade` column, the `criar-usuario` function, the Storage bucket) is actually live. When adding a new DB change, write a new numbered `.sql` file in `supabase/migrations/` following the existing style (comment explaining what/why, not just what) and ask the user to run it.
