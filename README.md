# 2d-Shooter 

### Statement 
Our project will be a 2d side scrolling shooter, similar to the game contra. This is interesting because we both will be
able to learn how the 2htdp graphics and rsound libraries work and bring them together to produce this game. We both personally
find this idea interesting because we both like to play games in our free time and thought that it would be fun to implement our
own game. We hope to learn how to implement concepts we learned in class like object oriented programming and data abstraction
and apply it to our idea.

### Analysis
Since this game is a shooter game we will need to use object orientation to create the player, bullet, and enemy objects. We have not
completely figured out on exactly how we wish to update the world itself, but we may use state-modification or data abstraction techniques
in order to update player, bullet, and enemy object positions. For example how fast different enemies approach the player sprite will
use these concepts mentioned above.

### External Technologies
Our project will allow users to have control on how the character sprite moves by using the arrow keys and spacebar. We will also 
generate sound using the rsound library.

### Data Sets or other Source Materials
We will not be using extensive outside materials other than importing character, bullet, and enemy sprites. Since most of the needed material
to make this project work is implementing the 2htdp graphics library and rsound library.

### Deliverable and Demonstration
At the end of this project we hope to have created an interactive game that catches the users attention. At the live demo users will be able
to play through levels which progressively get harder and they will be able to experience certain interactions we have created in game. We hope 
to produce a solid game that is interactive and hopefully easily re-runnable with no bugs.

### Evaluation of Results 
We will know that we are successful if we are able to produce solid game with no bugs. For example while exploring the 2htdp graphics
library we personally had some errors due to user input. Since that is the foundation of our project, if users are able to fluidly run through
the game without it crashing we will know were successful.

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

 
