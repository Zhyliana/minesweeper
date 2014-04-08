###Minesweeper
===========

You remember Minesweeper, right? Well, I rebuilt it! Very colorful and so retro you'll want to bust out some Vanilla Ice.

First, I set up a square grid (you can adjust the size when you initialize the game). I then randomly seeded it with (grid-length*1.14) bombs (a very official the formula). 

The game then prompts the user for the coordinates of the tile they'd like to play an action on. The game will also prompt them for the action they would like to take on that tile. They can either reveal the tile (R) or flag it (F).

##Reveal a tile

If the user chooses to reveal a tile that contains a bomb, game over. Kapoot. They loose. 

Otherwise, it will be revealed, and so will its neighbors, and its neighbors' neighbors, and so on intil it reaches the end of the board, or a bomb's neighbors (labeled as tiles where `bomb_count == true`). 

##Flag a tile

If the user thinks this tile contains a bomb, they can flag it `(flag == true)`. This will keep that tile from being revealed, even when surrounding areas would have otherwise revealed it. The user wins once only bombs are flagged (no flagging the entire board!).

##Saving

If the user ever exits an uncompleted game, they will have the option to continue their game or start a new one.
