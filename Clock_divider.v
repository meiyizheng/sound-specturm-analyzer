`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:15:20 12/09/2020 
// Design Name: 
// Module Name:    Clock_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Clock_divider( clock_in, clock_out
    );
	 
	 input wire clock_in;
	 output clock_out;
	 
	 reg [27:0] counter = 28'd0;
	 parameter DIVISOR = 1133;
	
	 
	 always @ (posedge clock_in) 
	 begin
		counter <= counter + 28'd1;
		if (counter >= (DIVISOR -1)) 
			counter <= 28'd0;
		end 
		
		assign clock_out = (counter < DIVISOR /2)? 1'b0:1'b1;

endmodule
