// top level module
`include "../definitions/define.vh"

module SnakeGame (
	// joystick input
	input wire
		res_x_one,
		res_x_two,
		res_y_one,
		res_y_two,
	
	input wire clk, // 50MHz
	
	// VGA input
	input wire
		reset,
		color, // swap between 2 outputs
	
	// VGA output
	output wire
		VGA_HS, // VGA H_SYNC
		VGA_VS, // VGA V_SYNC
		VGA_R,  // VGA Red
		VGA_G,  // VGA Green
		VGA_B   // VGA Blue
	
	// joystick output
	//, output wire [0:1] dir_out // for debug
);
	// Clock
	wire vga_clk;
	
	VGA_clk vga_clk_gen (
		clk,
		vga_clk
	);

	// Game input
	wire [0:1] dir;

	joystick_input ji (
		.one_resistor_x(res_x_one),
		.two_resistors_x(res_x_two),
		.one_resistor_y(res_y_one),
		.two_resistors_y(res_y_two),
		.clk(vga_clk),
		.direction(dir)
	);

	assign dir_out = dir; // for debug

	// Game logic
	wire [0:1] cur_ent_code;

	game_logic game_logic_module (
		.clk(vga_clk),
		.reset(reset),
		.direction(dir),
		.x_in(mVGA_X),
		.y_in(mVGA_Y),
		.entity(cur_ent_code),
		//.game_over(),
		//.game_won()
	);

	// VGA
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
