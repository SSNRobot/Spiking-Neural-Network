module spike_counter (
  input clk,
  input en,
  input spike,
  input reset,
  output reg [9:0] spike_cnt
);

reg [9:0] counter;
reg en_flag;

always @(posedge clk) begin     // 50 MHz clk
  if (reset) begin
    counter <= 0;
  end else begin
    counter <= counter + spike; // output spike from exc neurons
    if (!en) begin
      en_flag <= 1;
    end 
    if (en && en_flag) begin       // en is 20 kHz signal from frequency divider
      if (counter != 0) begin
        spike_cnt <= counter;   // spike_cnt goes through bin2hex to display3 (3 digit 7 segment display bdf)
      end
      counter <= 0;
      en_flag <= 0;
    end
  end
end

endmodule