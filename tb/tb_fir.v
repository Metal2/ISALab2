module tb_fir();

	wire CLK_i;
	wire RST_n_i;
	wire [31:0] data_in;
	wire [31:0] data_out;
	
   
   
clk_gen CG ( .CLK(CLK_i));
			
data_maker DM ( .CLK(CLK_i),
			.DATA(data_in));
			
data_sink DS ( .CLK(CLK_i),
				.DIN(data_out));
			
fpmul UUT(.FP_A(data_in),
			   		.FP_B(data_in),
			  		 .clk(CLK_i),
			  		 .FP_Z(data_out));
			   
endmodule
