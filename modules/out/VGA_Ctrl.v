module	VGA_Ctrl	(	//	Host Side
						iRed,
						iGreen,
						iBlue,
						oCurrent_X,
						oCurrent_Y,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_HS,
						oVGA_VS,
						oVGA_SYNC,
						oVGA_BLANK,
						oVGA_CLOCK,
						//	Control Signal
						iCLK,
						reset	);
//	Host Side
input		iRed;
input		iGreen;
input		iBlue;
output		[9:0]	oCurrent_X;
output		[9:0]	oCurrent_Y;
//	VGA Side
output		oVGA_R;
output		oVGA_G;
output		oVGA_B;
output	reg			oVGA_HS;
output	reg			oVGA_VS;
output				oVGA_SYNC;
output				oVGA_BLANK;
output				oVGA_CLOCK;
//	Control Signal
input				iCLK;
input				reset;	
//	Internal Registers
reg			[9:0]	H_Cont;
reg			[9:0]	V_Cont;
////////////////////////////////////////////////////////////
//	Horizontal	Parameter

	parameter	H_FRONT	=	16;
	parameter	H_SYNC	=	96;
	parameter	H_BACK	=	48;
	parameter	H_ACT	=	640;
/*
parameter	H_FRONT	=	72;
parameter	H_SYNC	=	144;
parameter	H_BACK	=	216;
parameter	H_ACT	=	1368;
*/
parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
////////////////////////////////////////////////////////////
//	Vertical Parameter

parameter	V_FRONT	=	10;
parameter	V_SYNC	=	2;
parameter	V_BACK	=	33;
parameter	V_ACT	=	480;
/*
parameter	V_FRONT	=	1;
parameter	V_SYNC	=	3;
parameter	V_BACK	=	23;
parameter	V_ACT	=	768;
*/
parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;
////////////////////////////////////////////////////////////
assign	oVGA_SYNC	=	1'b1;			//	This pin is unused.
assign	oVGA_BLANK	=	~((H_Cont<H_BLANK)||(V_Cont<V_BLANK));
assign	oVGA_CLOCK	=	~iCLK;
assign	oVGA_R		=	(oCurrent_X > 0) ?	iRed : 0 ;
assign	oVGA_G		=	(oCurrent_X > 0) ?	iGreen : 0 ;
assign	oVGA_B		=	(oCurrent_X > 0) ?	iBlue : 0 ;

assign	oCurrent_X	=	(H_Cont>=H_BLANK)	?	H_Cont-H_BLANK	:	10'h0	;
assign	oCurrent_Y	=	(V_Cont>=V_BLANK)	?	V_Cont-V_BLANK	:	10'h0	;

//	Horizontal Generator: Refer to the pixel clock
always@(posedge iCLK or posedge reset)
begin
	if(reset)
	begin
		H_Cont		<=	0;
		oVGA_HS		<=	1;
	end
	else
	begin
		//Vertical sync
		if(H_Cont<H_TOTAL-1)
		H_Cont	<=	H_Cont+1'b1;
		else
		H_Cont	<=	0;
		//	Horizontal Sync
		if(H_Cont==H_FRONT-1)			//	Front porch end
		oVGA_HS	<=	1'b0;
		if(H_Cont==H_FRONT+H_SYNC-1)	//	Sync pulse end
		oVGA_HS	<=	1'b1;
	end
end

//	Vertical Generator: Refer to the horizontal sync
always@(posedge oVGA_HS or posedge reset)
begin
	if(reset)
	begin
		V_Cont		<=	0;
		oVGA_VS		<=	1;
	end
	else
	begin
//		if(V_Cont<V_TOTAL)
		if(V_Cont<V_TOTAL-1)
		V_Cont	<=	V_Cont+1'b1;
		else
		V_Cont	<=	0;
		//	Vertical Sync
		if(V_Cont==V_FRONT-1)			//	Front porch end
		oVGA_VS	<=	1'b0;
		if(V_Cont==V_FRONT+V_SYNC-1)	//	Sync pulse end
		oVGA_VS	<=	1'b1;
	end
end


endmodule