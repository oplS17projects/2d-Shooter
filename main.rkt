#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require rsound)

;; ------------------------------------------------2D SHOOTER GAME--------------------------------------------------
;; -------------------------------------------By: luffy1727, dannynguyen1 ------------------------------------------
;; -----------------------------------------------------------------------------------------------------------------
;; -------------------------------------------- 2017----------------------------------------------------------------

(define player-image-right (bitmap "character_sprite_right.png"))
(define player-image-left (bitmap "character_sprite_left.png"))
(define monster-image (bitmap "enemy.png"))
(define bullet-image (bitmap "bullet1.png"))
(define background-image (bitmap "background.png"))
(define boss-bullet-image (bitmap "final_boss_bullet.png"))
(define boss-image (bitmap "boss.png"))
(define game-over-screen-image (bitmap "boss2.jpg"))
(define music "/Users/dannynguyen/Desktop/OPL/2d-shooter")
(define fire (build-path music "fire 1.wav"))
(define collision (build-path music "bangMedium 1.wav"))
(define firingSound (rs-read fire))
(define collisionSound (rs-read collision))
(define gravity-y 3)
(define friction-x 1.5)
(define backgroundmusic (make-pstream))


;; structure for world
;; @player - player object [x y health status direction x-speed y-speed]
;; @monsters - monster object [list-of-monsters numdead]
;; @bullets - list of bullets
;; @lvl - current lvl [integer]
;; @boss - boss object [x y health status]
(define-struct world [player monsters bullets lvl boss])

(define-struct bullets (list-of-bullets))

(define-struct monsters (list-of-monsters numdead))

(define-struct bullet [x-coordinate y-coordinate status direction type])

(define-struct monster [x-coordinate y-coordinate status direction])

(define-struct player [x-coordinate y-coordinate health status direction x-speed y-speed])

(define-struct boss [x-coordinate y-coordinate health status])


;; @created by : T
;; @name : the-one-for-all
;; @variable : world
;;  ~world type object
;; @returns : nothing
;; @brief : takes up a world and draws corresponding image on the background
;; this function also calls the function to draw bullet
(define (the-one-for-all world)
  (check-game-over
   (if (eq? (player-direction (world-player world)) 'right)
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
      (place-image (text (format "Press [space] to restart") 20 "black")
                   (/ (image-width image) 2)
                   (- (/ (image-height image) 2) 70) 
                   (place-image
                    (text (format "All of the class failed JUST BECAUSE OF YOU.") 50 "black")
                    (/ (image-width image) 2)
                    (- (/ (image-height image) 2) 130)
                    (place-image
                     (text (format "Maybe try harder next semester?.") 40 "red")
                     (/ (image-width image) 2)
                     (+ (/ (image-height image) 2) 200)
                     game-over-screen-image)))
      
      (if (null? (monsters-list-of-monsters (world-monsters world)))
          (if (eq? (world-lvl world) 2)
              image
              (place-image (text (format "Press [space] to restart") 20 "black") (/ (image-width image) 2) (- (/ (image-height image) 2) 70) 
                           (place-image (text (format "Congratulations! You are adequate now!") 50 "red")
                                        (/ (image-width image) 2)
                                        (- (/ (image-height image) 2) 130)
                                        (place-image (text (format "Seriously though, Thanks for Playing!") 20 "black")
                                                     (/ (image-width image) 2)
                                                     (+ (/ (image-height image) 2) 130)
                                                     (place-image (text (format "2D SHOOTER GAME © 2017") 13 "red")
                                                                  150
                                                                  (+ (/ (image-height image) 2) 280)
                                                                  (place-image (text (format "luffy1727 , dannynguyen1 (please hire us)") 10 "red")
                                                                               150
                                                                               (+ (/ (image-height image) 2) 300)
                                                                               background-image))))))
          
          image)
      
      )
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
      (if
       (eq? (bullet-type-acc world) 'enemy)
       (begin
         (place-image boss-bullet-image
                      (bullet-coordinate-x world)
                      (bullet-coordinate-y world)
                      (draw-bullet
                       (make-world
                        (make-player (player-coordinate-x world)
                                     (player-coordinate-y world)
                                     (player-health (world-player world))
                                     (player-status (world-player world))
                                     (player-direction (world-player world))
                                     (player-speed-x world)
                                     (player-speed-y world))
                        (world-monsters world)
                        (make-bullets (cdr (bullets-list-of-bullets (world-bullets world))))
                        (world-lvl world) ;lvl
                        (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                   (boss-health (world-boss world)) 'dead)
                        ))
                      )    
              )
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
                                        (make-bullets (cdr (bullets-list-of-bullets (world-bullets world))))
                                        (world-lvl world) ;lvl
                                        (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                                   (boss-health (world-boss world)) 'dead)
                                        ))
                          )    
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
  (if (eq? (world-lvl world) 2)
      (place-image boss-image
                   (boss-coordinate-x world)
                   (boss-coordinate-y world)
                   background-image
                   )
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
                                              (make-bullets (bullets-list-of-bullets (world-bullets world)))
                                              (world-lvl world) ;lvl
                                              (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                                         (boss-health (world-boss world)) 'dead)
                                              
                                              )
                                             )
                              )
                 )
          )
      )
  
  )

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

(define (bullet-type-acc world)
  (bullet-type (car (bullets-list-of-bullets (world-bullets world))))
  )

(define (boss-coordinate-x world)
  (boss-x-coordinate (world-boss world))
  )
(define (boss-coordinate-y world)
  (boss-y-coordinate (world-boss world))
  )
(define (boss-health-acc world)
  (boss-health (world-boss world))
  )
;; end of accessors


;; @created by : T
;; @name : the-tick-handler
;; @variable : world
;;  ~world type object
;; @returns : world type object
;; @brief : takes a world and returns an world type object with updated coordinates
(define (the-tick-handler world)
  (if
   (eq? (world-lvl world) 2)
   (if (null? (bullets-list-of-bullets (world-bullets world)))
       (boss-bullet-update world)
       (if (eq? (bullet-type-acc world) 'enemy)
           (if (eq? (bullet-status-acc world) 'alive)
           (bullet-update world)
           (boss-bullet-update world))
           (bullet-update world)
           )
       )
  
   (bullet-update world)
   )
  )

;; -----------------------------------------under construction -------------------------------
(define (anyBossBullets? list-of-bullets pred)
  (if (null? list-of-bullets)
      pred
      (begin (if (and (eq? (bullet-status (car list-of-bullets)) 'alive)
                      (eq? (bullet-type (car list-of-bullets)) 'enemy))
                     (set! pred #t)
                     pred
                     )
                 (anyBossBullets? (cdr list-of-bullets) pred)))
      )

(define (bullet-update world)
  (monster-health-deletion (make-world (player-health-deletion (make-player (+ (player-coordinate-x world) (player-speed-x world))
                                                                            (min 500 (max 100 (+ (player-coordinate-y world) (player-speed-y world))))
                                                                            (player-health (world-player world))
                                                                            (player-status (world-player world))
                                                                            (player-direction (world-player world))
                                                                            (/ (player-speed-x world) friction-x)
                                                                            (+ (player-speed-y world) gravity-y)) (world-monsters world) world)
                                       (make-monsters (map monster-map-filter (monsters-list-of-monsters (world-monsters world))) (monsters-numdead (world-monsters world))) 
                                       (make-bullets (map bullet-map-filter (bullets-list-of-bullets (world-bullets world))))
                                       (world-lvl world) ;lvl
                                       (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                                  (boss-health (world-boss world)) 'dead)
                                       
                                       ))
  )

(define (boss-bullet-update world)
  (monster-health-deletion (make-world (player-health-deletion (make-player (+ (player-coordinate-x world) (player-speed-x world))
                                                                            (min 500 (max 100 (+ (player-coordinate-y world) (player-speed-y world))))
                                                                            (player-health (world-player world))
                                                                            (player-status (world-player world))
                                                                            (player-direction (world-player world))
                                                                            (/ (player-speed-x world) friction-x)
                                                                            (+ (player-speed-y world) gravity-y)) (world-monsters world) world)
                                       (make-monsters (map monster-map-filter (monsters-list-of-monsters (world-monsters world))) (monsters-numdead (world-monsters world))) 
                                       (make-bullets (cons
                                                      (make-bullet (boss-coordinate-x world) (boss-coordinate-y world) 'alive
                                                                   'left 'enemy)
                                                      (map bullet-map-filter (bullets-list-of-bullets (world-bullets world)))))
                                       (world-lvl world) ;lvl
                                       (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                                  (boss-health (world-boss world)) 'dead)
                                       
                                       ))
  )



; Take in a world, deletes monsters from the world which are touching a bullet and delete bullets which are touching monsters.
; Return a new world which removes the colliding objects.
(define (monster-health-deletion world)
  ; If no monsters in world, return world.
  (if (null? (monsters-list-of-monsters (world-monsters world)))
      world
      ; If no bullets in world, return world.
      (if (null? (bullets-list-of-bullets (world-bullets world)))
          world
          ; Figure out which bullets are NOT touching the first monster, set that to aliveBullets.
          (let ([aliveBullets (bullets-touch-monster (bullets-list-of-bullets (world-bullets world)) (car (monsters-list-of-monsters (world-monsters world))))])
            ; Number removed is just old list of bullets - new list of bullets.
            (let ([numRemoved (- (length (bullets-list-of-bullets (world-bullets world))) (length aliveBullets))])
              (if (> numRemoved 0)
                  ; If some were removed, play sound then return new world with that monster removed AND the bullets touching that monster removed, and
                  ; recursively call whole thing again on remaining monsters and remaining bullets.
                  (and (pstream-play backgroundmusic collisionSound) (monster-health-deletion
                                              (make-world (world-player world)
                                                          (make-monsters (cdr (monsters-list-of-monsters (world-monsters world))) (+ 1 (monsters-numdead (world-monsters world))))
                                                          (make-bullets aliveBullets) (world-lvl world) (world-boss world))
                   ))
                  ; If none were removed, return same world same function recursively called on remaining monsters and same bullets.
                  (let ([nextworld (monster-health-deletion (make-world (world-player world)
                                                          (make-monsters (cdr (monsters-list-of-monsters (world-monsters world))) (monsters-numdead (world-monsters world)))
                                                          (make-bullets aliveBullets)
                                                          (world-lvl world) (world-boss world)))])
                    (make-world (world-player world)
                                (make-monsters (cons (car (monsters-list-of-monsters (world-monsters world))) (monsters-list-of-monsters (world-monsters nextworld))) (monsters-numdead (world-monsters nextworld)))
                                (world-bullets nextworld) (world-lvl world) (world-boss world)))
                  ))))))
      

; Determine if any of the bullets given are touching the monster given.
; Return which bullets are not touching monster.
(define (bullets-touch-monster bullets monster)
  (if (null? bullets)
      '()
      (if (and (< (abs (- (bullet-x-coordinate (car bullets)) (monster-x-coordinate monster))) (/ (image-width monster-image) 1))
               (< (abs (- (bullet-y-coordinate (car bullets)) (monster-y-coordinate monster))) (/ (image-height monster-image) 1)))
          (bullets-touch-monster (cdr bullets) monster)
          (cons (car bullets) (bullets-touch-monster (cdr bullets) monster))
  ))
  )


;; @created by : danny
;; @name : player-health-deletion
;; @variable : monsters world
;;  @monsters - list of monster type object
;;  @world - world type object
;; @returns : player-type object with updated health bar
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
  (if
   (eq? (bullet-type bullet) 'normal)
   (cond
     [(eq? (bullet-direction bullet) 'right)
      (if (> (bullet-x-coordinate bullet) (image-width background-image))
          (make-bullet
           (+ (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'dead 'right 'normal)
          (make-bullet
           (+ (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'alive 'right 'normal))
      ]
     [(eq? (bullet-direction bullet) 'left)
      (if (< (bullet-x-coordinate bullet) 100)
          (make-bullet
           (- (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'dead 'left 'normal)
          (make-bullet
           (- (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'alive 'left 'normal))
      ]
     [else (make-bullet
            (bullet-x-coordinate bullet) (bullet-y-coordinate bullet) 'deadandshouldnevercomehereiguess?)]
     )
   (cond
     [(eq? (bullet-direction bullet) 'right)
      (if (> (bullet-x-coordinate bullet) (image-width background-image))
          (make-bullet
           (+ (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'dead 'right 'normal)
          (make-bullet
           (+ (bullet-x-coordinate bullet) 10) (bullet-y-coordinate bullet) 'alive 'right 'normal))
      ]
     [(eq? (bullet-direction bullet) 'left)
           (if (< (bullet-x-coordinate bullet) 100)
               (make-bullet
                (- (bullet-x-coordinate bullet) 20) (bullet-y-coordinate bullet) 'dead 'left 'enemy)
               (make-bullet
                (- (bullet-x-coordinate bullet) 20) (bullet-y-coordinate bullet) 'alive 'left 'enemy))
           ]
          [else (make-bullet
                 (bullet-x-coordinate bullet) (bullet-y-coordinate bullet) 'deadandshouldnevercomehereiguess?)]
          )
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
                            (world-lvl world) ;lvl
                            (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                       (boss-health (world-boss world)) 'dead)
                            
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
                            (world-lvl world) ;lvl
                            (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                       (boss-health (world-boss world)) 'dead)
                            
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
                            (world-lvl world) ;lvl
                            (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                       (boss-health (world-boss world)) 'dead)
                            )
                         ]

;----------------boss level under construction ----------------
    [(key=? a-key " ")
     (if (eq? (world-lvl world) 2)
         (if (or (<= (player-health (world-player world)) 0) (<= (boss-health-acc world) 0))
         ('dead)
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
                                                              (player-direction (world-player world)) 'normal)
                                                 (bullets-list-of-bullets (world-bullets world))))
                                  (world-lvl world) ;lvl
                                  (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                             (boss-health (world-boss world)) 'dead)
                                  
                                  ))
         (if (or (<= (player-health (world-player world)) 0)
                                (null? (monsters-list-of-monsters (world-monsters world)))) 

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
                        (make-bullets (list (make-bullet 49 497 'alive 'right 'normal)))
                        (world-lvl world)
                        (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                   (boss-health (world-boss world)) 'dead)
                        )
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
                                                              (player-direction (world-player world)) 'normal)
                                                 (bullets-list-of-bullets (world-bullets world))))
                                  (world-lvl world) ;lvl
                                  (make-boss (boss-coordinate-x world) (boss-coordinate-y world)
                                             (boss-health (world-boss world)) 'dead)
                                  
                                  )))
          
     

     ]
   
    [(= (string-length a-key) 1) world] 
    [else world]))

(define (LETSGO)
  (big-bang
            (make-world (make-player 20 500 3 'alive 'right 0 0)
                        (make-monsters (list (make-monster 800 200 'alive 'up)
                                             (make-monster 700 100 'alive 'down)
                                             (make-monster 600 500'alive 'right)
                                             (make-monster 500 500 'alive 'left)
                                             (make-monster 400 500 'alive 'left)
                                             (make-monster 300 150 'alive 'up)
                                             (make-monster 200 300 'alive 'down)
                                             (make-monster 100 100 'alive 'up)
                                             (make-monster 900 500 'alive 'right)) 0)
                        (make-bullets '())
                        1 ;lvl
                        (make-boss 1185 468 5 'dead)
                        ) ;;initial world
            (to-draw the-one-for-all)
            (on-key change)
            [on-tick the-tick-handler])
  )

(LETSGO)

          
