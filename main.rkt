#lang racket
(require 2htdp/image)
(require 2htdp/universe)

;; importing images which should be in different file
;; all the importing should be in different file
;; the sound should be imported also.

(define player-image-right (bitmap "character_sprite_right.png"))
(define player-image-left (bitmap "character_sprite_left.png"))
(define enemy-image (bitmap "enemy.jpg"))
(define bullet-image (bitmap "bullet1.png"))
(define background-image (bitmap "background.png"))
;(define enemy-bullet (bitmap "bullet1.png")) should be replaced with enemy bullets

;; MISSING:
;;
;; 1. Projectile movements
;; 3. shooting bullets ++ multiple bullets
;; 4. enemy bullets
;; 5. interactions between projectile and soldier
;; 5. sound effects
;; 6. menu




;; structure for world
(define-struct world [player enemy bullets])

(define-struct bullets (list-of-bullets))


;; bullet should be list . i tihnk
;; list of bulle
;; structure for bulet
;; status for collision and out of bounds
;; need cleanup fucntion
(define-struct bullet [x-coordinate y-coordinate status])

;; if status == dead create 1 else stay
(define-struct enemy [x-coordinate y-coordinate status])

;; direction for shooting bullets
;; if health == 0 game over starts with 3 decreases as make contact
(define-struct player [x-coordinate y-coordinate health status direction])

;;player needs direction 






;; @created by : T
;; @name : the-one-for-all
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw bullet

(define (the-one-for-all world)
  (if (eq? (player-direction (world-player world)) 'right)
      (place-image player-image-right
                   (player-x-coordinate  (world-player world))
                   (player-y-coordinate (world-player world))
                   (draw-bullet world))
      (place-image player-image-left
                   (player-x-coordinate  (world-player world))
                   (player-y-coordinate (world-player world))
                   (draw-bullet world))
      )
  
  )

;; @created by : T
;; @name : draw-bullet
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw enemy


;; bullet list
;; cons everytime 

(define (draw-bullet world)
  (if (null? (bullets-list-of-bullets (world-bullets world)))
      (draw-enemy world)
      (begin (place-image bullet-image
                          (bullet-coordinate-x world)
                          (bullet-coordinate-y world)
                          (draw-bullet (make-world
                                        (make-player (player-coordinate-x world)
                                                     (player-coordinate-y world)
                                                     (player-health (world-player world))
                                                     (player-status (world-player world))
                                                     (player-direction (world-player world)))
                                        (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)
                                        (make-bullets (cdr (bullets-list-of-bullets (world-bullets world))))))
                          )    
             )
      )
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
  (bullet-x-coordinate (car (bullets-list-of-bullets (world-bullets world))))
  )

(define (bullet-coordinate-y world)
  (bullet-y-coordinate (car (bullets-list-of-bullets (world-bullets world))))
  )

(define (bullet-status-acc world)
  (bullet-status (car (bullets-list-of-bullets (world-bullets world))))
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
                           (player-status (world-player world))
                           (player-direction (world-player world)))
              (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)
              (make-bullets (cons
                             (make-bullet ( + (bullet-coordinate-x world) 10)
                                          (bullet-coordinate-y world) 'alive)
                             (bullets-list-of-bullets (world-bullets world))))
              )

      
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
       [(<= (enemy-coordinate-y world) 0)
        (make-enemy (enemy-coordinate-x world) (+ (enemy-coordinate-y world) 10) 'alive)
        ]
       [(>= (enemy-coordinate-y world) 300)
        (make-enemy (enemy-coordinate-x world) (- (enemy-coordinate-y world) 10) 'alive)]
       [else (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)]
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
                             (player-status (world-player world))
                             'left)
                            (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)
                            (make-bullets (cons
                                           (make-bullet (bullet-coordinate-x world) (bullet-coordinate-y world) 'alive)
                                           (bullets-list-of-bullets (world-bullets world))
                                           )
                                          )
                            )
                             ]
    [(key=? a-key "right") (make-world
                            (make-player
                             (+ (player-coordinate-x world) 5)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-status (world-player world))
                             'right)
                            (make-enemy (enemy-coordinate-x world) (enemy-coordinate-y world) 'alive)
                            (make-bullets (cons
                                           (make-bullet (bullet-coordinate-x world) (bullet-coordinate-y world) 'alive)
                                           (bullets-list-of-bullets (world-bullets world))))
                            )]

    [(key=? a-key " ")  ]
    [(= (string-length a-key) 1) world] 
    [else world]))

(define (LETSGO)
  (big-bang
            (make-world (make-player 20 500 3 'alive 'right)
                        (make-enemy 1000 500 'alive)
                        (make-bullets (list (make-bullet 49 497 'alive)))) ;;initial world
            (to-draw the-one-for-all)
            (on-key change)
            [on-tick the-tick-handler])
  )

(LETSGO)

          
