
module KB(clk, enter, up, down, scan_history, ps2_clk, ps2_dat);
	input clk; 
	input ps2_clk, ps2_dat;
	


	wire [7:0] scan_code ;
	wire read , scan_ready ;
	output reg [15:0] scan_history;
	output enter, up, down;
	always @( posedge scan_ready )begin
		scan_history [15:8] <= scan_history [7:0];
		scan_history [7:0] <= scan_code ;
	end
  // END OF PS2 KB SETUP
  // Keyboard Section
	keyboard kb (
				.keyboard_clk(ps2_clk),
				.keyboard_data(ps2_dat),
				.clock50(clk),
				.reset(0),
				.read(read),
				.scan_ready(scan_ready),
				.scan_code(scan_code));
	
	oneshot pulse (
					  .pulse_out(read),
					  .trigger_in(scan_ready),
					  .clk(clk));
	
	assign enter = ((scan_history [7:0] == 'h5a) && (scan_history[15:12] != 'hF)); // key for enter key
	assign up = ((scan_history [7:0] == 'h75) && (scan_history[15:12] != 'hF)); // Key for up_arrow
	assign down = ((scan_history [7:0] == 'h72) && (scan_history[15:12] != 'hF)); // Keyfor down_arrow


endmodule

