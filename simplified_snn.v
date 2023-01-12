


module simplified_snn #(
    parameter DW = 16, INPUTNUM = 4, EXCNUM = 2, INT_DW = 8
)(
    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
	 input wire[0:3] Sensor_input,
	 input wire[0:3] Material_type
    );
    
    wire signed [DW + INT_DW - 1 : 0] synapses_results [INPUTNUM - 1 : 0][EXCNUM - 1 : 0];
    wire signed [DW + INT_DW - 1 : 0] after_sum [EXCNUM - 1 : 0];
    wire Output_spike [EXCNUM - 1 : 0];
    wire spike_inh;
	 
	 wire Pre_spike[0:3];
    
		assign spike_inh = 0;
    
    reg weights_en;
    always@(posedge clk) begin
        if(rst) weights_en <= 1'b0;
        else if (en) weights_en <= en;
    end
    wire en_for_initweights;
    assign en_for_initweights = weights_en ^ en;
      
	 
	 input_neuron Far_Left (clk,rst,en,Sensor_input[0],Material_type[0],Pre_spike[0]);
    input_neuron Mid_Left (clk,rst,en,Sensor_input[1],Material_type[1],Pre_spike[1]);
    input_neuron Mid_Right (clk,rst,en,Sensor_input[2],Material_type[2],Pre_spike[2]);
    input_neuron Far_Right (clk,rst,en,Sensor_input[3],Material_type[3],Pre_spike[3]);
    

    synapse syn1_1 (.clk(clk), .rst(rst), .en(en), .weights_w(394), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][0]));
    synapse syn1_2 (.clk(clk), .rst(rst), .en(en), .weights_w(144), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][1]));
	
    synapse syn2_1 (.clk(clk), .rst(rst), .en(en), .weights_w(626), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][0]));
    synapse syn2_2 (.clk(clk), .rst(rst), .en(en), .weights_w(-37), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][1]));
	
    synapse syn3_1 (.clk(clk), .rst(rst), .en(en), .weights_w(-21), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][0]));
    synapse syn3_2 (.clk(clk), .rst(rst), .en(en), .weights_w(898), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][1]));
	
    synapse syn4_1 (.clk(clk), .rst(rst), .en(en), .weights_w(138), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][0]));
    synapse syn4_2 (.clk(clk), .rst(rst), .en(en), .weights_w(553), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][1]));
	
	
    assign after_sum[0] = synapses_results[0][0] + synapses_results[1][0] + synapses_results[2][0] + synapses_results[3][0];
    assign after_sum[1] = synapses_results[0][1] + synapses_results[1][1] + synapses_results[2][1] + synapses_results[3][1];
	
	
    exc_neuron Left (clk,rst,en,after_sum[0],Output_spike[0]);
    exc_neuron Right (clk,rst,en,after_sum[1],Output_spike[1]);
    
endmodule
