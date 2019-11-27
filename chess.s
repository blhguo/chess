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

addi $10 $0, -1
bne $2, $10, 1
bne $10, $0, 1

# addi $10 $0, 1
# bne $1, $10, 1
# jal debug

# invalid initial position check, aka no input_1 has been made
addi $10 $0 -1
bne $10, $1, 4
#reset 64 and 65 to be invalid
addi $10, $0, -1
sw $10, 64($0)
sw $10, 65($0)
j 0

#CHeck if $2 is valid/active. is_$2_eq_-1 in $20
#$20 = is_$2_invalid
bne $2, $10, 2
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
bne $11, $0, 4
#reset 64 and 65 to be invalid
addi $10, $0, -1
sw $10, 64($0)
sw $10, 65($0)
j 0

#$12 contains piece color
#$13 contains curr player's turn color
addi $10 $0 1
and $12, $10, $3
and $13, $10, $30

bne $12, $13, 1
bne $10, $0, 4
#reset 64 and 65 to be invalid
addi $10, $0, -1
sw $10, 64($0)
sw $10, 65($0)
j 0

#If $1 is valid and $2 is valid
bne $20 $0 1
j handle2Valid
j handle2InValid

j 0
##################GAME BIG LOOP ENDS HERE##########################

debug:
    addi $18, $0, 73
    addi $17, $0, 36
    sw $18, 0($17)
    jr $31

debug2:
    addi $18, $0, 73
    addi $17, $0, 37
    sw $18, 0($17)
    jr $31

debug3:
    addi $18, $0, 73
    addi $17, $0, 38
    sw $18, 0($17)
    jr $31

handle2Valid:
    # $1: (yx) of input1, $2: (yx) of input2, $3: cellData_input1 $4: cellData_input2    
    #'dont think we need this lw'
    lw $4, 0($2)
    j move

###!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!TODO:######################
checkWin:
    ####Scan if there are two kings still on board, call this at bottom of         
    ####handle2Valid
    #### FLIP THE TURN STATE ONLY WHEN ITS A VALID MOVE

handle2InValid:
    # $1: (yx) of input1, $3: cellData_input1
    #load arguments into registers
    # jal debug
    #$11 is going to hold the piece type, unshifted, then we shift it
    #$10 is going to hold the mask
    #10 = 000000...1110
    addi $10 $0 14
    and $11, $10, $3
    sra $11, $11, 1
    
    #wipe 100-131
    addi $10, $0, -1
    sw $10, 100($0)
    sw $10, 101($0)
    sw $10, 102($0)
    sw $10, 103($0)
    sw $10, 104($0)
    sw $10, 105($0)
    sw $10, 106($0)
    sw $10, 107($0)
    sw $10, 108($0)
    sw $10, 109($0)
    sw $10, 110($0)
    sw $10, 111($0)
    sw $10, 112($0)
    sw $10, 113($0)
    sw $10, 114($0)
    sw $10, 115($0)
    sw $10, 116($0)
    sw $10, 117($0)
    sw $10, 118($0)
    sw $10, 119($0)
    sw $10, 120($0)
    sw $10, 121($0)
    sw $10, 122($0)
    sw $10, 123($0)
    sw $10, 124($0)
    sw $10, 125($0)
    sw $10, 126($0)
    sw $10, 127($0)
    sw $10, 128($0)
    sw $10, 129($0)
    sw $10, 130($0)
    sw $10, 131($0)
    
    # handle knight
    addi $10 $0 1
    bne $11 $10 1
    j handleKnight
    
    # handle king
    addi $10 $0 2
    bne $11 $10 1
    j handleKing
    
    # # TODO: handle queen
    addi $10 $0 3
    bne $11 $10 1
    j handleQueen
    
    # # TODO: handle bishop
    addi $10 $0 4
    bne $11 $10 1
    j handleBishop
    
    # handle rook
    addi $10 $0 5
    bne $11 $10 1
    j handleRook
    
    # handle pawn
    addi $10 $0 6
    bne $11 $10 1
    j handlePawn
    
    j 0

handleQueen:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    j handleQueenDiag

handleQueenDiag:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    # Writes to dedicated $6 = address, starting from 100
    
    addi $6, $0, 100
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x + 1, $8= y+1
    addi $7, $7, 1
    addi $8, $8, 1
    j startLoopQueenXAdd1YAdd1
#######START OF x+1 loop
startLoopQueenXAdd1YAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenXAdd1YAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1

    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, 1 #x = x + 1
    addi $8, $8, 1 #y = y + 1
    j startLoopQueenXAdd1YAdd1 #end loooooop
    j endLoopQueenXAdd1YAdd1

#######END OF x+1 loop
endLoopQueenXAdd1YAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x + 1, $8= y - 1
    addi $7, $7, 1
    addi $8, $8, -1
    j startLoopQueenXAdd1YSub1
#######START OF x-1 loop
startLoopQueenXAdd1YSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenXAdd1YSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, 1 #x = x + 1
    addi $8, $8, -1 #y = y - 1
    j startLoopQueenXAdd1YSub1 #end loooooop
    j endLoopQueenXAdd1YSub1

#######END OF x-1 loop
endLoopQueenXAdd1YSub1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x-1, $8= y + 1
    addi $7, $7, -1
    addi $8, $8, 1
    j startLoopQueenXSub1YAdd1
startLoopQueenXSub1YAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenXSub1YAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, -1 #x = x - 1
    addi $8, $8, 1 #y = y + 1
    j startLoopQueenXSub1YAdd1 #end loooooop
    j endLoopQueenXSub1YAdd1

#######END OF x=x-1 loop
endLoopQueenXSub1YAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x-1, $8= y - 1
    addi $7, $7, -1
    addi $8, $8, -1
    j startLoopQueenXSub1YSub1
startLoopQueenXSub1YSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenXSub1YSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, -1 #x = x - 1
    addi $8, $8, -1 #y = y - 1
    j startLoopQueenXSub1YSub1 #end loooooop
    j endLoopQueenXSub1YSub1

#######END OF y-1 loop
endLoopQueenXSub1YSub1:
    j handleQueenStraight

handleQueenStraight:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    # Writes to dedicated $6 = address, starting from 100
    
    addi $6, $0, 114
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x + 1, $8= y
    addi $7, $7, 1
    j startLoopQueenXAdd1
#######START OF x+1 loop
startLoopQueenXAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenXAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1

    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2
    addi $7, $7, 1 #x = x + 1
    j startLoopQueenXAdd1 #end loooooop
    j endLoopQueenXAdd1

#######END OF x+1 loop
endLoopQueenXAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x - 1, $8= y
    addi $7, $7, -1
    j startLoopQueenXSub1
#######START OF x-1 loop
startLoopQueenXSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenXSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2
    addi $7, $7, -1 #x = x - 1
    j startLoopQueenXSub1 #end loooooop
    j endLoopQueenXSub1

#######END OF x-1 loop
endLoopQueenXSub1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x, $8= y + 1
    addi $8, $8, 1
    j startLoopQueenYAdd1
startLoopQueenYAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenYAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2
    addi $8, $8, 1 #y = y + 1
    j startLoopQueenYAdd1 #end loooooop
    j endLoopQueenYAdd1

#######END OF x=x-1 loop
endLoopQueenYAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x, $8= y - 1
    addi $8, $8, -1
    j startLoopQueenYSub1
startLoopQueenYSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopQueenYSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2 
    addi $8, $8, -1 #y = y - 1
    j startLoopQueenYSub1 #end loooooop
    j endLoopQueenYSub1

#######END OF y-1 loop
endLoopQueenYSub1:
    j 0


handlePawn:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest

    # storing current players color in $11 and color mask in $10
    addi $10, $0, 1
    and $11, $10, $30

    # if curr pawn color is white, then whitePawnCheck, otherwise blackPawnCheck
    bne $11, $0, 2
    jal whitePawnCheck
    j 0
    jal blackPawnCheck
    j 0

blackPawnCheck:
    j blackPawnCheckSub1

blackPawnCheckSub1:
    # check y - 1, if it fails, it also must fail y - 2, so continue to leftDiag
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, -1
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j blackPawnLeftDiagCheck
    
    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS AT THAT CELL AND FAIL IF THERE IS, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero -> fail, go to leftdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    bne $10, $0, 1
    j blackPawnLeftDiagCheck

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100
    sw $10, 100($0)

    ### because you passed y - 1, move onto y - 2, but only if you are at y - 1= 5 rn
    addi $10, $0, 5
    bne $10, $8, 1
    j blackPawnYSub2Check
    j blackPawnLeftDiagCheck

blackPawnYSub2Check:
    # check y - 2 only if it passes y - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, -2
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j blackPawnLeftDiagCheck

    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS AT THAT CELL AND FAIL IF THERE IS, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero -> fail, go to leftdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    bne $10, $0, 1
    j blackPawnLeftDiagCheck

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 101
    sw $10, 101($0)
    
    j blackPawnLeftDiagCheck


blackPawnLeftDiagCheck:
    # check y - 1, x - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, -1
    addi $7, $7, -1
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j blackPawnRightDiagCheck

    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS NOT AT THAT CELL AND FAIL IF THERE IS NO PIECE, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is zero -> fail, go to rightdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    j blackPawnRightDiagCheck

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 102
    sw $10, 102($0)
    
    j blackPawnRightDiagCheck

blackPawnRightDiagCheck:
    # check y - 1, x + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, -1
    addi $7, $7, 1
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j 0

    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS NOT AT THAT CELL AND FAIL IF THERE IS NO PIECE, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is zero -> fail, go to rightdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    j 0

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 102
    sw $10, 103($0)
    
    j 0

whitePawnCheck:
    j whitePawnYAdd1Check

whitePawnYAdd1Check:
    # check y + 1, if it fails, it also must fail y + 2, so continue to leftDiag
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, 1
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j whitePawnLeftDiagCheck
    
    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS AT THAT CELL AND FAIL IF THERE IS, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero -> fail, go to leftdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    bne $10, $0, 1
    j whitePawnLeftDiagCheck

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100
    sw $10, 100($0)

    ### because you passed y + 1, move onto y + 2, but only if you are at y + 1= 2 rn
    addi $10, $0, 2
    bne $10, $8, 1
    j whitePawnYAdd2Check
    j whitePawnLeftDiagCheck

whitePawnYAdd2Check:
    # check y + 2 only if it passes y + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, 2
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j whitePawnLeftDiagCheck

    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS AT THAT CELL AND FAIL IF THERE IS, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero -> fail, go to leftdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    bne $10, $0, 1
    j whitePawnLeftDiagCheck

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 101
    sw $10, 101($0)
    
    j whitePawnLeftDiagCheck


whitePawnLeftDiagCheck:
    # check y + 1, x - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, 1
    addi $7, $7, -1
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j whitePawnRightDiagCheck

    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS NOT AT THAT CELL AND FAIL IF THERE IS NO PIECE, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is zero -> fail, go to rightdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    j whitePawnRightDiagCheck

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 102
    sw $10, 102($0)
    
    j whitePawnRightDiagCheck

whitePawnRightDiagCheck:
    # check y + 1, x + 1
    # check y + 1, x - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, 1
    addi $7, $7, 1
    jal validateDestination #writes to $9 if valid move
    bne $9, $0, 1
    j 0

    ### GET CELL DATA AT NEW CELL
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)

    ### CHECKING IF PIECE IS NOT AT THAT CELL AND FAIL IF THERE IS NO PIECE, cell data in $11
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is zero -> fail, go to rightdiag, otherwise mark valid, keep going
    bne $12, $0, 1
    j 0

    ### WRITING GREEN SQUARE AND VALID MOVE, $11 already has unaltered cell data
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # create address again for writing to cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 102
    sw $10, 103($0)
    
    j 0

handleKing:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    
    ############ $7 = x + 1, $8= y -1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 1
    addi $8, $8, -1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 100($0)
    # bne lands past here
    
    ############ $7 = x + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 101($0)
    
    ############ $7 = x + 1, $8= y + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 1
    addi $8, $8, 1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 102($0)

    ############ $7 = x, $8= y - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, -1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 103($0)

    ############ $7 = x, $8= y + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $8, $8, 1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 104($0)

    ############ $7 = x - 1, $8= y - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -1
    addi $8, $8, -1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 105($0)

    ############ $7 = x - 1, $8= y
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 106($0)

    ############ $7 = x - 1, $8= y + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -1
    addi $8, $8, 1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 107($0)

    #... # do this for the other 5 cases, all should be same except for the offsets -> DONE :)
    j 0
    
handleBishop:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    # Writes to dedicated $6 = address, starting from 100
    
    addi $6, $0, 100
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x + 1, $8= y+1
    addi $7, $7, 1
    addi $8, $8, 1
    j startLoopBishopXAdd1YAdd1
#######START OF x+1 loop
startLoopBishopXAdd1YAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopBishopXAdd1YAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1

    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, 1 #x = x + 1
    addi $8, $8, 1 #y = y + 1
    j startLoopBishopXAdd1YAdd1 #end loooooop
    j endLoopBishopXAdd1YAdd1

#######END OF x+1 loop
endLoopBishopXAdd1YAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x + 1, $8= y - 1
    addi $7, $7, 1
    addi $8, $8, -1
    j startLoopBishopXAdd1YSub1
#######START OF x-1 loop
startLoopBishopXAdd1YSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopBishopXAdd1YSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, 1 #x = x + 1
    addi $8, $8, -1 #y = y - 1
    j startLoopBishopXAdd1YSub1 #end loooooop
    j endLoopBishopXAdd1YSub1

#######END OF x-1 loop
endLoopBishopXAdd1YSub1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x-1, $8= y + 1
    addi $7, $7, -1
    addi $8, $8, 1
    j startLoopBishopXSub1YAdd1
startLoopBishopXSub1YAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopBishopXSub1YAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, -1 #x = x - 1
    addi $8, $8, 1 #y = y + 1
    j startLoopBishopXSub1YAdd1 #end loooooop
    j endLoopBishopXSub1YAdd1

#######END OF x=x-1 loop
endLoopBishopXSub1YAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x-1, $8= y - 1
    addi $7, $7, -1
    addi $8, $8, -1
    j startLoopBishopXSub1YSub1
startLoopBishopXSub1YSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopBishopXSub1YSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 3
    addi $7, $7, -1 #x = x - 1
    addi $8, $8, -1 #y = y - 1
    j startLoopBishopXSub1YSub1 #end loooooop
    j endLoopBishopXSub1YSub1

#######END OF y-1 loop
endLoopBishopXSub1YSub1:
    j 0



handleRook:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    # Writes to dedicated $6 = address, starting from 100
    
    addi $6, $0, 100
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x + 1, $8= y
    addi $7, $7, 1
    j startLoopRookXAdd1
#######START OF x+1 loop
startLoopRookXAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopRookXAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1

    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2
    addi $7, $7, 1 #x = x + 1
    j startLoopRookXAdd1 #end loooooop
    j endLoopRookXAdd1

#######END OF x+1 loop
endLoopRookXAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x - 1, $8= y
    addi $7, $7, -1
    j startLoopRookXSub1
#######START OF x-1 loop
startLoopRookXSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopRookXSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2
    addi $7, $7, -1 #x = x - 1
    j startLoopRookXSub1 #end loooooop
    j endLoopRookXSub1

#######END OF x-1 loop
endLoopRookXSub1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x, $8= y + 1
    addi $8, $8, 1
    j startLoopRookYAdd1
startLoopRookYAdd1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopRookYAdd1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2
    addi $8, $8, 1 #y = y + 1
    j startLoopRookYAdd1 #end loooooop
    j endLoopRookYAdd1

#######END OF x=x-1 loop
endLoopRookYAdd1:
    jal parseXY # parses $1 to make $7=x and $8=y
    ############ $7 = x, $8= y - 1
    addi $8, $8, -1
    j startLoopRookYSub1
startLoopRookYSub1:
    ### CHECK IF MOVE IS VALID
    jal validateDestination #writes to $9 if valid move
    # if its valid, continue, else go to the end of this loop
    bne $9, $0, 1
    j endLoopRookYSub1
    
    ### WRITING GREEN SQUARE AND VALID MOVE
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into current valid move address ($6)
    sw $10, 0($6)
    addi $6, $6, 1 #addr = addr + 1
    
    ### CHECKING IF PIECE OF OPP. COLOR IS AT THAT CELL, cell data in $11 already
    # Checks if there's a piece at new cell
    # uses: $11 = new cell data, $10 = piece mask, $12 = piece info of new cell
    addi $10, $0, 14 #piece mask stored in $10 = 1110
    and $12, $11, $10 # store the non shifted piece info in $12
    # if piece at this cell is nonzero, do some more checks, otherwise dw keep looping
    bne $12, $0, 2 
    addi $8, $8, -1 #y = y - 1
    j startLoopRookYSub1 #end loooooop
    j endLoopRookYSub1

#######END OF y-1 loop
endLoopRookYSub1:
    j 0

handleKnight:
    # Access to:
    #    $1: (yx) of input1
    #    $30: state variable (has the current players color)
    # Writes to dedicated $7 = x, $8 = y, $9 = wasValidDest
    
    ############ $7 = x + 1, $8= y + 2
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 1
    addi $8, $8, 2
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 100($0)
    # bne lands past here
    
    ############ $7 = x + 1, $8= y - 2
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 1
    addi $8, $8, -2
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 101($0)
    
    ############ $7 = x - 1, $8= y + 2
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -1
    addi $8, $8, 2
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 102($0)

    ############ $7 = x - 1, $8= y - 2
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -1
    addi $8, $8, -2
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 103($0)

    ############ $7 = x + 2, $8= y + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 2
    addi $8, $8, 1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 104($0)

    ############ $7 = x + 2, $8= y - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, 2
    addi $8, $8, -1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 105($0)

    ############ $7 = x - 2, $8= y + 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -2
    addi $8, $8, 1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 106($0)

    ############ $7 = x - 2, $8= y - 1
    jal parseXY # parses $1 to make $7=x and $8=y
    addi $7, $7, -2
    addi $8, $8, -1
    jal validateDestination #writes to $9 if valid move
    addi $19, $0, 1
    bne $9, $19, 9 #!!!!WARNING!!!!: this number is subject to change if the number of instr changes
    # create address for indexing into cell data: $10 has the address
    sll $10, $8, 3
    add $10, $10, $7
    # get the cell data at that loc: $11 has the cell data
    lw $11, 0($10)
    # replace the square color at that loc with green
    #     $12 has the square color mask
    #     $13 has the square color bits that we will subtract
    addi $12, $0, 240 #square color mask 11110000
    and $13, $11, $12
    sub $11, $11, $13
    addi $11, $11, 16 #green sq color 00010000
    # write the new cell data to mem
    sw $11, 0($10)
    # write the address for indexing into cell data into address 100 (100 stored in $14)
    sw $10, 107($0)

    #... # do this for the other 5 cases, all should be same except for the offsets -> DONE :)
    j 0
    

parseXY:
    # Access to:
    #    $1: (yx) of input1
    # Writes values to dedicated $7=x and $8=y by parsing from $1

    # storing x mask in $12, y mask in $13
    addi $12, $0, 7 #lsb x mask 000111
    addi $13, $0, 56 #lsb y mask 111000
    
    # curr x position in $14 and curr y position in $15 and 
    # parse x
    and $7, $1, $12
    and $8, $1, $13
    sra $8, $8, 3
    
    jr $31

validateDestination:
    # list known paramemters
    # $7 is x, $8 is y, $9 is output. if output=1, then the move is valid
    
    #check oob x<0#
    addi $10 $0 1
    blt $7 $0 1
    bne $0 $10 2
    addi $9 $0 0
    jr $31
    
    #check oob x>7#
    addi $10 $0 7
    blt $10 $7 1
    bne $0 $10 2
    addi $9 $0 0
    jr $31
    
    #check oob y<0#
    addi $10 $0 1
    blt $8 $0 1
    bne $0 $10 2
    addi $9 $0 0
    jr $31
    
    #check oob y>7#
    addi $10 $0 7
    blt $10 $8 1
    bne $0 $10 2
    addi $9 $0 0
    jr $31
    
    # storing current players color in $11 and color mask in $10
    addi $10, $0, 1
    and $11, $10, $30
    
    sll $12 $8 3
    add $12 $12 $7
    lw $13 0($12)
    
    addi $15 $0 14 #piece mask
    and $14 $13 $15
    bne $14 $0 2
    addi $9 $0 1
    jr $31
    
    # $13 contains temp cell data $12 contains yx
    and $14 $13 $10
    bne $14, $11, 2
    addi $9 $0 0
    jr $31
        
    addi $9 $0 1
    jr $31


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
    ##!!!!!!!!!!!!!!!!!!!!!!!!ADD MORE OF THEM 28 -> DONE :)!!!!!!!!!!!!!!!!##    
    #load zeroth valid move from dmem100
    lw $10 100($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem101
    lw $10 101($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    lw $10 102($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem103
    lw $10 103($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem104
    lw $10 104($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem105
    lw $10 105($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem106
    lw $10 106($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem107
    lw $10 107($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem108
    lw $10 108($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem109
    lw $10 109($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem110
    lw $10 110($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem111
    lw $10 111($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem112
    lw $10 112($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem113
    lw $10 113($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem114
    lw $10 114($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem115
    lw $10 115($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem116
    lw $10 116($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem117
    lw $10 117($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem118
    lw $10 118($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem119
    lw $10 119($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem120
    lw $10 120($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem121
    lw $10 121($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem122
    lw $10 122($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem123
    lw $10 123($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem124
    lw $10 124($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem125
    lw $10 125($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem126
    lw $10 126($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid

    #load zeroth valid move from dmem127
    lw $10 127($0)
    #compare valid move (y, x) to the dest of playermove (input_2)
    bne $10, $2, 1
    j handle_valid
    
    #...
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
    and $17, $10, $12
    # parse lsb y and shift lsb y to line up with lsb x
    and $18, $10, $13
    sra $18, $18, 3
    
    sub $19, $17, $18
    #if $19 == 0, same polarity, black square
    bne $19, $0, 2
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
    addi $2, $0, 0
    addi $3, $0, 0
    addi $4, $0, 0
    addi $5, $0, 0
    addi $6, $0, 0
    addi $7, $0, 0
    addi $8, $0, 0
    addi $9, $0, 0
    addi $10, $0, 0
    addi $11, $0, 0
    addi $12, $0, 0
    addi $13, $0, 0
    addi $14, $0, 0
    addi $15, $0, 0
    addi $16, $0, 0
    addi $17, $0, 0
    addi $18, $0, 0
    addi $19, $0, 0
    addi $20, $0, 0
    addi $21, $0, 0
    addi $22, $0, 0
    addi $23, $0, 0
    addi $24, $0, 0
    addi $25, $0, 0
    addi $26, $0, 0
    addi $27, $0, 0
    addi $28, $0, 0
    addi $29, $0, 0
    addi $30, $0, 0
    
    #reset 64 and 65 to be invalid
    addi $10, $0, -1
    sw $10, 64($0)
    sw $10, 65($0)
    
    #wipe 100-131
    addi $10, $0, -1
    sw $10, 100($0)
    sw $10, 101($0)
    sw $10, 102($0)
    sw $10, 103($0)
    sw $10, 104($0)
    sw $10, 105($0)
    sw $10, 106($0)
    sw $10, 107($0)
    sw $10, 108($0)
    sw $10, 109($0)
    sw $10, 110($0)
    sw $10, 111($0)
    sw $10, 112($0)
    sw $10, 113($0)
    sw $10, 114($0)
    sw $10, 115($0)
    sw $10, 116($0)
    sw $10, 117($0)
    sw $10, 118($0)
    sw $10, 119($0)
    sw $10, 120($0)
    sw $10, 121($0)
    sw $10, 122($0)
    sw $10, 123($0)
    sw $10, 124($0)
    sw $10, 125($0)
    sw $10, 126($0)
    sw $10, 127($0)
    sw $10, 128($0)
    sw $10, 129($0)
    sw $10, 130($0)
    sw $10, 131($0)
    
    j 0
    
handle_valid:
    sw $3, 0($2)
    sw $0, 0($1)
    
    #...
    ### flip the turn
    # get the current color -> $11
    addi $10, $0, 1
    and $11, $10, $30
    sub $30, $30, $11 # subtract current color
    # if the curr color is white (0), make the next color black (1)
    bne $11, $0, 1
    addi $30, $30, $10 # add 1 to $30 to make it black
    # else make the next color white (0)
    #$30's color already has been subtracted, so by default its now white

    ##### commented out for now, test pieces first
    # add stuff with checking win conditions, etc.....
    # startLoopCheckWin writes to $12 for a win, 0=no win, 1=win
    addi $12, $0, 1 # default to a win
    addi $10, $0, 0 # address iterator $10 starts at 0
    jal startLoopCheckWin # writes $12 to 0 if opponent's king is found!
    addi $11, $0, 1
    bne $12, $11, 1
    # get this to display on the screen by writing to $30! this gets written to dmem in the next block of code
    jal markWin # this writes win status to register 30

    sw $30, 66($0) 
    #####
    j restoreColors

markWin:
    addi $10, $0, 2 # win status mask
    and $11, $10, $30 # store current win status in $11
    sub $30, $30, $11 # subtract those status bits
    addi $30, $30, 2 # mark the status bits as win 0000...1x
    jr $31

startLoopCheckWin:
    # dedicated scratch register 12 within this scope! write the win status to $12, default is 1, so only write 0 if no win
    addi $11, $0, 64
    bne $10, $11, 1
    j endLoopCheckWin
    # get opponent's color -> $13
    addi $11, $0, 1 # color mask
    and $13, $30, $11
    
    # get cell data at $10 -> store in $14
    lw $14, 0($10)

    # get piece info from cell data -> $15
    addi $11, $0, 14
    and $15, $11, $14
    # get color info from cell data -> $16
    addi $11, $0, 1
    and $16, $11, $14
    # if piece == king and color == opponent's color, set $12 = 0
    addi $11, $0, 2 #010 = king. 
    bne $15, $11, 3 #WARNING: bigger jump # of instrs dependent. If piece is not a king, go back to start of loop 
    bne $16, $13, 2 # if color is not equal to opponents color, go back to start of loop
    addi $12, $0, 0 # write 0 to $12
    j endLoopCheckWin
    addi $10, $10, 1 # i = i + 1
    j startLoopCheckWin

endLoopCbeckWin:
    jr $31

# -----------------------------------------------
# -----------------------------------------------
# #lw 
# #$4, 0($2)

# #bne $1,  2
# #addi $29, $0, 1
# bne $0, $29, 1
# addi $29, $0, 0

# bne $1, cond2 2
# addi $28, $0, 1
# bne $0, $28, 1
# addi $28, $0, 0

# and $res, $28, $29
# bne $res, don't do res
# do res

# # do stuff
# bne $1, cond1, #63
# j move
# j 0
# bne $1, cond2, #65
# j move
# j 0
# bne $2, cond3, #2
# j move
# j 0

# #check #2
# #if (cond1 && cond2):
# bne $1, cond1, #70
# bne $1, cond2, #70
# j move


# #if input1:
#     if input2:
#            eval move
#       else: 
#           print green moves
# #else:
# #    go back to top of loop

# #if input2:
#     eval move
   


# return:
# j 0
# ##################GAME BIG LOOP ENDS HERE##########################

# # possible functions
# j move
# j 0 # jump back to the beginning of the loop
# j findPieceAtPos
# j 0 # jump back to the beginning of the loop
# j move
# j 0 # jump back to the beginning of the loop






# move:
#     # inputs:
#     #   currCellData (32 bits), startPos (6 bit number), endPos (6 bit number)
#     # outputs:
#     # task:
#     # overwriting dest cell data with curr cell data, checking to see if we took a king by lwing the dest pos
#     # then restoreColors
#     # display win if necessary


# findPieceAtPos:
#     # inputs:
#     #   currColor, x, y
#     # task:
#     #   looks through 32 addresses in dmem to look for a piece at x,y that belongs to currColor
#     # outputs:
#     #   write these valid moves to each piece square background colors to indicate valid moves
#     #   write 28 32-bit writes to dmem. 000...dest_loc if valid move. Else its going to be all 1's (-1).

# checkWin:
#     # inputs:
#     #   none
#     # outputs:
#     #   0 == 0, 1, or -1. 0 indicates nobody winning, 1 indicates white wins, -1 indicates black wins

# getPiece:
#     # input:
#     #   2 32 bit numbers (really 3 bit) -> x, y coords
#     # outputs:
#     #   the 32 bit piece from dmem

# restoreColors:
#     # input: no input, but make sure to loop through 0-63 in dmem
#     # outputs: none, but write to dmem

# findMovesForPiece:
#     # inputs:
#     #   32 bit piece
#     # outputs:
#     #   0-27 == store up to 28 possible moves into memory, storing nulls for the moves that aren't possible

