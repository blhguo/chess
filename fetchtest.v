module fetchtest(pc_out_word, imem_out, pc_in_overwrite, pc_in_overwrite_data, enable, clock, clr);


	input enable, clock, clr;
	
	input pc_in_overwrite;
	input [31:0] pc_in_overwrite_data;
	output [31:0] pc_out_word;
	output [31:0] imem_out;
	
	fetch myfetch(pc_out_word, imem_out, pc_in_overwrite, pc_out_word, pc_in_overwrite_data, enable, clock, clr);
	
endmodule