# Codex Config

```
codex mcp add Gertrud --url http://localhost:3030/mcp
```

# VS Code Config

At `~/Library/Application Support/Code/User/mcp.json` add:

```
{
  "servers": {
    "Gertrud": {
      "url": "http://localhost:3030/mcp",
      "type": "http"
    }
  }
}
```

# Tests

1. Server starten mit HTTP‑Endpoints:

```
./dbfvea.sh --http
```

2. Health check:

```
curl -s http://localhost:3030/health
```

3. Views abfragen:

```
curl -s "http://localhost:3030/views"
curl -s "http://localhost:3030/views?q=Dataflow"
```

