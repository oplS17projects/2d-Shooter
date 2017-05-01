# 2d-Shooter

## Danny Nguyen
### April 30, 2017

# Overview
I worked together with Chintushig Ochirsukh in order to create a fully functional 2d-shooter, similar to the classic Shoot 'em up genre game Contra.
This is a one player game where user input is taken from the keyboard, players can fire bullets by pressing spacebar, jump using the 'up' arrow and move
using the 'right' and 'left' arrows. This is a PVE type game where players are given 3 lives and once that reaches 0 it is game over, and in order
to win the player must kill all the enemies.

**Authorship note:** All of the code described here was mostly written by myself. Excerpts of code which were worked on collaboraively will be specified.
# Libraries Used
The code uses three libraries:

```
(require 2htdp/image)
(require 2htdp/universe)
(require rsound)
```

* The ```2htdp/image``` library allows us to place imported images and objects onto the screen.
* The ```2htdp/universe``` library allows us to access the 'world' which grants us access to object manipulation using the keyboard, which also
allows us to recieve user input
* The ```rsound``` library allows us to introduce sound to certain elements of the game, for example when bullets are fired or collision between enemies and bullets

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Three examples are shown and they are individually numbered.

## 1. Using map on a list of objects

The following code creates a procedure which we ```map```through the list-of-monsters in order to keep
track of their x and y coordinates. We did not want the monsters to move off the window so we set a boundary
to how far they could move horizontally and vertically.

```
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
```
```
(monster-health-deletion (make-monsters (map monster-map-filter (monsters-list-of-monsters (world-monsters world)))) (world-bullets world)) 
                (make-bullets (map bullet-map-filter (bullet-removal (bullets-list-of-bullets (world-bullets world)))))
                )
    )
 ```
 
## 2. Recursion for collision
Another feature which we had implement was the collision mechanic making sure monster and bullet objects were destroyed when a collision occured. 
I passed into ```monster-health-deletion``` the ```world``` which contained the player, monsters, and bullets object.
First we checked if there were any monsters or bullets in the world, if there were not any then we would just return the world.
Then I used a ```let``` to to create a local binding to the variable ```aliveBullets``` which kept track of bullets which are not 
touching the first monster.
In order to actually keep track of the numbers of bullets we needed to remove, I did another local binding to ```numRemoved``` which is
the ```old list of bullets``` minus the ```new list of bullets``` and if that was greater than 0 then we have to remove a certain amount
of bullets and monsters.
If we did remove any monsters and bullets then we would return the new world with the monsters removed and the 
bullets touching those monster removed.
Finally we would ```recursively``` call this on the remaining monsters and bullets. And if no monsters or bullets were removed
then we would return the same world and ```recursively``` call the function on remaining monsters and bullets.

```
(define (monster-health-deletion world)
  (if (null? (monsters-list-of-monsters (world-monsters world)))
      world
      (if (null? (bullets-list-of-bullets (world-bullets world)))
          world
          (let ([aliveBullets (bullets-touch-monster (bullets-list-of-bullets (world-bullets world)) (car (monsters-list-of-monsters (world-monsters world))))])
            (let ([numRemoved (- (length (bullets-list-of-bullets (world-bullets world))) (length aliveBullets))])
              (if (> numRemoved 0)
                  (and (pstream-play backgroundmusic collisionSound) (monster-health-deletion
                                              (make-world (world-player world)
                                                          (make-monsters (cdr (monsters-list-of-monsters (world-monsters world))) (+ 1 (monsters-numdead (world-monsters world))))
                                                          (make-bullets aliveBullets) (world-lvl world) (world-boss world))
                   ))
                  (let ([nextworld (monster-health-deletion (make-world (world-player world)
                                                          (make-monsters (cdr (monsters-list-of-monsters (world-monsters world))) (monsters-numdead (world-monsters world)))
                                                          (make-bullets aliveBullets)
                                                          (world-lvl world) (world-boss world)))])
                    (make-world (world-player world)
                                (make-monsters (cons (car (monsters-list-of-monsters (world-monsters world))) (monsters-list-of-monsters (world-monsters nextworld))) (monsters-numdead (world-monsters nextworld)))
                                (world-bullets nextworld) (world-lvl world) (world-boss world)))
                  ))))))

```

## 3. Object-Orientation
The majority of our game relies on mostly three objects the player, monsters, bullets, and updating the world. Here is a small excerpt of code 
I wrote to keep track of the players health. We check to see if absolute value of the player's x and y coordinate minus the
monster's x y coordinate is less than the image height and width of the monster and if so then we know that they are "touching"
so we subtract 1 from the player's health. Here we also use the monsters object to manipulate the player objects 'health'.

```
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
```

