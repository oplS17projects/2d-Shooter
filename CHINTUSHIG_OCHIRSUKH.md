# 2D Shooter Game

## Chintushig Ochirsukh
### April 30, 2017

# Overview
This project is a 2d side scrolling shooter game similiar to the game "contra" from the 90`s. 

Essentially, there are number of enemies oscillating randomly and the purpose of our main
character is to dodge and destroy those. 

**Authorship note:** All of the code described here was written by myself and by my partner : dannynugyen1

# Libraries Used
The code uses four libraries:

```
(require 2htdp/image)
(require 2htdp/universe)
(require rsound)

```

* The ```2htdp/image``` library enables us to import and use image files for our universe.
* The ```2htdp/universe``` library is for rendering our universe with the provided images from the ```2htdp/image``` library.
* The ```rsound``` library is used to import and play sound for the corresponding action 

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Five examples are shown and they are individually numbered. 

## 1. Initialization using a Global Object

(define-struct world [player monsters bullets lvl boss])

In our game i have created the structure of the whole world of the game. (world, images, bullets etc)
Every core function in this code passes around world object and use accessors and selectors in order to use or change the values.


## 2. Object orientation

```
(define-struct world [player monsters bullets lvl boss])

(define-struct bullets (list-of-bullets))

(define-struct bullet [x-coordinate y-coordinate status direction type])

(define-struct player [x-coordinate y-coordinate health status direction x-speed y-speed])

(define-struct boss [x-coordinate y-coordinate health status]) ;; this line of code did not make it to the real game
 ```
 The world is a global object world which has player and monsters 
 , bullets,  lvl and boss which are individual objects that has their own attributes inside of them. 
 By doing this we are creating 2 layers of abstraction and some level of efficiency by passing around only the world object and 
 using accessors to access certain attributes of the object.
 
 For example: 
 
 Here is an example of using an accessor in order to get the player attributes from the world object.
 
 ```
 (define-struct player [x-coordinate y-coordinate health status direction x-speed y-speed])
 
 
 (define (player-coordinate-x world)
  (player-x-coordinate (world-player world))
  )
  
  (make-player
            (player-coordinate-x world)
            (player-coordinate-y world)
            (player-health (world-player world))
            (player-status (world-player world))
             'left
              -10
            (player-speed-y world))

 ```
 
 
## 3. Using list/map/filter 

The object bullet is different from the rest because it has a list of object bullet inside the bullets object. This data structure is
very convenient because the on-tick function updates every bullet on the list by cdr-ing down the bullet list.
```
(if (eq? (bullet-status-acc world) 'alive)
           (bullet-update world)
(define (bullet-update world)           
   (make-bullets (map bullet-map-filter (bullets-list-of-bullets (world-bullets world))))           
```

Also we used the function isAlive? which is a predicate function for the filtering function which only returns the alive bullets.
which we use map later on to apply it to our list of bullets. /* these first 2 functions were renamed and updated by my teammate
in order to use it on the monsters also*/

```
(define (isAlive? bullet)
  (if (eq? (bullet-status bullet) 'alive)
      #t #f)
  )


(define (bullet-removal bullets)
  (filter isAlive? bullets)
  )
  
  (make-bullets (map bullet-map-filter (bullets-list-of-bullets (world-bullets world))))
```





