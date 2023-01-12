//  https://github.com/doitdodo/FPGA_Spiking_NN

module exc_neuron  #(
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
	 
	 
	 reg refractory_en;
    always@(posedge clk) begin
        if(rst) begin 
            refractory_cnt <= 0;
            refractory_en <= 0;
        end
        else if(en) begin
            if(refractory_cnt == REFRAC * ENCODE_TIME) begin
                refractory_cnt <= 0;
                refractory_en <= 1'b0;
            end
            if(potential >= threshold) begin
                refractory_en <= 1'b1;
            end
            else if (refractory_en) begin
                refractory_cnt <= refractory_cnt + 1;
            end
        end
    end
	 
endmodule



module input_neuron #(
    parameter ENCODE_TIME = 23, T_WINDOW = 250
)(


    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
    
	 input wire Sensor_input,
	 input wire Material_type,
	 
	 output reg Pre_spike
	 
);

	wire potential;
	reg spike;
	
	assign potential = Sensor_input;
	
	always @(posedge clk) 
	begin
	
	if((Material_type > 500) && (Sensor_input < 700)) begin  //change values to 12 bit from 10 bit   and)
		assign spike = 1;
	end
	else if((Material_type < 500) && (Sensor_input > 275)) begin
		assign spike = 1;
	end
	else begin
		spike <= 0;
	end
	
	
	Pre_spike <= spike;
	
	end
endmodule

