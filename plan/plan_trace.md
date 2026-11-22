# Traza de ejecución del plan (34 pasos)

> Nota: los predicados estáticos (`connected`, `has-sink`, `packing-station`, `washer-at`,
> `autoclave-at`, `kit-requested`) nunca cambian y el grounder de pyperplan los omite de las
> precondiciones listadas; todos se cumplen desde el estado inicial.

## Paso 1: `(walk tech-ana packing-room wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana packing-room)`
- Agrega: `(tech-at tech-ana wash-room)`
- Elimina: `(tech-at tech-ana packing-room)`

## Paso 2: `(walk tech-ana wash-room intake)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana wash-room)`
- Agrega: `(tech-at tech-ana intake)`
- Elimina: `(tech-at tech-ana wash-room)`

## Paso 3: `(carry-kit tech-ana cardio-kit intake wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit intake)`, `(tech-at tech-ana intake)`
- Agrega: `(kit-at cardio-kit wash-room)`, `(tech-at tech-ana wash-room)`
- Elimina: `(kit-at cardio-kit intake)`, `(tech-at tech-ana intake)`

## Paso 4: `(walk tech-ana wash-room intake)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana wash-room)`
- Agrega: `(tech-at tech-ana intake)`
- Elimina: `(tech-at tech-ana wash-room)`

## Paso 5: `(carry-kit tech-ana ortho-kit intake wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit intake)`, `(tech-at tech-ana intake)`
- Agrega: `(kit-at ortho-kit wash-room)`, `(tech-at tech-ana wash-room)`
- Elimina: `(kit-at ortho-kit intake)`, `(tech-at tech-ana intake)`

## Paso 6: `(load-washer tech-ana cardio-kit washer-1 wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit wash-room)`, `(kit-dirty cardio-kit)`, `(tech-at tech-ana wash-room)`, `(washer-empty washer-1)`
- Agrega: `(kit-in-washer cardio-kit washer-1)`
- Elimina: `(kit-at cardio-kit wash-room)`, `(tech-clean tech-ana)`, `(washer-empty washer-1)`

## Paso 7: `(run-washer washer-1 cardio-kit)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-dirty cardio-kit)`, `(kit-in-washer cardio-kit washer-1)`
- Agrega: `(kit-washed cardio-kit)`
- Elimina: `(kit-dirty cardio-kit)`

## Paso 8: `(unload-washer tech-ana cardio-kit washer-1 wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-in-washer cardio-kit washer-1)`, `(kit-washed cardio-kit)`, `(tech-at tech-ana wash-room)`
- Agrega: `(kit-at cardio-kit wash-room)`, `(washer-empty washer-1)`
- Elimina: `(kit-in-washer cardio-kit washer-1)`

## Paso 9: `(load-washer tech-ana ortho-kit washer-1 wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit wash-room)`, `(kit-dirty ortho-kit)`, `(tech-at tech-ana wash-room)`, `(washer-empty washer-1)`
- Agrega: `(kit-in-washer ortho-kit washer-1)`
- Elimina: `(kit-at ortho-kit wash-room)`, `(tech-clean tech-ana)`, `(washer-empty washer-1)`

## Paso 10: `(run-washer washer-1 ortho-kit)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-dirty ortho-kit)`, `(kit-in-washer ortho-kit washer-1)`
- Agrega: `(kit-washed ortho-kit)`
- Elimina: `(kit-dirty ortho-kit)`

## Paso 11: `(unload-washer tech-ana ortho-kit washer-1 wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-in-washer ortho-kit washer-1)`, `(kit-washed ortho-kit)`, `(tech-at tech-ana wash-room)`
- Agrega: `(kit-at ortho-kit wash-room)`, `(washer-empty washer-1)`
- Elimina: `(kit-in-washer ortho-kit washer-1)`

## Paso 12: `(carry-kit tech-ana cardio-kit wash-room packing-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit wash-room)`, `(tech-at tech-ana wash-room)`
- Agrega: `(kit-at cardio-kit packing-room)`, `(tech-at tech-ana packing-room)`
- Elimina: `(kit-at cardio-kit wash-room)`, `(tech-at tech-ana wash-room)`

## Paso 13: `(sanitize-hands tech-ana packing-room)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana packing-room)`
- Agrega: `(tech-clean tech-ana)`
- Elimina: —

## Paso 14: `(pack-kit tech-ana cardio-kit packing-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit packing-room)`, `(kit-washed cardio-kit)`, `(tech-at tech-ana packing-room)`, `(tech-clean tech-ana)`
- Agrega: `(kit-packed cardio-kit)`
- Elimina: `(kit-washed cardio-kit)`

## Paso 15: `(walk tech-ana packing-room wash-room)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana packing-room)`
- Agrega: `(tech-at tech-ana wash-room)`
- Elimina: `(tech-at tech-ana packing-room)`

## Paso 16: `(carry-kit tech-ana ortho-kit wash-room packing-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit wash-room)`, `(tech-at tech-ana wash-room)`
- Agrega: `(kit-at ortho-kit packing-room)`, `(tech-at tech-ana packing-room)`
- Elimina: `(kit-at ortho-kit wash-room)`, `(tech-at tech-ana wash-room)`

## Paso 17: `(pack-kit tech-ana ortho-kit packing-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit packing-room)`, `(kit-washed ortho-kit)`, `(tech-at tech-ana packing-room)`, `(tech-clean tech-ana)`
- Agrega: `(kit-packed ortho-kit)`
- Elimina: `(kit-washed ortho-kit)`

## Paso 18: `(carry-kit tech-ana cardio-kit packing-room sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit packing-room)`, `(tech-at tech-ana packing-room)`
- Agrega: `(kit-at cardio-kit sterilizer-room)`, `(tech-at tech-ana sterilizer-room)`
- Elimina: `(kit-at cardio-kit packing-room)`, `(tech-at tech-ana packing-room)`

## Paso 19: `(walk tech-ana sterilizer-room packing-room)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana sterilizer-room)`
- Agrega: `(tech-at tech-ana packing-room)`
- Elimina: `(tech-at tech-ana sterilizer-room)`

## Paso 20: `(carry-kit tech-ana ortho-kit packing-room sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit packing-room)`, `(tech-at tech-ana packing-room)`
- Agrega: `(kit-at ortho-kit sterilizer-room)`, `(tech-at tech-ana sterilizer-room)`
- Elimina: `(kit-at ortho-kit packing-room)`, `(tech-at tech-ana packing-room)`

## Paso 21: `(load-autoclave tech-ana cardio-kit autoclave-1 sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(autoclave-empty autoclave-1)`, `(kit-at cardio-kit sterilizer-room)`, `(kit-packed cardio-kit)`, `(tech-at tech-ana sterilizer-room)`
- Agrega: `(kit-in-autoclave cardio-kit autoclave-1)`
- Elimina: `(autoclave-empty autoclave-1)`, `(kit-at cardio-kit sterilizer-room)`

## Paso 22: `(run-autoclave autoclave-1 cardio-kit)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-in-autoclave cardio-kit autoclave-1)`, `(kit-packed cardio-kit)`
- Agrega: `(kit-sterile cardio-kit)`
- Elimina: `(kit-packed cardio-kit)`

## Paso 23: `(unload-autoclave tech-ana cardio-kit autoclave-1 sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-in-autoclave cardio-kit autoclave-1)`, `(kit-sterile cardio-kit)`, `(tech-at tech-ana sterilizer-room)`, `(tech-clean tech-ana)`
- Agrega: `(autoclave-empty autoclave-1)`, `(kit-at cardio-kit sterilizer-room)`
- Elimina: `(kit-in-autoclave cardio-kit autoclave-1)`

## Paso 24: `(load-autoclave tech-ana ortho-kit autoclave-1 sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(autoclave-empty autoclave-1)`, `(kit-at ortho-kit sterilizer-room)`, `(kit-packed ortho-kit)`, `(tech-at tech-ana sterilizer-room)`
- Agrega: `(kit-in-autoclave ortho-kit autoclave-1)`
- Elimina: `(autoclave-empty autoclave-1)`, `(kit-at ortho-kit sterilizer-room)`

## Paso 25: `(run-autoclave autoclave-1 ortho-kit)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-in-autoclave ortho-kit autoclave-1)`, `(kit-packed ortho-kit)`
- Agrega: `(kit-sterile ortho-kit)`
- Elimina: `(kit-packed ortho-kit)`

## Paso 26: `(unload-autoclave tech-ana ortho-kit autoclave-1 sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-in-autoclave ortho-kit autoclave-1)`, `(kit-sterile ortho-kit)`, `(tech-at tech-ana sterilizer-room)`, `(tech-clean tech-ana)`
- Agrega: `(autoclave-empty autoclave-1)`, `(kit-at ortho-kit sterilizer-room)`
- Elimina: `(kit-in-autoclave ortho-kit autoclave-1)`

## Paso 27: `(carry-kit tech-ana cardio-kit sterilizer-room corridor)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit sterilizer-room)`, `(tech-at tech-ana sterilizer-room)`
- Agrega: `(kit-at cardio-kit corridor)`, `(tech-at tech-ana corridor)`
- Elimina: `(kit-at cardio-kit sterilizer-room)`, `(tech-at tech-ana sterilizer-room)`

## Paso 28: `(carry-kit tech-ana cardio-kit corridor or-2)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit corridor)`, `(tech-at tech-ana corridor)`
- Agrega: `(kit-at cardio-kit or-2)`, `(tech-at tech-ana or-2)`
- Elimina: `(kit-at cardio-kit corridor)`, `(tech-at tech-ana corridor)`

## Paso 29: `(stock-kit tech-ana cardio-kit or-2)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at cardio-kit or-2)`, `(kit-sterile cardio-kit)`, `(tech-at tech-ana or-2)`, `(tech-clean tech-ana)`
- Agrega: `(kit-stocked cardio-kit or-2)`
- Elimina: `(kit-at cardio-kit or-2)`

## Paso 30: `(walk tech-ana or-2 corridor)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana or-2)`
- Agrega: `(tech-at tech-ana corridor)`
- Elimina: `(tech-at tech-ana or-2)`

## Paso 31: `(walk tech-ana corridor sterilizer-room)`

- Precondiciones (todas verdaderas en el estado previo): `(tech-at tech-ana corridor)`
- Agrega: `(tech-at tech-ana sterilizer-room)`
- Elimina: `(tech-at tech-ana corridor)`

## Paso 32: `(carry-kit tech-ana ortho-kit sterilizer-room corridor)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit sterilizer-room)`, `(tech-at tech-ana sterilizer-room)`
- Agrega: `(kit-at ortho-kit corridor)`, `(tech-at tech-ana corridor)`
- Elimina: `(kit-at ortho-kit sterilizer-room)`, `(tech-at tech-ana sterilizer-room)`

## Paso 33: `(carry-kit tech-ana ortho-kit corridor or-1)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit corridor)`, `(tech-at tech-ana corridor)`
- Agrega: `(kit-at ortho-kit or-1)`, `(tech-at tech-ana or-1)`
- Elimina: `(kit-at ortho-kit corridor)`, `(tech-at tech-ana corridor)`

## Paso 34: `(stock-kit tech-ana ortho-kit or-1)`

- Precondiciones (todas verdaderas en el estado previo): `(kit-at ortho-kit or-1)`, `(kit-sterile ortho-kit)`, `(tech-at tech-ana or-1)`, `(tech-clean tech-ana)`
- Agrega: `(kit-stocked ortho-kit or-1)`
- Elimina: `(kit-at ortho-kit or-1)`

## Verificación de la meta

- `(kit-stocked cardio-kit or-2)`: ✔ se cumple
- `(kit-stocked ortho-kit or-1)`: ✔ se cumple
