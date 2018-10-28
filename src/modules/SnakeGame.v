// top level module

module SnakeGame (
	// input from joystick
	input wire clk, // 50MHz
	input reset,
	input color, // swap between 2 outputs
	////////////////////	VGA ////////////////////////////
	output	VGA_HS,							//	VGA H_SYNC
	output	VGA_VS,							//	VGA V_SYNC
	output	VGA_R,   						//	VGA Red
	output	VGA_G,	 						//	VGA Green
	output	VGA_B 						   //	VGA Blue
);

	///////////////////CLOCK ADJUSTMENT//////////////////
	wire gl_clk;
	
	glob_clk global_clock (
		.inclk0 (clk),
		.c0 (gl_clk) // clk for VGA
	);	

	//////////////////////GAME LOGIC/////////////////////
	wire read_write_mem_sig, calc_finished;
	wire [1:0] dir = `TOP_DIR; // TODO: process input from joystick
	wire [`WORD_MSB:0]
		snake_head,
		apple,
		tail_pos,
		new_tail_pos;
		
	wire [`MSB_NUM_TAILS:0]
		tails_count,
		tail_addr_logic;
	
	game_logic game_proc (
		.direction (dir),
		
		.clk (gl_clk),
		
		.tail_value (tail_pos),
		
		.snake_head_pos (snake_head),
		.apple_pos (apple),
		.num_tails (tails_count),
		
		.new_tail_value (new_tail_pos),
		
		.value_addr (tail_addr_logic),
		
		.read_write_mem (read_write_mem_sig),
		.is_calc_finished (calc_finished)
	);
	
	snake_memory game_mem (
		.read_write_sig ((read_write_mem_sig & ~calc_finished) | calc_finished),
		
		.value_addr (((calc_finished) ? tail_address_tran : tail_addr_logic)),
		
		.new_value (new_tail_pos),
		
		.snake_head_pos (snake_head),
		.apple_pos (apple),
		
		.num_tails (tails_count),
		
		.value (tail_pos)
	);
	
	//////////////////////// TRANSLATION ////////////////////
	wire [0:1] cur_ent_code;
	wire [`WORD_MSB:0] tail_address_tran;
	//wire trans_fin;
	
	coord2grid_translator trans (
		.inX (mVGA_X),
		.inY (mVGA_Y),

		.calculation_finished (gl_clk),

		.num_tails (tails_count),

		.snake_head_pos (snake_head),
		.apple_pos (apple),
		.cur_tail_pos (tail_pos),
	
		.value_addr (tail_address_tran),

		.entity_code (cur_ent_code),
		//.translation_finished (trans_fin)
	);
	
	////////////////////////	VGA	////////////////////
	wire	[9:0]	mVGA_X;
	wire	[9:0]	mVGA_Y;
	wire	mVGA_R;
	wire	mVGA_G;
	wire	mVGA_B;

	wire	sVGA_R;
	wire	sVGA_G;
	wire	sVGA_B;

	assign	VGA_R	=	sVGA_R;
	assign	VGA_G	=	sVGA_G;
	assign	VGA_B	=	sVGA_B;
	
	VGA_Ctrl	u2 // Setting up VGA Signal
			(	//	Host Side
				.oCurrent_X(mVGA_X),
				.oCurrent_Y(mVGA_Y),
				.iRed(mVGA_R),
				.iGreen(mVGA_G),
				.iBlue(mVGA_B),
				//	VGA Side
				.oVGA_R(sVGA_R),
				.oVGA_G(sVGA_G),
				.oVGA_B(sVGA_B),
				.oVGA_HS(VGA_HS),
				.oVGA_VS(VGA_VS),
				.oVGA_SYNC(),
				.oVGA_BLANK(),
				.oVGA_CLOCK(),
				//	Control Signal
				.iCLK(gl_clk),
				.reset(reset)
			);
	
	VGA_Pattern	u3 // Drawing
			(	//	Read Out Side
				.oRed(mVGA_R),
				.oGreen(mVGA_G),
				.oBlue(mVGA_B),
				.iVGA_X(mVGA_X),
				.iVGA_Y(mVGA_Y),
				.iVGA_CLK(gl_clk),
				//	Control Signals
				.reset(reset),
				.iColor_SW(color),
				.ent(cur_ent_code)
			);

endmodule
