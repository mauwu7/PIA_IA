#!/usr/bin/env bash
# Resuelve el problema con pyperplan y valida el plan resultante.
# Uso (desde la raíz del proyecto):  bash tools/run_planner.sh
set -euo pipefail
cd "$(dirname "$0")/.."

pip install --quiet pyperplan 2>/dev/null || true

echo "== A* con heurística hFF =="
pyperplan -H hff -s astar pddl/domain.pddl pddl/problem.pddl
mv pddl/problem.pddl.soln plan/plan.txt

echo "== BFS (óptimo para costos unitarios), solo para comparar longitud =="
pyperplan -s bfs pddl/domain.pddl pddl/problem.pddl
rm -f pddl/problem.pddl.soln

echo "== Validación independiente del plan =="
python tools/validate_plan.py
