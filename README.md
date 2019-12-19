#ECE350 Final Project Report
=== 
Brandon Guo (blg19)
Andy Nguyen (aln20)

Introduction
---
Our group project is Chess. Chess is an ancient board game that is played on an 8x8 board between two players. The rules of the game are very simple, yet the overall strategic depth has proven to be an NP-Hard problem. Here, we provide the users with a platform to explore the simple game's complexity and depth. 

Project Design and Specifications
---
Our final project is Chess as a Service. Using a PS2 Keyboard to take user input, our project empowers users to play chess. 

At a high level, the project is a chess board with chess pieces represented, and with the ability to take user input to control and move the pieces. It is inherently a two-player adversarial game, and as such we provide the mechanisms for two players to compete in a challenge to capture the opponent's king. The game state/board is rendered on a 640x480 monitor through the VGA connection port, and all the game representation logic is handled by the processor. In fact, the entire game logic and rules enforcement occurs in the processor, with the interaction between hardware (display and keyboard) and the processor passing through designated addresses in the DMEM. 

In more detail, our project provides the following features:
- 8x8 game grid, with proper locations of pawns, kings, queens, bishops, knights, and rooks. 
- PS2 to select piece-to-move and location-to-move-to
- VGA Monitor to render the current game state
- When a piece is selected, validates that the user has indeed
    - selected a piece
    - controls the selected piece
- When a piece is selected, highlights the cells that represent the possible valid moves that that piece has available to it
- When a piece is selected, highlights (in a different color) the currently selected piece, for easy user interaction
- When a piece is selected and a second piece is reselected, changes the active piece to the second piece
- When a piece is selected and a destination is selected, validates that the selected piece is able to visit the chosen destination
- When a king is taken, displays the winner
- When a timer hits zero, displays the winner
- When a timer is less than 1 minute, changes background color to red to signify warning state
- When a move is made, the turn switches and the timer being decremented switches
- When a move is made, the current turn display switches
- When the R key is hit, resets the game to classic chess, including all existing inputs and timer
- When the K key is hit, resets the game to King of the Hill Chess, including all existing inputs and timer
- When the L key is hit, resets the game to Light Brigade Chess, including all existing inputs and timer
- When a game has ended, background is grayed out, all non-reset inputs are disabled
- When a pawn reaches the end of the board, the pawn is promoted to a Queen


The vast majority of our features are encoded as processor instructions in the instruction memory, written in a MIPS-like language. At a high module level, the major components are a VGA controller, a keyboard input controller, Data memory, and processor. VGA controller handles what data (read from data memory) should be rendered. Keyboard input handles what data should be written to data memory. Processor reads from the designated write positions of the keyboard input to process user input, and the data memory represents both the shared state and the data bus between the inputs and the game logic. 

Input and Output
---

#### Inputs
The inputs to the project are all in the PS2 Keyboard. The input rules are as follows

- To select a piece to move, the user must hit the left arrow key, then the letter corresponding to the cell's x address, and then the number representing the cell's y address. 
    ![](https://i.imgur.com/25197JK.png)
    - If an invalid cell (cell without a piece, cell with opposite colored piece) is selected, the processor validates, fails validation, and asks the user to reinput/reselect a piece
    - If the user then hits the left arrow key, then the letter corresponding to another cell's x address, and then the number representing the cell's y address, it replaces the user's initial piece selection with the new selection, both graphically and in the game state being read by VGA and processor
- Similarily, once a piece is selected (and consequently the valid move choices are displayed), the user must hit the right arrow key, then the letter corresponding to the cell's x address, and then the number representing the cell's y address. This represents the user's move from cell_one to cell_two
    - If the destination selected is invalid, then the processor will fail the validation and ask the user to reselect a piece to move, and reselect a destination. This does not pause the clock
    - If the destination selected is valid, then the processor will perform the relevant computations to determine if the game is over, to move the piece, and to switch the turn and the clock. 

#### Outputs
The outputs of the game are confined solely to the displayed VGA. On a continuous cycle, the following are constantly queried and rendered:

- Chess board cells (checkerboard pattern, highlights) with column/row labels
- Chess pieces on the board (pawn, king, queen, bishop, knight, rook)
- Turn indicator
- White clock, ticks down when it is the white player's turn
- Black clock, ticks down when it is the black player's turn
- Current game mode (Classic Chess, King of the Hill, Light Brigade)
- Legend indicating reset controls
- Border color (defaults to blue, set to red when the current player is running low on time, set to gray when the game is over)
- On game termination, displays the winner

Changes made to processor
---
We were fortunate to have a fully-functional and bypassed processor. Consequently, no new code or adjustments needed to be made to the processor itself. 

A minor update was made to the DMEM to turn it into 2-port RAM. This is due to the fact that the hardware verilog (responsible for writing keyboard input to DMEM and for reading out chess board data from DMEM) and the processor (responsible for handling game logic and rule enforcement) must be able to both concurrently read from and write to the DMEM. Fortunately, the initially coded 12-bit addresses (4096 addresses total) proved to be enough addresses to handle and represent all the MIPS code and game state necessary. 

Challenges
---
#### Move Validation Code Complexity
One challenge that we faced was that the task of validating moves and executing moves for each of the possible pieces in the game was inherantly complex, especially when coded in MIPS. Issues that could arise with programming this is that we have multiple pieces in chess that all move in distinct ways. We thus had to be careful as to write code that can be built off of and extended across multiple pieces, as well as potentially adding on new game modes. We overcame this challenge by being very strict with our approach to writing the MIPS code for this project. We spent the time to not start coding right away, but to rather map out in pseudocode how move validation checks should happen for each piece. We also kept strict standards as to what registers we were allowed to write to, so as to avoid any conflicts across function calls. For instance, we specified that registers 1-9 would be dedicated registers that would not be written to across function calls. Essentially each of these registers would contain read-only data as input from the hardware, dmem, etc. We also dedicated registers 10-20 as temporary scratch registers that allow us to do quick calculations and conditional checks within function calls (values don't matter after the function call). In short, we spent lots of time planning how are program would interact with hardware, as well as maintaining strict coding standards so that we could build off our MIPS code as we proceeded with the project.

#### Letting Hardware Interact with MIPS code
We found that it was difficult to have our MIPS code receive user input. The first issue was that while we had mapped out pseudocode for function calls such as move validation and making moves, we needed that code to be executed upon receiving user input. We found that the only reasonable way for MIPS code to take in user input is to write user inputs to our DMEM file and have our MIPS code constantly poll our DMEM file for changes. We solved this problem by mapping out the concept of a game loop and how the MIPS code would take inputs from the processor in order to activate move validation as a function call.
We also specified that our MIPS code would take input from the hardware by reading specific dmem addresses that the hardware would write to. Keeping strict with what addresses in DMEM correspond to hardware input was key, and structuring this game loop made it possible for us to be able to constantly check for user input.

#### Concurrently Reading and Writing from/to DMEM
Another challenge that we faced was that our verilog code needs to read from DMEM in order to display the chess board and pieces on the VGA display. However, our verilog code also needs to write to DMEM, since we need to receive keyboard input from the user and write those keyboard inputs into DMEM so that the MIPS code can interact with user input. The issue with this is that the verilog dmem module only has one address port, meaning that there is no concept of a read address and a write address, but rather an and address that may read or write depending on the write enable value to the dmem module. This means that while we are displaying information read from addresses in our DMEM corresponding to our chess board and pieces, we can not at the same time write to a different address within our dmem module, since only one address can be specified at a time. In order to combat this issue, whenever we needed to write to a DMEM address due to keyboard input, we would pause the VGA display clock for one cycle, allowing us to write to DMEM within that one clock cycle, and then resume the VGA display clock on the next clock cycle so that it can go back to displaying the chess board. Essentially, we created a display interrupt that allows us to "concurrently" write to DMEM while still displaying the chess board.

#### Keyboard input bugs
Another challenge we found was that our keyboard input handling had several bugs. We found that keyboard inputs were sometimes not being detected by the verilog code while listening for keyboard inputs on each positive edge of the 50 MHZ clock. We found that occasionally due to unfortunate timing, the keyboard input signal passes through that always block undetected. We found that instead of listening on every 50 MHZ clock edge, we could just have an always block on the positive clock edge of the keyboard press. The second keyboard issue that we found was that we only wanted our keypresses to write to DMEM for a small amount of clock cycles (as close to 1 as possible), so as to not interfere with currently executing code. The strategy that we implemented to combat this was by starting a counter whenever keyboard input has started and we begin writing to DMEM once that counter has started. When that counter has reached a certain threshold, we reset the keyboard input and write enable to dmem, as well as the counter. This allows us to write to DMEM in as few clock cycles as possible after receiving keyboard input.

#### Debugging MIPS code
Another challenge that we found was that it was difficult to debug our MIPS code. We initially thought that MIPS code could be debugged by using waveforms similar to how our processor code was tested. However, we realized that because our VGA display worked properly, we could actually display debug symbols on the VGA display as an indication that something has occurred (similar to a print statement in most other languages). Thus, we made a debug function that makes a piece appear on the board at a specific square, and we called this function whenever we needed to debug our code.

#### Reset
It was also difficult to restart our game from scratch. We realized that from a user standpoint, having reset-game functionality is very important. This was challenging because while a game is occurring, a reset can occur at any point in time (while a player is making their move or just starting a game). We needed a way to do this "asyncronously". It was also challenging because we wanted to build different game modes (king of the hill and light brigade), so each of these game modes would need to have their own resets. We found that to solve this problem, we needed to use the game loop to constantly poll for reset inputs from the user, and, depending on which type of reset input the user receives (different reset inputs have different DMEM addresses), we overwrite our existing chess board dmem (dmem addresses 0-63) with corresponding backup chess board data also stored in dmem.

Circuit Diagrams
---
No circuit diagrams exist in this project

Testing
---
In order to ensure that the chess game performed as expected with no extraneous behaviors, the following tests were run:

#### Classic Chess
> 1. White piece takes black king (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 2. Black piece takes white king (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 3. White timer hits zero (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 4. Black timer hits zero (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 5. White timer is less than one (Expected: Game timer continue to decrement, background turned red on white turn but not necessarily red on turn flip, no banner displayed, all inputs enabled)
> 6. Black timer is less than one (Expected: Game timer continue to decrement, background turned red on black turn but not necessarily red on turn flip, no banner displayed, all inputs enabled)
> 7. Pawn able to move two spaces (on first move) or one space (anytime it is not blocked). Pawn able to move diagonally if it is able to capture an opposite colored piece in that cell. Pawn cannot move backwards
> 8. King able to move one space in any direction into any cell not occupied by an allied color
> 9. Queen able to move unlimited spaces in cardinal or diagonal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 10. Bishop able to move unlimited spaces in diagonal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 11. Rook able to move unlimited spaces in cardinal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 12. Knight able to move in some instance of current_location + [+-1, +-2] or [+-2, +-1] assuming destination is not occupied by allied piece and is in bounds
> 13. Pawn that reaches opposite border is promoted to a Queen
> 14. King that moves into center four squares does not trigger a win condition (Negative test case against accidentally running King of the Hill mode win conditions)
> 15. User reselection of piece (voluntary)
> 16. User reselection of piece (involuntary, user selected cell without allied colored piece)
> 17. User selection of destination before start (Expected: User forced to reselect destination)
> 18. User reselection of piece (involundary, user selected invalid destination)
> 19. Reset game to Classic Chess
> 20. Reset game to King of the Hill Chess
> 21. Reset game to Light Brigade Chess

#### King of the Hill
> 1. White piece takes black king (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 2. Black piece takes white king (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 3. White timer hits zero (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 4. Black timer hits zero (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 5. White timer is less than one (Expected: Game timer continue to decrement, background turned red on white turn but not necessarily red on turn flip, no banner displayed, all inputs enabled)
> 6. Black timer is less than one (Expected: Game timer continue to decrement, background turned red on black turn but not necessarily red on turn flip, no banner displayed, all inputs enabled)
> 7. Pawn able to move two spaces (on first move) or one space (anytime it is not blocked). Pawn able to move diagonally if it is able to capture an opposite colored piece in that cell. Pawn cannot move backwards
> 8. King able to move one space in any direction into any cell not occupied by an allied color
> 9. Queen able to move unlimited spaces in cardinal or diagonal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 10. Bishop able to move unlimited spaces in diagonal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 11. Rook able to move unlimited spaces in cardinal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 12. Knight able to move in some instance of current_location + [+-1, +-2] or [+-2, +-1] assuming destination is not occupied by allied piece and is in bounds
> 13. Pawn that reaches opposite border is promoted to a Queen
> 15. User reselection of piece (voluntary)
> 16. User reselection of piece (involuntary, user selected cell without allied colored piece)
> 17. User selection of destination before start (Expected: User forced to reselect destination)
> 18. User reselection of piece (involundary, user selected invalid destination)
> 19. Reset game to Classic Chess
> 20. Reset game to King of the Hill Chess
> 21. Reset game to Light Brigade Chess
> 22. Black King that moves into center four squares and survives one turn, triggers a win condition (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 23. White King that moves into center four squares and survives one turn, triggers a win condition (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 24. First king that moves into center four squares and survives one turn wins the game, even if the opposing king makes it into the center four squares as well

#### Light Brigade Chess
> 1. White piece takes black king (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 2. Black piece takes white king (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 3. White timer hits zero (Expected: Game timers no longer decrement, background grayed out, "Black Wins" displayed, all non-reset inputs disabled)
> 4. Black timer hits zero (Expected: Game timers no longer decrement, background grayed out, "White Wins" displayed, all non-reset inputs disabled)
> 5. White timer is less than one (Expected: Game timer continue to decrement, background turned red on white turn but not necessarily red on turn flip, no banner displayed, all inputs enabled)
> 6. Black timer is less than one (Expected: Game timer continue to decrement, background turned red on black turn but not necessarily red on turn flip, no banner displayed, all inputs enabled)
> 7. Pawn able to move two spaces (on first move) or one space (anytime it is not blocked). Pawn able to move diagonally if it is able to capture an opposite colored piece in that cell. Pawn cannot move backwards
> 8. King able to move one space in any direction into any cell not occupied by an allied color
> 9. Queen able to move unlimited spaces in cardinal or diagonal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 10. Bishop able to move unlimited spaces in diagonal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 11. Rook able to move unlimited spaces in cardinal directions into any cell not occupied by an allied color, stopping the "unlimited" when either a piece or the end of the board is encountered
> 12. Knight able to move in some instance of current_location + [+-1, +-2] or [+-2, +-1] assuming destination is not occupied by allied piece and is in bounds
> 13. Pawn that reaches opposite border is promoted to a Queen
> 14. King that moves into center four squares does not trigger a win condition (Negative test case against accidentally running King of the Hill mode win conditions)
> 15. User reselection of piece (voluntary)
> 16. User reselection of piece (involuntary, user selected cell without allied colored piece)
> 17. User selection of destination before start (Expected: User forced to reselect destination)
> 18. User reselection of piece (involundary, user selected invalid destination)
> 19. Reset game to Classic Chess
> 20. Reset game to King of the Hill Chess
> 21. Reset game to Light Brigade Chess
> 22. Light Brigade starts with correct board layout (8 pawns + 7 knights + 1 king vs 8 pawns + 3 queens + 1 king)

Assembly Code
---
At a high level, our code has the following flow
![](https://i.imgur.com/3usX6cQ.png)

We maintained an infinite while loop that continuously checked for user input (stored in desginated addresses in the DMEM by the hardware verilog interface). When an input is detected, processor logic handles what specific input type it is, and whether it represents a move request (source and destination) or if it represents a piece query (source only). Based on that determination, the processor exits the infinite loop and computes the necessary changes to the game state (represented in DMEM, written to by the processor). These computations include validity checking and physical piece movement/representsOnce the writes are completed, the processor jumps back to the top of the game loop and awaits further user input. 

Should a reset signal be recieved, the processor loads specific addresses from the DMEM and performs a board restore, reseting the game state and all relevate variables bound to the game state. It also edits a special register to indicate the new game mode (Classic Chess, King of the Hill, Light Brigade). 

Improvements/New Features Given More Time
---
More Advanced Pawn Promotion
> Currently, pawn promotion defaults to assuming that the user always wants a Queen. This logic is sound, since there is no situation where the user would prefer a Rook over a Queen or a Bishop over a Queen, and only very very situationally would prefer a Knight over a Queen. Given the rarity of this occurence, we decided to simplify the implementation and assume that the player would prefer a Queen. One improvement that could be made is to offer the option to choose different pieces, which would entail some selection logic in both the processor's promotion code and in the hardware verilog code to handle new selection inputs

Check Detection
> Given an inordinate amount of time, another feature that we would like to build was check detection. This is an extremely cumbersome feature to build, however, since it inherently requires the processor to permutate over all possible one-step-out moves and detect if any of them threaten the king. It also requires the processor to do that same check for *potential* moves as well, since the existence of a check-validation implies that users not only must react to a check, but must also not move pieces into check. 

Castling
> One fairly reasonable feature we would have liked to build was the move known as castling. As context, castling is a move in which the following conditions hold true:
> - The player's king has not moved before in the current game
> - The player's rook has not moved before in the current game
> - There are no pieces in between the player's king and the player's rook
> - The player's king is not currently under threat of check, and castling will not move the player's king into threat of check
> Due to the difficulty of these conditions to represent, and the lack of a concept of "check" in our implementation, the development of castling would require significant time investment. 

Sound effects
> A fun extension feature we could have implemented were sound effects. Some ideas we had included 
> - Background music
> - Urgency music when a timer is running low
> - Sound effect on piece capture
> - Sound effect on move completion
> - Sound effect on game termination
> 
> However, as a consequence of lack of time and lack of experience with sound files, we did not ultimately build this feature, as it was not critical to the functionality of the game




Pictures
---
Classic Chess Mode:
![](https://i.imgur.com/x6NGsyH.jpg)


King of the Hill Mode:
![](https://i.imgur.com/6VNjwlE.jpg)


Light Brigade Mode:
![](https://i.imgur.com/RAVpgvq.jpg)


White Win Screen:
![](https://i.imgur.com/t50iTru.jpg)


Black Win Screen:
![](https://i.imgur.com/l9zogi4.png)


King of the Hill Win (white king made it to center squares):
![](https://i.imgur.com/UohuBRq.jpg)


Low Time Background Changes to Red:
![](https://i.imgur.com/fLWenTq.jpg)


Timeout Win:
![](https://i.imgur.com/utcJ9LA.jpg)
