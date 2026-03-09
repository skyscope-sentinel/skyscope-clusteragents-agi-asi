# Limbic-Memory Graph

## Graph Purpose
Represents episodic, semantic, and procedural memory pointers used by the hive to stabilize long-running work without carrying full history in context.

## Node Types
- **Episode:** time-bounded event summary with references
- **Concept:** durable fact or definition with provenance
- **Procedure:** stepwise workflow with preconditions and rollback
- **Constraint:** policy or boundary condition that must persist

## Edge Types
- **caused_by**, **supports**, **contradicts**, **refines**, **depends_on**

## JSON Schema
```json
{
  "graph_id": "skyscope-memory-graph",
  "nodes": [
    { "id": "string", "type": "episode|concept|procedure|constraint", "summary": "string", "refs": [] }
  ],
  "edges": [
    { "from": "string", "to": "string", "type": "caused_by|supports|contradicts|refines|depends_on" }
  ]
}
```
