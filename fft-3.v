`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:21:59 12/07/2020 
// Design Name: 
// Module Name:    fft 
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
module fft(
	input [window_size*value_width-1:0] window,
	output reg [window_size*value_width-1:0] out
);

parameter window_size = 2**12;
parameter value_width = 16;
real w_k_a[0:window_size-1];
real w_k_b[0:window_size-1];

integer i;

initial begin
	w_k_a[0] = 1;
	w_k_b[0] = 0;
	w_k_a[1] = 0.99999882345;
	w_k_b[1] = 0.00153398018;
	for (i=1;i<window_size;i=i+1) begin
		w_k_a[i] = complex_multiply_a(w_k_a[i-1], w_k_b[i-1], w_k_a[1], w_k_b[1]);
		w_k_b[i] = complex_multiply_b(w_k_a[i-1], w_k_b[i-1], w_k_a[1], w_k_b[1]);
	end
	//$display("expected -1, got %f + i%f", w_k_a[2**11], w_k_b[2**11]);
	//$display("expected 0.99999882345-i0.00153398018, got %f + i%f", w_k_a[window_size-1], w_k_b[window_size-1]);
	//$display("index(3) = %d, 3072 expected", index(3));
end

reg signed [15:0] tmp;
real in[0:window_size-1];
real intermediate_a [0:11][0:window_size-1];
real intermediate_b [0:11][0:window_size-1];

integer j,k;
always@* begin
	for (i=0;i<window_size;i=i+1) begin
		tmp = window[i*value_width+:value_width];
		in[i] = tmp;
	end

	//this for loop performs the bottom round of fft
	for (i=0;i<window_size;i=i+1) begin
		if (i%2 == 0) begin
			intermediate_a[0][i] = in[index(i)] + in[index(i+1)];
		end else begin
			intermediate_a[0][i] = in[index(i-1)] - in[index(i)];
		end
		intermediate_b[0][i] = 0;
	end

	for (i=1;i<12;i=i+1) begin
		// These 2 inner loops represent together one pass over the whole input
		for (j=0;j<2**(11-i);j=j+1)begin // j is the index of the block that we are computing, for example if we're computing X_eo, then j=1
			for (k=0;k<2**i;k=k+1) begin // k is the index of the value we're computing inside of a block. (the actual index will therefore be 2**(i+1)*j+k)
				intermediate_a[i][2**(i+1)*j+k] = intermediate_a[i-1][2**(i+1)*j+k] + complex_multiply_a(w_k_a[2**(11-i)*k],w_k_b[2**(11-i)*k],intermediate_a[i-1][2**(i+1)*j+2**i+k], intermediate_b[i-1][2**(i+1)*j+2**i+k]);
				intermediate_b[i][2**(i+1)*j+k] = intermediate_b[i-1][2**(i+1)*j+k] + complex_multiply_b(w_k_a[2**(11-i)*k],w_k_b[2**(11-i)*k],intermediate_a[i-1][2**(i+1)*j+2**i+k], intermediate_b[i-1][2**(i+1)*j+2**i+k]);
				
				intermediate_a[i][2**(i+1)*j+2**i+k] = intermediate_a[i-1][2**(i+1)*j+k] + complex_multiply_a(w_k_a[2**(11-i)*k],w_k_b[2**(11-i)*k],intermediate_a[i-1][2**(i+1)*j+2**i+k], intermediate_b[i-1][2**(i+1)*j+2**i+k]);
				intermediate_b[i][2**(i+1)*j+2**i+k] = intermediate_b[i-1][2**(i+1)*j+k] - complex_multiply_b(w_k_a[2**(11-i)*k],w_k_b[2**(11-i)*k],intermediate_a[i-1][2**(i+1)*j+2**i+k], intermediate_b[i-1][2**(i+1)*j+2**i+k]);
			end
		end
	end
	
	for (i=0;i<window_size;i=i+1) begin
		out[i*value_width+:value_width] = ((intermediate_a[11][i]/window_size)**2 + (intermediate_b[11][i]/window_size)**2)**0.5;
	end
end

//returns the index in the input array of the element that corresponds to a given position in the FFT graph.
function automatic [11:0] index (input [11:0] position);
	integer j;
	for (j=0;j<12;j=j+1) begin
		index[j] = position[11-j];
	end
endfunction

//returns the real part of a complex multiplication
function automatic real complex_multiply_a (input real a1, b1, a2, b2);
	complex_multiply_a = a1*a2 - b1*b2;
endfunction

//returns the imaginary part of a complex multiplication
function automatic real complex_multiply_b (input real a1, b1, a2, b2);
	complex_multiply_b = a1*b2 + a2*b1;
endfunction

endmodule
