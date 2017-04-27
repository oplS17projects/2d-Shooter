#lang racket
(require 2htdp/image)
(require 2htdp/universe)

;; importing images which should be in different file
;; all the importing should be in different file
;; the sound should be imported also.

(define player-image-right (bitmap "character_sprite_right.png"))
(define player-image-left (bitmap "character_sprite_left.png"))
(define monster-image (bitmap "enemy.jpg"))
(define bullet-image (bitmap "bullet1.png"))
(define background-image (bitmap "background.png"))
;(define monster-bullet (bitmap "bullet1.png")) should be replaced with monster bullets

;; MISSING:
;;
;; 4. monster bullets
;; 5. interactions between projectile and soldier
;; 5. sound effects
;; 6. menu


(define gravity-y 3)
(define friction-x 1.5)

;; structure for world
(define-struct world [player monsters bullets])

;; structure for bullets
(define-struct bullets (list-of-bullets))

(define-struct monsters (list-of-monsters numdead))


;; status for collision and out of bounds
;; direction for moving the bullet
(define-struct bullet [x-coordinate y-coordinate status direction])

;; if status == dead create 1 else stay
(define-struct monster [x-coordinate y-coordinate status direction])

;; direction for shooting bullets
;; if health == 0 game over starts with 3 decreases as make contact
(define-struct player [x-coordinate y-coordinate health status direction x-speed y-speed])


;; @created by : T
;; @name : the-one-for-all
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw bullet
(define (the-one-for-all world)
  (check-game-over (if (eq? (player-direction (world-player world)) 'right)
      (place-image player-image-right
                   (player-x-coordinate  (world-player world))
                   (player-y-coordinate (world-player world))
                   (draw-bullet world))
      (place-image player-image-left
                   (player-x-coordinate  (world-player world))
                   (player-y-coordinate (world-player world))
                   (draw-bullet world))
      ) world) 
  )

(define (check-game-over image world)
  (if (<= (player-health (world-player world)) 0)
      (place-image (text (format "Press [space] to restart") 20 "black") (/ (image-width image) 2) (- (/ (image-height image) 2) 70) 
      (place-image (text (format "Aw shoot. YOU DIED.") 50 "black") (/ (image-width image) 2) (- (/ (image-height image) 2) 130) background-image))
      (if (null? (monsters-list-of-monsters (world-monsters world)))
          (place-image (text (format "Press [space] to restart") 20 "black") (/ (image-width image) 2) (- (/ (image-height image) 2) 70) 
      (place-image (text (format "Nice! You beat the game!") 50 "black") (/ (image-width image) 2) (- (/ (image-height image) 2) 130) background-image))
          image))
  )

;; @created by : T
;; @name : draw-bullet
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw monster
(define (draw-bullet world)
  (if (null? (bullets-list-of-bullets (world-bullets world)))
      (draw-monsters world)
      (begin (place-image bullet-image
                          (bullet-coordinate-x world)
                          (bullet-coordinate-y world)
                          (draw-bullet (make-world
                                        (make-player (player-coordinate-x world)
                                                     (player-coordinate-y world)
                                                     (player-health (world-player world))
                                                     (player-status (world-player world))
                                                     (player-direction (world-player world))
                                                     (player-speed-x world)
                                                     (player-speed-y world))
                                        (world-monsters world)
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
(define (draw-monsters world)
  (if (null? (monsters-list-of-monsters (world-monsters world)))
      (place-image (text (format "Points: ~a" (monsters-numdead (world-monsters world))) 24 "white") 400 610
      (place-image (text (format "Health: ~a" (player-health (world-player world))) 24 "white") 60 610 background-image))
      (begin (place-image monster-image
                          (monster-coordinate-x world)
                          (monster-coordinate-y world)
                          (draw-monsters (make-world
                                        (make-player (player-coordinate-x world)
                                                     (player-coordinate-y world)
                                                     (player-health (world-player world))
                                                     (player-status (world-player world))
                                                     (player-direction (world-player world))
                                                     (player-speed-x world)
                                                     (player-speed-y world))
                                        (make-monsters (cdr (monsters-list-of-monsters (world-monsters world))) (monsters-numdead (world-monsters world)))
                                        (make-bullets (bullets-list-of-bullets (world-bullets world))))))
                                        )))

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

(define (player-speed-x world)
  (player-x-speed (world-player world))
  )

(define (player-speed-y world)
  (player-y-speed (world-player world))
  )

(define (monster-coordinate-x world)
  (monster-x-coordinate (car (monsters-list-of-monsters (world-monsters world))))
  )

(define (monster-coordinate-y world)
  (monster-y-coordinate (car (monsters-list-of-monsters (world-monsters world))))
  )

;; end of accessors


;; @created by : T
;; @name : the-tick-handler
;; @variable : world
;;  ~world type object
;; @returns : world type object
;; @brief : takes a world and returns an world type object with updated coordinates
(define (the-tick-handler world)
        (make-world (player-health-deletion (make-player (+ (player-coordinate-x world) (player-speed-x world))
               (min 500 (max 100 (+ (player-coordinate-y world) (player-speed-y world))))
                           (player-health (world-player world))
                           (player-status (world-player world))
                           (player-direction (world-player world))
                           (/ (player-speed-x world) friction-x)
                           (+ (player-speed-y world) gravity-y)) (world-monsters world) world)
              (monster-health-deletion (make-monsters (map monster-map-filter (monsters-list-of-monsters (world-monsters world))) (monsters-numdead (world-monsters world))) (world-bullets world)) 
              (make-bullets (map bullet-map-filter (bullet-removal (bullets-list-of-bullets (world-bullets world)))))
              )
  )

(define (monster-health-deletion monsters bullets)
  (if (null? (monsters-list-of-monsters monsters))
      monsters
      (if (null? (bullets-list-of-bullets bullets))
          monsters
          (if (bullets-touch-monster (bullets-list-of-bullets bullets) (car (monsters-list-of-monsters monsters)))
              (monster-health-deletion (make-monsters (cdr (monsters-list-of-monsters monsters)) (+ 1 (monsters-numdead monsters))) bullets)
              (let ([nextmonsters (monster-health-deletion (make-monsters (cdr (monsters-list-of-monsters monsters)) (monsters-numdead monsters)) bullets)])
                (make-monsters (cons (car (monsters-list-of-monsters monsters))
                                   (monsters-list-of-monsters nextmonsters)) (monsters-numdead nextmonsters)))))) )
      


(define (bullets-touch-monster bullets monster)
  (if (null? bullets)
      #f
      (if (and (< (abs (- (bullet-x-coordinate (car bullets)) (monster-x-coordinate monster))) (/ (image-width monster-image) 1))
               (< (abs (- (bullet-y-coordinate (car bullets)) (monster-y-coordinate monster))) (/ (image-height monster-image) 1)))
          #t
          (bullets-touch-monster (cdr bullets) monster)
  ))
  )

(define (player-health-deletion player monsters world)
  (if (null? (monsters-list-of-monsters monsters))
      player
      (if (and (< (abs (- (player-x-coordinate player) (monster-x-coordinate (car (monsters-list-of-monsters monsters))))) (/ (image-width monster-image) 2))
               (< (abs (- (player-y-coordinate player) (monster-y-coordinate (car (monsters-list-of-monsters monsters))))) (/ (image-height monster-image) 2)))
          (make-player 20 500
                           (- (player-health (world-player world)) 1)
                           (player-status (world-player world))
                           (player-direction (world-player world))
                           (player-speed-x world)
                           (player-speed-y world))
          (player-health-deletion player (make-monsters (cdr (monsters-list-of-monsters monsters)) (monsters-numdead monsters)) world)
  )))


;; @created by : T
;; @name : bullet-map-filter 
;; @variable : bullet
;;  ~bullet type object
;; @returns : bullet type object
;; @brief : takes a bullet and returns an world type object with updated coordinates + status
(define (bullet-map-filter bullet)
  (cond
    [(eq? (bullet-direction bullet) 'right)
     (if (> (bullet-x-coordinate bullet) (image-width background-image))
         (make-bullet
         (+ (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'dead 'right)
         (make-bullet
         (+ (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'alive 'right))
     ]
    [(eq? (bullet-direction bullet) 'left)
     (if (< (bullet-x-coordinate bullet) 100)
         (make-bullet
         (- (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'dead 'left)
         (make-bullet
         (- (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'alive 'left))
         ]
    [else (make-bullet
     (bullet-x-coordinate bullet) (bullet-y-coordinate bullet))]
    )
    )

(define (monster-map-filter monster)
  (cond
    [(eq? (monster-direction monster) 'right)
     (if (> (monster-x-coordinate monster) 500)
         (make-monster (- (monster-x-coordinate monster) 10) (monster-y-coordinate monster) 'alive 'left)
         (make-monster (+ (monster-x-coordinate monster) 10) (monster-y-coordinate monster) 'alive 'right))
     ]
    [(eq? (monster-direction monster) 'left)
     (if (< (monster-x-coordinate monster) 100)
         (make-monster (+ (monster-x-coordinate monster) 10) (monster-y-coordinate monster) 'alive 'right)
         (make-monster (- (monster-x-coordinate monster) 10) (monster-y-coordinate monster) 'alive 'left))
         ]
    [(eq? (monster-direction monster) 'up)
     (if (< (monster-y-coordinate monster) 100)
         (make-monster (monster-x-coordinate monster) (+ (monster-y-coordinate monster) 10) 'alive 'down)
         (make-monster (monster-x-coordinate monster) (- (monster-y-coordinate monster) 10) 'alive 'up))
         ]
    [(eq? (monster-direction monster) 'down)
     (if (> (monster-y-coordinate monster) 500)
         (make-monster (monster-x-coordinate monster) (- (monster-y-coordinate monster) 10) 'alive 'up)
         (make-monster (monster-x-coordinate monster) (+ (monster-y-coordinate monster) 10) 'alive 'down))
     ]
    )
    )

;; @created by : T
;; @name : isAlive?
;; @variable : bullet
;;  ~bullet type object
;; @returns : predicate
;; @brief : takes a bullet returns predicate
(define (isAlive? bullet)
  (if (eq? (bullet-status bullet) 'alive)
      #t #f)
  )



;; @created by : T
;; @name : bullet-removal 
;; @variable : bullets
;;  ~bullet type object
;; @returns : bullet type object
;; @brief : takes a list of bullets and returns list of alive bullets
(define (bullet-removal bullets)
  (filter isAlive? bullets)
  )



;; @created by : T
;; @name : move-monster
;; @variable : world
;;  ~world type object
;; @returns : monster type object
;; @brief : takes a world and returns an monster type object with updated coordinates
;(define (move-monster world)
;  (cond
;    [(eq? (monster-status (world-monster world)) 'alive)
;     (cond
;       [(<= (monster-coordinate-y world) 0)
;        (make-monster (monster-coordinate-x world) (+ (monster-coordinate-y world) 10) 'alive)
;        ]
;       [(>= (monster-coordinate-y world) 300)
;        (make-monster (monster-coordinate-x world) (- (monster-coordinate-y world) 10) 'alive)]
;       [else (make-monster (monster-coordinate-x world) (monster-coordinate-y world) 'alive)]
;       )]
;    [else (make-monster (monster-coordinate-x world) (monster-coordinate-y world) 'alive)]
;    )
;  )


(define (change world a-key)
  (cond
    [(key=? a-key "left")  (make-world
                            (make-player
                             (player-coordinate-x world)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-status (world-player world))
                             'left
                             -10
                             (player-speed-y world))
                            (make-monsters (monsters-list-of-monsters (world-monsters world)) (monsters-numdead (world-monsters world)))
                            (make-bullets (bullets-list-of-bullets (world-bullets world)))
                            )
                             ]
    [(key=? a-key "right") (make-world
                            (make-player
                             (player-coordinate-x world)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-status (world-player world))
                             'right
                             10
                             (player-speed-y world))
                            (make-monsters (monsters-list-of-monsters (world-monsters world)) (monsters-numdead (world-monsters world)))
                            (make-bullets (bullets-list-of-bullets (world-bullets world)))
                            )]
    [(key=? a-key "up")  (make-world
                            (make-player
                             (player-coordinate-x world)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-status (world-player world))
                             (player-direction (world-player world))
                             (player-speed-x world)
                             (if (< (player-coordinate-y world) 500) (player-speed-y world) -20))
                            (make-monsters (monsters-list-of-monsters (world-monsters world)) (monsters-numdead (world-monsters world)))
                            (make-bullets (bullets-list-of-bullets (world-bullets world)))
                            )
                             ]
    [(key=? a-key " ")  (if (or (<= (player-health (world-player world)) 0) (null? (monsters-list-of-monsters (world-monsters world))))
                                 (make-world (make-player 20 500 3 'alive 'right 0 0)
                        (make-monsters (list (make-monster 800 200 'alive 'up)
                                             (make-monster 700 100 'alive 'down)
                                             (make-monster 600 450'alive 'right)
                                             (make-monster 500 400 'alive 'left)
                                             (make-monster 400 450 'alive 'left)
                                             (make-monster 300 150 'alive 'up)
                                             (make-monster 200 300 'alive 'down)
                                             (make-monster 100 100 'alive 'up)
                                             (make-monster 900 450 'alive 'right)) 0)
                        (make-bullets (list (make-bullet 49 497 'alive 'right))))
                                 (make-world
                            (make-player
                             (player-coordinate-x world)
                             (player-coordinate-y world)
                             (player-health (world-player world))
                             (player-status (world-player world))
                             (player-direction (world-player world))
                             (player-speed-x world)
                             (player-speed-y world))
                            (make-monsters (monsters-list-of-monsters (world-monsters world)) (monsters-numdead (world-monsters world)))
                            (make-bullets (cons
                                           (make-bullet (player-coordinate-x world) (player-coordinate-y world) 'alive
                                                        (player-direction (world-player world)))
                                           (bullets-list-of-bullets (world-bullets world))))
                            ))
     

     ]
   
    [(= (string-length a-key) 1) world] 
    [else world]))

(define (LETSGO)
  (big-bang
            (make-world (make-player 20 500 3 'alive 'right 0 0)
                        (make-monsters (list (make-monster 800 200 'alive 'up)
                                             (make-monster 700 100 'alive 'down)
                                             (make-monster 600 450'alive 'right)
                                             (make-monster 500 400 'alive 'left)
                                             (make-monster 400 450 'alive 'left)
                                             (make-monster 300 150 'alive 'up)
                                             (make-monster 200 300 'alive 'down)
                                             (make-monster 100 100 'alive 'up)
                                             (make-monster 900 450 'alive 'right)) 0)
                        (make-bullets '())) ;;initial world
            (to-draw the-one-for-all)
            (on-key change)
            [on-tick the-tick-handler])
  )

(LETSGO)

          