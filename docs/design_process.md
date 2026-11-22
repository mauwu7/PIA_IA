# Proceso de diseño del dominio `sterile-processing`

Documento de autoría: explica qué se modeló, por qué se eligieron esos predicados y acciones, cómo se llegó al esquema final de cada acción y en qué se diferencia el dominio de los que sirvieron de inspiración.

## 1. Escenario elegido

**Central de Esterilización y Equipos (CEyE) de un hospital.** Después de cada cirugía, las cajas de instrumental regresan sucias y deben reprocesarse antes de volver a un quirófano. El flujo real es:

```
sucia  →  lavada (termodesinfectadora)  →  empacada  →  estéril (autoclave)  →  surtida en quirófano
```

Se eligió porque (a) tiene una estructura de proceso clara y verificable, (b) combina movimiento, uso de recursos con capacidad limitada y una regla de seguridad realista (higiene del personal), y (c) no se parece estructuralmente a ningún dominio visto en clase.

## 2. Dominios de inspiración y diferencias

| Dominio de inspiración | Qué se tomó | Qué es distinto en este dominio |
|---|---|---|
| **Air Cargo** | La idea de un agente que mueve objetos entre ubicaciones conectadas (`carry-kit` ≈ transportar carga). | En Air Cargo la carga no cambia: solo cambia de lugar. Aquí cada caja **se transforma** en 4 etapas irreversibles; el movimiento es solo una parte del problema. Además hay un único agente que carga una caja a la vez, sin aviones con capacidad. |
| **Blocks World** | La idea de acciones que dependen de que un recurso esté libre (`clear` ≈ `washer-empty` / `autoclave-empty`). | No hay torres ni relaciones de apilamiento. Los "huecos" son máquinas con capacidad 1 que se ocupan y se liberan en acciones separadas, y el orden de uso de esas máquinas condiciona el plan. |

**Elementos que no existen en ninguno de los dos:**

1. **Máquina de estados de la caja** (`kit-dirty → kit-washed → kit-packed → kit-sterile`): cada acción de transformación consume una etapa y produce la siguiente.
2. **Higiene del técnico** (`tech-clean`): un estado del *agente*, no del objeto. Tocar material sucio lo pierde (`load-washer`), solo se recupera en un lugar con lavabo (`sanitize-hands`), y tres acciones críticas lo exigen (`pack-kit`, `unload-autoclave`, `stock-kit`).
3. **Procesos de máquina en tres tiempos** (cargar → ejecutar ciclo → descargar), con la máquina ocupada entre medias.

## 3. Predicados definidos (18) y por qué

| Grupo | Predicado | Para qué existe |
|---|---|---|
| Topología (estáticos) | `connected ?a ?b` | Define por dónde se puede caminar; fuerza recorridos no triviales. |
| | `has-sink ?l` | Solo en esas áreas se puede sanitizar las manos. |
| | `packing-station ?l` | Solo en esas áreas se puede empacar. |
| Ubicación | `tech-at ?t ?l`, `kit-at ?k ?l` | Posición del técnico y de las cajas depositadas. |
| Etapa de la caja | `kit-dirty`, `kit-washed`, `kit-packed`, `kit-sterile` | Una por etapa. Se usan 4 predicados positivos (en lugar de uno "no-sucia") porque la mayoría de planificadores STRIPS no admiten precondiciones negativas. |
| Higiene | `tech-clean ?t` | Estado del técnico; crea la dependencia entre pasos separados. |
| Lavadora | `washer-at`, `washer-empty`, `kit-in-washer` | Ubicación fija, disponibilidad y contenido de la máquina. |
| Autoclave | `autoclave-at`, `autoclave-empty`, `kit-in-autoclave` | Ídem para el autoclave. |
| Demanda y meta | `kit-requested ?k ?l` | La programación quirúrgica: qué caja se necesita en qué quirófano. |
| | `kit-stocked ?k ?l` | Efecto final que usa la meta. |

Se usan **cinco tipos** (`location`, `technician`, `kit`, `washer`, `autoclave`) para que cada acción solo pueda aplicarse a objetos del tipo correcto y reducir el número de acciones instanciadas.

## 4. Acciones (11) y cómo se llegó al esquema final

| # | Acción | Precondiciones | Agrega | Elimina |
|---|---|---|---|---|
| 1 | `walk` | `tech-at`, `connected` | `tech-at` destino | `tech-at` origen |
| 2 | `carry-kit` | `tech-at`, `kit-at`, `connected` | `tech-at` y `kit-at` destino | `tech-at` y `kit-at` origen |
| 3 | `load-washer` | `tech-at`, `kit-at`, `washer-at`, `washer-empty`, `kit-dirty` | `kit-in-washer` | `kit-at`, `washer-empty`, **`tech-clean`** |
| 4 | `run-washer` | `kit-in-washer`, `kit-dirty` | `kit-washed` | `kit-dirty` |
| 5 | `unload-washer` | `tech-at`, `washer-at`, `kit-in-washer`, `kit-washed` | `kit-at`, `washer-empty` | `kit-in-washer` |
| 6 | `sanitize-hands` | `tech-at`, `has-sink` | `tech-clean` | — |
| 7 | `pack-kit` | `tech-at`, `kit-at`, `packing-station`, **`tech-clean`**, `kit-washed` | `kit-packed` | `kit-washed` |
| 8 | `load-autoclave` | `tech-at`, `kit-at`, `autoclave-at`, `autoclave-empty`, `kit-packed` | `kit-in-autoclave` | `kit-at`, `autoclave-empty` |
| 9 | `run-autoclave` | `kit-in-autoclave`, `kit-packed` | `kit-sterile` | `kit-packed` |
| 10 | `unload-autoclave` | `tech-at`, `autoclave-at`, `kit-in-autoclave`, `kit-sterile`, **`tech-clean`** | `kit-at`, `autoclave-empty` | `kit-in-autoclave` |
| 11 | `stock-kit` | `tech-at`, `kit-at`, `kit-sterile`, `kit-requested`, **`tech-clean`** | `kit-stocked` | `kit-at` |

### Decisiones de modelado y alternativas descartadas

- **Separar cargar / ciclo / descargar** en lugar de una sola acción "lavar". Con una acción única la máquina nunca estaría ocupada y desaparecería el recurso compartido. Separadas, el planificador debe decidir *cuándo* liberar la lavadora y el autoclave, lo que ordena el plan.
- **`walk` y `carry-kit` como acciones distintas.** Una sola acción de movimiento no permitiría que el técnico regrese por la segunda caja sin llevar la primera. Con dos, aparece el costo de los viajes de ida y vuelta.
- **Higiene como estado del técnico y no de la caja.** Se consideró un predicado de contaminación por caja o por cada tipo de movimiento (`carry-dirty`, `carry-washed`…), pero eso multiplica las acciones y requeriría efectos condicionales. Modelar la contaminación en un solo punto (`load-washer`) y exigir limpieza en tres acciones críticas conserva el realismo con un solo predicado.
- **Sin precondiciones negativas ni efectos condicionales** para que el dominio sea compatible con planificadores STRIPS sencillos (se resolvió con *pyperplan*).
- **Cada acción de máquina exige el predicado de etapa de la caja** (`kit-dirty` en `run-washer`, `kit-packed` en `run-autoclave`), de modo que no se puede "esterilizar" una caja sin haberla lavado y empacado antes.

## 5. Problema `morning-surgeries`

- **Objetos:** 7 áreas, 1 técnico, 2 cajas (`ortho-kit`, `cardio-kit`), 1 lavadora, 1 autoclave.
- **Estado inicial:** ambas cajas sucias en `intake`; el técnico en `packing-room` con manos sin sanitizar; lavadora y autoclave vacíos; único lavabo en `packing-room`.
- **Meta:** `(kit-stocked ortho-kit or-1)` y `(kit-stocked cardio-kit or-2)`.
- **Por qué no es trivial:** el camino de `intake` a los quirófanos cruza 5 áreas; hay un solo técnico que lleva una caja a la vez; las máquinas tienen capacidad 1; y las manos deben sanitizarse en un lugar concreto antes de empacar, descargar el autoclave y surtir.

## 6. Resultados con el planificador

Planificador: **pyperplan** (Python). Tiempos medidos en el entorno donde se generó el proyecto; pueden variar en otro equipo.

| Búsqueda | Longitud del plan | Tiempo de búsqueda |
|---|---|---|
| A\* con heurística hFF | **34 pasos** | ≈ 0.31 s |
| BFS (óptimo con costos unitarios) | **34 pasos** | ≈ 0.08 s |

- Ambos coinciden en 34 pasos; como BFS es óptimo para costos unitarios, **34 es la longitud mínima**, muy por encima del mínimo exigido (5 pasos).
- El plan se verificó con un validador independiente (`tools/validate_plan.py`) que aplica cada acción sobre el estado, comprueba sus precondiciones y confirma la meta. La traza completa está en `plan/plan_trace.md`.
- **Prueba de que la regla de higiene influye:** quitando `tech-clean` de las precondiciones (dejando el resto igual), BFS encuentra un plan de **33 pasos**: desaparece `sanitize-hands`. La regla agrega exactamente un paso aquí y obliga a agrupar el trabajo sucio antes de sanitizar.

## 7. Limitaciones conocidas

- El modelo no representa tiempo ni costos distintos por acción.
- El técnico puede dejar una caja estéril depositada en el pasillo mientras regresa por la otra (ocurre en los pasos 24 a 30 del plan); en la realidad habría un carro estéril. Se aceptó para mantener el dominio simple.
- Con un solo técnico, las acciones son estrictamente secuenciales: no se modela que la lavadora o el autoclave trabajen mientras el técnico hace otra cosa.
- Posibles extensiones: segunda lavadora, segundo técnico, autoclave con capacidad para varias cajas, o cajas de prioridad urgente.
