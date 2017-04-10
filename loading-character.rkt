#lang racket
(require 2htdp/image)
(require 2htdp/universe)

(define player (bitmap "character_sprite.png"))

(define (character t) ;t =WorldState
  (place-image player
               (car t)
               (cdr t)
               (empty-scene 500 500)))

(define (change w a-key)
  (cond
    [(key=? a-key "left")  (cons (-(car w) 5) (cdr w))] 
    [(key=? a-key "right") (cons (+ 5 (car w)) (cdr w))]
    [(= (string-length a-key) 1) w] 
    [else w]))

(big-bang '(20 . 450) 
          (to-draw character)
          (on-key change))