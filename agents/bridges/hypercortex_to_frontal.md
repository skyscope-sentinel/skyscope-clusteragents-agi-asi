# hypercortex_to_frontal

## Bridge Purpose
Feeds long-horizon proposals into the executive/orchestration layer with governance gates.

## Source Agent(s)
- hypercortex modules under [hypercortex/](../hypercortex/)

## Target Agent(s)
- [architect_asi.md](../cluster_1/architect_asi.md)
- [supervisor.md](../cluster_1/supervisor.md)
- [governance.md](../cluster_8/governance.md)

## Transformation Logic
```text
transform(proposal):
  return {
    proposal_id: proposal.id,
    summary: proposal.summary,
    risks: proposal.risks,
    success_metrics: proposal.success_metrics,
    rollback: proposal.rollback
  }
```

## State-Sync Protocol
```text
graph.set('proposal:' + proposal_id, proposal)
```
