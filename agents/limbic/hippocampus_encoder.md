# hippocampus_encoder

## Module Role
Encodes episodic experiences into durable memory pointers.

## Participation in State Export
Consumes state summaries from [compactor.md](../cluster_1/compactor.md) and emits graph-ready nodes.

## 6-Brain Mapping
Anchors the Hippocampus function defined in [human_brain_replication.md](../human_brain_replication.md).

## Export Template
```json
{ "module": "hippocampus_encoder", "write": { "node": { "type": "episode", "summary": "string", "refs": [] } } }
```
