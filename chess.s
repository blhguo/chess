# brainstorm:
# 32 bits to encode each piece
# info:
#       - piece type: => 6 pieces => 3 bits total
#           - knight (001)
#           - king (010)
#           - queen (011)
#           - bishop (100)
#           - rook (101)
#           - pawn (110)
#       - color of piece: one bit total => 0 = white, 1 = black
#       - color of square: four bits total => 0001 = BWRG
#      IF THERE IS NO PIECE AT AN ADDRESS IN DMEM (addr 0-63) : all 1s (-1)
#   ex: 1000     110     0       : is a white pawn
#       sqclr    piece  color
# these pieces will be stored at an address in dmem that represents a position on a board
# follow drawing for encoding details: chessboard.jpg

# encoding dedicated state register:
# register number 30
#   right-aligned 32 bits:
#   lsb currplayer: 0 = white or 1 = player
# register number 29
#   valid move registers (to be loaded to over every valid move in dmem)
# register number 28
#   current cell data
# register number 27
#   curr piece color
# register number 26
#   curr piece type
# register number 25
#   curr piece position
# register number 24
#   tempCellData
# register number 23
#   temp piece color
# register number 22
#   temp piece type
# register number 21
#   temp piece position
#


#
#//note
#if(cond1 && cond2)
#bne $1, cond1 2
#addi $29, $0, 1
#bne $0, $29, 1
#addi $29, $0, 0

#bne $1, cond2 2
#addi $28, $0, 1
#bne $0, $28, 1
#addi $28, $0, 0

#and $res, $28, $29
#bne $res, don't do res
#do res
#
#
# $1: (yx) of input1, $2: (yx) of input2, $3: cellData_input1 $4: cellData_input2
##################GAME LOOP BEGINS HERE##########################
# bunch of no-ops in the beginning
nop
nop
nop
nop
nop
nop
nop
nop
nop

lw $1, 64($0)
lw $2, 65($0)

# invalid initial position check, aka no input_1 has been made
addi $10 $0 -1
bne $10, $1, 1
j 0

#CHeck if $2 is valid/active. is_$2_eq_-1 in $20
#$20 = is_$2_invalid
bne $2, $10 2
addi $20, $0, 1
bne $0, $20, 1
addi $20, $0, 0

lw $30, 66($0)
lw $3, 0($1)

######right-aligned
######ex: 1000     110     0       : is a white pawn
###       sqclr    piece  color

#$11 contains extracted masked value of currcelldata looking for piece
#14 = 000000...1110
addi $10 $0 14
and $11, $10, $3
bne $11, $0, 1
j 0

#$12 contains piece color
#$13 contains curr player's turn color
addi $10 $0 1
and $12, $10, $3
and $13, $10, $30

bne $12, $13, 1
bne $10, $0, 1
j 0

#If $1 is valid and $2 is valid
bne $20 $0 1
j handle$2Valid
j handle$2InValid

j 0
##################GAME BIG LOOP ENDS HERE##########################


handle$2Valid:
    //load arguments into registers
    
    //parse start pos (used to address into dmem)
    
    //parse end pos (used to address into dmem AND to compare to valid moves)
    //parse curr cell data (used to overwrite addresses in dmem)
    
    'dont think we need this lw'
    lw $4, 0($2)
    
    jal move
    j 0


handle$2InValid:
    //load arguments into registers


    j 0


move:
# inputs:
    #   currCellData (32 bits), startPos (6 bit number), endPos (6 bit number)
    # outputs:
    # task:
    # validate whether move is within valid set of moves
    # overwriting dest cell data with curr cell data, checking to see if we took a king by lwing the dest pos prior to blast
    # -> then restoreColors (RESETS all register file data and cleans up the DMEM
    # display win if necessary
    # reset $1 and $2 to be invalid (-1)    
    
    #################CHECK ALL DMEM VALID MOVES COMPARE############
    ##???????????????????????????????ADD MORE OF THEM 28???????????????????????##
    #load zeroth valid move from dmem100
    lw $10 100($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid
    
    addi $11, $0, -1
    bne $10, $11, 1
    j restoreColors
    
    #load zeroth valid move from dmem100
    lw $10 101($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid
    
    addi $11, $0, -1
    bne $10, $11, 1
    j restoreColors
    
    #load zeroth valid move from dmem100
    lw $10 102($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid
    
    addi $11, $0, -1
    bne $10, $11, 1
    j restoreColors
    
    
    ...
    j restoreColors

restoreColors:
    #reset the colors
    addi $10, $0, 0 #iterator i
    addi $11, $0, 64 #upper loop bound
    addi $12, $0, 1 #lsb x mask 0001
    addi $13, $0, 8 #lsb y mask 1000
    addi $14, $0, 240 #square color mask 11110000
    j startLoopRestoreColors
#looooop
startLoopRestoreColors:
    bne $10, $11, 1
    j endLoopRestoreColors
    lw $15, 0($10)
    
    #get the sq color bits from $15 and subtract them away
    and $16, $14, $15
    sub $15, $15, $16
    
    # parse lsb x
    and $17, $1, $12
    # parse lsb y and shift lsb y to line up with lsb x
    and $18, $1, $13
    srl $18, $18, 3
    
    sub $19, $17, $18
    #if $19 == 0, same polarity, black square
    bne $19, $0, 1
    addi $15, $15, 128 #10000000
    bne $12, $0, 1 #just to skip running the write white sq part
    #else white square
    addi $15, $15, 64 #01000000
    
    sw $15, 0($10)
    addi $10, $10, 1 #i = i + 1
    
    j startLoopRestoreColors #end loooooop
     
endLoopRestoreColors:
    # wipe registers in reg file just in case
    addi $1, $0, 0
    ...
    addi $30, $0, 0
    
    #reset 64 and 65 to be invalid
    addi $10, $0, -1
    sw $10, 64($0)
    sw $10, 65($0)
    
    j 0
    
handle_valid:
    sw $3, 0($2)
    sw $0, 0($1)
    ...
    j restoreColors

lw 
$4, 0($2)

bne $1,  2
addi $29, $0, 1
bne $0, $29, 1
addi $29, $0, 0

bne $1, cond2 2
addi $28, $0, 1
bne $0, $28, 1
addi $28, $0, 0

and $res, $28, $29
bne $res, don't do res
do res

# do stuff
bne $1, cond1, #63
j move
j 0
bne $1, cond2, #65
j move
j 0
bne $2, cond3, #2
j move
j 0

#check #2
#if (cond1 && cond2):
bne $1, cond1, #70
bne $1, cond2, #70
j move


#if input1:
    if input2:
           eval move
      else: 
          print green moves
#else:
#    go back to top of loop

#if input2:
    eval move
   


return:
j 0
##################GAME BIG LOOP ENDS HERE##########################

# possible functions
j move
j 0 # jump back to the beginning of the loop
j findPieceAtPos
j 0 # jump back to the beginning of the loop
j move
j 0 # jump back to the beginning of the loop






move:
    # inputs:
    #   currCellData (32 bits), startPos (6 bit number), endPos (6 bit number)
    # outputs:
    # task:
    # overwriting dest cell data with curr cell data, checking to see if we took a king by lwing the dest pos
    # then restoreColors
    # display win if necessary


findPieceAtPos:
    # inputs:
    #   currColor, x, y
    # task:
    #   looks through 32 addresses in dmem to look for a piece at x,y that belongs to currColor
    # outputs:
    #   write these valid moves to each piece square background colors to indicate valid moves
    #   write 28 32-bit writes to dmem. 000...dest_loc if valid move. Else its going to be all 1's (-1).

checkWin:
    # inputs:
    #   none
    # outputs:
    #   0 == 0, 1, or -1. 0 indicates nobody winning, 1 indicates white wins, -1 indicates black wins

getPiece:
    # input:
    #   2 32 bit numbers (really 3 bit) -> x, y coords
    # outputs:
    #   the 32 bit piece from dmem

restoreColors:
    # input: no input, but make sure to loop through 0-63 in dmem
    # outputs: none, but write to dmem

findMovesForPiece:
    # inputs:
    #   32 bit piece
    # outputs:
    #   0-27 == store up to 28 possible moves into memory, storing nulls for the moves that aren't possible

