#lang racket
(require 2htdp/image)
(require 2htdp/universe)

;; importing images which should be in different file
;; all the importing should be in different file
;; the sound should be imported also.

(define player-image (bitmap "character_sprite.png"))
(define enemy-image (bitmap "enemy.jpg"))
(define bullet-image (bitmap "bullet1.png"))
(define background-image (bitmap "background.png"))

;; MISSING:
;;
;; 1.Projectile movements
;; 2.jump function for the soldier
;; 3.shooting bullets ++ multiple bullets
;; 4.enemy bullets
;; 5.interactions between projectile and soldier
;; 5.sound effects
;; 6.menu



;; structure for world
(define-struct world [player enemy bullet])


;; structure for bulet
(define-struct bullet [x-coordinate y-coordinate])

;; if status == dead create 1 else stay
(define-struct enemy [x-coordinate y-coordinate status])

;; direction for shooting bullets
;; if health == 0 game over starts with 3 decreases as make contact
(define-struct player [x-coordinate y-coordinate health direction])

;;player needs direction 



;; @created by : T
;; @name : the-one-for-all
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw bullet

(define (the-one-for-all world)
  (place-image player-image
               (player-x-coordinate  (world-player world))
               (player-y-coordinate (world-player world))
            (draw-bullet world))
  )

;; @created by : T
;; @name : draw-bullet
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw enemy

(define (draw-bullet world)
  (place-image bullet-image
               (bullet-coordinate-x world)
               (bullet-coordinate-y world)
               (draw-enemy world))
  )


;; @created by : T
;; @name : draw-bullet
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background

(define (draw-enemy world)
  (place-image enemy-image
               (enemy-coordinate-x world)
               (enemy-coordinate-y world)
               background-image
               )
  )

;; the draw function


;;




;;accessors starts here

;; @created by : T
;; @name : accessors for coordinates
;; @variable : world
;;  ~world type object
;; @returns : integer
;; @brief : takes a world and returns an integer type number for corresponding object

(define (bullet-coordinate-x world)
  (bullet-x-coordinate (world-bullet world))
  )

(define (bullet-coordinate-y world)
  (bullet-y-coordinate (world-bullet world))
  )

(define (player-coordinate-x world)
  (player-x-coordinate (world-player world))
  )

(define (player-coordinate-y world)
  (player-y-coordinate (world-player world))
  )

(define (enemy-coordinate-x world)
  (enemy-x-coordinate (world-enemy world))
  )

(define (enemy-coordinate-y world)
  (enemy-y-coordinate (world-enemy world))
  )
;; end of accessors


;; @created by : T
;; @name : the-tick-handler
;; @variable : world
;;  ~world type object
;; @returns : world type object
;; @brief : takes a world and returns an world type object with updated coordinates

(define (the-tick-handler world)
  (make-world (make-player (player-coordinate-x world)
               (player-coordinate-y world)
               (player-health (world-player world))
               (player-direction (world-player world)))
              (make-enemy (enemy-coordinate-x world) (- (enemy-coordinate-y world) 10) 'alive)
              (make-bullet ( + (bullet-coordinate-x world) 10)
                            (bullet-coordinate-y world)))
  )

;; @created by : T
;; @name : move-enemy
;; @variable : world
;;  ~world type object
;; @returns : enemy type object
;; @brief : takes a world and returns an enemy type object with updated coordinates

(define (move-enemy world)
  (cond
    [(eq? (enemy-status (world-enemy world)) 'alive)
     (cond
       [(< (enemy-coordinate-y world) 0)
        (make-enemy (enemy-coordinate-x world) (+ (enemy-coordinate-y world) 10) 'alive)]
       [(> (enemy-coordinate-y world) 500)
        (make-enemy (enemy-coordinate-x world) (- (enemy-coordinate-y world) 10) 'alive)]
       )]
    [else (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)]
    )
  )

(define (change world a-key)
  (cond
    [(key=? a-key "left")  (make-world
                            (make-player
                             (- (player-coordinate-x world) 5)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-direction (world-player world)))
                            (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)
                            (make-bullet (bullet-coordinate-x world) (bullet-coordinate-y world))
                            )
                             ] 
    [(key=? a-key "right") (make-world
                            (make-player
                             (+ (player-coordinate-x world) 5)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-direction (world-player world)))
                            (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)
                            (make-bullet (bullet-coordinate-x world) (bullet-coordinate-y world))
                            )]
    [(= (string-length a-key) 1) world] 
    [else world]))

(define (LETSGO)
  (big-bang
            (make-world (make-player 20 500 3 'alive)
                        (make-enemy 1000 500 'alive)
                        (make-bullet 49 497)) ;;initial world
            (to-draw the-one-for-all)
            (on-key change)
            [on-tick the-tick-handler])
  )

(LETSGO)

          
