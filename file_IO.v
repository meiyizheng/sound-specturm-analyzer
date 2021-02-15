module file_IO;

parameter sample_size = 2**12;
parameter file_size = 4365900;

reg enable;
reg enable_process;
reg [15:0] wav_input;
reg clk;

integer scan;
integer fd;
integer count = 0;

sliding_window uut(.clk(clk), 
		   .enable(enable), 
		   .enable_process(enable_process),
		   .wav_input(wav_input),
		   .idx(count),
		   .window(window));

always begin
	#5 clk = ~clk;
end

initial begin
	clk = 0;
	enable = 1;
	enable_process = 0;
	fd = $fopen("C:/Users/yoshi/OneDrive/Desktop/mono_del_row.csv", "r");
end
//*c
always @ (posedge clk) begin
	
	if(!$feof(fd)) begin
		scan = $fscanf(fd, "%d", wav_input);
		count = count + 1;
		if(enable_process == 0 && count >= sample_size) begin
			enable_process = 1;
		end
	end
	else begin
		enable = 0;
		enable_process = 0;
	end
/*
	if(count == file_size - 1) begin
		enable = 0;
		enable_process = 0;
	end
*/
end

endmodule
