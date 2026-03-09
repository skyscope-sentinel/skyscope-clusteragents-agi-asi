# Society of Minds – Sentinel Wiring

## Overview
This workspace models a multi-agent hierarchy where an executive cluster maintains goals and governance, an orchestration cluster routes work, execution clusters produce artifacts, and compaction/state export prevents runaway context.

## Hierarchy
1. **Governance & Vision:** [visionary.md](cluster_8/visionary.md), [governance.md](cluster_8/governance.md), [commander.md](cluster_8/commander.md)
2. **Orchestration & Safety:** [supervisor.md](cluster_1/supervisor.md), [protocol.md](cluster_1/protocol.md), [security.md](cluster_1/security.md), [sync.md](cluster_1/sync.md)
3. **Execution & Delivery:** clusters 2–7
4. **Handoff:** [compactor.md](cluster_1/compactor.md) and [finalizer.md](cluster_8/finalizer.md)

## Message Contract
```json
{
  "msg_id": "uuid",
  "from_agent": "string",
  "to_agent": "string",
  "intent": "string",
  "priority": "low|medium|high|critical",
  "payload": {},
  "context_refs": [{ "type": "file|url|memory", "ref": "string" }],
  "constraints": { "write_allowed": false, "network_allowed": false }
}
```

## State Export
State exports are summaries only. They must not include private chain-of-thought. They should include: goals, decisions, constraints, references, and next actions.
