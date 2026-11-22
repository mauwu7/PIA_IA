;;; ============================================================================
;;; PROBLEMA: Cirugías de la mañana — dos cajas sucias por reprocesar
;;;
;;; Mapa (pasillos en ambos sentidos):
;;;
;;;   [intake]--[wash-room]--[packing-room]--[sterilizer-room]--[corridor]--[or-1]
;;;                                                                  |
;;;                                                                [or-2]
;;;
;;; Hay un solo técnico, una sola lavadora y un solo autoclave (capacidad 1),
;;; y el único lavabo está en la sala de empaque.
;;; Meta: la caja de ortopedia en el quirófano 1 y la de cardiología en el 2,
;;; ambas estériles. El técnico empieza en la sala de empaque.
;;; ============================================================================
(define (problem morning-surgeries)
  (:domain sterile-processing)

  (:objects
    intake wash-room packing-room sterilizer-room corridor or-1 or-2 - location
    tech-ana - technician
    ortho-kit cardio-kit - kit
    washer-1 - washer
    autoclave-1 - autoclave)

  (:init
    ;; --- Topología (conexiones simétricas) ---
    (connected intake wash-room)          (connected wash-room intake)
    (connected wash-room packing-room)    (connected packing-room wash-room)
    (connected packing-room sterilizer-room) (connected sterilizer-room packing-room)
    (connected sterilizer-room corridor)  (connected corridor sterilizer-room)
    (connected corridor or-1)             (connected or-1 corridor)
    (connected corridor or-2)             (connected or-2 corridor)

    ;; --- Equipamiento de las áreas ---
    (has-sink packing-room)               ; único lavabo del servicio
    (packing-station packing-room)
    (washer-at washer-1 wash-room)
    (washer-empty washer-1)
    (autoclave-at autoclave-1 sterilizer-room)
    (autoclave-empty autoclave-1)

    ;; --- Técnico: empieza en empaque, con manos sin sanitizar ---
    (tech-at tech-ana packing-room)

    ;; --- Cajas sucias recién llegadas de quirófano ---
    (kit-at ortho-kit intake)
    (kit-dirty ortho-kit)
    (kit-at cardio-kit intake)
    (kit-dirty cardio-kit)

    ;; --- Demanda de la programación quirúrgica ---
    (kit-requested ortho-kit or-1)
    (kit-requested cardio-kit or-2))

  (:goal (and (kit-stocked ortho-kit or-1)
              (kit-stocked cardio-kit or-2)))
)
