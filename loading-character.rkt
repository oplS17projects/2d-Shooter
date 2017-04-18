#lang racket
(require 2htdp/image)
(require 2htdp/universe)

(define player (bitmap "character_sprite.png"))

(define background (bitmap "background.png"))

(define (screen t)
  (overlay/xy (bitmap "background.png")
               500 500
               (empty-scene 0 0)))

(define (character t)
  (place-image player
               (car t)
               (cdr t)
               (screen 0)))

(define (change w a-key)
  (cond
    [(key=? a-key "left")  (cons (-(car w) 5) (cdr w))] 
    [(key=? a-key "right") (cons (+ 5 (car w)) (cdr w))]
    [(= (string-length a-key) 1) w] 
    [else w]))

(big-bang '(10 . 490) 
          (to-draw character)
          (on-key change))