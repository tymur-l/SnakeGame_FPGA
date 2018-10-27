module	VGA_Pattern	(	//	Read Out Side
						oRed,
						oGreen,
						oBlue,
						iVGA_X,
						iVGA_Y,
						iVGA_CLK,
						//	Control Signals
						reset,
						iColor_SW	);
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

//tries to implement animation




always@(posedge iVGA_CLK or posedge reset)
begin
	if(reset)
	begin
		oRed	<=	0;
		oGreen	<=	0;
		oBlue	<=	0;
	end
	else
	begin
		if(iColor_SW == 0)
		begin
		
		if (iVGA_Y>320 && iVGA_Y<336 && iVGA_X>240 && iVGA_X<252)
		begin
				oRed <= 1;
				oGreen <= 1;
				oBlue <= 1;
		end else
		begin
				oRed <= 0;
				oGreen <= 0;
				oBlue <= 0;
		end
		
			/*
			if (iVGA_Y < 160)
			begin
				oRed <= 1;
				oGreen <= 0;
				oBlue <= 0;
			end else if (iVGA_Y < 320)
			begin
				oRed <= 0;
				oGreen <= 1;
				oBlue <= 0;
			end else
			begin
				oRed <= 0;
				oGreen <= 0;
				oBlue <= 1;
			end
			*/
		
			
		end
		else
		begin
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