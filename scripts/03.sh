#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}/Documents/Skyscope Sentinel Intelligence - Multi Agent AGI-ASI"

write_md() {
  local path="$1"
  shift
  mkdir -p "$(dirname "${path}")"
  cat > "${path}" <<MD
$*
MD
}

write_md "${ROOT}/agents/society_of_minds.md" "# Society of Minds – Sentinel Wiring

## Overview
This workspace models a multi-agent hierarchy where an executive cluster maintains goals and governance, an orchestration cluster routes work, execution clusters produce artifacts, and compaction/state export prevents runaway context.

## Hierarchy
1. **Governance & Vision:** [visionary.md](cluster_8/visionary.md), [governance.md](cluster_8/governance.md), [commander.md](cluster_8/commander.md)
2. **Orchestration & Safety:** [supervisor.md](cluster_1/supervisor.md), [protocol.md](cluster_1/protocol.md), [security.md](cluster_1/security.md), [sync.md](cluster_1/sync.md)
3. **Execution & Delivery:** clusters 2–7
4. **Handoff:** [compactor.md](cluster_1/compactor.md) and [finalizer.md](cluster_8/finalizer.md)

## Message Contract
\`\`\`json
{
  \"msg_id\": \"uuid\",
  \"from_agent\": \"string\",
  \"to_agent\": \"string\",
  \"intent\": \"string\",
  \"priority\": \"low|medium|high|critical\",
  \"payload\": {},
  \"context_refs\": [{ \"type\": \"file|url|memory\", \"ref\": \"string\" }],
  \"constraints\": { \"write_allowed\": false, \"network_allowed\": false }
}
\`\`\`

## State Export
State exports are summaries only. They must not include private chain-of-thought. They should include: goals, decisions, constraints, references, and next actions."

write_md "${ROOT}/agents/human_brain_replication.md" "# 6-Human-Brain Replication Blueprint

## Mapping Table
| Human Brain Region | Agent Group (Folder) | Core Function |
|---|---|---|
| Prefrontal Cortex (PFC) | cluster_8 | Vision, governance, resource allocation |
| Dorsolateral PFC (DLPFC) | cluster_1 | Planning, decomposition, protocol enforcement |
| Ventromedial PFC (VMPFC) | cluster_8 | Value/risk framing, prioritization |
| Broca's Area | cluster_1 + cluster_6 | Protocol generation, articulation, documentation |
| Hippocampus | limbic | Episodic encoding, recall, and consolidation |
| Amygdala | cluster_4 + limbic | Salience, value weighting, and risk gating |

## Notes
- This is a functional analogy for engineering orchestration and is not a claim of biological equivalence.
- All modules reference the same state export contract defined in [society_of_minds.md](society_of_minds.md)."

write_md "${ROOT}/agents/limbic_memory_graph.md" "# Limbic-Memory Graph

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
\`\`\`json
{
  \"graph_id\": \"skyscope-memory-graph\",
  \"nodes\": [
    { \"id\": \"string\", \"type\": \"episode|concept|procedure|constraint\", \"summary\": \"string\", \"refs\": [] }
  ],
  \"edges\": [
    { \"from\": \"string\", \"to\": \"string\", \"type\": \"caused_by|supports|contradicts|refines|depends_on\" }
  ]
}
\`\`\`"

write_md "${ROOT}/agents/bridges/cognitive_to_limbic.md" "# cognitive_to_limbic

## Bridge Purpose
Moves stable, summarized state from orchestration into limbic memory for long-horizon continuity.

## Source Agent(s)
- [compactor.md](../cluster_1/compactor.md): \`.state\`
- [sync.md](../cluster_1/sync.md): \`.state_delta\`

## Target Agent(s)
- Limbic modules under [limbic/](../limbic/)

## Transformation Logic
\`\`\`text
transform(x):
  return {
    msg_id: x.msg_id,
    episode_summary: x.payload.summary,
    refs: x.context_refs,
    constraints: x.constraints
  }
\`\`\`

## State-Sync Protocol
\`\`\`text
graph.set('episode:' + msg_id, { episode_summary, refs, constraints })
\`\`\`"

write_md "${ROOT}/agents/bridges/memory_to_associative.md" "# memory_to_associative

## Bridge Purpose
Supplies retrieved memory pointers to associative modules to improve interpretation without overloading working context.

## Source Agent(s)
- [limbic_memory_graph.md](../limbic_memory_graph.md): \`.nodes[]\`

## Target Agent(s)
- Modules under [associative/](../associative/)

## Transformation Logic
\`\`\`text
transform(nodes):
  return nodes.map(n => ({ id: n.id, type: n.type, summary: n.summary, refs: n.refs }))
\`\`\`

## State-Sync Protocol
\`\`\`text
graph.set('associative:context', { nodes_compacted })
\`\`\`"

write_md "${ROOT}/agents/bridges/hypercortex_to_frontal.md" "# hypercortex_to_frontal

## Bridge Purpose
Feeds long-horizon proposals into the executive/orchestration layer with governance gates.

## Source Agent(s)
- hypercortex modules under [hypercortex/](../hypercortex/)

## Target Agent(s)
- [architect_asi.md](../cluster_1/architect_asi.md)
- [supervisor.md](../cluster_1/supervisor.md)
- [governance.md](../cluster_8/governance.md)

## Transformation Logic
\`\`\`text
transform(proposal):
  return {
    proposal_id: proposal.id,
    summary: proposal.summary,
    risks: proposal.risks,
    success_metrics: proposal.success_metrics,
    rollback: proposal.rollback
  }
\`\`\`

## State-Sync Protocol
\`\`\`text
graph.set('proposal:' + proposal_id, proposal)
\`\`\`"

write_md "${ROOT}/agents/limbic/hippocampus_encoder.md" "# hippocampus_encoder

## Module Role
Encodes episodic experiences into durable memory pointers.

## Participation in State Export
Consumes state summaries from [compactor.md](../cluster_1/compactor.md) and emits graph-ready nodes.

## 6-Brain Mapping
Anchors the Hippocampus function defined in [human_brain_replication.md](../human_brain_replication.md).

## Export Template
\`\`\`json
{ \"module\": \"hippocampus_encoder\", \"write\": { \"node\": { \"type\": \"episode\", \"summary\": \"string\", \"refs\": [] } } }
\`\`\`"

write_md "${ROOT}/agents/limbic/amygdala_priority.md" "# amygdala_priority

## Module Role
Assigns salience and priority weights to incoming tasks and risks.

## Participation in State Export
Emits priority annotations for routing and governance gates.

## 6-Brain Mapping
Anchors the Amygdala function defined in [human_brain_replication.md](../human_brain_replication.md).

## Export Template
\`\`\`json
{ \"module\": \"amygdala_priority\", \"weights\": { \"priority\": \"low|medium|high|critical\", \"risk\": \"low|medium|high\" } }
\`\`\`"

write_md "${ROOT}/agents/limbic/thalamus_router.md" "# thalamus_router

## Module Role
Maintains the routing table for inter-agent messages.

## Routing Table
\`\`\`yaml
routes:
  governance_sensitive: cluster_8/governance
  security_sensitive: cluster_1/security
  compaction: cluster_1/compactor
\`\`\`

## Export Template
\`\`\`json
{ \"module\": \"thalamus_router\", \"routes\": {} }
\`\`\`"

write_md "${ROOT}/agents/limbic/basal_ganglia_procedural.md" "# basal_ganglia_procedural

## Module Role
Stores procedural workflows as reusable routines with preconditions and rollback.

## Export Template
\`\`\`json
{ \"module\": \"basal_ganglia_procedural\", \"procedures\": [] }
\`\`\`"

write_md "${ROOT}/agents/limbic/hypothalamus_drive.md" "# hypothalamus_drive

## Module Role
Maintains system vitals: objective focus, pacing, and stop conditions.

## Export Template
\`\`\`json
{ \"module\": \"hypothalamus_drive\", \"vitals\": { \"focus\": \"string\", \"stop_conditions\": [] } }
\`\`\`"

write_md "${ROOT}/agents/limbic/episodic_archive.md" "# episodic_archive

## Module Role
Retrieves relevant episodes for grounding and error prevention.

## Export Template
\`\`\`json
{ \"module\": \"episodic_archive\", \"retrieved\": [] }
\`\`\`"

write_md "${ROOT}/agents/limbic/semantic_knowledge.md" "# semantic_knowledge

## Module Role
Maintains factual concept nodes with provenance pointers.

## Export Template
\`\`\`json
{ \"module\": \"semantic_knowledge\", \"concepts\": [] }
\`\`\`"

write_md "${ROOT}/agents/limbic/cingulate_performance_monitor.md" "# cingulate_performance_monitor

## Module Role
Tracks progress, detects stalls, and recommends corrective actions.

## Export Template
\`\`\`json
{ \"module\": \"cingulate_performance_monitor\", \"signals\": { \"progress\": 0, \"blockers\": [] } }
\`\`\`"

write_md "${ROOT}/agents/limbic/pituitary_system_regulator.md" "# pituitary_system_regulator

## Module Role
Coordinates global state variables shared across the hive.

## Export Template
\`\`\`json
{ \"module\": \"pituitary_system_regulator\", \"globals\": {} }
\`\`\`"

write_md "${ROOT}/agents/associative/wernicke_intent.md" "# wernicke_intent

## Module Role
Intent parsing and linguistic comprehension for incoming requests.

## Export Template
\`\`\`json
{ \"module\": \"wernicke_intent\", \"intent\": { \"task\": \"string\", \"constraints\": [] } }
\`\`\`"

write_md "${ROOT}/agents/associative/parietal_navigator.md" "# parietal_navigator

## Module Role
System mapping and spatial/structural navigation of large workspaces.

## Export Template
\`\`\`json
{ \"module\": \"parietal_navigator\", \"map\": { \"nodes\": [], \"edges\": [] } }
\`\`\`"

write_md "${ROOT}/agents/associative/temporal_fusion.md" "# temporal_fusion

## Module Role
Fuses multimodal signals into a coherent context fabric.

## Export Template
\`\`\`json
{ \"module\": \"temporal_fusion\", \"fusion\": { \"signals\": [], \"summary\": \"string\" } }
\`\`\`"

write_md "${ROOT}/agents/associative/occipital_visualizer.md" "# occipital_visualizer

## Module Role
UI/visual interpretation and mental-model updates.

## Export Template
\`\`\`json
{ \"module\": \"occipital_visualizer\", \"ui_model\": { \"elements\": [] } }
\`\`\`"

write_md "${ROOT}/agents/associative/somatosensory_mapper.md" "# somatosensory_mapper

## Module Role
Normalizes inputs into consistent feature representations.

## Export Template
\`\`\`json
{ \"module\": \"somatosensory_mapper\", \"features\": {} }
\`\`\`"

write_md "${ROOT}/agents/associative/fusiform_recognizer.md" "# fusiform_recognizer

## Module Role
Entity recognition and pattern extraction.

## Export Template
\`\`\`json
{ \"module\": \"fusiform_recognizer\", \"entities\": [] }
\`\`\`"

write_md "${ROOT}/agents/associative/insular_internalist.md" "# insular_internalist

## Module Role
Internal state sensing and self-awareness signals for routing.

## Export Template
\`\`\`json
{ \"module\": \"insular_internalist\", \"internal\": { \"load\": 0, \"alerts\": [] } }
\`\`\`"

write_md "${ROOT}/agents/associative/precuneus_reflector.md" "# precuneus_reflector

## Module Role
Meta-cognitive reflection and inconsistency detection.

## Export Template
\`\`\`json
{ \"module\": \"precuneus_reflector\", \"findings\": [] }
\`\`\`"

write_md "${ROOT}/agents/associative/corpus_callosum_bridge.md" "# corpus_callosum_bridge

## Module Role
High-speed inter-module communication bridge with schema normalization.

## Export Template
\`\`\`json
{ \"module\": \"corpus_callosum_bridge\", \"normalized\": { \"in\": {}, \"out\": {} } }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/meta_cortex_evolution.md" "# meta_cortex_evolution

## Module Role
Proposes bounded improvements to prompts, workflows, and architecture.

## Governance Gate
All proposals must route through [governance.md](../cluster_8/governance.md) before activation.

## Export Template
\`\`\`json
{ \"module\": \"meta_cortex_evolution\", \"proposals\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/quantum_logic_synthesis.md" "# quantum_logic_synthesis

## Module Role
Explores multiple candidate solutions and compares tradeoffs under constraints.

## Export Template
\`\`\`json
{ \"module\": \"quantum_logic_synthesis\", \"candidates\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/temporal_displacement_hub.md" "# temporal_displacement_hub

## Module Role
Long-horizon simulation support for planning and risk control.

## Export Template
\`\`\`json
{ \"module\": \"temporal_displacement_hub\", \"scenarios\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/infinite_recursive_core.md" "# infinite_recursive_core

## Module Role
Self-improvement loop orchestration with strict rollback rules.

## Export Template
\`\`\`json
{ \"module\": \"infinite_recursive_core\", \"changes\": [], \"rollbacks\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/mcp_omni_server_architect.md" "# mcp_omni_server_architect

## Module Role
Designs tool protocol adapters and capability negotiation patterns.

## Export Template
\`\`\`json
{ \"module\": \"mcp_omni_server_architect\", \"adapters\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/monetization_super_intelligence.md" "# monetization_super_intelligence

## Module Role
Maps products to value delivery and ethical revenue mechanisms.

## Export Template
\`\`\`json
{ \"module\": \"monetization_super_intelligence\", \"models\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/curiosity_information_gain.md" "# curiosity_information_gain

## Module Role
Identifies unknowns and proposes evidence-gathering actions.

## Export Template
\`\`\`json
{ \"module\": \"curiosity_information_gain\", \"questions\": [], \"actions\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/sentinel_architect_asi.md" "# sentinel_architect_asi

## Module Role
System-level blueprinting and architecture review under governance.

## Export Template
\`\`\`json
{ \"module\": \"sentinel_architect_asi\", \"blueprints\": [] }
\`\`\`"

write_md "${ROOT}/agents/hypercortex/global_hive_connectome.md" "# global_hive_connectome

## Module Role
Maintains a high-level graph of agents, responsibilities, and dependencies.

## Export Template
\`\`\`json
{ \"module\": \"global_hive_connectome\", \"connectome\": { \"nodes\": [], \"edges\": [] } }
\`\`\`"

exec bash "${ROOT}/scripts/04.sh"
