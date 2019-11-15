/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */
//instruction, dmem out, written into rd, rd itself, reg A, reg B, 
module skeleton(clock_t, reset, instruction_output, dmem_output, rdval_writeback, regA_out, regB_out, rd_writeback
/*, 
current_program_counter, pc_in_overwrite, execute_output_DEBUG, 
output1_debug, output2_debug, output3_debug, alu_input_A, alu_input_B, alu_output, alu_op_in_exec, stalling, 
	pc_in_overwrite_data, 
	is_flush*/


);
    input clock_t, reset;
	 
	 //#################################invert the clock#############################//
	 wire clock;
	 not inv_clock(clock, clock_t);

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
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	 
	 output [31:0] instruction_output, dmem_output, rdval_writeback, regA_out, regB_out;
	 output [4:0] rd_writeback;
	 
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
	 /*
	 //###########DEBUG####################//
	 output [31:0] 			output1_debug, output2_debug, output3_debug;
	 output [31:0] 		alu_input_A, alu_input_B, alu_output;
	 output [31:0] current_program_counter;
	 output pc_in_overwrite;
	 output [31:0] execute_output_DEBUG;
	 output [31:0] alu_op_in_exec;
	 output stalling;
	 output[31:0]	pc_in_overwrite_data;
	 output is_flush;
	 */
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
		/*output1_debug, output2_debug, output3_debug,
		alu_input_A, alu_input_B, alu_output,
			alu_op_in_exec,
			current_program_counter, pc_in_overwrite, 
			stalling, 
			pc_in_overwrite_data, 
			is_flush
			*/
	 );

endmodule
