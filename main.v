module main(
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B,															//	VGA Blue[9:0]
	CLOCK_50,
	ps2_clock, ps2_data,
	resetn,
	lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,
	leds, lcd_data,
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,
	DEBUG_button_clicked);  													// 50 MHz clock
		
	////////////////////////	VGA	////////////////////////////
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	input				CLOCK_50;
	
	////////////////////////	PS2	////////////////////////////
	input 			resetn;
	inout 			ps2_data, ps2_clock;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	leds, lcd_data;
	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	
	
	//###############################DEBUG############################//
	input DEBUG_button_clicked;
	
	
	//#############################KEYBOARD####################################################//
//	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	wire	[7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;	
	
	// clock divider (by 5, i.e., 10 MHz)
//	pll div(CLOCK_50,inclock);
//	assign clock_ps2 = CLOCK_50;
	
	// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
	//assign clock = inclock;
	
	// keyboard controller
	PS2_Interface myps2(CLOCK_50, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	
	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, ps2_out, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
	
	// the other seven segment displays are currently set to 0
	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
	
	
	//#######################################PROCESSOR SKELETON#################################################//
	 //clock_t, reset, instruction_output, dmem_output, rdval_writeback, regA_out, regB_out, rd_writeback
	 wire reset;
	 //TODO: Fixed to zero for now, may be mapped to some logic related to hasCommandBeenStarted
	 assign reset = 1'b0;
	 //invert the clock//
	 wire clock;
	 not inv_clock(clock, CLOCK_50);

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
	 
	 wire [11:0] chess_address;
	 wire [31:0] chess_data;
	 wire [11:0] temp_chess_addr;
	 
//	 assign temp_chess_addr = DEBUG_button_clicked ? 12'd8 : chess_address;
	 
	 
	 
	 wire temp_we;
	 
	 wire keyboard_we;
	 wire [31:0] keyboard_write_data;
	 wire [11:0] keyboard_write_address;
	 
	 wire [41:0] black_clock;
	 wire [41:0] white_clock;

	 wire winner, winnerEnable;
	 keyboard_input keyboard_wrapper(CLOCK_50,1'b0, ps2_key_data, ps2_key_pressed, ps2_out, 
			keyboard_we, keyboard_write_data, keyboard_write_address,
			chess_address, chess_data, black_clock, white_clock, winner, winnerEnable);
	 
//	 assign temp_we = chess_address == 36 && DEBUG_button_clicked ? 1'b1 : 1'b0;
//	 assign temp_we = chess_address == 36 && ps2_out == 8'h6B;
	 dmem_valid my_dmem( //a goes to process, b goes to hardware
		.address_a(address_dmem),
		.address_b(chess_address),
		.clock(~clock),
		.data_a(data),
		//need to add state, not just keyb write dat
		.data_b(keyboard_write_data),//(32'b00000000000000000000000001001001),
		.wren_a(wren),
		.wren_b(keyboard_we),
		.q_a(q_dmem),
		.q_b(chess_data));
		
		
//		wire [31:0] keyboard_write_data_temp;
//		wire [11:0] chess_address_temp;
//		assign chess_address_temp = chess_address == 12'd65 ? 12'd30 : chess_address;
//		assign keyboard_write_data_temp = chess_address == 12'd65 ? 32'b00000000000000000000000001001001 : keyboard_write_data;
		wire vga_clock_controled;
		wire [11:0] chess_address_vga;
		
//		and vga_clock_and(vga_clock_controled, CLOCK_50, ~keyboard_we);
		and vga_clock_and(vga_clock_controled, VGA_CLK, ~keyboard_we);
		assign chess_address = keyboard_we ? keyboard_write_address : chess_address_vga;
	 
//    dmem my_dmem(
//        .address    (address_dmem),       // address of data
//        .clock      (~clock),                  // may need to invert the clock
//        .data	    (data),    // data you want to write
//        .wren	    (wren),      // write enable
//        .q          (q_dmem)    // data from dmem
//    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	 
	 //////////////////////////////////////DEBUG WIRES FOR TESTBENCHES///////////////////////////
	 wire [31:0] instruction_output, dmem_output, rdval_writeback, regA_out, regB_out;
	 wire [4:0] rd_writeback;
	 
	 assign instruction_output = q_imem;
	 assign dmem_output = q_dmem;
	 assign rdval_writeback = data_writeReg;
	 assign regA_out = data_readRegA;
	 assign regB_out = data_readRegB;
	 assign rd_writeback = ctrl_writeReg;
	 
    regfile my_regfile(
        ~clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB                   // I: Data from port B of regfile
	 );
	 //##########################################END PROCESSOR SKELETON###########################################//
	
	// VGA
	Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST)	);
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins(.iRST_n(DLY_RST),
								 .iVGA_CLK(vga_clock_controled),
								 .oBLANK_n(VGA_BLANK),
								 .oHS(VGA_HS),
								 .oVS(VGA_VS),
								 .b_data(VGA_B),
								 .g_data(VGA_G),
								 .r_data(VGA_R), 
								 .chess_address(chess_address_vga),
								 .chess_data(chess_data), .winnerKB(winner), .winnerEnableKB(winnerEnable), .white_clock(white_clock), .black_clock(black_clock));
endmodule