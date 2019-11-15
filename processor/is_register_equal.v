module is_register_equal(reg1, reg2, is_equal);
	input [4:0] reg1, reg2;
	output is_equal;
	
	wire [4:0] xor_res;
	xor comp_xor0(xor_res[0], reg1[0] ,reg2[0]);
	xor comp_xor1(xor_res[1], reg1[1] ,reg2[1]);
	xor comp_xor2(xor_res[2], reg1[2] ,reg2[2]);
	xor comp_xor3(xor_res[3], reg1[3] ,reg2[3]);
	xor comp_xor4(xor_res[4], reg1[4] ,reg2[4]);
	
	wire is_equal_tmp;
	nor res_nor(is_equal_tmp, xor_res[0], xor_res[1], xor_res[2], xor_res[3], xor_res[4]);
	
	wire is_zero;
	nor is_zero_nor(is_zero, reg1[0], reg1[1], reg1[2], reg1[3], reg1[4]);
	assign is_equal = is_zero ? 1'b0 : is_equal_tmp;
endmodule