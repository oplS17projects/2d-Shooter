# 2d-Shooter 


<p align="center" width="300">
<img src="https://raw.githubusercontent.com/oplS17projects/2d-Shooter/master/game_screen.png">
</p>

### Statement 
Our project is 2d side scrolling shooter game, similar to the game contra. This was an interesting idea because we both learned how the
2htdp graphics and rsound libraries worked and by bringing them together we produced this game. Since we were both interested in
games, we really enjoyed developing our own game. We implemented various data structures, lists, maps, filters into our code and used it
efficiently.

### Analysis
We implemented the game at 3 layer deep abstraction. (world -> player -> bullet -> bullet-list etc.) Since it is 2d shooter game we had
to pass around the world which has player, bullet and the enemy inside. By passing the world around we were able to update the location
of the player and the enemy at the same time using the on-tick function.
We started off with just a picture and a player-sprite. As we discovered 2htdp/graphics library, we found out that in order to place 2 
different image at the same time we had to place one of them inside the other place-image function. With this information, we were able
to implement moving enemy, player and exactly one bullet. Then arose the second problem, how to get multiple bullets? We struggled with
the idea for a while and finally changed the bullets into a list which has bullet object inside. Everytime the on-tick function triggers
it cdrs down the list and draws each one of them which gets updated as it goes on.

### External Technologies
Our game allows users to have control on how the character sprite moves by using the arrow keys and spacebar. We also 
generate sound using the rsound library.

### Data Sets or other Source Materials
Only source materials we used was the imported images and sprites

### Deliverable and Demonstration
So far, the game has 2 the beginning and the final level is the boss level. 


### Evaluation of Results 
All in all, the game is at 90 percent and only need minor apperance tweaks for user pleasure. 

## Architecture Diagram
We load the world with 4 objects the player, bullet, enemy, and boss

We check if a collision occurs for any of the objects:
# True: 
player life - 1

destroy bullet

destroy enemy

boss life -1

# False: 
Update the world

We check the following:

Player life = 0 -> game over screen and reset game

enemy list = '() -> go to boss stage

boss health = 0 -> win screen

Lastly we linked the collision whenever bullet list is less than the old bullet list and fire sound bound to the spacebar key and upate the world

<p align="center" width="500" height= "600">
<img src="https://github.com/oplS17projects/2d-Shooter/blob/master/2d-shooter%20diagram%20-%20Page%201.png">
</p>

## Schedule
### First Milestone (Sun Apr 9)
By the first mileston we hope to have been able to load up the world, sprite, bullets, and enemies and also getting the input 
events working properly for the character sprite.

### Second Milestone (Sun Apr 16)
For the second milestone we will have the enemy and projectile sprites functional. We will also have the sound implemented.

### Public Presentation Fri Apr 28 
For this public presentation we have created a functional game that takes in user input, and has two playable stages.
All character, projectiles, and enemies are functional.
Sound has also been implemented for when the character fires a bullet and when that bullet collides with enemies.

## Group Responsibilities

### Danny Nguyen @dannynguyen1
User input

Sound with rsound

### Chintushig Ochirsukh @luffy1727
Projectile movement 

Enemy functionalities

### What we did together @dannynguyen1 and @luffy1727
Projectile interactions and filtering

Collisions

 
