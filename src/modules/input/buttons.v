//Include Defines

module buttons(
input left, right, up, down,
output reg [1:0] out
);

initial 
begin 
out = 2'b01;
end
	always@(*) // TODO: check whether it works without clk
begin
	if(left +right + up + down == 3'b001) // if only one pressed
	begin
		if(left && out != 2'b10) // TODO: Replace with defines
		begin
			out = 2'b00;
		end
		
		if(right && out != 2'b00)
		begin
			out = 2'b10;
		end

		if(up && out != 2'b11)
		begin
			out = 2'b01;
		end
		
		if(down && out != 2'b01)
		begin
			out = 2'b11;
		end

	end
end
endmodule
