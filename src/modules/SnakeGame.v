// top level module

module SnakeGame (
	// input from joystick
	input wire clk, // 50MHz
	
	//////////////////// VGA ////////////////////////////
	input reset,
	input color, // swap between 2 outputs
	
	output	VGA_HS, // VGA H_SYNC
	output	VGA_VS, // VGA V_SYNC
	output	VGA_R,  // VGA Red
	output	VGA_G,  // VGA Green
	output	VGA_B   // VGA Blue
);
	wire vga_clk;
	
	VGA_clk vga_clk_gen (
		clk,
		vga_clk
	);
	// process input from joystick
	// send processed input from joystick to game logic module
		// save game state to shared memory
	// let VGA controller take the data from memory and produce output

	//////////////////////// VGA ////////////////////
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
	
	// temp value to test
	wire [0:2] cur_ent_code;
	assign cur_ent_code = 0;
	
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
	
endmodule
