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
	
	

reg [11:0] dmemAddress, dmemAddressX, dmemAddressY;
assign chess_address = dmemAddress;


reg [5:0] colorSelector;
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
					24'hF5A442; //light blue background
					

wire [31:0] dmemData;
assign dmemData = chess_data;
wire [2:0] pieceType;
wire [3:0] squareColor;
wire pieceColor;
wire playerTurn;
assign pieceType = dmemData[3:1];
assign squareColor = dmemData[7:4];
assign pieceColor = dmemData[0];
assign playerTurn = pieceColor;

always@(posedge iVGA_CLK) //clocking
begin
	if (addressX >= 64 & addressX <= 576 & addressY >= 64 && addressY < 576) begin
		//figure out which address in dmem this corresponds to and extract the piece info/square color
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
		else	if (squareColor[3]) begin //black
			colorSelector = 0;
		end
		else if (squareColor[2]) begin  //white
			colorSelector = 1;
		end
		else if (squareColor[1]) begin  //red
			colorSelector = 2;
		end
		else if (squareColor[0]) begin  //green
			colorSelector = 3;
		end
		else begin
			colorSelector = 3;
		end
	end
	//whose turn square color display
	else if (addressX >= 138 & addressX <= 182 & addressY >= 586 && addressY < 630) begin
		dmemAddress = 12'd66;
		if(playerTurn == 1'b0) begin
			colorSelector = 17;
		end
		else begin
			colorSelector = 18;
		end
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
 	















