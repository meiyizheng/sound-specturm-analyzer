`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:05:36 12/09/2020 
// Design Name: 
// Module Name:    LEDOutput 
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
module LEDOutput(
	input [window_size*value_width-1:0] values,
	output reg [n_bands*column_height-1:0] leds
);

parameter window_size = 2**12;
parameter value_width = 16;
parameter n_bands = 8;
parameter column_height = 16;
parameter led_step_size = 2**(value_width-1)/column_height;

reg [value_width+12:0] bands[0:n_bands-1];
integer i,j;
always@* begin
	//initialize values
	for (i=0;i<n_bands;i=i+1) begin
		bands[i] = 0;
	end
	//sum across band
	for (i=0;i<window_size/2;i=i+1) begin
		j = i/(window_size/2/n_bands);
		bands[j] = bands[j] + values[i*value_width+:value_width];
	end
	//normalize, convert to int and output
	for (i=0;i<n_bands;i=i+1) begin
		bands[i] = bands[i]/(window_size/2/n_bands);
		for (j=0;j<column_height;j=j+1) begin
			leds[i*column_height+j] = bands[i] > (led_step_size*j);
		end
	end
end

endmodule
