# memory_to_associative

## Bridge Purpose
Supplies retrieved memory pointers to associative modules to improve interpretation without overloading working context.

## Source Agent(s)
- [limbic_memory_graph.md](../limbic_memory_graph.md): `.nodes[]`

## Target Agent(s)
- Modules under [associative/](../associative/)

## Transformation Logic
```text
transform(nodes):
  return nodes.map(n => ({ id: n.id, type: n.type, summary: n.summary, refs: n.refs }))
```

## State-Sync Protocol
```text
graph.set('associative:context', { nodes_compacted })
```
