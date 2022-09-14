module simplified_snn #(
    parameter DW = 16, INT_DW = 8, REFRAC = 5, ENCODE_TIME = 23
)(
    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
    
    // Input spking values
    input wire signed [DW + INT_DW - 1 : 0] spiking_value,
    
    // Input inh
    input wire inh,
    
    // Output spikes and spike cnt
    output reg out_spike,
    output reg [31 : 0] spike_cnt
    );
    
    localparam inh_value = 24'h3c0000;
    localparam threshold = 24'h0d0000;
    localparam reset_v = 24'd0;
	 
	 reg signed [DW + INT_DW - 1 : 0] potential;
    reg [3 : 0] refractory_cnt;
	 
	 always@(posedge clk) begin
		if (rst) begin
			potential <= 0;
         out_spike <= 0;
         spike_cnt <= 0;
		end
		else if (en) begin
			if (refractory_cnt == 4'd0) begin
				potential <= potential + spiking_value;
				if (inh) begin
					potential <= potential - inh_value;
				end
				
				if (potential >= threshold) begin
					potential <= reset_v;			// hard reset potential
					out_spike <= 1'b1;				// set output spike High
					spike_cnt <= spike_cnt + 1;	// count total spikes
				end
				else
					out_spike <= 1'b0;				// set output spike Low
				end
			else begin
				potential <= potential;
				out_spike <= 1'b0;
				spike_cnt <= spike_cnt;
			end
		end
	 end
endmodule
