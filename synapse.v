


module synapse #(
    // DW: CORDIC width, T_DW: trace width
    parameter DW = 16, T_DW = 4
)(

    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
    
    // Write or read weights in synapses
    input wire signed [15 : 0] weights_w,
    //input wire write_enable,
   // output reg [DW - 1 : 0] weights_r,
    //input wire read_enable,
    
    // Input spiking and output value
    input wire pre_spiking,
    output reg signed [15 : 0] spking_value
    //output reg post_en,
    
    // Update weights control. Update_lock is used for locking the pre neurons to avoid write & read weights simultaneously
    //input wire update_en,
    //input wire signed [DW - 1 : 0] learning_rate
    );
	 
	 
	 always@(posedge clk) begin
        
		  spking_value <= weights_w * pre_spiking;
		  
		  
	 end
	 

endmodule