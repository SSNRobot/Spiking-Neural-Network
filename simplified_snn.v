module simplified_snn #(
    parameter DW = 16, INPUTNUM = 10, EXCNUM = 2, INT_DW = 8
)(
    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en
    );
    
    wire signed [DW + INT_DW - 1 : 0] synapses_results [INPUTNUM - 1 : 0][EXCNUM - 1 : 0];
    wire signed [DW + INT_DW - 1 : 0] after_sum [EXCNUM - 1 : 0];
    wire output_spikes [EXCNUM - 1 : 0];
    wire spike_inh;
    
//        generate
//        genvar a, b;
//        for(a = 0; a < EXCNUM; a = a + 1) begin   : loop1
//            assign spike_inh = spike_inh | output_spikes[a];
//        end
//    endgenerate

		assign spike_inh = 0;
    
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
            synapses_results[3][h]+
            synapses_results[4][h]+
            synapses_results[5][h]+
            synapses_results[6][h]+
            synapses_results[7][h]+
            synapses_results[8][h]+
            synapses_results[9][h];
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
    
endmodule
