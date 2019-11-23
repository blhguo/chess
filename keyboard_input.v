module keyboard_input(clock, reset, ps2_key_data, ps2_key_pressed, ps2_out, 
keyboard_we, keyboard_write_data, keyboard_write_address);
	input clock, reset; //global reset???
	
	input	[7:0]	 ps2_key_data;
	input			 ps2_key_pressed;
	input	[7:0]	 ps2_out;

	output keyboard_we;
	output [31:0] keyboard_write_data;
	output [11:0] keyboard_write_address;
	
	assign keyboard_write_address = receivingInput2 ? 12'd65 : 12'd64;
	assign keyboard_we = last_input_letter != 8'b0 && last_input_number != 8'b0;
	//END OF INPUTS AND OUTPUTS
	
	wire key_just_released;//check if this works? interchange between ps2_key_out and ps2_key_data depending on what works
	assign key_just_released = ps2_out == 8'hF0;
	
	wire reg_reset;
	assign reg_reset = (last_input_letter != 8'b0 && last_input_number != 8'b0) || reset;
	
	reg receivingInput2;
	
	reg [7:0] last_input_letter;
	reg [7:0] last_input_number;
	
	wire [2:0] keyboard_letter_conv;
	assign keyboard_letter_conv = last_input_letter == 8'h1C ? 3'd0
											: last_input_letter == 8'h32 ? 3'd1
											: last_input_letter == 8'h21 ? 3'd2
											: last_input_letter == 8'h23 ? 3'd3
											: last_input_letter == 8'h24 ? 3'd4
											: last_input_letter == 8'h2B ? 3'd5
											: last_input_letter == 8'h34 ? 3'd6
											: last_input_letter == 8'h33 ? 3'd7
											: 3'd0;
	wire [2:0] keyboard_number_conv;
	assign keyboard_number_conv = last_input_number == 8'h16 ? 3'd0
											: last_input_number == 8'h1E ? 3'd1
											: last_input_number == 8'h26 ? 3'd2
											: last_input_number == 8'h25 ? 3'd3
											: last_input_number == 8'h2E ? 3'd4
											: last_input_number == 8'h36 ? 3'd5
											: last_input_number == 8'h3D ? 3'd6
											: last_input_number == 8'h3E ? 3'd7
											: 3'd0;
	assign keyboard_write_data = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
											1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0,
											keyboard_number_conv[2], keyboard_number_conv[1], keyboard_number_conv[0],
											keyboard_letter_conv[2], keyboard_letter_conv[1], keyboard_letter_conv[0]};

	always @(posedge clock)
	begin
		if (reg_reset == 1'b1) begin
			last_input_letter <= 8'h00;
			last_input_number <= 8'h00;
		end
		else if (ps2_key_pressed == 1'b1) begin
			if (ps2_key_data == 8'h6B) begin//left arrow
				receivingInput2 <= 1'b0;
				last_input_letter <= 8'h00;
				last_input_number <= 8'h00;
			end
			else if(ps2_key_data == 8'h74) begin//right arrow
				receivingInput2 <= 1'b1;
				last_input_letter <= 8'h00;
				last_input_number <= 8'h00;
			end
			else if(ps2_key_data == 8'h1C//A
					|| ps2_key_data == 8'h32//B
					|| ps2_key_data == 8'h21//C
					|| ps2_key_data == 8'h23//D
					|| ps2_key_data == 8'h24//E
					|| ps2_key_data == 8'h2B//F
					|| ps2_key_data == 8'h34//G
					|| ps2_key_data == 8'h33) begin//H
				last_input_letter <= ps2_key_data;
			end
			else if(ps2_key_data == 8'h16//1
					|| ps2_key_data == 8'h1E//2
					|| ps2_key_data == 8'h26//3
					|| ps2_key_data == 8'h25//4
					|| ps2_key_data == 8'h2E//5
					|| ps2_key_data == 8'h36//6
					|| ps2_key_data == 8'h3D//7
					|| ps2_key_data == 8'h3E) begin//8)
				last_input_number <= ps2_key_data;
			end
		end
	end
	
	
	
endmodule