#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}/Documents/Skyscope Sentinel Intelligence - Multi Agent AGI-ASI"

python3 - <<'PY'
import json, os, glob, datetime

root = os.path.expanduser("~/Documents/Skyscope Sentinel Intelligence - Multi Agent AGI-ASI")
agents_dir = os.path.join(root, "agents")

cluster_dirs = [os.path.join(agents_dir, f"cluster_{i}") for i in range(1, 9)]
agents = []

for cdir in cluster_dirs:
    for path in sorted(glob.glob(os.path.join(cdir, "*.md"))):
        agent_id = os.path.splitext(os.path.basename(path))[0]
        cluster = os.path.basename(cdir)
        agents.append({
            "agent_id": agent_id,
            "cluster": cluster,
            "definition_path": os.path.relpath(path, agents_dir),
            "state": {
                "status": "idle",
                "goals": [],
                "active_context_summary": "",
                "memory_refs": [],
                "last_outputs": []
            }
        })

connections = [
    {"from": "cluster_8/governance", "to": "cluster_1/security", "type": "policy_gate"},
    {"from": "cluster_1/supervisor", "to": "cluster_1/logic_engineer", "type": "delegate"},
    {"from": "cluster_1/supervisor", "to": "cluster_2/backend", "type": "delegate"},
    {"from": "cluster_1/supervisor", "to": "cluster_7/synthesizer", "type": "delegate"},
    {"from": "cluster_1/compactor", "to": "limbic/hippocampus_encoder", "type": "persist"},
    {"from": "cluster_8/finalizer", "to": "cluster_1/compactor", "type": "export_request"}
]

payload = {
    "schema": "skyscope.neural_state.v1",
    "generated_at": datetime.datetime.utcnow().replace(microsecond=0).isoformat() + "Z",
    "notes": "State is a summary-only export and must not include private chain-of-thought.",
    "agents": agents,
    "connections": connections
}

out_path = os.path.join(agents_dir, "neural_state.json")
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(payload, f, indent=2)
    f.write("\n")

print(out_path)
PY

echo "Done."
