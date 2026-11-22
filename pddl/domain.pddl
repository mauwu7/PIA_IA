;;; ============================================================================
;;; DOMINIO: Central de Esterilización y Equipos (CEyE) de un hospital
;;;
;;; Modela el ciclo de reprocesamiento de cajas de instrumental quirúrgico:
;;;     sucia -> lavada -> empacada -> estéril -> surtida en quirófano
;;;
;;; Elementos distintivos (no existen en Air Cargo ni Blocks World):
;;;   1. Cada caja pasa por una "máquina de estados" de 4 etapas irreversibles.
;;;   2. Las máquinas (lavadora, autoclave) tienen capacidad 1 y deben quedar
;;;      libres antes de recibir otra caja (recurso compartido).
;;;   3. HIGIENE DEL TÉCNICO: tocar material sucio le quita la condición de
;;;      "manos limpias"; solo recupera la condición en un lugar con lavabo.
;;;      Algunas acciones críticas exigen manos limpias.
;;;
;;; Compatible con planificadores STRIPS + typing (sin precondiciones negativas).
;;; ============================================================================
(define (domain sterile-processing)
  (:requirements :strips :typing)

  (:types
    location technician kit washer autoclave - object)

  (:predicates
    ;; --- Topología del hospital ---
    (connected ?a - location ?b - location)        ; pasillo directo entre dos áreas
    (has-sink ?l - location)                       ; el área tiene lavabo quirúrgico
    (packing-station ?l - location)                ; el área tiene mesa de empaque

    ;; --- Posición de agentes y objetos ---
    (tech-at ?t - technician ?l - location)
    (kit-at ?k - kit ?l - location)                ; caja depositada en un área

    ;; --- Etapa de procesamiento de la caja (exactamente una es verdadera) ---
    (kit-dirty ?k - kit)
    (kit-washed ?k - kit)
    (kit-packed ?k - kit)
    (kit-sterile ?k - kit)

    ;; --- Higiene del técnico ---
    (tech-clean ?t - technician)

    ;; --- Lavadora termodesinfectadora ---
    (washer-at ?w - washer ?l - location)
    (washer-empty ?w - washer)
    (kit-in-washer ?k - kit ?w - washer)

    ;; --- Autoclave de vapor ---
    (autoclave-at ?a - autoclave ?l - location)
    (autoclave-empty ?a - autoclave)
    (kit-in-autoclave ?k - kit ?a - autoclave)

    ;; --- Demanda y meta ---
    (kit-requested ?k - kit ?l - location)         ; la caja se necesita en este quirófano
    (kit-stocked ?k - kit ?l - location))          ; la caja ya fue entregada ahí

  ;; ------------------------------------------------------------------------
  ;; 1. Caminar solo (movimiento del técnico entre áreas conectadas)
  ;; ------------------------------------------------------------------------
  (:action walk
    :parameters (?t - technician ?from - location ?to - location)
    :precondition (and (tech-at ?t ?from)
                       (connected ?from ?to))
    :effect (and (tech-at ?t ?to)
                 (not (tech-at ?t ?from))))

  ;; ------------------------------------------------------------------------
  ;; 2. Trasladar una caja (el técnico la lleva consigo)
  ;; ------------------------------------------------------------------------
  (:action carry-kit
    :parameters (?t - technician ?k - kit ?from - location ?to - location)
    :precondition (and (tech-at ?t ?from)
                       (kit-at ?k ?from)
                       (connected ?from ?to))
    :effect (and (tech-at ?t ?to)
                 (kit-at ?k ?to)
                 (not (tech-at ?t ?from))
                 (not (kit-at ?k ?from))))

  ;; ------------------------------------------------------------------------
  ;; 3. Cargar la lavadora con una caja sucia. CONTAMINA al técnico.
  ;; ------------------------------------------------------------------------
  (:action load-washer
    :parameters (?t - technician ?k - kit ?w - washer ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (kit-at ?k ?l)
                       (washer-at ?w ?l)
                       (washer-empty ?w)
                       (kit-dirty ?k))
    :effect (and (kit-in-washer ?k ?w)
                 (not (kit-at ?k ?l))
                 (not (washer-empty ?w))
                 (not (tech-clean ?t))))

  ;; ------------------------------------------------------------------------
  ;; 4. Ciclo de lavado y desinfección térmica: sucia -> lavada
  ;; ------------------------------------------------------------------------
  (:action run-washer
    :parameters (?w - washer ?k - kit)
    :precondition (and (kit-in-washer ?k ?w)
                       (kit-dirty ?k))
    :effect (and (kit-washed ?k)
                 (not (kit-dirty ?k))))

  ;; ------------------------------------------------------------------------
  ;; 5. Descargar la lavadora: libera la máquina y deja la caja en el área
  ;; ------------------------------------------------------------------------
  (:action unload-washer
    :parameters (?t - technician ?k - kit ?w - washer ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (washer-at ?w ?l)
                       (kit-in-washer ?k ?w)
                       (kit-washed ?k))
    :effect (and (kit-at ?k ?l)
                 (washer-empty ?w)
                 (not (kit-in-washer ?k ?w))))

  ;; ------------------------------------------------------------------------
  ;; 6. Lavado quirúrgico de manos: recupera "manos limpias" (requiere lavabo)
  ;; ------------------------------------------------------------------------
  (:action sanitize-hands
    :parameters (?t - technician ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (has-sink ?l))
    :effect (tech-clean ?t))

  ;; ------------------------------------------------------------------------
  ;; 7. Empacar: solo una caja lavada, en mesa de empaque, con manos limpias
  ;; ------------------------------------------------------------------------
  (:action pack-kit
    :parameters (?t - technician ?k - kit ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (kit-at ?k ?l)
                       (packing-station ?l)
                       (tech-clean ?t)
                       (kit-washed ?k))
    :effect (and (kit-packed ?k)
                 (not (kit-washed ?k))))

  ;; ------------------------------------------------------------------------
  ;; 8. Cargar el autoclave con una caja empacada
  ;; ------------------------------------------------------------------------
  (:action load-autoclave
    :parameters (?t - technician ?k - kit ?a - autoclave ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (kit-at ?k ?l)
                       (autoclave-at ?a ?l)
                       (autoclave-empty ?a)
                       (kit-packed ?k))
    :effect (and (kit-in-autoclave ?k ?a)
                 (not (kit-at ?k ?l))
                 (not (autoclave-empty ?a))))

  ;; ------------------------------------------------------------------------
  ;; 9. Ciclo de esterilización por vapor: empacada -> estéril
  ;; ------------------------------------------------------------------------
  (:action run-autoclave
    :parameters (?a - autoclave ?k - kit)
    :precondition (and (kit-in-autoclave ?k ?a)
                       (kit-packed ?k))
    :effect (and (kit-sterile ?k)
                 (not (kit-packed ?k))))

  ;; ------------------------------------------------------------------------
  ;; 10. Descargar material estéril: exige manos limpias (zona limpia)
  ;; ------------------------------------------------------------------------
  (:action unload-autoclave
    :parameters (?t - technician ?k - kit ?a - autoclave ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (autoclave-at ?a ?l)
                       (kit-in-autoclave ?k ?a)
                       (kit-sterile ?k)
                       (tech-clean ?t))
    :effect (and (kit-at ?k ?l)
                 (autoclave-empty ?a)
                 (not (kit-in-autoclave ?k ?a))))

  ;; ------------------------------------------------------------------------
  ;; 11. Surtir la caja estéril en el quirófano que la solicitó
  ;; ------------------------------------------------------------------------
  (:action stock-kit
    :parameters (?t - technician ?k - kit ?l - location)
    :precondition (and (tech-at ?t ?l)
                       (kit-at ?k ?l)
                       (kit-sterile ?k)
                       (kit-requested ?k ?l)
                       (tech-clean ?t))
    :effect (and (kit-stocked ?k ?l)
                 (not (kit-at ?k ?l))))
)
