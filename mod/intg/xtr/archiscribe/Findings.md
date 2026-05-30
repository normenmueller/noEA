# Findings (./main)

## High
- Unbounded request body with optimistic JSON parsing and no content-type checks; large payloads can cause memory pressure or ambiguity in downstream handling. `main/src/mcp/index.ts:12`

## Medium
- HTTP endpoints are unauthenticated and return raw error messages; no rate limiting or sanitization at the API boundary. `main/src/api/router.ts:6`
- ModelLoader swallows watcher errors and on parse failure returns an empty model; operational issues can be silently masked. `main/src/model/loader.ts:33`
- Logger bootstraps via `loadConfig()` which requires `modelPath`; logging can fail if model configuration is missing. `main/src/utils/logger.ts:16`

## Low
- View/element lookup resolves the first partial match; duplicates can lead to non-deterministic results. `main/src/mcp/tools.ts:93`
