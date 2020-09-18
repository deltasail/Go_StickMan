// Project: Go ! SticK-Man
// Powered by: Ruanfan Chen & Yuxiao Chen
// Acknowledgement: VGA codes & Keyboard codes resources, provided on course website (Portal)


module goStickMan(CLOCK_50, 
					 KEY,
					 HEX2,
					 HEX1,
					 HEX0,
					 
					 PS2_CLK,
					 PS2_DAT,
					 
					 VGA_CLK,   					//	VGA Clock
					 VGA_HS,							//	VGA H_SYNC
					 VGA_VS,							//	VGA V_SYNC
					 VGA_BLANK_N,					//	VGA BLANK
					 VGA_SYNC_N,					//	VGA SYNC
					 VGA_R,   						//	VGA Red[9:0]
					 VGA_G,	 						//	VGA Green[9:0]
					 VGA_B   						//	VGA Blue[9:0]
					 );
		
		
		
	
	input CLOCK_50;
	input [0:0] KEY;	
	output [6:0] HEX2, HEX1, HEX0; //HEX5,HEX4, HEX3
	
	
	input PS2_CLK, PS2_DAT;
	wire go, up, down, resetn, clk;
	wire [7:0] x; 
	wire [6:0] y;
	assign resetn = KEY[0];
	assign clk = CLOCK_50;

	
	wire [2:0] colour;

	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire ld_pre_welcome, ld_welcome, ld_welcome_pre_clear, ld_welcome_clear,
		  ld_pre_run_one, ld_run_one, ld_run_one_pre_clear, ld_run_one_clear, 
		  ld_pre_run_two, ld_run_two, ld_run_two_pre_clear, ld_run_two_clear,
		  ld_pre_jump, ld_jump, ld_jump_pre_clear, ld_jump_clear,
		  ld_pre_slide, ld_slide, ld_slide_pre_clear, ld_slide_clear, 
		  ld_pre_end, ld_end, ld_end_pre_clear, ld_end_clear,
		  writeEn;
		  
	wire [7:0] bx0;
	wire [6:0] by0;
	
	wire [11:0] score;
	// should have pre_draw, but not includes pre_clear
	wire clear = ld_pre_welcome | ld_pre_run_one | ld_pre_run_two | ld_pre_jump | ld_pre_slide| ld_pre_end | ld_welcome_clear | ld_run_one_clear| ld_run_two_clear| ld_jump_clear| ld_slide_clear | ld_end_clear; //| ld_welcome_pre_clear | ld_jump_pre_clear | ld_slide_pre_clear;
	assign colour = clear? 3'b000: 3'b111;
	
	wire haha;
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	
	// Connects the keyboard with go, up, down
	
	wire [15:0] scan_history;
	KB  kb0(
				.clk(clk),
			   .enter(go),	
				.up(up), 
				.down(down), 
				.scan_history(scan_history),
				.ps2_clk(PS2_CLK), 
				.ps2_dat(PS2_DAT)
				);
			  
	
	ControlPath C0(
					  .clk(clk), 
					  .resetn(resetn), 
					  .go(go), 
					  .up(up), 
					  .down(down),
					  
					  .ld_pre_welcome(ld_pre_welcome), 
					  .ld_welcome(ld_welcome), 
					  .ld_welcome_pre_clear(ld_welcome_pre_clear), 
					  .ld_welcome_clear(ld_welcome_clear),
					  
					  .ld_pre_run_one(ld_pre_run_one),
					  .ld_run_one(ld_run_one), 
					  .ld_run_one_pre_clear(ld_run_one_pre_clear),
					  .ld_run_one_clear(ld_run_one_clear),
					  
					  .ld_pre_run_two(ld_pre_run_two),
					  .ld_run_two(ld_run_two), 
					  .ld_run_two_pre_clear(ld_run_two_pre_clear),
					  .ld_run_two_clear(ld_run_two_clear),
					  
					  .ld_pre_jump(ld_pre_jump), 
					  .ld_jump(ld_jump), 
					  .ld_jump_pre_clear(ld_jump_pre_clear),
					  .ld_jump_clear(ld_jump_clear), 
					  
					  .ld_pre_slide(ld_pre_slide), 
					  .ld_slide(ld_slide), 
					  .ld_slide_pre_clear(ld_slide_pre_clear),
					  .ld_slide_clear(ld_slide_clear), 
					  
					  .ld_pre_end(ld_pre_end),
					  .ld_end(ld_end),
					  .ld_end_pre_clear(ld_end_pre_clear), 
					  .ld_end_clear(ld_end_clear),
					  
					  .bx0(bx0),
					  .by0(by0), 
					  
					  .score(score),
					  .haha(haha)
					  );
					  
	DataPath D0(
				  .clk(clk), 
				  .resetn(resetn), 
				  .ld_pre_welcome(ld_pre_welcome), 
				  .ld_welcome(ld_welcome), 
				  .ld_welcome_pre_clear(ld_welcome_pre_clear), 
				  .ld_welcome_clear(ld_welcome_clear),
					  
				  .ld_pre_run_one(ld_pre_run_one),
		        .ld_run_one(ld_run_one), 
				  .ld_run_one_pre_clear(ld_run_one_pre_clear),
				  .ld_run_one_clear(ld_run_one_clear),
				  
					  
				  .ld_pre_run_two(ld_pre_run_two),
				  .ld_run_two(ld_run_two), 
				  .ld_run_two_pre_clear(ld_run_two_pre_clear),
				  .ld_run_two_clear(ld_run_two_clear),
					  
				  .ld_pre_jump(ld_pre_jump), 
				  .ld_jump(ld_jump), 
				  .ld_jump_pre_clear(ld_jump_pre_clear),
				  .ld_jump_clear(ld_jump_clear), 
					  
				  .ld_pre_slide(ld_pre_slide), 
				  .ld_slide(ld_slide), 
				  .ld_slide_pre_clear(ld_slide_pre_clear),
				  .ld_slide_clear(ld_slide_clear), 
				  
				  .ld_pre_end(ld_pre_end),
				  .ld_end(ld_end),
				  .ld_end_pre_clear(ld_end_pre_clear), 
				  .ld_end_clear(ld_end_clear),
				  
				  .plot(writeEn),
				  .x(x),
				  .y(y),
				  
				  .bx_0(bx0),
				  .by_0(by0),
				  
				  .score(score)
				  );
//	hex_decoder H5(
//					  .in(scan_history[7:4]), 
//					  .out(HEX5)
//					  );
//	hex_decoder H4(
//					  .in(scan_history[3:0]), 
//					  .out(HEX4)
//					  );
//	hex_decoder H3(
//					  .in(scan_history[15:12]), 
//					  .out(HEX3)
//					  );					  
	hex_decoder H2(
					  .in(score[11:8]), 
					  .out(HEX2)
					  );
					  
	hex_decoder H1(
					  .in(score[7:4]), 
					  .out(HEX1)
					  );
	
	hex_decoder H0(
					  .in(score[3:0]), 
					  .out(HEX0)
					  );		

endmodule


module ControlPath(clk, resetn, go, up, down, 
						ld_pre_welcome, ld_welcome, ld_welcome_pre_clear, ld_welcome_clear,
						ld_pre_run_one, ld_run_one, ld_run_one_pre_clear, ld_run_one_clear, 
						ld_pre_run_two, ld_run_two, ld_run_two_pre_clear, ld_run_two_clear,
						ld_pre_jump, ld_jump, ld_jump_pre_clear, ld_jump_clear,
						ld_pre_slide, ld_slide, ld_slide_pre_clear, ld_slide_clear, 
						ld_pre_end, ld_end, ld_end_pre_clear, ld_end_clear,
						bx0, by0,
						score,
						haha);
	input clk, resetn, go, up, down;
	input [7:0] bx0;
	input [6:0] by0;
	output reg 	ld_pre_welcome, ld_welcome, ld_welcome_pre_clear, ld_welcome_clear,
					ld_pre_run_one, ld_run_one, ld_run_one_pre_clear, ld_run_one_clear, 
					ld_pre_run_two, ld_run_two, ld_run_two_pre_clear, ld_run_two_clear,
					ld_pre_jump, ld_jump, ld_jump_pre_clear, ld_jump_clear,
					ld_pre_slide, ld_slide, ld_slide_pre_clear, ld_slide_clear,
					ld_pre_end, ld_end, ld_end_pre_clear, ld_end_clear;
					
	output reg [11:0] score;
	output haha;
	
	reg  [4:0] current_state, next_state; 
	wire welcomeNext, welcomeClearNext, 
		  oneNext, oneClearNext,
		  twoNext, twoClearNext,
		  jumpNext,jumpClearNext, 
		  slideNext, slideClearNext,
		  endNext, endClearNext,
		  goDraw, goClear,
		  goPreEnd;
	
	wire [7:0] char_x_left, char_x_right;
	wire [6:0] char_y_top, char_y_bottom; 
	
	assign char_x_left = 8'd10;
	assign char_x_right = 8'd19;
	
	
	// PRE_CLEAR states: th eT = 1/60s delay
	localparam S_PRE_WELCOME 		 = 5'd0,
				  S_WELCOME  		 = 5'd1,
				  S_WELCOME_PRE_CLEAR = 5'd2,
				  S_WELCOME_CLEAR     = 5'd3,
				  
				  S_PRE_RUN_ONE		 = 5'd4,
				  S_RUN_ONE    		 = 5'd5,
				  S_RUN_ONE_PRE_CLEAR = 5'd6,
				  S_RUN_ONE_CLEAR 	 = 5'd7,
				  
				  S_PRE_RUN_TWO		 = 5'd8,
				  S_RUN_TWO 			 = 5'd9,
				  S_RUN_TWO_PRE_CLEAR = 5'd10,
				  S_RUN_TWO_CLEAR 	 = 5'd11,
				  
				  S_PRE_JUMP  	   	 = 5'd12,
				  S_JUMP 	      	 = 5'd13,
				  S_JUMP_PRE_CLEAR	 = 5'd14,
				  S_JUMP_CLEAR	   	 = 5'd15,
				  
				  S_PRE_SLIDE  		 = 5'd16,
				  S_SLIDE	   		 = 5'd17,
				  S_SLIDE_PRE_CLEAR 	 =	5'd18,
				  S_SLIDE_CLEAR		 = 5'd19,
				  
				  S_PRE_END 			 = 5'd20,
				  S_END					 = 5'd21,
				  S_END_PRE_CLEAR		 = 5'd22,
				  S_END_CLEAR         = 5'd23;
				  
				  
				  
				  
		// Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
					 S_PRE_WELCOME: next_state = S_WELCOME;
					 S_WELCOME: next_state = (welcomeNext & go)? S_WELCOME_PRE_CLEAR :S_WELCOME;
					 S_WELCOME_PRE_CLEAR: next_state = ~go ? S_WELCOME_CLEAR : S_WELCOME_PRE_CLEAR;
                S_WELCOME_CLEAR: next_state = welcomeClearNext ? S_PRE_RUN_ONE : S_WELCOME_CLEAR; 
					 
					 S_PRE_RUN_ONE: next_state = S_RUN_ONE;				 
					 S_RUN_ONE: next_state = oneNext? S_RUN_ONE_PRE_CLEAR: S_RUN_ONE; 
					 S_RUN_ONE_PRE_CLEAR: next_state = goClear? S_RUN_ONE_CLEAR: S_RUN_ONE_PRE_CLEAR;					 
					 S_RUN_ONE_CLEAR: next_state = oneClearNext? ((goPreEnd? S_PRE_END : ((up || down) ? (up? S_PRE_JUMP: S_PRE_SLIDE) : S_PRE_RUN_TWO))) : S_RUN_ONE_CLEAR;
					 
					 
					 S_PRE_RUN_TWO: next_state = S_RUN_TWO ;
					 S_RUN_TWO: next_state = twoNext? S_RUN_TWO_PRE_CLEAR: S_RUN_TWO; 
					 S_RUN_TWO_PRE_CLEAR: next_state = goClear? S_RUN_TWO_CLEAR: S_RUN_TWO_PRE_CLEAR;
					 S_RUN_TWO_CLEAR: next_state = twoClearNext? ((goPreEnd? S_PRE_END : ((up || down) ? (up? S_PRE_JUMP: S_PRE_SLIDE) : S_PRE_RUN_ONE))) : S_RUN_TWO_CLEAR;

					 
					 S_PRE_JUMP: next_state = S_JUMP;
					 S_JUMP : next_state = jumpNext? S_JUMP_PRE_CLEAR : S_JUMP;
					 S_JUMP_PRE_CLEAR: next_state = goClear? S_JUMP_CLEAR: S_JUMP_PRE_CLEAR;
					 S_JUMP_CLEAR : next_state = jumpClearNext? ((goPreEnd? S_PRE_END : ((up || down) ? (up? S_PRE_JUMP: S_PRE_SLIDE) : S_PRE_RUN_ONE))): S_JUMP_CLEAR;			 
                
					 S_PRE_SLIDE: next_state = S_SLIDE;					 
					 S_SLIDE: next_state = slideNext? S_SLIDE_PRE_CLEAR : S_SLIDE; 
					 S_SLIDE_PRE_CLEAR: next_state = goClear? S_SLIDE_CLEAR: S_SLIDE_PRE_CLEAR;
					 S_SLIDE_CLEAR: next_state = slideClearNext? ((goPreEnd? S_PRE_END : ((up || down) ? (up? S_PRE_JUMP: S_PRE_SLIDE) : S_PRE_RUN_ONE))): S_SLIDE_CLEAR;
					 
					 S_PRE_END: next_state = S_END;
					 S_END: next_state = endNext? S_END_PRE_CLEAR : S_END;
					 S_END_PRE_CLEAR: next_state = go? S_END_CLEAR : S_END_PRE_CLEAR;
					 S_END_CLEAR: next_state = (endClearNext & ~go)? S_PRE_WELCOME : S_END_CLEAR;
					 
            default:     next_state = S_PRE_WELCOME;
        endcase
    end // state_table
	 
	wire reset_fdc, countdown_fdc;
	assign reset_fdc = ld_run_one | ld_run_two| ld_jump| ld_slide; // reset the 1/60s delay counter before the PRE_CLEAR states
	assign countdown_fdc = ld_run_one_pre_clear | ld_run_two_pre_clear | ld_jump_pre_clear| ld_slide_pre_clear;	 // enable signal for the 1/60s delay

	 
	 // Output logic,  aka all of our datapath control signals
    always @(*)
	 begin: enable_signals
        // By default make all our signals 0
		  ld_pre_welcome    = 1'b0;
		  ld_welcome  = 1'b0;
		  ld_welcome_pre_clear = 1'b0;
		  ld_welcome_clear = 1'b0;
		  
		  ld_pre_run_one= 1'b0;
		  ld_run_one= 1'b0; 
		  ld_run_one_pre_clear=1'b0; 
		  ld_run_one_clear=1'b0; 

		  
		  ld_pre_run_two= 1'b0; 
		  ld_run_two= 1'b0;
		  ld_run_two_pre_clear=1'b0; 
		  ld_run_two_clear= 1'b0;

		  
		  ld_pre_jump= 1'b0;
		  ld_jump= 1'b0;
		  ld_jump_pre_clear=1'b0;
		  ld_jump_clear= 1'b0;
		  
		  ld_pre_slide= 1'b0;
		  ld_slide= 1'b0;
		  ld_slide_pre_clear= 1'b0;
		  ld_slide_clear= 1'b0;
		  
		  ld_pre_end = 1'b0;
		  ld_end = 1'b0;
		  ld_end_pre_clear = 1'b0;
		  ld_end_clear = 1'b0;
		  
		 		  
        case (current_state)
				S_PRE_WELCOME: begin
					ld_pre_welcome = 1'b1;
				end
				
				S_WELCOME: begin
					ld_welcome = 1'b1;
				end
				
				S_WELCOME_PRE_CLEAR: begin
					ld_welcome_pre_clear = 1'b1;
				end
				
				S_WELCOME_CLEAR: begin
					ld_welcome_clear = 1'b1;
				end
				
				
				
				// RUN 1
            S_PRE_RUN_ONE: begin
                ld_pre_run_one = 1'b1;
            end				
				
            S_RUN_ONE: begin
                ld_run_one = 1'b1;
            end
				
				S_RUN_ONE_PRE_CLEAR: begin
                ld_run_one_pre_clear = 1'b1;
            end	
				
            S_RUN_ONE_CLEAR: begin
                ld_run_one_clear = 1'b1;
            end				
				
				
				
				//RUN 2
				S_PRE_RUN_TWO: begin
					ld_pre_run_two = 1'b1;
				end
				
				S_RUN_TWO: begin
					ld_run_two = 1'b1;
				end
				
				S_RUN_TWO_PRE_CLEAR: begin
                ld_run_two_pre_clear = 1'b1;
            end	
				
				S_RUN_TWO_CLEAR: begin
					ld_run_two_clear = 1'b1;
				end
				
				
				
				// JUMP
            S_PRE_JUMP: begin
                ld_pre_jump = 1'b1;
            end
				
				S_JUMP: begin
					ld_jump= 1'b1;
				end
				
				S_JUMP_PRE_CLEAR: begin
                ld_jump_pre_clear = 1'b1;
            end					
					 
				S_JUMP_CLEAR: begin
					ld_jump_clear = 1'b1;
				end
				
				
				
				
				// SLIDE
				S_PRE_SLIDE: begin
					ld_pre_slide = 1'b1;
				end
				
				S_SLIDE: begin
					ld_slide = 1'b1;
				end
				
				S_SLIDE_PRE_CLEAR: begin
                ld_slide_pre_clear = 1'b1;
            end					
				
				S_SLIDE_CLEAR: begin
					ld_slide_clear= 1'b1;
				end
				
				
				// END
				S_PRE_END: begin
					ld_pre_end = 1'b1;
				end
				
				S_END: begin
					ld_end = 1'b1;
				end
				
				S_END_PRE_CLEAR: begin
					ld_end_pre_clear = 1'b1;
				end
				
				S_END_CLEAR: begin
					ld_end_clear = 1'b1;
				end
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn) begin
            current_state <= S_PRE_WELCOME;
		  end		
        else begin
            current_state <= next_state;				
		  end
		  
		  
    end // state_FFS	
	 
	 
	 always@(posedge clk) begin
		 if (!resetn | ld_welcome)
					score <= 11'b0;
		 else begin
			if ((~goPreEnd) & (char_x_left > (bx0 + 8'd4)) & (oneClearNext | twoClearNext | jumpClearNext | slideClearNext)) begin
				score[3:0] <= score[3:0] + 4'b0001;
				if (score[3:0] == 4'b1001) begin
					score[7:4] <= score[7:4] + 4'b0001;
					score[3:0] <= 4'b0;
				end
				if (score[7:4] == 4'b1001) begin
					score[7:4] <= 4'b0;
					score[11:8] <= score[11:8] + 4'b0001;
				end
				if (score[11:8] == 4'b1001)
					score[11:8] <= 4'b0;
			end
		 end

	 end
	 
	 
	CharacterPos CPos0(
							.current_state(current_state), 
							.char_y_top(char_y_top), 
							.char_y_bottom(char_y_bottom)
							);
	
	// When x in range , and : either the top of the character hits the bottom of the UPBlock, or the bottom of the character hits the top of the DOWNBlock, goPreEnd = 1;
	assign goPreEnd = (ld_run_one_clear | ld_run_two_clear | ld_jump_clear| ld_slide_clear)
							& 
					     (((char_x_left < bx0) & (bx0 < char_x_right)) | ((char_x_left < (bx0 + 8'd4)) & ((bx0 + 8'd4) < char_x_right)))
						  &  
						  ((by0 == 7'd40)? (char_y_top < 7'd55) : (char_y_bottom > 7'd65));	
//	assign goPreEnd = 1'b0;
	
	assign haha = goPreEnd;
	
	wire [24:0] welcome_delay, wait_delay, run_one_delay, run_two_delay, jump_delay, slide_delay, test_delay, end_delay;
	assign welcome_delay = 25'd213;
	assign wait_delay	= 25'd8333330; // T = 1/6 s, actually used
	assign test_delay = 25'd600; // for testing on ModelSim
	assign run_one_delay = 25'd490; 
	assign run_two_delay = 25'd490; 
	assign jump_delay = 25'd463;
	assign slide_delay= 25'd461; 
	assign end_delay = 25'd365;
	
	FrameDelayCounter FDCW(
								 .clk(clk), 
								 .resetn(~ld_pre_welcome), 
								 .enable(ld_welcome), 
								 .r(welcomeNext),
								 .start(welcome_delay)
								 );
								 
	FrameDelayCounter FDCWClear(
								 .clk(clk), 
								 .resetn(~ld_welcome_pre_clear), 
								 .enable(ld_welcome_clear), 
								 .r(welcomeClearNext),
								 .start(welcome_delay)
								 );							 
	 
	// for delay in PER_CLEARE states, T = 1/60 s 
	FrameDelayCounter FDC0(
								 .clk(clk), 
								 .resetn(~reset_fdc), 
								 .enable(countdown_fdc), 
								 .r(goClear),
								 .start(wait_delay)
								 );
	
   // delay for drawing/clearing 	
	FrameDelayCounter FDC1(
								 .clk(clk), 
								 .resetn(~ld_pre_run_one), 
								 .enable(ld_run_one), 
								 .r(oneNext),
								 .start(run_one_delay)
								 );				
								 
	FrameDelayCounter FDC1Clear(
								 .clk(clk), 
								 .resetn(~ ld_run_one_pre_clear), 
								 .enable(ld_run_one_clear), 
								 .r(oneClearNext),
								 .start(run_one_delay)
								 );									 
								 
								 
								 
								 
	FrameDelayCounter FDC2(
								 .clk(clk), 
								 .resetn(~ld_pre_run_two), 
								 .enable(ld_run_two), 
								 .r(twoNext),
								 .start(run_two_delay)
								 );
								 
	FrameDelayCounter FDC2Clear(
								 .clk(clk), 
								 .resetn(~ld_run_two_pre_clear), 
								 .enable(ld_run_two_clear), 
								 .r(twoClearNext),
								 .start(run_two_delay)
								 );	
	
	
	
	
	FrameDelayCounter FDCJ(
								 .clk(clk), 
								 .resetn(~ld_pre_jump), 
								 .enable(ld_jump), 
								 .r(jumpNext),
								 .start(jump_delay)
								 );
							
	FrameDelayCounter FDCJClear(
								 .clk(clk), 
								 .resetn(~ld_jump_pre_clear), 
								 .enable(ld_jump_clear), 
								 .r(jumpClearNext),
								 .start(jump_delay)
								 );	
			
			
	FrameDelayCounter FDCS(
								 .clk(clk), 
								 .resetn(~ld_pre_slide), 
								 .enable(ld_slide), 
								 .r(slideNext),
								 .start(slide_delay)
								 );
								 
	FrameDelayCounter FDCSClear(
								 .clk(clk), 
								 .resetn(~ld_slide_pre_clear), 
								 .enable(ld_slide_clear), 
								 .r(slideClearNext),
								 .start(slide_delay)
								 );

	FrameDelayCounter FDCEnd(
								 .clk(clk), 
								 .resetn(~ld_pre_end), 
								 .enable(ld_end), 
								 .r(endNext),
								 .start(end_delay)
								 );
						
			
 	FrameDelayCounter FDCEndClear(
								 .clk(clk), 
								 .resetn(~ld_end_pre_clear), 
								 .enable(ld_end_clear), 
								 .r(endClearNext),
								 .start(end_delay)
								 );			
endmodule



module DataPath(clk, resetn, ld_pre_welcome, ld_welcome, ld_welcome_pre_clear, ld_welcome_clear,
					ld_pre_run_one, ld_run_one, ld_run_one_pre_clear, ld_run_one_clear, 
					ld_pre_run_two, ld_run_two, ld_run_two_pre_clear, ld_run_two_clear,
					ld_pre_jump, ld_jump, ld_jump_pre_clear, ld_jump_clear,
					ld_pre_slide, ld_slide, ld_slide_pre_clear, ld_slide_clear, 
					ld_pre_end, ld_end, ld_end_pre_clear, ld_end_clear,
					plot, x, y,
					bx_0, by_0,
					score);
					
	input clk, resetn, 
			ld_pre_welcome, ld_welcome, ld_welcome_pre_clear, ld_welcome_clear,
			ld_pre_run_one, ld_run_one, ld_run_one_pre_clear, ld_run_one_clear, 
			ld_pre_run_two, ld_run_two, ld_run_two_pre_clear, ld_run_two_clear,
			ld_pre_jump, ld_jump, ld_jump_pre_clear, ld_jump_clear,
			ld_pre_slide, ld_slide, ld_slide_pre_clear, ld_slide_clear,
			ld_pre_end, ld_end, ld_end_pre_clear, ld_end_clear;
	
	input [11:0] score;
	
	output reg plot;
	output reg [7:0] x;
	output reg [6:0] y;
	
	output [7:0] bx_0;
	output [6:0] by_0;
	
	wire [1711:0] welcome_x;
	wire [1497:0] welcome_y;					

	wire [535:0] W1x, W2x;
	wire [468:0] W1y, W2y;
	
	wire [319:0] WJx;
	wire [279:0] WJy;
	
	wire [303:0] WSx;
	wire [265:0] WSy;
	
	wire [1935:0] end_draw_x; // 1935 + 3*184 + 840
	wire [1693:0] end_draw_y; // 
	
	wire [31:0] block_x;
	wire [27:0] block_y;
	
	wire [7:0] bx0, bx1, bx2, bx3;
	wire [6:0] by0, by1, by2, by3;
	
	wire [2399:0] block_x_draw;
	wire [2099:0] block_y_draw;
	
	assign bx0 = block_x[31:24];
	assign bx1 = block_x[23:16];
	assign bx2 = block_x[15:8];
	assign bx3 = block_x[7:0];
	assign by0 = block_y[27:21];
	assign by1 = block_y[20:14];
	assign by2 = block_y[13:7];
	assign by3 = block_y[6:0];
	
	wire [183:0] score2_x_draw, score1_x_draw, score0_x_draw;
	wire [160:0] score2_y_draw, score1_y_draw, score0_y_draw;
	
	wire [439:0] score_x;
	wire [384:0] score_y;
	
	assign bx_0 = bx0;
	assign by_0 = by0;
//	(ld_pre_run_one | ld_pre_run_two | ld_pre_jump | ld_pre_slide)

	score_decoder s2(
						.clk(clk), 
						.number_x(8'd140),
						.number_y(7'd15),
						.number(score[11:8]),
						.score_x_draw(score2_x_draw),
						.score_y_draw(score2_y_draw)
						);
	
	score_decoder s1(
						.clk(clk), 
						.number_x(8'd146),
						.number_y(7'd15),
						.number(score[7:4]),
						.score_x_draw(score1_x_draw),
						.score_y_draw(score1_y_draw)
						);
	
	score_decoder s0(
						.clk(clk), 
						.number_x(8'd152),
						.number_y(7'd15),
						.number(score[3:0]),
						.score_x_draw(score0_x_draw),
						.score_y_draw(score0_y_draw)
						);
	
	Block B0(
			  .clk(clk), 
			  .resetn(resetn & ~ld_pre_welcome & ~ld_welcome), 
			  .enable(ld_pre_run_one | ld_pre_run_two | ld_pre_jump | ld_pre_slide),
			  .block_x(block_x), 
			  .block_y(block_y)
			  );
	
	RunOnePoints R1(
						.one_x(W1x),
						.one_y(W1y)
						);
						
	RunTwoPoints R2(
						.two_x(W2x),
						.two_y(W2y)
						);
						
	JumpPoints	RJ(
						.jump_x(WJx),
						.jump_y(WJy)
						);
	SlidePoints RS(
						.slide_x(WSx),
						.slide_y(WSy)
						);
						
	BlockPoints BP0(
				      .bx0(bx0), 
						.bx1(bx1), 
						.bx2(bx2), 
						.bx3(bx3), 
						.by0(by0), 
						.by1(by1), 
						.by2(by2), 
						.by3(by3), 
						.block_x_draw(block_x_draw), 
						.block_y_draw(block_y_draw)
						);
						
	WelcomePoints WP0(
						  .welcome_x(welcome_x), 
						  .welcome_y(welcome_y)
						  );
						  
	EndPoints EP0(
					 .end_draw_x(end_draw_x), 
					 .end_draw_y(end_draw_y)
					 );
	SmallerScorePoints SPS(
						.sx0(8'd139), 
						.sy0(7'd7), 
						.score_x(score_x), 
						.score_y(score_y));
						  

	
	wire [3927:0] one_draw_x, two_draw_x; 
	wire [3436:0] one_draw_y, two_draw_y; 
	
	wire [3711:0] jump_draw_x; 
	wire [3247:0] jump_draw_y; 
	

	wire [3695:0] slide_draw_x;
	wire [3233:0] slide_draw_y;
	
	wire [2927:0] real_end_x;
	wire [2561:0] real_end_y;

	assign one_draw_x = {block_x_draw, W1x, score2_x_draw, score1_x_draw, score0_x_draw, score_x};
	assign one_draw_y = {block_y_draw, W1y, score2_y_draw, score1_y_draw, score0_y_draw, score_y};
	
	assign two_draw_x = {block_x_draw, W2x, score2_x_draw, score1_x_draw, score0_x_draw, score_x};
	assign two_draw_y = {block_y_draw, W2y, score2_y_draw, score1_y_draw, score0_y_draw, score_y};
	
	assign jump_draw_x = {block_x_draw, WJx, score2_x_draw, score1_x_draw, score0_x_draw, score_x};
	assign jump_draw_y = {block_y_draw, WJy, score2_y_draw, score1_y_draw, score0_y_draw, score_y};
	
	assign slide_draw_x = {block_x_draw, WSx, score2_x_draw, score1_x_draw, score0_x_draw, score_x};
	assign slide_draw_y = {block_y_draw, WSy, score2_y_draw, score1_y_draw, score0_y_draw, score_y};
	
	assign real_end_x = {end_draw_x, score2_x_draw, score1_x_draw, score0_x_draw, score_x};
	assign real_end_y = {end_draw_y, score2_y_draw, score1_y_draw, score0_y_draw, score_y};
	
 
	
	
	reg [9:0] count_draw, count_clear;
	
	always @ (posedge clk) begin
        if (!resetn) begin
				plot <= 1'b0;
				count_draw <= 10'd0;
				count_clear <= 10'd0;

        end
		  
        else begin
		  
				if (ld_pre_welcome) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;
				end
				
				if (ld_welcome) begin
					plot <= 1'b1; 
					// draw GO!STICK-MAN// April 2, 2018 Mon. 21:02
					x <= welcome_x[count_draw*8 +: 8];
					y <= welcome_y[count_draw*7 +: 7];
					if (count_draw < 10'd213) begin
						count_draw <= count_draw + 10'd1;
					end
				end

				if (ld_welcome_pre_clear) begin
					plot <= 1'b1;
					count_clear <= 10'd0;

				end
				
				if (ld_welcome_clear) begin
					plot <= 1'b1; 
					// clear GO!STICK-MAN
					x <= welcome_x[count_clear*8 +: 8];
					y <= welcome_y[count_clear*7 +: 7];
					count_clear <= count_clear + 10'd1;
				end					
				
				
				
				// RUN 1
				if (ld_pre_run_one) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;

				end
				
				if (ld_run_one) begin
					plot <= 1'b1;
					x <= one_draw_x[count_draw*8 +: 8];
					y <= one_draw_y[count_draw*7 +: 7];
					count_draw <= count_draw + 10'd1;
				end

				if (ld_run_one_pre_clear) begin
					plot <= 1'b0;

					count_clear <= 10'd0;// April 2, 2018 Mon. 21:02
					
				end	
				
				if (ld_run_one_clear) begin
					plot <= 1'b1;
					x <= one_draw_x[count_clear*8 +: 8];
					y <= one_draw_y[count_clear*7 +: 7];
					count_clear <= count_clear + 10'd1;
				end			
				
				
				
				
				// RUN 2
				if (ld_pre_run_two) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;
				end	
				
				if (ld_run_two) begin
					plot <= 1'b1;
					x <= two_draw_x[count_draw*8 +: 8];
					y <= two_draw_y[count_draw*7 +: 7];
					count_draw <= count_draw + 10'd1;
				end
			
				if (ld_run_two_pre_clear) begin
					plot <= 1'b0;
					count_clear <= 10'd0;
				end				
				
				if (ld_run_two_clear) begin
					plot <= 1'b1;
					x <= two_draw_x[count_clear*8 +: 8];
					y <= two_draw_y[count_clear*7 +: 7];
					count_clear <= count_clear + 10'd1;
				end
				
	

	
				// JUMP
				if (ld_pre_jump) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;
				end

				if (ld_jump) begin
					plot <= 1'b1;
					x <= jump_draw_x[count_draw*8 +: 8];
					y <= jump_draw_y[count_draw*7 +: 7];
					count_draw <= count_draw + 10'd1;
				end
				
				if (ld_jump_pre_clear) begin
					plot <= 1'b0;
					count_clear <= 10'd0;
				end					
				
				if (ld_jump_clear) begin
					plot <= 1'b1;
					x <= jump_draw_x[count_clear*8 +: 8];
					y <= jump_draw_y[count_clear*7 +: 7];
					count_clear <= count_clear + 10'd1;
				end				
				
				
				
				
				// SLIDE
				if (ld_pre_slide) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;
				end
				
				if (ld_slide) begin
					plot <= 1'b1;
					x <= slide_draw_x[count_draw*8 +: 8];
					y <= slide_draw_y[count_draw*7 +: 7];
					count_draw <= count_draw + 10'd1;
				end
				
				if (ld_slide_pre_clear) begin
					plot <= 1'b0;
					count_clear <= 10'd0;
				end					

				if (ld_slide_clear) begin
					plot <= 1'b1;
					x <= slide_draw_x[count_clear*8 +: 8];
					y <= slide_draw_y[count_clear*7 +: 7];
					count_clear <= count_clear + 10'd1;
				end
				
				

				if (ld_pre_end) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;
				end
				
				if(ld_end) begin
					plot <= 1'b1;
					x <= real_end_x[count_draw*8 +: 8];
					y <= real_end_y[count_draw*7 +: 7];
					count_draw <= count_draw + 10'd1;
				end
				
				if (ld_end_pre_clear) begin
					plot <= 1'b0;
					count_draw <= 10'd0;
					count_clear <= 10'd0;
				end
				
				if(ld_end_clear) begin
					plot <= 1'b1;
					x <= real_end_x[count_clear*8 +: 8];
					y <= real_end_y[count_clear*7 +: 7];
					if (count_clear < 10'd365) begin
						count_clear <= count_clear + 10'd1;
					end
				end
				

        end
    end
	 

endmodule


// Points to draw for different states

module RunOnePoints(one_x, one_y);


	output [535:0] one_x; 
	output [468:0] one_y;
	
	
	assign one_x = {8'd10, 8'd10, 
						 8'd11, 8'd11, 8'd11, 8'd11,
						 8'd12, 8'd12, 8'd12, 8'd12, 8'd12, 8'd12, 8'd12, 8'd12, 8'd12,
						 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13,
						 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 
						 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15,
						 8'd16, 8'd16, 8'd16, 8'd16, 8'd16, 8'd16,
						 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17,
						 8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18,
						 8'd19, 8'd19, 8'd19
						 };
	
	assign one_y = {7'd78, 7'd79, //10
						 7'd63, 7'd64, 7'd76, 7'd77, //11
						 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd62, 7'd65, 7'd74, 7'd75, //12
						 7'd50, 7'd56, 7'd61, 7'd65, 7'd72, 7'd73, //13
						 7'd50, 7'd56, 7'd60, 7'd66, 7'd70, 7'd71, // 14
						 7'd50, 7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, //15
						 7'd50, 7'd56, 7'd60, 7'd67, 7'd70, 7'd71, // 16
						 7'd50, 7'd56, 7'd60, 7'd61, 7'd72, 7'd78, 7'd79, //17
						 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd62, 7'd73, 7'd76, 7'd77, //18
						 7'd63, 7'd74, 7'd75 // 19						 
						};
	

endmodule




module RunTwoPoints(two_x, two_y);
	output [535:0] two_x;
	output [468:0] two_y;
	
	assign two_x = {8'd12, 8'd12, 8'd12, 8'd12, 8'd12,
						 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13, 8'd13,
						 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 8'd14, 8'd14,
						 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15,
						 8'd16, 8'd16, 8'd16, 8'd16, 8'd16, 8'd16, 8'd16,
						 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17, 8'd17,						 
						 8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18
						 
						};
						
	assign two_y = {7'd51, 7'd52, 7'd53, 7'd54, 7'd55, //12
						 7'd50, 7'd56, 7'd61, 7'd62, 7'd63, 7'd64, 7'd65, 7'd76, 7'd77, 7'd78, 7'd79, //13
						 7'd50, 7'd56, 7'd60, 7'd66, 7'd70, 7'd71, 7'd72, 7'd73, 7'd74, 7'd75, //14
						 7'd50, 7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, //15
						 7'd50, 7'd56, 7'd60, 7'd70, 7'd71, 7'd78, 7'd79, //16
						 7'd50, 7'd56, 7'd61, 7'd62, 7'd63, 7'd64, 7'd65, 7'd72, 7'd73, 7'd74, 7'd75, 7'd76, 7'd77, //17
						 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd66 //18						 
						};
	
endmodule




module JumpPoints(jump_x, jump_y);
	output [319:0] jump_x;
	output [279:0] jump_y;
	
	assign jump_x = {8'd11, 
						  8'd12, 8'd12, 8'd12, 8'd12, 8'd12, 8'd12,
						  8'd13, 8'd13, 8'd13, 8'd13, 8'd13,
						  8'd14, 8'd14, 8'd14, 8'd14, 8'd14,
						  8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15,
						  8'd16, 8'd16, 8'd16, 8'd16, 8'd16,
						  8'd17, 8'd17, 8'd17, 8'd17, 8'd17,
						  8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18,
						  8'd19
						 };
						 
	assign jump_y = {7'd57, //11
						  7'd51, 7'd52, 7'd53, 7'd54, 7'd58, 7'd61, //12
						  7'd50, 7'd55, 7'd58, 7'd60, 7'd62, //13
						  7'd50, 7'd55, 7'd58, 7'd60, 7'd63, //14
						  7'd50, 7'd55, 7'd56, 7'd57, 7'd58, 7'd59, //15
						  7'd50, 7'd55, 7'd58, 7'd60, 7'd63, //16
						  7'd50, 7'd55, 7'd58, 7'd60, 7'd62, //17
						  7'd51, 7'd52, 7'd53, 7'd54, 7'd58, 7'd61, //18
						  7'd57 //19						  
						 };
	
endmodule




module SlidePoints(slide_x, slide_y);
	output [303:0] slide_x;
	output [265:0] slide_y;
	
	assign slide_x = {8'd11, 
							8'd12, 8'd12, 8'd12, 8'd12, 8'd12,
							8'd13, 8'd13, 8'd13, 8'd13, 
							8'd14, 8'd14, 8'd14, 8'd14, 8'd14,
							8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 8'd15, 
							8'd16, 8'd16, 8'd16, 8'd16,
							8'd17, 8'd17, 8'd17, 8'd17,
							8'd18, 8'd18, 8'd18, 8'd18, 8'd18, 8'd18,
							8'd19, 8'd19
						  };
	
	assign slide_y = {7'd76, //11
							7'd67, 7'd68, 7'd69, 7'd70, 7'd75, //12
							7'd66, 7'd71, 7'd74, 7'd77, //13
							7'd66, 7'd71, 7'd73, 7'd76, 7'd78, //14
							7'd66, 7'd71, 7'd72, 7'd73, 7'd74, 7'd75, 7'd79, //15
							7'd66, 7'd71, 7'd73, 7'd76, //16
							7'd66, 7'd71, 7'd73, 7'd77, //17
							7'd67, 7'd68, 7'd69, 7'd70, 7'd73, 7'd78, //18
							7'd73, 7'd79 //19
						  };
	
endmodule

// Points to draw GO!STICK-MAN
module WelcomePoints(welcome_x, welcome_y);
	// 217 points to draw
	output [1711:0] welcome_x;
	output [1497:0] welcome_y;
	
	assign welcome_x = {8'd48, 8'd48, 8'd48, 8'd48, 8'd48, 8'd48, 8'd48, 8'd48, 8'd48,  		  // G
							  8'd49, 8'd49,
							  8'd50, 8'd50, 8'd50, 
							  8'd51, 8'd51, 8'd51,
							  8'd52, 8'd52, 8'd52, 8'd52, 8'd52, 8'd52,
							  
							  8'd54, 8'd54, 8'd54, 8'd54, 8'd54, 8'd54, 8'd54, 8'd54, 8'd54,  		  // O
							  8'd55, 8'd55, 
							  8'd56, 8'd56,
							  8'd57, 8'd57, 
							  8'd58, 8'd58, 8'd58, 8'd58, 8'd58, 8'd58, 8'd58, 8'd58, 8'd58, 
							  
							  8'd61, 8'd61, 8'd61, 8'd61, 8'd61, 8'd61, 8'd61, 8'd61, 					  // !
							  
							  8'd64, 8'd64, 8'd64, 8'd64, 8'd64, 8'd64,										  // S
							  8'd65, 8'd65, 8'd65,
							  8'd66, 8'd66, 8'd66,
							  8'd67, 8'd67, 8'd67,
							  8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 
							  
							  8'd70, 																					  // T
							  8'd71, 
							  8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 
							  8'd73, 
							  8'd74, 
							  
							  8'd76, 8'd76, 8'd76, 8'd76, 8'd76, 8'd76, 8'd76, 8'd76, 8'd76,  		  // I
							  
							  8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 			  // C
							  8'd79, 8'd79, 
							  8'd80, 8'd80, 
							  8'd81, 8'd81, 
							  8'd82, 8'd82, 
							  
							  8'd84, 8'd84, 8'd84, 8'd84, 8'd84, 8'd84, 8'd84, 8'd84, 8'd84,  		  // K
							  8'd85, 8'd85, 
							  8'd86, 8'd86, 
							  8'd87, 8'd87, 
							  8'd88, 8'd88, 
							  
							  8'd89, 																					  // -
							  8'd90, 																					  // -
							  8'd91,																						  // -
							  
							  8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 					  // M
							  8'd95, 
							  8'd96, 8'd96, 8'd96, 8'd96, 8'd96, 8'd96, 8'd96, 
							  8'd97, 
							  8'd98, 8'd98, 8'd98, 8'd98, 8'd98, 8'd98, 8'd98, 
							  8'd99, 
							  8'd100, 8'd100, 8'd100, 8'd100, 8'd100, 8'd100, 8'd100, 8'd100, 
							  
							  8'd102, 8'd102, 8'd102, 8'd102, 8'd102, 8'd102, 8'd102, 					  // A
							  8'd103, 8'd103, 
							  8'd104, 8'd104,
							  8'd105, 8'd105, 
							  8'd106, 8'd106, 8'd106, 8'd106, 8'd106, 8'd106, 8'd106, 
							  
							  8'd108, 8'd108, 8'd108, 8'd108, 8'd108, 8'd108, 8'd108, 8'd108, 8'd108, // N
							  8'd109, 
							  8'd110, 8'd110, 8'd110, 8'd110, 8'd110, 8'd110, 
							  8'd111, 
							  8'd112, 8'd112, 8'd112, 8'd112, 8'd112, 8'd112, 8'd112, 8'd112, 8'd112
							 };
	
	
	assign welcome_y = {
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 48
							  7'd56, 7'd64, // 49
							  7'd56, 7'd60, 7'd64, //50
							  7'd56, 7'd60, 7'd64, //51
							  7'd56, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 52
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 54
							  7'd56, 7'd64, // 55
							  7'd56, 7'd64, // 56
							  7'd56, 7'd64, // 57
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 58
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd63, 7'd64, // 61
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd64, // 64
							  7'd56, 7'd60, 7'd64, //65
							  7'd56, 7'd60, 7'd64, //66
							  7'd56, 7'd60, 7'd64, //67
							  7'd56, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 68
							  7'd56, // 70
							  7'd56, // 71
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 72
							  7'd56, // 73
							  7'd56, // 74
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 76
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 78
							  7'd56, 7'd64, // 79
							  7'd56, 7'd64, // 80
							  7'd56, 7'd64, // 81
							  7'd56, 7'd64, // 82
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 84
							  7'd59, 7'd61, // 85
							  7'd58, 7'd62, // 86
							  7'd57, 7'd63, // 87
							  7'd56, 7'd64, // 88
							  7'd60, // 89
							  7'd60, // 90
							  7'd60, // 91
							  7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 94
							  7'd56, //95
							  7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, // 96
							  7'd64, 
							  7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, // 98
							  7'd56, // 99
							  7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 100
							  7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 102
							  7'd57, 7'd61, // 103
							  7'd56, 7'd61, // 104
							  7'd57, 7'd61, // 105
							  7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 106
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, // 108
							  7'd56, // 109
							  7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, // 110
							  7'd63, // 111
							  7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64 // 112
							  };
	
endmodule


module BlockPoints(bx0, bx1, bx2, bx3, by0, by1, by2, by3, block_x_draw, block_y_draw);
	input [7:0] bx0, bx1, bx2, bx3;
	input [6:0] by0, by1, by2, by3;
	
	output [2399:0] block_x_draw;
	output [2099:0] block_y_draw;
	
	assign block_x_draw = {bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //0
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //1
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //2
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //3
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //4
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //5
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //6
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //7
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //8
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //9
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //10
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //11
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //12
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //13
								  bx0, (bx0 + 8'd1),  (bx0 + 8'd2),  (bx0 + 8'd3),  (bx0 + 8'd4), //14

								  
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //0
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //1
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //2
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //3
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //4
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //5
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //6
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //7
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //8
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //9
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //10
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //11
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //12
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //13
								  bx1, (bx1 + 8'd1),  (bx1 + 8'd2),  (bx1 + 8'd3),  (bx1 + 8'd4), //14
								  
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //0
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //1
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //2
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //3
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //4
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //5
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //6
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //7
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //8
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //9
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //10
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //11
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //12
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //13
								  bx2, (bx2 + 8'd1),  (bx2 + 8'd2),  (bx2 + 8'd3),  (bx2 + 8'd4), //14
								  
								   
								  
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //0
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //1
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //2
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //3
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //4
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //5
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //6
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //7
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //8
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //9
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //10
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //11
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //12
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4), //13
								  bx3, (bx3 + 8'd1),  (bx3 + 8'd2),  (bx3 + 8'd3),  (bx3 + 8'd4)  //14
								 };
								 
	assign block_y_draw = { by0, by0, by0, by0, by0, 
									(by0 + 7'd1),  (by0 + 7'd1), (by0 + 7'd1), (by0 + 7'd1), (by0 + 7'd1), 
									(by0 + 7'd2),  (by0 + 7'd2), (by0 + 7'd2), (by0 + 7'd2), (by0 + 7'd2),  
									(by0 + 7'd3),  (by0 + 7'd3), (by0 + 7'd3), (by0 + 7'd3), (by0 + 7'd3),
									(by0 + 7'd4),  (by0 + 7'd4), (by0 + 7'd4), (by0 + 7'd4), (by0 + 7'd4), 
									(by0 + 7'd5),  (by0 + 7'd5), (by0 + 7'd5), (by0 + 7'd5), (by0 + 7'd5), 
									(by0 + 7'd6),  (by0 + 7'd6), (by0 + 7'd6), (by0 + 7'd6), (by0 + 7'd6), 
									(by0 + 7'd7),  (by0 + 7'd7), (by0 + 7'd7), (by0 + 7'd7), (by0 + 7'd7),  
									(by0 + 7'd8),  (by0 + 7'd8), (by0 + 7'd8), (by0 + 7'd8), (by0 + 7'd8), 
									(by0 + 7'd9),  (by0 + 7'd9), (by0 + 7'd9), (by0 + 7'd9), (by0 + 7'd9), 
								   (by0 + 7'd10), (by0 + 7'd10), (by0 + 7'd10), (by0 + 7'd10), (by0 + 7'd10),
									(by0 + 7'd11), (by0 + 7'd11), (by0 + 7'd11), (by0 + 7'd11), (by0 + 7'd11), 
									(by0 + 7'd12), (by0 + 7'd12), (by0 + 7'd12), (by0 + 7'd12), (by0 + 7'd12), 
									(by0 + 7'd13), (by0 + 7'd13), (by0 + 7'd13), (by0 + 7'd13), (by0 + 7'd13), 
									(by0 + 7'd14), (by0 + 7'd14), (by0 + 7'd14), (by0 + 7'd14), (by0 + 7'd14), 
								  
	
									by1, by1, by1, by1, by1, 
									(by1 + 7'd1),  (by1 + 7'd1), (by1 + 7'd1), (by1 + 7'd1), (by1 + 7'd1), 
									(by1 + 7'd2),  (by1 + 7'd2), (by1 + 7'd2), (by1 + 7'd2), (by1 + 7'd2),  
									(by1 + 7'd3),  (by1 + 7'd3), (by1 + 7'd3), (by1 + 7'd3), (by1 + 7'd3),
									(by1 + 7'd4),  (by1 + 7'd4), (by1 + 7'd4), (by1 + 7'd4), (by1 + 7'd4), 
									(by1 + 7'd5),  (by1 + 7'd5), (by1 + 7'd5), (by1 + 7'd5), (by1 + 7'd5), 
									(by1 + 7'd6),  (by1 + 7'd6), (by1 + 7'd6), (by1 + 7'd6), (by1 + 7'd6), 
									(by1 + 7'd7),  (by1 + 7'd7), (by1 + 7'd7), (by1 + 7'd7), (by1 + 7'd7),  
									(by1 + 7'd8),  (by1 + 7'd8), (by1 + 7'd8), (by1 + 7'd8), (by1 + 7'd8), 
									(by1 + 7'd9),  (by1 + 7'd9), (by1 + 7'd9), (by1 + 7'd9), (by1 + 7'd9), 
								   (by1 + 7'd10), (by1 + 7'd10), (by1 + 7'd10), (by1 + 7'd10), (by1 + 7'd10),
									(by1 + 7'd11), (by1 + 7'd11), (by1 + 7'd11), (by1 + 7'd11), (by1 + 7'd11), 
									(by1 + 7'd12), (by1 + 7'd12), (by1 + 7'd12), (by1 + 7'd12), (by1 + 7'd12), 
									(by1 + 7'd13), (by1 + 7'd13), (by1 + 7'd13), (by1 + 7'd13), (by1 + 7'd13), 
									(by1 + 7'd14), (by1 + 7'd14), (by1 + 7'd14), (by1 + 7'd14), (by1 + 7'd14), 
								  
								   by2, by2, by2, by2, by2, 
									(by2 + 7'd1),  (by2 + 7'd1), (by2 + 7'd1), (by2 + 7'd1), (by2 + 7'd1), 
									(by2 + 7'd2),  (by2 + 7'd2), (by2 + 7'd2), (by2 + 7'd2), (by2 + 7'd2),  
									(by2 + 7'd3),  (by2 + 7'd3), (by2 + 7'd3), (by2 + 7'd3), (by2 + 7'd3),
									(by2 + 7'd4),  (by2 + 7'd4), (by2 + 7'd4), (by2 + 7'd4), (by2 + 7'd4), 
									(by2 + 7'd5),  (by2 + 7'd5), (by2 + 7'd5), (by2 + 7'd5), (by2 + 7'd5), 
									(by2 + 7'd6),  (by2 + 7'd6), (by2 + 7'd6), (by2 + 7'd6), (by2 + 7'd6), 
									(by2 + 7'd7),  (by2 + 7'd7), (by2 + 7'd7), (by2 + 7'd7), (by2 + 7'd7),  
									(by2 + 7'd8),  (by2 + 7'd8), (by2 + 7'd8), (by2 + 7'd8), (by2 + 7'd8), 
									(by2 + 7'd9),  (by2 + 7'd9), (by2 + 7'd9), (by2 + 7'd9), (by2 + 7'd9), 
								   (by2 + 7'd10), (by2 + 7'd10), (by2 + 7'd10), (by2 + 7'd10), (by2 + 7'd10),
									(by2 + 7'd11), (by2 + 7'd11), (by2 + 7'd11), (by2 + 7'd11), (by2 + 7'd11), 
									(by2 + 7'd12), (by2 + 7'd12), (by2 + 7'd12), (by2 + 7'd12), (by2 + 7'd12), 
									(by2 + 7'd13), (by2 + 7'd13), (by2 + 7'd13), (by2 + 7'd13), (by2 + 7'd13), 
									(by2 + 7'd14), (by2 + 7'd14), (by2 + 7'd14), (by2 + 7'd14), (by2 + 7'd14), 
								  
								  
								   by3, by3, by3, by3, by3, 
									(by3 + 7'd1),  (by3 + 7'd1), (by3 + 7'd1), (by3 + 7'd1), (by3 + 7'd1), 
									(by3 + 7'd2),  (by3 + 7'd2), (by3 + 7'd2), (by3 + 7'd2), (by3 + 7'd2),  
									(by3 + 7'd3),  (by3 + 7'd3), (by3 + 7'd3), (by3 + 7'd3), (by3 + 7'd3),
									(by3 + 7'd4),  (by3 + 7'd4), (by3 + 7'd4), (by3 + 7'd4), (by3 + 7'd4), 
									(by3 + 7'd5),  (by3 + 7'd5), (by3 + 7'd5), (by3 + 7'd5), (by3 + 7'd5), 
									(by3 + 7'd6),  (by3 + 7'd6), (by3 + 7'd6), (by3 + 7'd6), (by3 + 7'd6), 
									(by3 + 7'd7),  (by3 + 7'd7), (by3 + 7'd7), (by3 + 7'd7), (by3 + 7'd7),  
									(by3 + 7'd8),  (by3 + 7'd8), (by3 + 7'd8), (by3 + 7'd8), (by3 + 7'd8), 
									(by3 + 7'd9),  (by3 + 7'd9), (by3 + 7'd9), (by3 + 7'd9), (by3 + 7'd9), 
								   (by3 + 7'd10), (by3 + 7'd10), (by3 + 7'd10), (by3 + 7'd10), (by3 + 7'd10),
									(by3 + 7'd11), (by3 + 7'd11), (by3 + 7'd11), (by3 + 7'd11), (by3 + 7'd11), 
									(by3 + 7'd12), (by3 + 7'd12), (by3 + 7'd12), (by3 + 7'd12), (by3 + 7'd12), 
									(by3 + 7'd13), (by3 + 7'd13), (by3 + 7'd13), (by3 + 7'd13), (by3 + 7'd13), 
									(by3 + 7'd14), (by3 + 7'd14), (by3 + 7'd14), (by3 + 7'd14), (by3 + 7'd14)
								 };
	
endmodule


// 242 pixels to draw "GAME OVER"
module EndPoints(end_draw_x, end_draw_y);
	output [1935:0] end_draw_x;
	output [1693:0] end_draw_y;
	
	assign end_draw_x = {8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 8'd62, 
								8'd63, 8'd63, 8'd63, 8'd63, 
								8'd64, 8'd64, 8'd64, 8'd64,
								8'd65, 8'd65, 8'd65, 8'd65, 8'd65,
								8'd66, 8'd66, 8'd66, 8'd66, 8'd66,
								8'd67, 8'd67, 8'd67, 8'd67, 8'd67,
								8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 8'd68, 
								8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 8'd72, 
								8'd73, 8'd73, 8'd73, 
								8'd74, 8'd74, 8'd74, 
								8'd75, 8'd75, 8'd75, 
								8'd76, 8'd76, 8'd76, 
								8'd77, 8'd77, 8'd77, 
								8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 8'd78, 
								8'd82, 8'd82, 8'd82, 8'd82, 8'd82, 8'd82, 8'd82, 8'd82, 8'd82, 8'd82, 
								8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 8'd83, 
								8'd84, 8'd84, 8'd84, 8'd84, 
								8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 8'd85, 
								8'd86, 8'd86, 8'd86, 8'd86,
								8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 8'd87, 
								8'd88, 8'd88, 8'd88, 8'd88, 
								8'd89, 8'd89, 8'd89, 8'd89, 
								8'd90, 8'd90, 8'd90, 8'd90, 8'd90, 8'd90, 8'd90, 8'd90, 8'd90, 8'd90, 
								8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 8'd94, 
								8'd95, 8'd95, 8'd95, 8'd95, 8'd95, 8'd95, 
								8'd96, 8'd96, 8'd96, 8'd96, 8'd96, 8'd96, 
								8'd97, 8'd97, 8'd97, 8'd97, 8'd97, 8'd97, 
								8'd98, 8'd98, 8'd98, 8'd98, 8'd98, 8'd98, 
								8'd99, 8'd99, 8'd99, 8'd99, 8'd99, 8'd99, 
								8'd100, 8'd100, 8'd100, 8'd100, 8'd100, 8'd100								
							  };
	
	assign end_draw_y = {7'd48, 7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, 7'd71, 7'd72, 7'd73, //62
								7'd48, 7'd58, 7'd63, 7'd73, //63
								7'd48, 7'd58, 7'd63, 7'd73, //64
							   7'd48, 7'd53, 7'd58, 7'd63, 7'd73, //65
								7'd48, 7'd53, 7'd58, 7'd63, 7'd73, //66
								7'd48, 7'd53, 7'd58, 7'd63, 7'd73, //67
								7'd48, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, 7'd71, 7'd72, 7'd73, //68
								7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, //72
								7'd49, 7'd53, 7'd71, //73
								7'd48, 7'd53, 7'd72, //74
								7'd47, 7'd53, 7'd73, //75
								7'd48, 7'd53, 7'd72, //76
								7'd49, 7'd53, 7'd71, //77
								7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, //78
								7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, //82
								7'd48, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, 7'd71, 7'd72, 7'd73, //83
								7'd48, 7'd63, 7'd68, 7'd73, //84
							   7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd63, 7'd68, 7'd73, //85
								7'd58, 7'd63, 7'd68, 7'd73, //86
								7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd63, 7'd68, 7'd73, //87
								7'd48, 7'd63, 7'd68, 7'd73, //88
								7'd48, 7'd63, 7'd68, 7'd73, //89
								7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, //90
								7'd48, 7'd49, 7'd50, 7'd51, 7'd52, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, 7'd71, 7'd72, 7'd73, //94
								7'd48, 7'd53, 7'd58, 7'd63, 7'd68, 7'd69, //95
								7'd48, 7'd53, 7'd58, 7'd63, 7'd68, 7'd70, //96
								7'd48, 7'd53, 7'd58, 7'd63, 7'd68, 7'd71, //97
								7'd48, 7'd53, 7'd58, 7'd63, 7'd68, 7'd72, //98
								7'd48, 7'd53, 7'd58, 7'd64, 7'd67, 7'd73, //99
								7'd48, 7'd53, 7'd58, 7'd65, 7'd66, 7'd73 //100
							  };
endmodule






module FrameDelayCounter (clk, resetn, enable, r, start);
	input resetn, clk, enable;
	input [24:0] start;
	output r;
	reg [24:0] fdc;
	
	always @ (posedge clk) begin
		if (!resetn | fdc == 25'd0) begin
			fdc <= start;		
		end
		
		else if (fdc > 25'd0 && enable == 1'b1) begin
			fdc <= fdc - 25'd1;
	   end
		 
	end
	
	assign r = (fdc == 25'd0) ? 1'b1 : 1'b0;
	 
endmodule



module CharacterPos(current_state, char_y_top, char_y_bottom);
	input [4:0] current_state;
	output reg [6:0] char_y_top, char_y_bottom;
	
	always@(*) begin

			
		if ((current_state == 5'd14) | (current_state == 5'd15) | (current_state == 5'd12) | (current_state == 5'd13))  begin // jump state
			char_y_top <= 7'd50;
			char_y_bottom <= 7'd63;
		end
			
		else if ((current_state == 5'd18) | (current_state == 5'd19) | (current_state == 5'd16) | (current_state == 5'd17)) begin // slide state
			char_y_top <= 7'd66;
			char_y_bottom <= 7'd79;
		end
		
		else begin
		  char_y_top <= 7'd50;
		  char_y_bottom <= 7'd79;
		end
			
			
	
	end 
	
endmodule



module Block(clk, resetn, enable, block_x, block_y);

	input clk, resetn, enable;
	// simulates 4 blocks displayinh on the VGA
	// block_x [31:24 | 23:16 | 15:8 | 7:0 ], 8-bit each
	// block_y [27:21 | 20:14 | 13:7 | 6:0 ], 7-bit each
	// initially, x:0, 40, 80, 120
	//            y:127, 65, 40,40
	output reg [31:0] block_x;
	output reg [27:0] block_y;
	wire [3:0] random_out;
	
	always@(posedge clk) begin
		if(!resetn) begin
			block_x <= {8'd50, 8'd90, 8'd130, 8'd170};
			block_y <= {7'd65, 7'd40, 7'd65, 7'd40}; // initially, don't display the leftmost block
		end
		
		else begin
			if (enable == 1'b1) begin
				if ((block_x[31:24] - 8'd6) > 8'd249) begin
					block_x[31:0] <= {block_x[23:16] - 8'd6, block_x[15:8] - 8'd6, block_x[7:0] - 8'd6, block_x[23:16] + 8'd114} ;
					
					block_y[27:7] <= block_y[20:0];
					if (random_out[0])
						block_y[6:0] <= 7'd40;
					else
						block_y[6:0] <= 7'd65;
				end
				
				else begin 
					block_x <= {block_x[31:24] - 8'd6, block_x[23:16] - 8'd6, block_x[15:8] - 8'd6, block_x[7:0] - 8'd6};
				end
			end
		end
			
	end
	
	RandomPos RD0(
					 .out(random_out),
					 .clk(clk),
					 .resetn(resetn)
					 );
endmodule


// hex_decoder - from Lab 2 Part 3
module hex_decoder(in, out);
    input [3:0] in; //Switch
    output [6:0] out; //output
  
    assign out[0] = (~in[3] & ~in[2] & ~in[1] & in[0]) | (~in[3] & in[2] & ~in[1] & ~in[0]) | (in[3] & ~in[2] & in[1] & in[0]) | (in[3] & in[2] & ~in[1] & in[0]);
    assign out[1] = (~in[3] & in[2] & (in[1] ^ in[0]) ) | (in[3] & in[2] & (in[1] | ~in[0])) | (in[3] & in[1] & in[0]);
    assign out[2] = (in[3] & in[2] & (in[1] | ~in[0]))  |   (~(in[3] ^ in[2]) & in[1] & ~in[0]); 
    assign out[3] =  (~in[2] & ~in[1] & in[0]) | (~in[3] & in[2] & ~(in[1] ^ in[0])) |(in[2] & in[1] & in[0]) | (in[3] & ~in[2] & (in[1] ^ in[0]));
    assign out[4] =  (~in[3] & in[0]) | (~in[3] & in[2] & ~in[1] & ~in[0]) | (in[3] & ~in[2] & ~in[1] & in[0]);
    assign out[5] =  (~in[3] & ~in[2] & (in[1] | in[0])) |  (~ in[3] & in[1] & in[0]) | (~(in[3] ^ in[2] ) & ~in[1] & in[0]);
    assign out[6] = (~in[3] & ~in[2] & ~in[1]) | (~in[3] & in[2] & in[1] & in[0]) | (in[3] & in[2] & ~in[1] & ~in[0]);

endmodule


// Generates random position for block_y (up:40 / down :65)
module RandomPos(out, clk, resetn);

	output reg [3:0] out;
   input clk, resetn;

   wire feedback;

   assign feedback = ~(out[3] ^ out[2]);

   always @(posedge clk) begin
		if (!resetn)
			out = 4'b0;
		else
			out = {out[2:0],feedback};
	end
endmodule


module score_decoder(
	input clk, 
	input [7:0] number_x,
	input [6:0] number_y,
	input [3:0] number,
	output reg [183:0] score_x_draw,
	output reg [160:0] score_y_draw
);
	always @ (posedge clk) begin
		case(number)
		
			4'd0: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, number_x, number_x, number_x,
						(number_x + 8'd1), (number_x + 8'd1),
						(number_x + 8'd2), (number_x + 8'd2),
						(number_x + 8'd3), (number_x + 8'd3),
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4),
						number_x//extra 1 pixel //only 20 -  lacking 3 pixels! Preblem Fixed : April 2, 2018
						};
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						number_y, (number_y + 7'd9),
						number_y, (number_y + 7'd9),
						number_y, (number_y + 7'd9),
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						
						(number_y + 7'd1) //extra 1 pixel
						};
			end
				
			4'd1: begin
					score_x_draw = {
						(number_x + 8'd1), (number_x + 8'd1),
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), 
						(number_x + 8'd3), 
						
						//extra 10 pixels
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2)
						};
						
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd9), 
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), (number_y + 7'd9), 
						(number_y + 7'd9),
						
						//extra 10 pixels
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), (number_y + 7'd9)
						};
			end
				
			4'd2: begin
					score_x_draw = {
						number_x, number_x, number_x, 
						(number_x + 8'd1), (number_x + 8'd1), (number_x + 8'd1),
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2),
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3),
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4),
						
						number_x, number_x, number_x, 
						(number_x + 8'd1), (number_x + 8'd1)//extra 5 pixels
						};
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd8), (number_y + 7'd9), 
						number_y, (number_y + 7'd7), (number_y + 7'd9), 
						number_y, (number_y + 7'd6), (number_y + 7'd9), 
						number_y, (number_y + 7'd5), (number_y + 7'd9), 
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd8), (number_y + 7'd9),
						
						(number_y + 7'd1), (number_y + 7'd8), (number_y + 7'd9), 
						number_y, (number_y + 7'd7) //extra 5 pixels
						};
			end
				
			4'd3: begin
					score_x_draw = {
						number_x, number_x,
						(number_x + 8'd1), (number_x + 8'd1),
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2),
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3),
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4),  //FIxed problem: 122 -> 222, 133-> 333
						
						//extra 6 pixels
						number_x, number_x,
						(number_x + 8'd1), (number_x + 8'd1),
						(number_x + 8'd1), (number_x + 8'd2)
						};
						
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd8), 
						number_y, (number_y + 7'd9), 
						number_y, (number_y + 7'd4), (number_y + 7'd9), 
						number_y, (number_y + 7'd4), (number_y + 7'd9), 
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), 
						
						//extra 6 pixels
						(number_y + 7'd1), (number_y + 7'd8), 
						number_y, (number_y + 7'd9), 
						number_y, (number_y + 7'd4)
						};
			end
				
			4'd4: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, number_x, 
						(number_x + 8'd1), 
						(number_x + 8'd2), 
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3),
						(number_x + 8'd4),
						
						//extra 4 pixels
						number_x, number_x, number_x, number_x
						};
						
					score_y_draw = {
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), 
						(number_y + 7'd5), 
						(number_y + 7'd5),
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), (number_y + 7'd9), 
						(number_y + 7'd5), 
						
						//extra 4 pixels
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3)
						};
			end
				
			4'd5: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, number_x,
						(number_x + 8'd1), (number_x + 8'd1), (number_x + 8'd1), 
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), 
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), 
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), 
						
						//extra 3 pixels
						number_x, number_x, number_x
						};
						
					score_y_draw = {
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd9),
						number_y, (number_y + 7'd4), (number_y + 7'd9), 
						number_y, (number_y + 7'd4), (number_y + 7'd9),
						number_y, (number_y + 7'd4), (number_y + 7'd9),
						number_y, (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						
						//extra 3 pixels
						number_y, (number_y + 7'd1), (number_y + 7'd2)
						};
			end
			
			4'd6: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, number_x, number_x, number_x, 
						(number_x + 8'd1), (number_x + 8'd1), (number_x + 8'd1), 
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), 
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), 
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), 
						
						//extra 1 pixel
						number_x
						};
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), 
						number_y, (number_y + 7'd4), (number_y + 7'd9),
						number_y, (number_y + 7'd4), (number_y + 7'd9),
						number_y, (number_y + 7'd4), (number_y + 7'd9),
						(number_y + 7'd1), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						
						//extra 1 pixel
						(number_y + 7'd1)
						};
			end

			4'd7: begin
					score_x_draw = {
						number_x, number_x, 
						(number_x + 8'd1), 
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), 
						(number_x + 8'd3), (number_x + 8'd3), 
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), 
						
						//extra 8 pixels
						number_x, number_x, 
						(number_x + 8'd1), 
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2)
						};
					
					score_y_draw = {
						number_y, (number_y + 7'd1), 
						number_y,
						number_y, (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), (number_y + 7'd9), 
						number_y, (number_y + 7'd4),
						number_y, (number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), 
						
						//extra 8 pixels
						number_y, (number_y + 7'd1), 
						number_y,
						number_y, (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8)
						};
			end
			
			4'd8: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, number_x, number_x, 
						(number_x + 8'd1), (number_x + 8'd1), (number_x + 8'd1), 
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), 
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), 
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4)
						}; // no extre pixels
						
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8), 
						number_y, (number_y + 7'd4), (number_y + 7'd9), 
						number_y, (number_y + 7'd4), (number_y + 7'd9), 
						number_y, (number_y + 7'd4), (number_y + 7'd9), 
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8)						
						}; // no extre pixels
			end
				
			4'd9: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, 
						(number_x + 8'd1), (number_x + 8'd1), (number_x + 8'd1), 
						(number_x + 8'd2), (number_x + 8'd2), (number_x + 8'd2), 
						(number_x + 8'd3), (number_x + 8'd3), (number_x + 8'd3), 
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), 
						
						//extra 1 pixel
						number_x
						};
						
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd8), 
						number_y, (number_y + 7'd5), (number_y + 7'd9), 
						number_y, (number_y + 7'd5), (number_y + 7'd9),
						number_y, (number_y + 7'd5), (number_y + 7'd9),
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						
						//extra 1 pixel
						(number_y + 7'd1)
						};
			end
				
			default: begin
					score_x_draw = {
						number_x, number_x, number_x, number_x, number_x, number_x, number_x, number_x,
						(number_x + 8'd1), (number_x + 8'd1),
						(number_x + 8'd2), (number_x + 8'd2),
						(number_x + 8'd3), (number_x + 8'd3),
						(number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4), (number_x + 8'd4),
						number_x//extra 1 pixel //only 20 -  lacking 3 pixels! Preblem Fixed : April 2, 2018
						};
					score_y_draw = {
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						number_y, (number_y + 7'd9),
						number_y, (number_y + 7'd9),
						number_y, (number_y + 7'd9),
						(number_y + 7'd1), (number_y + 7'd2), (number_y + 7'd3), (number_y + 7'd4), (number_y + 7'd5), (number_y + 7'd6), (number_y + 7'd7), (number_y + 7'd8),
						
						(number_y + 7'd1) //extra 1 pixel
						};
			end
			
		endcase
	end

endmodule

// Display smaller  "SCORE", 55 pixels
module SmallerScorePoints(sx0, sy0, score_x, score_y);
	input [7:0] sx0;
	input [6:0] sy0;
	output [439:0] score_x;
	output [384:0] score_y;
	
	assign score_x = {
						   sx0, sx0, sx0, sx0, 																			// S
							(sx0 + 8'd1), (sx0 + 8'd1), (sx0 + 8'd1), 
							(sx0 + 8'd2), (sx0 + 8'd2), (sx0 + 8'd2), (sx0 + 8'd2), 
							
							(sx0 + 8'd4), (sx0 + 8'd4), (sx0 + 8'd4), (sx0 + 8'd4), (sx0 + 8'd4),  		// C
							(sx0 + 8'd5), (sx0 + 8'd5), 			
							(sx0 + 8'd6), (sx0 + 8'd6), 
							
							(sx0 + 8'd8), (sx0 + 8'd8), (sx0 + 8'd8), (sx0 + 8'd8), (sx0 + 8'd8),      // O		
							(sx0 + 8'd9), (sx0 + 8'd9), 
							(sx0 + 8'd10), (sx0 + 8'd10), (sx0 + 8'd10), (sx0 + 8'd10), (sx0 + 8'd10),
							
							(sx0 + 8'd12), (sx0 + 8'd12), (sx0 + 8'd12), (sx0 + 8'd12), (sx0 + 8'd12), // R
							(sx0 + 8'd13), (sx0 + 8'd13), (sx0 + 8'd13),
							(sx0 + 8'd14), (sx0 + 8'd14), (sx0 + 8'd14), (sx0 + 8'd14), 

							(sx0 + 8'd16), (sx0 + 8'd16), (sx0 + 8'd16), (sx0 + 8'd16), (sx0 + 8'd16), // E
							(sx0 + 8'd17), (sx0 + 8'd17), (sx0 + 8'd17), 
							(sx0 + 8'd18), (sx0 + 8'd18), (sx0 + 8'd18)							
						  };
						  
	assign score_y = { 
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd4), // sx0 + 0
							sy0, (sy0 + 7'd2), (sy0 + 7'd4),  // sx0 + 1
							sy0, (sy0 + 7'd2), (sy0 + 7'd3),(sy0 + 7'd4), // sx0 + 2
							
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd3), (sy0 + 7'd4),   // sx0 + 4
							sy0, (sy0 + 7'd4), // sx0 + 5
							sy0, (sy0 + 7'd4), // sx0 + 6
							
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd3), (sy0 + 7'd4), // sx0 + 8
							sy0, (sy0 + 7'd4), // sx0 + 9
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd3), (sy0 + 7'd4), // sx0 + 10
							
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd3), (sy0 + 7'd4), // sx0 + 12
							sy0, (sy0 + 7'd2), (sy0 + 7'd3), // sx0 + 13
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd4), // sx0 + 14
							
							sy0, (sy0 + 7'd1), (sy0 + 7'd2), (sy0 + 7'd3), (sy0 + 7'd4), // sx0 + 16
							sy0, (sy0 + 7'd2), (sy0 + 7'd4), // sx0 + 17
							sy0, (sy0 + 7'd2), (sy0 + 7'd4)  // sx0 + 18						
						  };

endmodule


