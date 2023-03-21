
module simplified_snn #(
    parameter DW = 16, INPUTNUM = 4, EXCNUM = 2, INT_DW = 8
)(
    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
	 input wire[11:0] Sensor_input_fl,
	 input wire[11:0] Sensor_input_ml,
	 input wire[11:0] Sensor_input_mr,
	 input wire[11:0] Sensor_input_fr,
	 output wire[EXCNUM - 1 : 0] Output_spike
	 
    );
    wire [3 : 0] hidden_spike;
	 
    wire [9:0] Material_type[3:0];
	
    wire signed [15 : 0] synapses_results [3 : 0][3 : 0];
    wire signed [15 : 0] ex_syn_res [INPUTNUM - 1 : 0][EXCNUM - 1 : 0];
    wire signed [15 : 0] init_sum [3 : 0];
    wire signed [15 : 0] after_sum [EXCNUM - 1 : 0];
	 
    wire out_en;
    wire Pre_spike[0:3];
    
    reg weights_en;
    always@(posedge clk) begin
        if(rst) weights_en <= 1'b0;
        else if (en) weights_en <= en;
    end
    wire en_for_initweights;
    assign en_for_initweights = weights_en ^ en;
	 
    assign Material_type[0] = 600;
    assign Material_type[1] = 3000;
    assign Material_type[2] = 3000;
    assign Material_type[3] = 600;
      
	 
    input_neuron Far_Left (clk,rst,en,Sensor_input_fl,Material_type[0],Pre_spike[0]);
    input_neuron Mid_Left (clk,rst,en,Sensor_input_ml,Material_type[1],Pre_spike[1]);
    input_neuron Mid_Right (clk,rst,en,Sensor_input_mr,Material_type[2],Pre_spike[2]);
    input_neuron Far_Right (clk,rst,en,Sensor_input_fr,Material_type[3],Pre_spike[3]);
    

    synapse syn1_1 (.clk(clk), .rst(rst), .en(en), .weights_w(-59), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][0]),.update_en(hidden_spike[0]),.learning_rate(16'h0148));
    synapse syn1_2 (.clk(clk), .rst(rst), .en(en), .weights_w(-98), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][1]),.update_en(hidden_spike[1]),.learning_rate(16'h0148));
    synapse syn1_3 (.clk(clk), .rst(rst), .en(en), .weights_w(-89), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][2]),.update_en(hidden_spike[2]),.learning_rate(16'h0148));
    synapse syn1_4 (.clk(clk), .rst(rst), .en(en), .weights_w(-67), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][3]),.update_en(hidden_spike[3]),.learning_rate(16'h0148));
	
    synapse syn2_1 (.clk(clk), .rst(rst), .en(en), .weights_w(59), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][0]),.update_en(hidden_spike[0]),.learning_rate(16'h0148));
    synapse syn2_2 (.clk(clk), .rst(rst), .en(en), .weights_w(-73), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][1]),.update_en(hidden_spike[1]),.learning_rate(16'h0148));
    synapse syn2_3 (.clk(clk), .rst(rst), .en(en), .weights_w(-13), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][2]),.update_en(hidden_spike[2]),.learning_rate(16'h0148));
    synapse syn2_4 (.clk(clk), .rst(rst), .en(en), .weights_w(-56), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][3]),.update_en(hidden_spike[3]),.learning_rate(16'h0148));
	
    synapse syn3_1 (.clk(clk), .rst(rst), .en(en), .weights_w(-51), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][0]),.update_en(hidden_spike[0]),.learning_rate(16'h0148));
    synapse syn3_2 (.clk(clk), .rst(rst), .en(en), .weights_w(98), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][1]),.update_en(hidden_spike[1]),.learning_rate(16'h0148));
    synapse syn3_3 (.clk(clk), .rst(rst), .en(en), .weights_w(4), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][2]),.update_en(hidden_spike[2]),.learning_rate(16'h0148));
    synapse syn3_4 (.clk(clk), .rst(rst), .en(en), .weights_w(-97), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][3]),.update_en(hidden_spike[3]),.learning_rate(16'h0148));
	
    synapse syn4_1 (.clk(clk), .rst(rst), .en(en), .weights_w(-42), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][0]),.update_en(hidden_spike[0]),.learning_rate(16'h0148));
    synapse syn4_2 (.clk(clk), .rst(rst), .en(en), .weights_w(-30), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][1]),.update_en(hidden_spike[1]),.learning_rate(16'h0148));
    synapse syn4_3 (.clk(clk), .rst(rst), .en(en), .weights_w(-74), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][2]),.update_en(hidden_spike[2]),.learning_rate(16'h0148));
    synapse syn4_4 (.clk(clk), .rst(rst), .en(en), .weights_w(33), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][3]),.update_en(hidden_spike[3]),.learning_rate(16'h0148));
	
	
    assign init_sum[0] = synapses_results[0][0] + synapses_results[1][0] + synapses_results[2][0] + synapses_results[3][0];
    assign init_sum[1] = synapses_results[0][1] + synapses_results[1][1] + synapses_results[2][1] + synapses_results[3][1];
    assign init_sum[2] = synapses_results[0][2] + synapses_results[1][2] + synapses_results[2][2] + synapses_results[3][2];
    assign init_sum[3] = synapses_results[0][3] + synapses_results[1][3] + synapses_results[2][3] + synapses_results[3][3];
	
	
    hidden_neuron neu_1(clk,rst,en,init_sum[0],hidden_spike[0]);
    hidden_neuron neu_2(clk,rst,en,init_sum[1],hidden_spike[1]);
    hidden_neuron neu_3(clk,rst,en,init_sum[2],hidden_spike[2]);
    hidden_neuron neu_4(clk,rst,en,init_sum[3],hidden_spike[3]);
	
	
    synapse ex_syn1_1(.clk(clk), .rst(rst), .en(en), .weights_w(1), .pre_spiking(hidden_spike[0]),.spking_value(ex_syn_res[0][0]),.update_en(Output_spike[0]),.learning_rate(16'h0148));
    synapse ex_syn1_2(.clk(clk), .rst(rst), .en(en), .weights_w(-60), .pre_spiking(hidden_spike[0]),.spking_value(ex_syn_res[0][1]),.update_en(Output_spike[1]),.learning_rate(16'h0148));
	
    synapse ex_syn2_1(.clk(clk), .rst(rst), .en(en), .weights_w(-98), .pre_spiking(hidden_spike[1]),.spking_value(ex_syn_res[1][0]),.update_en(Output_spike[0]),.learning_rate(16'h0148));
    synapse ex_syn2_2(.clk(clk), .rst(rst), .en(en), .weights_w(40), .pre_spiking(hidden_spike[1]),.spking_value(ex_syn_res[1][1]),.update_en(Output_spike[1]),.learning_rate(16'h0148));
	
    synapse ex_syn3_1(.clk(clk), .rst(rst), .en(en), .weights_w(-26), .pre_spiking(hidden_spike[2]),.spking_value(ex_syn_res[2][0]),.update_en(Output_spike[0]),.learning_rate(16'h0148));
    synapse ex_syn3_2(.clk(clk), .rst(rst), .en(en), .weights_w(-19), .pre_spiking(hidden_spike[2]),.spking_value(ex_syn_res[2][1]),.update_en(Output_spike[1]),.learning_rate(16'h0148));
	
    synapse ex_syn4_1(.clk(clk), .rst(rst), .en(en), .weights_w(-77), .pre_spiking(hidden_spike[3]),.spking_value(ex_syn_res[3][0]),.update_en(Output_spike[0]),.learning_rate(16'h0148));
    synapse ex_syn4_2(.clk(clk), .rst(rst), .en(en), .weights_w(-76), .pre_spiking(hidden_spike[3]),.spking_value(ex_syn_res[3][1]),.update_en(Output_spike[1]),.learning_rate(16'h0148));
	
	
    assign after_sum[0] = ex_syn_res[0][0] + ex_syn_res[1][0] + ex_syn_res[2][0] + ex_syn_res[3][0];
    assign after_sum[1] = ex_syn_res[0][1] + ex_syn_res[1][1] + ex_syn_res[2][1] + ex_syn_res[3][1];
	
	
    exc_neuron Left (clk,rst,en,after_sum[0],Output_spike[0]);
    exc_neuron Right (clk,rst,en,after_sum[1],Output_spike[1]);
	 
    
endmodule