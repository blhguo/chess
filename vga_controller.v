module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data, 
							 chess_address,
							 chess_data);

	
input iRST_n;
input iVGA_CLK;
input [31:0] chess_data;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;      
output [11:0] chess_address;                
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
//img_data	img_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( index )
//	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
//img_index	img_index_inst (
//	.address ( index ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_raw)
//	);	
//////


/*
START OF CHESS IMAGES
*/



/*
ADDRESS WIRES
*/
wire [11:0] addressX, addressY;
assign addressX = ADDR % 640;
assign addressY = ADDR / 480;

wire [11:0] imgAddressX, imgAddressY;
assign imgAddressX = addressX % 64;
assign imgAddressY = addressY % 64;
wire [11:0] imgADDR;
assign imgADDR = imgAddressY*64 + imgAddressX;

wire [7:0] index_wkn,
				index_wki,
				index_wq,
				index_wb,
				index_wr,
				index_wp,
				index_bkn,
				index_bki,
				index_bq,
				index_bb,
				index_br,
				index_bp;
wire [23:0] bgr_data_raw_wkn,
				bgr_data_raw_wki,
				bgr_data_raw_wq,
				bgr_data_raw_wb,
				bgr_data_raw_wr,
				bgr_data_raw_wp,
				bgr_data_raw_bkn,
				bgr_data_raw_bki,
				bgr_data_raw_bq,
				bgr_data_raw_bb,
				bgr_data_raw_br,
				bgr_data_raw_bp;
/*
POSSIBLE COLOR INDEXES HERE
*/
	//white pieces
white_rook_data	white_rook_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wr )
	);
white_knight_data	white_knight_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wkn )
	);
white_king_data	white_king_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wki )
	);
white_queen_data	white_queen_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wq )
	);
white_bishop_data	white_bishop_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wb )
	);
white_pawn_data	white_pawn_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wp )
	);

	//black pieces
black_rook_data	black_rook_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_br )
	);
black_knight_data	black_knight_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bkn )
	);
black_king_data	black_king_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bki )
	);
black_queen_data	black_queen_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bq )
	);
black_bishop_data	black_bishop_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bb )
	);
black_pawn_data	black_pawn_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bp )
	);

	
/*
POSSIBLE COLOR TABLES HERE
*/
//chess pieces
	//white pieces
white_rook_index	white_rook_index_inst (
	.address ( index_wr ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wr)
	);	
white_knight_index	white_knight_index_inst (
	.address ( index_wkn ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wkn)
	);	
white_king_index	white_king_index_inst (
	.address ( index_wki ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wki)
	);	
white_queen_index	white_queen_index_inst (
	.address ( index_wq ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wq)
	);	
white_bishop_index	white_bishop_index_inst (
	.address ( index_wb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wb)
	);	
white_pawn_index	white_pawn_index_inst (
	.address ( index_wp ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wp)
	);	
	//black pieces
black_rook_index	black_rook_index_inst (
	.address ( index_br ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_br)
	);	
black_knight_index	black_knight_index_inst (
	.address ( index_bkn ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_bkn)
	);	
black_king_index	black_king_index_inst (
	.address ( index_bki ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_bki)
	);	
black_queen_index	black_queen_index_inst (
	.address ( index_bq ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_bq)
	);	
black_bishop_index	black_bishop_index_inst (
	.address ( index_bb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_bb)
	);	
black_pawn_index	black_pawn_index_inst (
	.address ( index_bp ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_bp)
	);	
	
	
wire [11:0] letterAddressX, letterAddressY;
assign letterAddressX = (addressX - 16) % 32;
assign letterAddressY = (addressY - 16) % 32;
wire [11:0] letterADDR;
assign letterADDR = letterAddressY*32 + letterAddressX;

wire [7:0] index_a,
				index_b,
				index_c,
				index_d,
				index_e,
				index_f,
				index_g,
				index_h,
				index_1,
				index_2,
				index_3,
				index_4,
				index_5,
				index_6,
				index_7,
				index_8;
wire [23:0] bgr_data_raw_a,
				bgr_data_raw_b,
				bgr_data_raw_c,
				bgr_data_raw_d,
				bgr_data_raw_e,
				bgr_data_raw_f,
				bgr_data_raw_g,
				bgr_data_raw_h,
				bgr_data_raw_1,
				bgr_data_raw_2,
				bgr_data_raw_3,
				bgr_data_raw_4,
				bgr_data_raw_5,
				bgr_data_raw_6,
				bgr_data_raw_7,
				bgr_data_raw_8;
/*
POSSIBLE COLOR INDEXES HERE
*/
//letters
letter_a_data	letter_a_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_a )
	);
letter_a_index	letter_a_index_inst (
	.address ( index_a ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_a)
	);	
letter_b_data	letter_b_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_b )
	);
letter_b_index	letter_b_index_inst (
	.address ( index_b ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_b)
	);	
letter_c_data	letter_c_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_c )
	);
letter_c_index	letter_c_index_inst (
	.address ( index_c ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_c)
	);	
letter_d_data	letter_d_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_d )
	);
letter_d_index	letter_d_index_inst (
	.address ( index_d ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_d)
	);	
letter_e_data	letter_e_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_e )
	);
letter_e_index	letter_e_index_inst (
	.address ( index_e ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_e)
	);	
letter_f_data	letter_f_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_f )
	);
letter_f_index	letter_f_index_inst (
	.address ( index_f ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_f)
	);	
letter_g_data	letter_g_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_g )
	);
letter_g_index	letter_g_index_inst (
	.address ( index_g ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_g)
	);	
letter_h_data	letter_h_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_h )
	);
letter_h_index	letter_h_index_inst (
	.address ( index_h ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_h)
	);	
//numbers
number_1_data	number_1_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_1 )
	);
number_1_index	number_1_index_inst (
	.address ( index_1 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_1)
	);	
number_2_data	number_2_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_2 )
	);
number_2_index	number_2_index_inst (
	.address ( index_2 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_2)
	);	
number_3_data	number_3_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_3 )
	);
number_3_index	number_3_index_inst (
	.address ( index_3 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_3)
	);	
number_4_data	number_4_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_4 )
	);
number_4_index	number_4_index_inst (
	.address ( index_4 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_4)
	);	
number_5_data	number_5_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_5 )
	);
number_5_index	number_5_index_inst (
	.address ( index_5 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_5)
	);	
number_6_data	number_6_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_6 )
	);
number_6_index	number_6_index_inst (
	.address ( index_6 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_6)
	);	
number_7_data	number_7_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_7 )
	);
number_7_index	number_7_index_inst (
	.address ( index_7 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_7)
	);	
number_8_data	number_8_data_inst (
	.address ( letterADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_8 )
	);
number_8_index	number_8_index_inst (
	.address ( index_8 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_8)
	);	

	
wire [11:0] turnAddressX, turnAddressY;
assign turnAddressX = addressX  % 64;
assign turnAddressY = addressY  % 64;
wire [11:0] turnADDR;
assign turnADDR = turnAddressY*64 + turnAddressX;

wire [7:0] index_turn;
wire [23:0] bgr_data_raw_turn;
//turn image
turn_data	turn_data_inst (
	.address ( turnADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_turn )
	);
turn_index	turn_index_inst (
	.address ( index_turn ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_turn)
	);	
	
//win image
wire [14:0] winAddressX, winAddressY;
assign winAddressX = (addressX - 192) % 256;
assign winAddressY = addressY  % 128;
wire [14:0] winADDR;
assign winADDR = winAddressY*256 + winAddressX;

wire [7:0] index_wwins;
wire [23:0] bgr_data_raw_wwins;
wire [7:0] index_bwins;
wire [23:0] bgr_data_raw_bwins;
white_wins_data	white_wins_data_inst (
	.address ( winADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wwins )
	);
white_wins_index	white_wins_index_inst (
	.address ( index_wwins ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wwins)
	);	
black_wins_data	black_wins_data_inst (
	.address ( winADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_bwins )
	);
black_wins_index	black_wins_index_inst (
	.address ( index_bwins ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_bwins)
	);	

//game mode images
wire [11:0] gameModeAddressX, gameModeAddressY;
assign gameModeAddressX = (addressX - 448) % 128;
assign gameModeAddressY = (addressY - 16) % 32;
wire [11:0] gameModeADDR;
assign gameModeADDR = gameModeAddressY*128 + gameModeAddressX;

wire [7:0] index_cchess;
wire [23:0] bgr_data_raw_cchess;
wire [7:0] index_koh;
wire [23:0] bgr_data_raw_koh;
cchess_data	cchess_data_inst (
	.address ( gameModeADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_cchess )
	);
cchess_index	cchess_index_inst (
	.address ( index_cchess ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_cchess)
	);	
koh_data	koh_data_inst (
	.address ( gameModeADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_koh )
	);
koh_index	koh_index_inst (
	.address ( index_koh ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_koh)
	);	

//instructions image
wire [13:0] instrAddressX, instrAddressY;
assign instrAddressX = (addressX - 592) % 32;
assign instrAddressY = (addressY - 128) % 384;
wire [13:0] instrADDR;
assign instrADDR = instrAddressY*32 + instrAddressX;

wire [7:0] index_instr;
wire [23:0] bgr_data_raw_instr;
instructions_data	instructions_data_inst (
	.address ( instrADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_instr )
	);
instructions_index	instructions_index_inst (
	.address ( index_instr ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_instr)
	);	

reg [11:0] dmemAddress, dmemAddressX, dmemAddressY;
assign chess_address = dmemAddress;


reg [6:0] colorSelector;
assign bgr_data_raw = colorSelector == 0 ? 24'h446999 : //dark brown like simran
					colorSelector == 1 ? 24'hCDE1F7 : //light brown like not simran
					colorSelector == 2 ? 24'hEF330B : //red
					colorSelector == 3 ? 24'h41B963 : //green
					colorSelector == 4 ? bgr_data_raw_wkn : //white knight
					colorSelector == 5 ? bgr_data_raw_wki : //white king
					colorSelector == 6 ? bgr_data_raw_wq : //white queen
					colorSelector == 7 ? bgr_data_raw_wb : //white bishop
					colorSelector == 8 ? bgr_data_raw_wr : //white rook
					colorSelector == 9 ? bgr_data_raw_wp : //white pawn
					colorSelector == 10 ? bgr_data_raw_bkn : //black knight
					colorSelector == 11 ? bgr_data_raw_bki : //black king
					colorSelector == 12 ? bgr_data_raw_bq : //black queen
					colorSelector == 13 ? bgr_data_raw_bb : //black bishop
					colorSelector == 14 ? bgr_data_raw_br : //black rook
					colorSelector == 15 ? bgr_data_raw_bp : //black pawn
					colorSelector == 16 ? 24'hF5A442 : //light blue background
					colorSelector == 17 ? 24'hFFFFFF : //white's turn background color square
					colorSelector == 18 ? 24'h000000 : //black's turn background color square
					colorSelector == 19 ? bgr_data_raw_a: //letter a
					colorSelector == 20 ? bgr_data_raw_b: //letter b
					colorSelector == 21 ? bgr_data_raw_c: //letter c
					colorSelector == 22 ? bgr_data_raw_d: //letter d
					colorSelector == 23 ? bgr_data_raw_e: //letter e
					colorSelector == 24 ? bgr_data_raw_f: //letter f
					colorSelector == 25 ? bgr_data_raw_g: //letter g
					colorSelector == 26 ? bgr_data_raw_h: //letter h
					colorSelector == 27 ? bgr_data_raw_8: //letter 8
					colorSelector == 28 ? bgr_data_raw_7: //letter 7
					colorSelector == 29 ? bgr_data_raw_6: //letter 6
					colorSelector == 30 ? bgr_data_raw_5: //letter 5
					colorSelector == 31 ? bgr_data_raw_4: //letter 4
					colorSelector == 32 ? bgr_data_raw_3: //letter 3
					colorSelector == 33 ? bgr_data_raw_2: //letter 2
					colorSelector == 34 ? bgr_data_raw_1: //letter 1
					colorSelector == 35 ? bgr_data_raw_turn: //turn:
					colorSelector == 36 ? bgr_data_raw_wwins: //white wins!
					colorSelector == 37 ? bgr_data_raw_bwins: //black wins!
					colorSelector == 38 ? 24'h0091DA: //hazel background
					colorSelector == 39 ? bgr_data_raw_instr: //instructions
					colorSelector == 40 ? bgr_data_raw_cchess: //classic chess mode
					colorSelector == 41 ? bgr_data_raw_koh: //koh mode
					24'hF5A442; //light blue background
					

wire [31:0] dmemData;
assign dmemData = chess_data;
wire [2:0] pieceType;
wire [3:0] squareColor;
wire pieceColor;
wire playerTurn;
wire playerWin;
wire is_KingHill;
wire whoWin;
assign pieceType = dmemData[3:1];
assign squareColor = dmemData[7:4];
assign pieceColor = dmemData[0];
assign playerTurn = pieceColor;
assign playerWin = dmemData[1];
assign is_KingHill = dmemData[2];
assign whoWin = dmemData[3];

always@(posedge iVGA_CLK) //clocking
begin
	if (addressX >= 64 && addressX <= 576 && addressY >= 64 && addressY < 576) begin
		if (addressX >= 192 & addressX <= 448 && addressY >= 256 && addressY < 384) begin
			if (addressX == 192 ) begin
				dmemAddress = 12'd66;
			end
	//			else begin
	//				dmemAddressX = (addressX - 64) >> 6; //(x-64)/64
	//				dmemAddressY = 7 - ((addressY - 64) >> 6);
	//				dmemAddress = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
	//								dmemAddressY[2], dmemAddressY[1], dmemAddressY[0], 
	//								dmemAddressX[2], dmemAddressX[1], dmemAddressX[0]};
	//			end
			
			if (playerWin && dmemAddress == 12'd66) begin
				dmemAddress = 12'd66; //status address, see what color
//				if(playerTurn == 1'b1) begin //new turn is black, so winner was white
//					colorSelector = whoWin ? 37 : 36;
//				end
//				else begin //new turn is white, so winner was black
//					colorSelector = is_KingHill ? 36 : 37;
//				end
				colorSelector = whoWin ? 37 : 36;
			end
			else if (addressX != 192) begin
				dmemAddressX = (addressX - 64) >> 6; //(x-64)/64
				dmemAddressY = 7 - ((addressY - 64) >> 6);
				dmemAddress = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
								dmemAddressY[2], dmemAddressY[1], dmemAddressY[0], 
								dmemAddressX[2], dmemAddressX[1], dmemAddressX[0]};
				//display pieces based on dmem data
				//white pieces
				if ( pieceType == 1 && pieceColor == 0 && index_wkn != 0) begin
					colorSelector = 4;
				end
				else if ( pieceType == 2 && pieceColor == 0 && index_wki != 0) begin
					colorSelector = 5;
				end
				else if ( pieceType == 3 && pieceColor == 0 && index_wq != 0) begin
					colorSelector = 6;
				end
				else if ( pieceType == 4 && pieceColor == 0 && index_wb != 0) begin
					colorSelector = 7;
				end
				else if ( pieceType == 5 && pieceColor == 0 && index_wr != 0) begin
					colorSelector = 8;
				end
				else if ( pieceType == 6 && pieceColor == 0 && index_wp != 0) begin
					colorSelector = 9;
				end
				
				//black pieces
				else if ( pieceType == 1 && pieceColor == 1 && index_bkn != 0) begin
					colorSelector = 10;
				end
				else if ( pieceType == 2 && pieceColor == 1 && index_bki != 0) begin
					colorSelector = 11;
				end
				else if ( pieceType == 3 && pieceColor == 1 && index_bq != 0) begin
					colorSelector = 12;
				end
				else if ( pieceType == 4 && pieceColor == 1 && index_bb != 0) begin
					colorSelector = 13;
				end
				else if ( pieceType == 5 && pieceColor == 1 && index_br != 0) begin
					colorSelector = 14;
				end
				else if ( pieceType == 6 && pieceColor == 1 && index_bp != 0) begin
					colorSelector = 15;
				end
				//figure out the square color
				else	if (squareColor == 4'b1000) begin //black
					colorSelector = 0;
				end
				else if (squareColor == 4'b0100) begin  //white
					colorSelector = 1;
				end
				else if (squareColor == 4'b0010) begin  //red
					colorSelector = 2;
				end
				else if (squareColor == 4'b0001) begin  //green
					colorSelector = 3;
				end
				else if (squareColor == 4'b0011) begin  //hazel
					colorSelector = 38;
				end
			end
		end
		
	
		//figure out which address in dmem this corresponds to and extract the piece info/square color
		else begin
			dmemAddressX = (addressX - 64) >> 6; //(x-64)/64
			dmemAddressY = 7 - ((addressY - 64) >> 6);
			dmemAddress = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
								dmemAddressY[2], dmemAddressY[1], dmemAddressY[0], 
								dmemAddressX[2], dmemAddressX[1], dmemAddressX[0]};
		
		
			//display pieces based on dmem data
			//white pieces
			if ( pieceType == 1 && pieceColor == 0 && index_wkn != 0) begin
				colorSelector = 4;
			end
			else if ( pieceType == 2 && pieceColor == 0 && index_wki != 0) begin
				colorSelector = 5;
			end
			else if ( pieceType == 3 && pieceColor == 0 && index_wq != 0) begin
				colorSelector = 6;
			end
			else if ( pieceType == 4 && pieceColor == 0 && index_wb != 0) begin
				colorSelector = 7;
			end
			else if ( pieceType == 5 && pieceColor == 0 && index_wr != 0) begin
				colorSelector = 8;
			end
			else if ( pieceType == 6 && pieceColor == 0 && index_wp != 0) begin
				colorSelector = 9;
			end
			
			//black pieces
			else if ( pieceType == 1 && pieceColor == 1 && index_bkn != 0) begin
				colorSelector = 10;
			end
			else if ( pieceType == 2 && pieceColor == 1 && index_bki != 0) begin
				colorSelector = 11;
			end
			else if ( pieceType == 3 && pieceColor == 1 && index_bq != 0) begin
				colorSelector = 12;
			end
			else if ( pieceType == 4 && pieceColor == 1 && index_bb != 0) begin
				colorSelector = 13;
			end
			else if ( pieceType == 5 && pieceColor == 1 && index_br != 0) begin
				colorSelector = 14;
			end
			else if ( pieceType == 6 && pieceColor == 1 && index_bp != 0) begin
				colorSelector = 15;
			end
			//figure out the square color
			else	if (squareColor == 4'b1000) begin //black
				colorSelector = 0;
			end
			else if (squareColor == 4'b0100) begin  //white
				colorSelector = 1;
			end
			else if (squareColor == 4'b0010) begin  //red
				colorSelector = 2;
			end
			else if (squareColor == 4'b0001) begin  //green
				colorSelector = 3;
			end
			else if (squareColor == 4'b0011) begin  //hazel
				colorSelector = 38;
			end
		end
	end
	//instructions display
	else if(addressX >= 592 && addressX <= 624 && addressY >= 128 && addressY < 512 && index_instr != 0) begin
		colorSelector = 39;
	end
	//possible modes: classic chess and king of the hill
	//instructions display
	else if(addressX >= 448 && addressX <= 576 && addressY >= 16 && addressY < 48) begin
		dmemAddress = 12'd66;
		if(~is_KingHill && index_cchess != 0) begin
			colorSelector = 40;
		end
		else if(is_KingHill && index_koh != 0) begin
			colorSelector = 41
		end
		else begin
			colorSelector = 16;
		end
	end
	//whose turn square color display
	else if (addressX >= 138 & addressX <= 182 & addressY >= 10 && addressY < 54) begin
		dmemAddress = 12'd66;
		if(playerTurn == 1'b0) begin
			colorSelector = 17;
		end
		else begin
			colorSelector = 18;
		end
	end
	//letters
	else if (addressX >= 80 & addressX <= 112 & addressY >= 592 && addressY < 624 && index_a != 0) begin
		colorSelector = 19;
	end
	else if (addressX >= 144 & addressX <= 176 & addressY >= 592 && addressY < 624 && index_b != 0) begin
		colorSelector = 20;
	end
	else if (addressX >= 208 & addressX <= 240 & addressY >= 592 && addressY < 624 && index_c != 0) begin
		colorSelector = 21;
	end
	else if (addressX >= 272 & addressX <= 304 & addressY >= 592 && addressY < 624 && index_d != 0) begin
		colorSelector = 22;
	end
	else if (addressX >= 336 & addressX <= 368 & addressY >= 592 && addressY < 624 && index_e != 0) begin
		colorSelector = 23;
	end
	else if (addressX >= 400 & addressX <= 432 & addressY >= 592 && addressY < 624 && index_f != 0) begin
		colorSelector = 24;
	end
	else if (addressX >= 464 & addressX <= 496 & addressY >= 592 && addressY < 624 && index_g != 0) begin
		colorSelector = 25;
	end
	else if (addressX >= 528 & addressX <= 560 & addressY >= 592 && addressY < 624 && index_h != 0) begin
		colorSelector = 26;
	end
	//numbers
	else if (addressY >= 80 & addressY <= 112 & addressX >= 16 && addressX < 48 && index_8 != 0) begin
		colorSelector = 27;
	end
	else if (addressY >= 144 & addressY <= 176 & addressX >= 16 && addressX < 48 && index_7 != 0) begin
		colorSelector = 28;
	end
	else if (addressY >= 208 & addressY <= 240 & addressX >= 16 && addressX < 48 && index_6 != 0) begin
		colorSelector = 29;
	end
	else if (addressY >= 272 & addressY <= 304 & addressX >= 16 && addressX < 48 && index_5 != 0) begin
		colorSelector = 30;
	end
	else if (addressY >= 336 & addressY <= 368 & addressX >= 16 && addressX < 48 && index_4 != 0) begin
		colorSelector = 31;
	end
	else if (addressY >= 400 & addressY <= 432 & addressX >= 16 && addressX < 48 && index_3 != 0) begin
		colorSelector = 32;
	end
	else if (addressY >= 464 & addressY <= 496 & addressX >= 16 && addressX < 48 && index_2 != 0) begin
		colorSelector = 33;
	end
	else if (addressY >= 528 & addressY <= 560 & addressX >= 16 && addressX < 48 && index_1 != 0) begin
		colorSelector = 34;
	end
	//turn
	else if (addressY >= 0 & addressY <= 64 & addressX >= 64 && addressX < 128 && index_turn != 0) begin
		colorSelector = 35;
	end
	else begin
		//don't display anything, outside the bounds of the chessboard
		colorSelector = 16;
	end
	
end


/*
END OF CHESS IMAGES
*/


//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















