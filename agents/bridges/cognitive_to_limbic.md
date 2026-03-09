# cognitive_to_limbic

## Bridge Purpose
Moves stable, summarized state from orchestration into limbic memory for long-horizon continuity.

## Source Agent(s)
- [compactor.md](../cluster_1/compactor.md): `.state`
- [sync.md](../cluster_1/sync.md): `.state_delta`

## Target Agent(s)
- Limbic modules under [limbic/](../limbic/)

## Transformation Logic
```text
transform(x):
  return {
    msg_id: x.msg_id,
    episode_summary: x.payload.summary,
    refs: x.context_refs,
    constraints: x.constraints
  }
```

## State-Sync Protocol
```text
graph.set('episode:' + msg_id, { episode_summary, refs, constraints })
```
