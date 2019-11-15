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
