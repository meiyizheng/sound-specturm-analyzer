`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:33:36 12/07/2020
// Design Name:   fft
// Module Name:   /home/pangalacticgb/Xilinx/14.7/ISE_DS/FrequencyAnalyzer/initialization_tb.v
// Project Name:  FrequencyAnalyzer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fft
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module initialization_tb;

	// Inputs
	reg [32767:0] window;

	// Outputs
	wire [32767:0] out;

	// Instantiate the Unit Under Test (UUT)
	fft uut (
		.window(window), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		window = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

