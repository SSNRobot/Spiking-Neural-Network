//  https://github.com/doitdodo/FPGA_Spiking_NN

module exc_neuron  #(   //output neuron
	parameter ENCODE_TIME = 23, T_WINDOW = 250
)(
    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
	 
    
    // Input spking values
    input wire signed [15 : 0] spiking_value,   //24 bit number
    

    
    // Output spikes and spike cnt
    output reg out_spike

    );
    
  
    localparam reset_v = 24'd0;
	 
	 reg signed [15 : 0] potential;    //16 bit number
    reg [15 : 0] out_value;
	 reg [15 : 0] out_time;
	// reg [31 : 0] count;
	 
	 always@(posedge clk) begin
		if (rst) begin
			potential <= 0;
         out_spike <= 0;

		end
		else if (en) begin
		
			potential <= potential + spiking_value;
				
		end
		
		count <= count + 1;
		
	 end
	 
	 assign out_value = potential / 8388608;  //need to change number
	 
	 assign out_time = (out_value / 2) * 1563;
	 

	 
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

