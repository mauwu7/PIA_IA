# Proyecto final PDDL: Central de Esterilización (CEyE)

Dominio y problema PDDL propios que modelan el reprocesamiento de instrumental quirúrgico en un hospital: lavado, empaque, esterilización en autoclave y entrega en quirófano.

## Estructura

```
pddl-esterilizacion/
├── README.md
├── pddl/
│   ├── domain.pddl      # 18 predicados, 11 acciones
│   └── problem.pddl     # 7 áreas, 2 cajas, 1 técnico; plan óptimo de 34 pasos
├── plan/
│   ├── plan.txt         # plan encontrado por el planificador
│   └── plan_trace.md    # traza paso a paso (precondiciones, efectos, meta)
├── docs/
│   ├── design_process.md            # proceso de diseño y originalidad
└── tools/
    ├── run_planner.sh   # resuelve y valida
    └── validate_plan.py # validador independiente del plan
```

## Cómo ejecutarlo

```bash
pip install pyperplan
bash tools/run_planner.sh
```

O manualmente:

```bash
pyperplan -H hff -s astar pddl/domain.pddl pddl/problem.pddl
python tools/validate_plan.py
```

## Resumen

| Requisito | Cumplimiento |
|---|---|
| Predicados (mín. 4) | 18 |
| Acciones (mín. 3) | 11, cada una con precondiciones, lista de agregar y lista de eliminar |
| Plan (mín. 5 pasos) | 34 pasos, óptimo (verificado con BFS) |
| Originalidad y proceso de diseño | `docs/design_process.md` |
