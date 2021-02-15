`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:01:27 12/10/2020 
// Design Name: 
// Module Name:    FrequencyAnalyzer 
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
module FrequencyAnalyzer(
    );

parameter window_size = 2**12;
parameter n_bands = 8;
parameter column_height = 16;
parameter value_width = 16;

reg [column_height-1:0] leds [0:n_bands-1];
wire [column_height*n_bands-1:0]leds_wire;
wire [window_size*value_width-1:0] window;
wire [window_size*value_width-1:0] ft;

fft f(.window(window), .out(ft));
LEDOutput led_output(.values(ft), .leds(leds_wire));

integer i;
always@*
	for (i=0;i<n_bands;i=i+1)
		leds[i] = leds_wire[i*column_height+:column_height];

endmodule
