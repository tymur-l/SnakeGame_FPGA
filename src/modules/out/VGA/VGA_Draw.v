`include "../../../definitions/define.vh"
`include "../../../definitions/sprites.vh"

module	VGA_Draw	(	//	Read Out Side
						oRed,
						oGreen,
						oBlue,
						iVGA_X,
						iVGA_Y,
						iVGA_CLK,
						//	Control Signals
						reset,
						iColor_SW,
						ent);
//	Read Out Side
output	reg	oRed;
output	reg	oGreen;
output	reg	oBlue;
input	[9:0]		iVGA_X;
input	[9:0]		iVGA_Y;
input				iVGA_CLK;
//	Control Signals
input				reset;
input				iColor_SW;
input	[0:1]		ent;

// Array of sprites
/*
0 - apple
1 - snake head
2 - snake tail

Every sprite consists of 3 bits - RGB values of a particular pixel
*/
reg [0:`SPRITE_MSB] sp [0:2][0:`H_SQUARE_LAST_ADDR][0:`V_SQUARE_LAST_ADDR];

initial
begin
	`SPRITE_INIT
end

always @(posedge iVGA_CLK or posedge reset)
begin
	if(reset)
	begin
		oRed   <= 0;
		oGreen <= 0;
		oBlue  <= 0;
	end
	else
	begin
	if(iColor_SW == 0)
		begin
			// DRAW CURRENT STATE
			if (ent == `ENT_NOTHING)
			begin
				oRed   <= 1;
				oGreen <= 1;
				oBlue  <= 1;
			end
			else
			begin
				// Drawing a particular pixel from sprite
				oRed <= sp[ent][iVGA_X % `H_SQUARE][iVGA_Y % `V_SQUARE][0];
				oGreen <= sp[ent][iVGA_X % `H_SQUARE][iVGA_Y % `V_SQUARE][1];
				oBlue <= sp[ent][iVGA_X % `H_SQUARE][iVGA_Y % `V_SQUARE][2];
			end
		end
		else
		begin //Draw lines of every color that can be produces
			if (iVGA_Y < 60)
			begin
				oRed <= 1;
				oGreen <= 1;
				oBlue <= 1;
			end else if (iVGA_Y < 120)
			begin
				oRed <= 1;
				oGreen <= 0;
				oBlue <= 1;
			end  else if (iVGA_Y < 180)
			begin
				oRed <= 1;
				oGreen <= 1;
				oBlue <= 0;
			end  else if (iVGA_Y < 240)
			begin
				oRed <= 1;
				oGreen <= 0;
				oBlue <= 0;
			end  else if (iVGA_Y < 300)
			begin
				oRed <= 0;
				oGreen <= 1;
				oBlue <= 1;
			end  else if (iVGA_Y < 360)
			begin
				oRed <= 0;
				oGreen <= 0;
				oBlue <= 1;
			end  else if (iVGA_Y < 420)
			begin
				oRed <= 0;
				oGreen <= 1;
				oBlue <= 0;
			end  else 
			begin
				oRed <= 0;
				oGreen <= 0;
				oBlue <= 0;
			end
			
		end
	end
end

endmodule
