


module simplified_snn #(
    parameter DW = 16, INPUTNUM = 4, EXCNUM = 2, INT_DW = 8
)(
    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en
    );
    
    wire signed [DW + INT_DW - 1 : 0] synapses_results [INPUTNUM - 1 : 0][EXCNUM - 1 : 0];
    wire signed [DW + INT_DW - 1 : 0] after_sum [EXCNUM - 1 : 0];
    wire output_spikes [EXCNUM - 1 : 0];
    
    reg weights_en;
    always@(posedge clk) begin
        if(rst) weights_en <= 1'b0;
        else if (en) weights_en <= en;
    end
    wire en_for_initweights;
    assign en_for_initweights = weights_en ^ en;
    
    generate
        genvar j, k;
        for(j = 0; j < INPUTNUM; j = j + 1) begin    : loop2
            for(k = 0; k < EXCNUM; k = k + 1) begin   : loop3
                synapse syn (
                    .clk(clk), .rst(rst), .en(en),
                    .weights_w(16'sd2000),.pre_spiking(1'b1), //input_spikes[j]
                    .spking_value(synapses_results[j][k]),.update_en(output_spikes[k]),
                    .learning_rate(16'h0148)
                );
            end
        end
    endgenerate
    
    generate
        genvar h;
        for(h = 0; h < EXCNUM; h = h + 1) begin    : loop4
            assign after_sum[h] = 
            synapses_results[0][h]+
            synapses_results[1][h]+
            synapses_results[2][h]+
            synapses_results[3][h];
        end
    endgenerate
    
    generate 
        genvar m;
        for(m = 0; m < EXCNUM; m = m + 1) begin    : loop5
            exc_neuron exc (
                clk,rst,en,after_sum[m],spike_inh,output_spikes[m]
            );
        end
    endgenerate    

	
    input_neuron Far_Left (clk,rst,en,Sensor_input[0],Material_type[0],Pre_spike[0]);
    input_neuron Mid_Left (clk,rst,en,Sensor_input[1],Material_type[1],Pre_spike[1]);
    input_neuron Mid_Right (clk,rst,en,Sensor_input[2],Material_type[2],Pre_spike[2]);
    input_neuron Far_Right (clk,rst,en,Sensor_input[3],Material_type[3],Pre_spike[3]);
    

    synapse syn1_1 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][0]));
    synapse syn1_2 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[0]),.spking_value(synapses_results[0][1]));
	
    synapse syn2_1 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][0]));
    synapse syn2_2 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[1]),.spking_value(synapses_results[1][1]));
	
    synapse syn3_1 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][0]));
    synapse syn3_2 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[2]),.spking_value(synapses_results[2][1]));
	
    synapse syn4_1 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][0]));
    synapse syn4_2 (.clk(clk), .rst(rst), .en(en), .weights_w(###), .pre_spiking(Pre_spike[3]),.spking_value(synapses_results[3][1]));
	
	
    assign after_sum[0] = synapses_results[0][0] + synapses_results[1][0] + synapses_results[2][0] + synapses_results[3][0];
    assign after_sum[1] = synapses_results[0][1] + synapses_results[1][1] + synapses_results[2][1] + synapses_results[3][1];
	
	
    exc_neuron Left (clk,rst,en,after_sum[0],Output_spike[0]);
    exc_neuron Right (clk,rst,en,after_sum[1],Output_spike[1]);
	
endmodule
