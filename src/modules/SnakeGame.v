// top level module
`include "../definitions/define.vh"

module SnakeGame (
	input wire
		left_pin,
		right_pin,
		top_pin,
		down_pin,
	
	input wire clk, // 50MHz
	
	//////////////////// VGA ////////////////////////////
	input wire
		reset,
		color, // swap between 2 outputs
	
	output wire
		VGA_HS, // VGA H_SYNC
		VGA_VS, // VGA V_SYNC
		VGA_R,  // VGA Red
		VGA_G,  // VGA Green
		VGA_B   // VGA Blue
	
	, output wire [0:1] dir_out // TODO: for debug
);
	wire vga_clk;
	
	VGA_clk vga_clk_gen (
		clk,
		vga_clk
	);
	
	wire [0:1] dir;
	
	buttons buttons_input (
		//.clk(vga_clk),
		.left(left_pin),
		.right(right_pin),
		.up(top_pin),
		.down(down_pin),
		.out(dir)
	);
	
	assign dir_out = dir; // TODO: for debug
	
	wire [0:1] cur_ent_code;
	
	game_logic game_logic_module (
		.clk (vga_clk),
		.direction (dir),
		.x (mVGA_X),
		.y (mVGA_Y),
		.entity (cur_ent_code)
	);

	//////////////////////// VGA ////////////////////
	wire	[9:0]	mVGA_X;
	wire	[9:0]	mVGA_Y;
	wire	mVGA_R;
	wire	mVGA_G;
	wire	mVGA_B;

	wire	sVGA_R;
	wire	sVGA_G;
	wire	sVGA_B;
	
	VGA_Pattern	u3 // Drawing
		(	//	Read Out Side
			.oRed(mVGA_R),
			.oGreen(mVGA_G),
			.oBlue(mVGA_B),
			.iVGA_X(mVGA_X),
			.iVGA_Y(mVGA_Y),
			.iVGA_CLK(vga_clk),
			//	Control Signals
			.reset(reset),
			.iColor_SW(color),
			.ent(cur_ent_code)
		);

	
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
			.iCLK(vga_clk),
			.reset(reset)
		);
	
	
	assign VGA_R = sVGA_R;
	assign VGA_G = sVGA_G;
	assign VGA_B = sVGA_B;
	
endmodule
