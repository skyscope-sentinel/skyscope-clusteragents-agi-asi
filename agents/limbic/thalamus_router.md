# thalamus_router

## Module Role
Maintains the routing table for inter-agent messages.

## Routing Table
```yaml
routes:
  governance_sensitive: cluster_8/governance
  security_sensitive: cluster_1/security
  compaction: cluster_1/compactor
```

## Export Template
```json
{ "module": "thalamus_router", "routes": {} }
```
