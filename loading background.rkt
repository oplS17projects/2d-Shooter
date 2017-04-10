#lang racket
(require 2htdp/image)
(require 2htdp/universe)
 
(define (background t)
  (overlay/xy (bitmap "background.png")
               500 175
               (empty-scene 0 0)))

(big-bang '(20 . 450) 
          (to-draw background))
          
          
