module buttons(
input left, right, up, down,
output reg [1:0] out
);

initial 
begin 
out = 2'b01;
end
always@(*)
begin
if(left +right + up + down == 1) begin
	if(left && out != 2'b10)begin
		out = 2'b00;
	end
	if(right && out != 2'b00)begin
		out = 2'b10;
	end

	if(up && out != 2'b11)begin
		out = 2'b01;
	end
	if(down && out != 2'b01)begin
		out = 2'b11;
	end

end
end
endmodule
