# brainstorm:
# 32 bits to encode each piece
# info: - x, y coordinates: 0-7 => 3 bits each => 6 bits total
#       - piece type: => 6 pieces => 3 bits total
#           - knight (001)
#           - king (010)
#           - queen (011)
#           - bishop (100)
#           - rook (101)
#           - pawn (110)
#       - color: one bit total => 0 = white, 1 = black
#       - address: might as well store its address in dmem so we can refer back to it later
#           - this takes 0-31 addresses, so 5 bits
#   ex: 00000 111 111   110     0 : is a white pawn at 7,7 on the board at address 0 in dmem
#        addr   x   y   piece  color

move:
    # inputs:
    #   currPiece (32 bits), x, y
    # do some more operations



findPieceAtPos:
    # inputs:
    #   currColor, x, y
    # task: 
    #   looks through 32 addresses in dmem to look for a piece at x,y that belongs to currColor
    # outputs:
    #   32-bit piece from dmem if valid. Else its going to be all zeros.

findMovesForPiece:
    # inputs: 
    #   32 bit piece
    # outputs:
    #   0-27 == store up to 28 possible moves into memory, storing nulls for the moves that aren't possible

checkWin:
    # inputs: 
    #   none
    # outputs:
    #   0 == 0, 1, or -1. 0 indicates nobody winning, 1 indicates white wins, -1 indicates black wins

parsePiece:
    # input:
    #   32 bit piece
    # outputs:
    #   alive, piece type, color, address, x, y
