module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
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
//assign VGA_CLK_n = ~iVGA_CLK;
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
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
*/

reg [10:0] imgAddressX, imgAddressY;
wire [10:0] imgADDR;
assign imgADDR = imgAddressY*8 + imgAddressX;
wire [7:0] index_wr;
wire [23:0] bgr_data_raw_wr;
//possible color indexes
white_rook_data	white_rook_data_inst (
	.address ( imgADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index_wr )
	);

//possible color tables
//chess pieces
white_rook_index	white_rook_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_wr)
	);	
	
wire [10:0] addressX, addressY;

assign addressX = ADDR % 640;
assign addressY = ADDR / 640;

reg [11:0] dmemAddress, dmemAddressX, dmemAddressY;

reg [23:0] bgr_data_square_color;

wire [31:0] dmemData;
wire [2:0] pieceType;
wire [3:0] squareColor;
wire pieceColor;

assign pieceType = dmemData[3:1];
assign squareColor = dmemData[7:4];
assign pieceColor = dmemData[0];

always@(posedge iVGA_CLK) //clocking
begin
	if (addressX >= 64 & addressX <= 576 & addressY >= 64 && addressY <= 576) begin
		//inside the bounds of the chessboard
		imgAddressX = addressX % 64;
		imgAddressY = addressY % 64;
		
		//figure out which address in dmem this corresponds to and extract the piece info/square color
		dmemAddressX = (addressX - d64) >> 6; //(x-64)/64
		dmemAddressY = 7 - ((addressY - 64) >> 6);
		dmemAddress = {0, 0, 0, 0, 0, 0, 
							dmemAddressY[2], dmemAddressY[1], dmemAddressY[0], 
							dmemAddressX[2], dmemAddressX[1], dmemAddressX[0]};
		
		//figure out the square color
		if (squareColor[3]) begin //black
			bgr_data_square_color = 23'h000000;
		end
		else if (squareColor[2]) begin  //white
			bgr_data_square_color = 23'hEDD5D0;
		end
		else if (squareColor[1]) begin  //red
			bgr_data_square_color = 23'hEF330B;
		end
		else if (squareColor[0]) begin  //green
			bgr_data_square_color = 23'h41B963;
		end
		
		
		//figure out if the piece is equal to -1 (no piece) or not and display pieces based on that
		if ( pieceType == -1 || bgr_data_raw_wr == 23'h080808) begin
			bgr_data_raw = bgr_data_square_color;
		end
		//depending on what piece it is, take a specific index
		else begin
			bgr_data_raw = bgr_data_rw_wr;
		end
	end
	else begin
		bgr_data_raw = 23'h555555;
		//don't display anything, outside the bounds of the chessboard
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
 	















