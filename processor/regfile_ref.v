module regfile_ref(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;

	reg[31:0] registers[31:0];
	
	always @(posedge clock or posedge ctrl_reset)
	begin
		if(ctrl_reset)
			begin
				integer i;
				for(i = 0; i < 32; i = i + 1)
					begin
						registers[i] = 32'd0;
					end
			end
		else
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0)
				registers[ctrl_writeReg] = data_writeReg;
	end
	
	wire is_read_zero_A;
	nor is_read_zero_A_nor(is_read_zero_A, ctrl_readRegA[4], ctrl_readRegA[3], ctrl_readRegA[2], ctrl_readRegA[1], ctrl_readRegA[0]);
	
	wire is_read_zero_B;
	nor is_read_zero_B_nor(is_read_zero_B, ctrl_readRegB[4], ctrl_readRegB[3], ctrl_readRegB[2], ctrl_readRegB[1], ctrl_readRegB[0]);
	
	assign data_readRegA = is_read_zero_A ? 32'b0 : ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
	assign data_readRegB = is_read_zero_B ? 32'b0 : ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];
	
endmodule