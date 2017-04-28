# 2d-Shooter 

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
So far, the game has 4 levels and it gets harder as it goes on. The final level is the boss level. 


### Evaluation of Results 
All in all, the game is at 90 percent and only need minor apperance tweaks for user pleasure. 

## Architecture Diagram
First block is the user input where we will use 2htdp-universe library to implement

Game design will also be using 2htdp-image/universe

Sound will link to the Game using rsound

Sprite interaction using 2htdp-universe to update the world when sprites collide

<img src="https://github.com/oplS17projects/2d-Shooter/blob/master/Screen%20Shot%202017-04-02%20at%208.16.12%20PM.png" width="800" height="800">

## Schedule
### First Milestone (Sun Apr 9)
By the first mileston we hope to have been able to load up the world, sprite, bullets, and enemies and also getting the input 
events working properly for the character sprite.

### Second Milestone (Sun Apr 16)
For the second milestone we will have the enemy and projectile sprites functional. We will also have the sound implemented.

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28 [your date to be determined later])
For the public presentation we will have completed testing with the game and have a fully functional game to demo. Where user input
is correctly implemented along with interaction between enemies and players. 

## Group Responsibilities

### Danny Nguyen @dannynguyen1
will write the event that take in input from the user

Will work on movement of the character sprire

### Chintushig Ochirsukh @luffy1727
Will work on the incorporating sound

Will work on projectile movement

 
