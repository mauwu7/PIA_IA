"""
Validador independiente de planes STRIPS.

Lee domain.pddl, problem.pddl y plan.txt, aplica cada acción del plan sobre el
estado, comprueba que sus precondiciones se cumplan y que al final se cumpla
la meta. Genera además una traza legible (plan/plan_trace.md) con, para cada
paso: precondiciones, efectos que agrega y efectos que elimina.

Uso (desde la raíz del proyecto):
    python tools/validate_plan.py
Requiere:  pip install pyperplan   (solo se usa su parser/grounder de PDDL)
"""
import sys
from pathlib import Path

from pyperplan import grounding
from pyperplan.pddl.parser import Parser

RAIZ = Path(__file__).resolve().parent.parent
DOMINIO = RAIZ / "pddl" / "domain.pddl"
PROBLEMA = RAIZ / "pddl" / "problem.pddl"
PLAN = RAIZ / "plan" / "plan.txt"
TRAZA = RAIZ / "plan" / "plan_trace.md"


def main():
    dom = Parser(str(DOMINIO), str(PROBLEMA))
    dominio = dom.parse_domain()
    problema = dom.parse_problem(dominio)
    tarea = grounding.ground(problema)
    operadores = {op.name: op for op in tarea.operators}

    pasos = [l.strip() for l in PLAN.read_text().splitlines() if l.strip().startswith("(")]
    estado = set(tarea.initial_state)
    lineas = [f"# Traza de ejecución del plan ({len(pasos)} pasos)\n",
              "> Nota: los predicados estáticos (`connected`, `has-sink`, `packing-station`, `washer-at`,",
              "> `autoclave-at`, `kit-requested`) nunca cambian y el grounder de pyperplan los omite de las",
              "> precondiciones listadas; todos se cumplen desde el estado inicial.\n"]
    ok = True

    for i, paso in enumerate(pasos, 1):
        op = operadores.get(paso)
        if op is None:
            print(f"Paso {i}: acción desconocida {paso}")
            ok = False
            continue
        faltan = sorted(op.preconditions - estado)
        if faltan:
            ok = False
            print(f"Paso {i} {paso}: precondiciones NO satisfechas: {faltan}")
        lineas.append(f"## Paso {i}: `{paso}`\n")
        lineas.append("- Precondiciones (todas verdaderas en el estado previo): "
                      + ", ".join(f"`{p}`" for p in sorted(op.preconditions)))
        lineas.append("- Agrega: " + (", ".join(f"`{p}`" for p in sorted(op.add_effects)) or "—"))
        lineas.append("- Elimina: " + (", ".join(f"`{p}`" for p in sorted(op.del_effects)) or "—"))
        lineas.append("")
        estado = (estado - op.del_effects) | op.add_effects

    meta_cumplida = tarea.goals <= estado
    lineas.append("## Verificación de la meta\n")
    for g in sorted(tarea.goals):
        lineas.append(f"- `{g}`: {'✔ se cumple' if g in estado else '✘ NO se cumple'}")
    TRAZA.write_text("\n".join(lineas) + "\n", encoding="utf-8")

    if ok and meta_cumplida:
        print(f"PLAN VÁLIDO: {len(pasos)} pasos, todas las precondiciones se cumplen y la meta se alcanza.")
        print(f"Traza escrita en {TRAZA.relative_to(RAIZ)}")
    else:
        print("PLAN INVÁLIDO")
        sys.exit(1)


if __name__ == "__main__":
    main()
