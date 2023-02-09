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
    
  

	 localparam signed threshold = 16'h0040;  //16 bit hex number
	 reg [15 : 0] refractory_cnt = 16'd0;
//	 reg refractory_en;
	 
	 reg signed [15 : 0] potential;    //16 bit number
	 
	 always@(posedge clk) begin
		if (rst) begin
			potential <= 0;
         out_spike <= 0;
//         refractory_cnt <= 0;
//         refractory_en <= 0;

		end
		else if (en) begin
		
			potential <= potential + spiking_value;
				
		end
		
		if(en) begin
            if(refractory_cnt == 16'd0) begin
                potential <= potential + spiking_value;
                
                if((potential >= threshold) ) begin//&& potential >= 0) begin
                    potential <= 16'b0;
                    out_spike <= 1'b1;
//         		     refractory_en <= 1'b1;
                end
                else out_spike <= 1'b0;
            end
            else begin
                potential <= potential;         
                out_spike <= 1'b0; 
            end
//				if(refractory_cnt == 50) begin   //100 clock cycle delay, which makes 2us delay
//                refractory_cnt <= 0;
//                refractory_en <= 1'b0;
//            end
//            else if (refractory_en) begin
//                refractory_cnt <= refractory_cnt + 1;
//            end
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
    
	 input wire[11:0] Sensor_input,
	 input wire[9:0] Material_type,
	 
	 output reg Pre_spike
	 
);

	wire [11:0] potential;
	reg spike;
	
	assign potential = Sensor_input;
	
	always @(posedge clk) 
	begin
	
	if((Material_type > 2000) && (Sensor_input < 2800)) begin  //change values to 12 bit from 10 bit   and)
		spike <= 1;
	end
	else if((Material_type < 2000) && (Sensor_input > 1100)) begin
		spike <= 1;
	end
	else begin
		spike <= 0;
	end
	
	
	Pre_spike <= spike;
	
	end
endmodule

