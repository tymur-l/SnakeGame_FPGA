include "../../definitions/define.vh"

module buttons(
input left, right, up, down,
output reg [1:0] out
);

initial 
begin 
out = TOP_DIR;
end
	always@(*) // TODO: check whether it works without clk
begin
	if(left +right + up + down == 3'b001) // if only one pressed
	begin
		if(left && out != RIGHT_DIR) // TODO: Replace with defines
		begin
			out = LEFT_DIR;
		end
		
		if(right && out != LEFT_DIR)
		begin
			out = RIGHT_DIR;
		end

		if(up && out != DOWN_DIR)
		begin
			out = TOP_DIR;
		end
		
		if(down && out != TOP_DIR)
		begin
			out = DOWN_DIR;
		end

	end
end
endmodule
