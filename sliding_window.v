module sliding_window(input wire clk, 
		      input wire enable, 
		      input wire enable_process, 
		      input wire [15:0] wav_input, 
		      input wire [31:0] idx,
		      output reg [(2**16)-1:0] window );

parameter sample_size = 2**12;
parameter width = 16;
parameter file_size = 4365900;

reg [file_size*width-1:0] wav_file = 0;
integer count = 0;

always @ (posedge clk) begin
	if(enable == 1'b1) begin
		wav_file[idx*width +: width] = wav_input;
	end
	if(enable_process == 1'b1) begin 
		window = wav_file[count*width +: sample_size * width];
		count = count + 1;
	end		
end
endmodule
