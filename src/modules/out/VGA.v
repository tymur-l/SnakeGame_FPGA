
module VGA
	(
		////////////////////	Clock Input	////////////////////	 
		CLOCK_50,						//	50 MHz
		reset,
		color,
		////////////////////	VGA ////////////////////////////
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_R,   						//	VGA Red
		VGA_G,	 						//	VGA Green
		VGA_B,  						   //	VGA Blue
		
	);

////////////////////////	Clock Input	 	////////////////////////
input		CLOCK_50;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input		reset;
input		color;

////////////////////////	VGA	////////////////////////////
output	VGA_HS;					//	VGA H_SYNC
output	VGA_VS;					//	VGA V_SYNC


output	VGA_R;
output	VGA_G;
output	VGA_B;

////////////////////////	VGA	////////////////////////////
wire	VGA_CTRL_CLK;
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

//=======================================================
//  Structural coding
//=======================================================

////////////////////////	VGA	////////////////////////////

	VGA_CLK		u1  //VGA_CLK		u1
			(	.inclk0(CLOCK_50),
				.c0(VGA_CTRL_CLK)
			);
	
	
	VGA_Ctrl	u2
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
				.iCLK(VGA_CTRL_CLK),
				.reset(reset)
			);
	
	VGA_Pattern	u3
			(	//	Read Out Side
				.oRed(mVGA_R),
				.oGreen(mVGA_G),
				.oBlue(mVGA_B),
				.iVGA_X(mVGA_X),
				.iVGA_Y(mVGA_Y),
				.iVGA_CLK(VGA_CTRL_CLK),
				//	Control Signals
				.reset(reset),
				.iColor_SW(color)
			);
	
endmodule