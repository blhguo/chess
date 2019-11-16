/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
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
	 /*
	output1_debug, output2_debug, output3_debug, 
	alu_input_A, alu_input_B, alu_output,
	alu_op_in_exec,
	current_program_counter, pc_in_overwrite, 
	stalling, 
	pc_in_overwrite_data, 
	is_flush
	*/
);
	 wire data_rdy;
	 //output stalling;
	 wire stalling;
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
    /* YOUR CODE STARTS HERE */
	 
	 //######################################Fetch Stage########################################################//
	 wire pc_in_overwrite;
	 wire enable, clk, clr;
	 //Enable will be whether anything at at reacts to clocks. Not write enable
	 assign enable = ~data_rdy;
	 assign clk = clock;
	 assign clr = reset;
	 wire [31:0] pc_in_data, imem_out, pc_out_word;
	 wire [31:0] pc_in_overwrite_data;
	 
	 //#################################################//
	 	 
	 assign address_imem = pc_in_data[11:0];
	 assign imem_out = q_imem;
	 
	 wire fetch_enable;
	 and fetch_enable_and(fetch_enable, enable, ~is_stall);
	 
	 fetch my_fetch_stage(pc_out_word, imem_out, pc_in_overwrite, pc_in_data, pc_in_overwrite_data, fetch_enable, clock, clr);
	 
	 //######################################Decode Stage#####################################################//
	 /* R_decode represents the data/wire being fed INTO the decode stage*/
	 wire R_decode, I_decode, JI_decode, JII_decode;
	 wire [4:0] opcode_decode, rd_decode, rs_decode, rt_decode, shiftamt_decode, aluop_decode;
	 wire [16:0] immediate_decode;
	 wire [26:0] target_decode;
	 wire [31:0] instruction;
	 	 
	 assign instruction = imem_out;
	 	 
	 instruction_decoder decode_instruction_fn(R_decode, I_decode, JI_decode, JII_decode,
						opcode_decode, rd_decode, rs_decode, rt_decode, shiftamt_decode, 
						aluop_decode, immediate_decode, target_decode, instruction);

	 wire [31:0] pc_out_execute, pc_in_decode;
	 wire [31:0] data_out_regA_execute, data_out_regB_execute;
	 wire R_execute, I_execute, JI_execute, JII_execute;
	 wire [4:0] opcode_execute, rd_execute, rs_execute, rt_execute, shiftamt_execute, aluop_execute;
	 wire [16:0] immediate_execute;
	 wire [26:0] target_execute;
	 wire [4:0] rd_writeback;
	 wire [31:0] rdval_writeback;
	 
	wire R_decode_inc_stall, I_decode_inc_stall, JI_decode_inc_stall, JII_decode_inc_stall;
	wire [4:0] opcode_decode_inc_stall, rd_decode_inc_stall, rs_decode_inc_stall, rt_decode_inc_stall, shiftamt_decode_inc_stall, aluop_decode_inc_stall;
	wire [16:0] immediate_decode_inc_stall;
	wire [26:0] target_decode_inc_stall;
	 
	 assign pc_in_decode = pc_in_data;
	 
	wire is_flush;
		
	 decode_stage my_decode_stage(
		pc_out_execute, pc_in_decode, 
		data_out_regA_execute, data_out_regB_execute,
		R_execute, I_execute, JI_execute, JII_execute, opcode_execute, rd_execute, rs_execute, rt_execute, shiftamt_execute, aluop_execute, immediate_execute, target_execute, 
		clk, fetch_enable, clr,
		R_decode_inc_stall, I_decode_inc_stall, JI_decode_inc_stall, JII_decode_inc_stall, opcode_decode_inc_stall, rd_decode_inc_stall, rs_decode_inc_stall, rt_decode_inc_stall, shiftamt_decode_inc_stall, aluop_decode_inc_stall, immediate_decode_inc_stall, target_decode_inc_stall, 
		rd_writeback, rdval_writeback);
	 
		
	assign R_decode_inc_stall = is_flush ? 1'b0 : R_decode;
	assign I_decode_inc_stall = is_flush ? 1'b0 : I_decode;
	assign JI_decode_inc_stall = is_flush ? 1'b0 : JI_decode;
	assign JII_decode_inc_stall = is_flush ? 1'b0 : JII_decode;
	assign opcode_decode_inc_stall = is_flush ? 5'b0 : opcode_decode;
	assign rd_decode_inc_stall = is_flush ? 5'b0 : rd_decode;
	assign rs_decode_inc_stall = is_flush ? 5'b0 : rs_decode;
	assign rt_decode_inc_stall = is_flush ? 5'b0 : rt_decode;
	assign shiftamt_decode_inc_stall = is_flush ? 5'b0 : shiftamt_decode;
	assign aluop_decode_inc_stall = is_flush ? 5'b0 : aluop_decode;
	assign immediate_decode_inc_stall = is_flush ? 17'b0 : immediate_decode;
	assign target_decode_inc_stall = is_flush ? 27'b0 : target_decode;
	
	
	assign ctrl_writeEnable = 1'b1;               // O: Write enable for regfile
	assign ctrl_writeReg = rd_writeback;                  // O: Register to write to in regfile
	assign ctrl_readRegA = rs_execute;                  // O: Register to read from port A of regfile
	assign ctrl_readRegB = rt_execute;                  // O: Register to read from port B of regfile
	assign data_writeReg = rdval_writeback;                  // O: Data to write to for regfile
	assign data_out_regA_execute = data_readRegA;                   // I: Data from port A of regfile
	assign data_out_regB_execute = data_readRegB;                   // I: Data from port B of regfile

	//#####################################Execute Stage#######################################################//
	wire [31:0] pc_in_execute, pc_out_memory;
	wire [31:0] execute_output, data_out_regB, pc_out_overwrite_data;
	wire pc_out_overwrite_enable;

	wire [31:0] data_in_regA_execute, data_in_regB_execute;
	
	wire R_memory, I_memory, JI_memory, JII_memory;
	wire [4:0] opcode_memory, rd_memory, rs_memory, rt_memory, shiftamt_memory, aluop_memory;
	wire [16:0] immediate_memory;
	wire [26:0] target_memory;
	
	assign pc_in_execute = pc_out_execute;
	

	 wire [31:0] current_program_counter;
	 assign current_program_counter = pc_in_data;
	 //#########################DEBUG########################//
	 //wire [31:0] isBNE_or_isBLT_DEBUG;
	wire [31:0] 	alu_input_A, alu_input_B, alu_output;
	 //##################################################//
	wire isBypassData_A, isBypassData_B;
	wire [31:0] bypassData_A, bypassData_B;
	wire [4:0] aluop_inc_swlw_inc_setx_jal;
	 
	wire R_execute_inc_stall, I_execute_inc_stall, JI_execute_inc_stall, JII_execute_inc_stall;
	wire [4:0] opcode_execute_inc_stall, rd_execute_inc_stall, rs_execute_inc_stall, rt_execute_inc_stall, shiftamt_execute_inc_stall, aluop_execute_inc_stall;
	wire [16:0] immediate_execute_inc_stall;
	wire [26:0] target_execute_inc_stall;
	
	wire is_stall;
	wire is_stall_or_flush;
	or is_stall_or_flush_gate(is_stall_or_flush, is_stall, is_flush);
	
	assign R_execute_inc_stall = is_stall_or_flush ? 1'b0 : R_execute;
	assign I_execute_inc_stall = is_stall_or_flush ? 1'b0 : I_execute;
	assign JI_execute_inc_stall = is_stall_or_flush ? 1'b0 : JI_execute;
	assign JII_execute_inc_stall = is_stall_or_flush ? 1'b0 : JII_execute;
	assign opcode_execute_inc_stall = is_stall_or_flush ? 5'b0 : opcode_execute;
	assign rd_execute_inc_stall = is_stall_or_flush ? 5'b0 : rd_execute;
	assign rs_execute_inc_stall = is_stall_or_flush ? 5'b0 : rs_execute;
	assign rt_execute_inc_stall = is_stall_or_flush ? 5'b0 : rt_execute;
	assign shiftamt_execute_inc_stall = is_stall_or_flush ? 5'b0 : shiftamt_execute;
	assign aluop_execute_inc_stall = is_stall_or_flush ? 5'b0 : aluop_execute;
	assign immediate_execute_inc_stall = is_stall_or_flush ? 17'b0 : immediate_execute;
	assign target_execute_inc_stall = is_stall_or_flush ? 27'b0 : target_execute;
	 
	wire alu_overflow; 
	execute_stage my_execute_stage(
		pc_out_memory, pc_in_execute, 
		execute_output, pc_out_overwrite_enable, data_out_regB, pc_out_overwrite_data,
		data_in_regA_execute, data_in_regB_execute,
		R_memory, I_memory, JI_memory, JII_memory, opcode_memory, rd_memory, rs_memory, rt_memory, shiftamt_memory, aluop_memory, immediate_memory, target_memory,
		clk, enable, clr,
		R_execute_inc_stall, I_execute_inc_stall, JI_execute_inc_stall, JII_execute_inc_stall, opcode_execute_inc_stall, rd_execute_inc_stall, rs_execute_inc_stall, rt_execute_inc_stall, shiftamt_execute_inc_stall, aluop_execute_inc_stall, immediate_execute_inc_stall, target_execute_inc_stall, 
		isBypassData_A, bypassData_A, 
		isBypassData_B, bypassData_B, 
		aluop_inc_swlw_inc_setx_jal, 
		alu_overflow
		//, isBNE_or_isBLT_DEBUG
		//data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG
		);
	
	wire [31:0] execute_output_multdiv;
	wire [31:0] pc_out_md;
	
	wire R_md, I_md, JI_md, JII_md;
	wire [4:0] opcode_md, rd_md, rs_md, rt_md, shiftamt_md, aluop_md;
	wire [16:0] immediate_md;
	wire [26:0] target_md;
	
	wire is_executing;
	wire multdiv_overflow;
	execute_stage_multdiv my_execute_stage_multdiv(
		pc_out_md, pc_in_execute, 
		execute_output_multdiv, data_rdy,
		data_in_regA_execute, data_in_regB_execute,
		R_md, I_md, JI_md, JII_md, opcode_md, rd_md, rs_md, rt_md, shiftamt_md, aluop_md, immediate_md, target_md,
		clk, enable, clr,
		R_execute_inc_stall, I_execute_inc_stall, JI_execute_inc_stall, JII_execute_inc_stall, opcode_execute_inc_stall, rd_execute_inc_stall, rs_execute_inc_stall, rt_execute_inc_stall, shiftamt_execute_inc_stall, aluop_execute_inc_stall, immediate_execute_inc_stall, target_execute_inc_stall, 
		isBypassData_A, bypassData_A, 
		isBypassData_B, bypassData_B, 
		is_executing, 
		multdiv_overflow
		//data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG
		);
		
	wire has_alu_overflow_during_mult;
	wire write_in_alu_overflow;
	wire alu_overflow_or_setx;
	wire is_setx;
	and is_setx_gate(is_setx, opcode_execute[0], ~opcode_execute[1], opcode_execute[2], ~opcode_execute[3], opcode_execute[4]);
	or alu_overflow_or_setx_gate(alu_overflow_or_setx, alu_overflow, is_setx);
	assign write_in_alu_overflow = is_executing ? has_alu_overflow_during_mult ? 1'b1 : data_rdy ? 1'b0 : alu_overflow_or_setx : 1'b0;
	register1 has_alu_overflow_during_mult_reg(clk, 1'b1, write_in_alu_overflow, has_alu_overflow_during_mult, clr);
	
	wire multdiv_overflow_while_has_overflowed;
	and multdiv_overflow_while_has_overflowed_gate(multdiv_overflow_while_has_overflowed, has_alu_overflow_during_mult, multdiv_overflow);
	
	assign data_in_regB_execute = data_out_regB_execute;
	assign data_in_regA_execute = data_out_regA_execute;
	assign pc_in_overwrite = pc_out_overwrite_enable;
	assign pc_in_overwrite_data = pc_out_overwrite_data;
	
	//####################################Memory Stage######################################################//
	wire [31:0] memory_input, data_in_regB_memory;

	wire [31:0] data_out_regA_writeback, data_mem_out_writeback;
	
	wire R_writeback, I_writeback, JI_writeback, JII_writeback;
	wire [4:0] opcode_writeback, rd_out_writeback, rs_writeback, rt_writeback, shiftamt_writeback, aluop_writeback;
	wire [16:0] immediate_writeback;
	wire [26:0] target_writeback;
	
	assign memory_input = execute_output;
	assign data_in_regB_memory = data_out_regB;
	wire [31:0] data_out_regB_as_output;
	
	wire [31:0] data_out_regB_as_input_bypass;
	wire is_data_out_regB_as_input_bypass;
	
	memory_stage my_memory_stage(
		memory_input, data_in_regB_memory, data_out_regB_as_output,
		data_out_regA_writeback, data_mem_out_writeback,
		R_writeback, I_writeback, JI_writeback, JII_writeback, opcode_writeback, rd_out_writeback, rs_writeback, rt_writeback, shiftamt_writeback, aluop_writeback, immediate_writeback, target_writeback, 
		clk, enable, clr,
		R_memory, I_memory, JI_memory, JII_memory, opcode_memory, rd_memory, rs_memory, rt_memory, shiftamt_memory, aluop_memory, immediate_memory, target_memory, 
		data_out_regB_as_input_bypass, is_data_out_regB_as_input_bypass
		);
		
	wire [4:0] opNot_wb;
	twos_complement_flipper5 opcode_writeback_flipper(opcode_writeback, opNot_wb);
			
	wire is_sw_mem;
	and is_sw_mem_and(is_sw_mem, opNot_wb[4], opNot_wb[3], opcode_writeback[2], opcode_writeback[1], opcode_writeback[0]);

	 assign address_dmem = data_out_regA_writeback[11:0];                   // O: The address of the data to get or put from/to dmem
    assign data = data_out_regB_as_output;                    // O: The data to write to dmem
    assign wren = is_sw_mem;                           // O: Write enable for dmem
    assign data_mem_out_writeback = q_dmem;                         // I: The data from dmem
	 
	 /*
			 	//##############DEBUG#############################//
	 wire [31:0] data_out_regA_internal_inc_bex_DEBUG, data_out_regB_internal_inc_bex_DEBUG, alu_output_DEBUG;
	 
	 */
	 
	wire is_bex;

	 wire [31:0] output1_debug;
	 wire [31:0] output2_debug;
	 wire [31:0] output3_debug;
	 
	 wire [4:0] alu_op_in_exec;
	 assign alu_op_in_exec = aluop_inc_swlw_inc_setx_jal;
	 
	 assign output1_debug = is_data_out_regB_as_input_bypass;
	 assign output2_debug = isBypassData_A;
	 assign output3_debug = isBypassData_B;

	 assign alu_input_A = data_in_regA_execute;
	 assign alu_input_B = data_in_regB_execute;
	 assign alu_output = execute_output;	 

	/**/
	
	//#########################################MX BYPASS###################################################//
	wire [31:0] alu_output_in_memory_stage, bypassData_A_MX, bypassData_B_MX;
	wire isBypassData_A_MX, isBypassData_B_MX;
	assign alu_output_in_memory_stage = data_out_regA_writeback;
	
	wire is_rd_memory_equal_rs_execute;
	is_register_equal rd_mem_and_rs_execute(rd_out_writeback, rs_memory, is_rd_memory_equal_rs_execute);
	assign isBypassData_A_MX = is_rd_memory_equal_rs_execute;
	assign bypassData_A_MX = alu_output_in_memory_stage;
	
	wire is_rd_memory_equal_rt_execute;
	is_register_equal rd_mem_and_rt_execute(rd_out_writeback, rt_memory, is_rd_memory_equal_rt_execute);
	assign isBypassData_B_MX = is_rd_memory_equal_rt_execute;
	assign bypassData_B_MX = alu_output_in_memory_stage;
	
	//###########################################WX BYPASS################################################//
	wire [31:0] alu_output_in_writeback_stage, bypassData_A_WX, bypassData_B_WX;
	wire isBypassData_A_WX, isBypassData_B_WX;
	assign alu_output_in_writeback_stage = rdval_writeback;
	
	wire is_rd_writeback_equal_rs_execute;
	is_register_equal rd_wb_and_rs_execute(rd_writeback, rs_memory, is_rd_writeback_equal_rs_execute);
	assign isBypassData_A_WX = is_rd_writeback_equal_rs_execute;
	assign bypassData_A_WX = alu_output_in_writeback_stage;	

	wire is_rd_writeback_equal_rt_execute;
	is_register_equal rd_wb_and_rt_execute(rd_writeback, rt_memory, is_rd_writeback_equal_rt_execute);
	assign isBypassData_B_WX = is_rd_writeback_equal_rt_execute;
	assign bypassData_B_WX = alu_output_in_writeback_stage;
	
	//#########################################EXECUTE BYPASS MUX###############################################//
	or isBypassData_A_or(isBypassData_A, isBypassData_A_WX, isBypassData_A_MX);
	or isBypassData_B_or(isBypassData_B, isBypassData_B_WX, isBypassData_B_MX);
	
	assign bypassData_A = isBypassData_A_MX ? bypassData_A_MX : bypassData_A_WX;
	assign bypassData_B = isBypassData_B_MX ? bypassData_B_MX : bypassData_B_WX;
	
	//###############################################WM BYPASS#################################################//
	wire is_rd_writeback_equal_rt_memory;
	is_register_equal rd_wb_and_rt_memory(rd_writeback, rt_writeback, is_rd_writeback_equal_rt_memory);
	assign is_data_out_regB_as_input_bypass = is_rd_writeback_equal_rt_memory;
	assign data_out_regB_as_input_bypass = rdval_writeback;
	
	//########################################STALL LOGIC COMPARISONS###############################################//
	wire is_DxIrOp_equal_LOAD, is_FdIrRS1_equal_DxIrRd, is_FdIrRs2_equal_DxIrRd, is_FdIrOp_not_equal_STORE;
	wire is_DxIrOp_equal_MULTDIV;
	wire is_DxIrOp_equal_MULTDIV_temp;
	wire is_DxIrOp_equal_MULTDIV_temptemp;
	wire is_DxIrOp_equal_MULT_temptemp;
	wire is_DxIrOp_equal_DIV_temptemp;
	
	nor is_DxIrOp_equal_MULTDIV_temp_gate(is_DxIrOp_equal_MULTDIV_temp, opcode_execute[0], opcode_execute[1], opcode_execute[2], opcode_execute[3], opcode_execute[4]);
	is_register_equal is_DxIrOp_equal_MULT_temptemp_comparison(aluop_execute, 5'b00110, is_DxIrOp_equal_MULT_temptemp);
	is_register_equal is_DxIrOp_equal_DIV_temptemp_comparison(aluop_execute, 5'b00111, is_DxIrOp_equal_DIV_temptemp);
	or is_DxIrOp_equal_MULTDIV_temptemp_OR(is_DxIrOp_equal_MULTDIV_temptemp, is_DxIrOp_equal_MULT_temptemp, is_DxIrOp_equal_DIV_temptemp);

	and is_DxIrOp_equal_MULTDIV_gate(is_DxIrOp_equal_MULTDIV, is_executing, is_DxIrOp_equal_MULTDIV_temp, is_DxIrOp_equal_MULTDIV_temptemp);
	
	wire is_executing_and_next_ins_bex;
	and is_bex_gate(is_bex, ~opcode_execute[0], opcode_execute[1], opcode_execute[2], ~opcode_execute[3], opcode_execute[4]);
	and is_executing_and_next_ins_bex_gate(is_executing_and_next_ins_bex, is_executing, is_bex);
	
	wire is_has_overflowed_and_next_ins_bex;
	and is_has_overflowed_and_next_ins_bex_gate(is_has_overflowed_and_next_ins_bex, has_alu_overflow_during_mult, is_bex);
	wire should_stall_based_on_bex_and_rstatus_predict;
	and should_stall_based_on_bex_and_rstatus_predict_gate(should_stall_based_on_bex_and_rstatus_predict, is_executing_and_next_ins_bex, ~is_has_overflowed_and_next_ins_bex);
	
	wire is_rs_from_MULTDIV_dst;
	is_register_equal is_rs_from_MULTDIV_dst_comparison(rd_md, rs_execute, is_rs_from_MULTDIV_dst);
	wire is_rt_from_MULTDIV_dst;
	is_register_equal is_rt_from_MULTDIV_dst_comparison(rd_md, rt_execute, is_rt_from_MULTDIV_dst);
	wire is_read_from_MULTDIV_dst;
	or is_read_from_MULTDIV_dst_gate(is_read_from_MULTDIV_dst, is_rs_from_MULTDIV_dst, is_rt_from_MULTDIV_dst);
	wire is_read_from_MULTDIV_dst_and_exec;
	and is_read_from_MULTDIV_dst_and_exec_gate(is_read_from_MULTDIV_dst_and_exec, is_read_from_MULTDIV_dst, is_executing);
	
	wire is_rd_equal_MULTDIV_dst;
	is_register_equal is_rd_equal_MULTDIV_dst_comparison(rd_md, rd_execute, is_rd_equal_MULTDIV_dst);
	wire is_write_to_MULTDIV_dst_and_exec;
	and is_write_to_MULTDIV_dst_and_exec_gate(is_write_to_MULTDIV_dst_and_exec, is_rd_equal_MULTDIV_dst, is_executing);
	
	wire is_FdIrOp_equal_STORE;
	is_register_equal is_DxIrOp_equal_LOAD_comparison(opcode_memory, 5'b01000, is_DxIrOp_equal_LOAD);
	is_register_equal is_FdIrRS1_equal_DxIrRd_comparison(rs_execute, rd_memory, is_FdIrRS1_equal_DxIrRd);
	is_register_equal is_FdIrRs2_equal_DxIrRd_comparison(rt_execute, rd_memory, is_FdIrRs2_equal_DxIrRd);
	is_register_equal is_FdIrOp_not_equal_STORE_comparison(opcode_execute, 5'b00111, is_FdIrOp_equal_STORE);
	not is_FdIrOp_not_equal_STORE_notgate(is_FdIrOp_not_equal_STORE, is_FdIrOp_equal_STORE);
	
	
	wire is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd;
	wire is_FdIrRS1_equal_DxIrRd_OR_is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd;
	and is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd_gate(is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd, is_FdIrOp_not_equal_STORE, is_FdIrRs2_equal_DxIrRd);
	or is_FdIrRS1_equal_DxIrRd_OR_is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd_gate(is_FdIrRS1_equal_DxIrRd_OR_is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd, is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd, is_FdIrRS1_equal_DxIrRd);
	
	wire is_stall_temp;
	and is_stall_temp_and(is_stall_temp, is_FdIrRS1_equal_DxIrRd_OR_is_FdIrOp_not_equal_STORE_AND_is_FdIrRs2_equal_DxIrRd, is_DxIrOp_equal_LOAD);
	or is_stall_or(is_stall, 
		is_DxIrOp_equal_MULTDIV, 
		is_stall_temp, 
		is_read_from_MULTDIV_dst_and_exec, 
		should_stall_based_on_bex_and_rstatus_predict, 
		is_write_to_MULTDIV_dst_and_exec);
	assign stalling = is_stall;
	
	//####################################FLUSH LOGIC#######################################################//
	assign is_flush = pc_in_overwrite;
	
	//####################################Writeback Stage##################################################//
		
	wire [31:0] data_in_regA_writeback;
	assign data_in_regA_writeback = data_out_regA_writeback;
	wire [31:0] data_mem_in_writeback;
	assign data_mem_in_writeback = data_mem_out_writeback;
	
	wire [4:0] rd_in_writeback;
	assign rd_in_writeback = rd_out_writeback;
	
	wire R_terminated, I_terminated, JI_terminated, JII_terminated;
	wire [4:0] opcode_terminated, rd_terminated, rs_terminated, rt_terminated, shiftamt_terminated, aluop_terminated;
	wire [16:0] immediate_terminated;
	wire [26:0] target_terminated;
	
	wire [31:0] rdval_writeback_wo_md;
	wire [4:0] rd_writeback_wo_md;
	writeback_stage my_writeback_stage(
		rdval_writeback_wo_md, rd_writeback_wo_md,
		data_in_regA_writeback, data_mem_in_writeback,
		R_terminated, I_terminated, JI_terminated, JII_terminated, opcode_terminated, rd_terminated, rs_terminated, rt_terminated, shiftamt_terminated, aluop_terminated, immediate_terminated, target_terminated, 
		clk, enable, clr,
		R_writeback, I_writeback, JI_writeback, JII_writeback, opcode_writeback, rd_in_writeback, rs_writeback, rt_writeback, shiftamt_writeback, aluop_writeback, immediate_writeback, target_writeback
		);
		
	assign rdval_writeback = data_rdy ? execute_output_multdiv : rdval_writeback_wo_md;
	assign rd_writeback = data_rdy ? multdiv_overflow_while_has_overflowed ? 5'b0 : rd_md : rd_writeback_wo_md;
	

endmodule
