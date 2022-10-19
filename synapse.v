module synapse #(
    // DW: CORDIC width, T_DW: trace width
    parameter DW = 16, T_DW = 4
)(

    // Clock, reset and enable
    input wire clk,
    input wire rst,
    input wire en,
    
    // Write or read weights in synapses
    input wire [DW - 1 : 0] weights_w,
    input wire write_enable,
    output reg [DW - 1 : 0] weights_r,
    input wire read_enable,
    
    // Input spiking and output value
    input wire pre_spiking,
    output reg signed [DW - 1 : 0] spking_value,
    output reg post_en,
    
    // Update weights control. Update_lock is used for locking the pre neurons to avoid write & read weights simultaneously
    input wire update_en,
    input wire signed [DW - 1 : 0] learning_rate
    );
	 
	 // FSM
    localparam IDLE = 3'b000;
    localparam FORWARD = 3'b001;
    localparam COMPUTE = 3'b010;
//    localparam UPDATE = 3'b011;
    reg [2 : 0] fsm_state;
    reg [2 : 0] fsm_next_state;
    reg compute_finish;
	 
	 always@(posedge clk) begin
        if(rst) begin
            fsm_state <= IDLE;
        end
        else if(en) fsm_state <= fsm_next_state;
    end
    
    always@(*) begin
        case(fsm_state)
            IDLE: begin
                if(en) begin
                    fsm_next_state = FORWARD;
                end
                else fsm_next_state = fsm_state;
            end
            FORWARD: begin
                if(en) begin
                    if(update_en) fsm_next_state = COMPUTE;
                    else fsm_next_state = fsm_state;
                end
                else fsm_next_state = fsm_state;
            end
            COMPUTE: begin
                if(en) begin
                   if(compute_finish) fsm_next_state = FORWARD;
                   else fsm_next_state = fsm_state;
                end
                else fsm_next_state = fsm_state;                
            end
//            UPDATE: begin
//                if(en) fsm_next_state = FORWARD;
//                else fsm_next_state = fsm_state;                
//            end
            default: fsm_next_state = IDLE;
        endcase
    end
	 
	 // Trace, including pre-synapses and post-synapses
    // In 2015's paper, we only use pre-synapses trace
    reg [T_DW - 1 : 0] pre_trace;
    reg [T_DW - 1 : 0] post_trace;
    always@(posedge clk) begin
        if (rst) begin
            pre_trace <= 0;
        end
        else begin
            if (en) begin
                if(pre_spiking) pre_trace <= pre_trace + 1;
            end
        end
    end
	 
	 // Synapse weight and update weight control
    reg signed [DW - 1 : 0] weights;
	 
	 // Forward
    always@(posedge clk) begin
        if(rst) begin 
            spking_value <= 0;
            post_en <= 0;
        end
        else if(en) begin
            if(pre_spiking)begin
                spking_value <= weights;
                post_en <= 1'b1;
            end
            else post_en <= 1'b0;
        end
    end
	 
	 
	 

endmodule
