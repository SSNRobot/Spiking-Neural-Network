module frequency_divider (
  input clk,
  input reset,
  output reg out
);

reg [11:0] counter;
parameter DIVIDER = 90; //2500 is 50us period

always @(posedge clk) begin
  if (reset) begin
    counter <= 0;
  end else begin
    counter <= counter + 1;
    if (counter == DIVIDER-1) begin
      out <= ~out;
      counter <= 0;
    end
  end
end

endmodule