// Code your testbench here
// or browse Examples
module tlc_tb();

//Integer for counter countdown purpose
integer i = 1;	

//Integer for detailed inspection of signals purpose
integer j = 1;


reg	i_clock;	
reg	i_reset_b;
reg	i_g2y_timer;
reg	i_y2r_timer;

//Inputs from sensors or buttons
  reg	[1:0] i_w_sensor;
  reg	[1:0] i_s_sensor;
  reg	[1:0] i_e_sensor;
  reg	[1:0] i_n_sensor;


//Various outputs
wire	w_red, w_yellow, w_green, s_red, s_yellow, s_green, e_red, e_yellow, e_green, n_red, n_yellow, n_green;
wire	[2:0]	o_west;
wire	[2:0]	o_south;
wire	[2:0]	o_east;
wire	[2:0]	o_north;


//Test variable
  reg	[1:0]	test_var;
  reg	[1:0]	test_var1;
  reg	[1:0]	test_var2;
  reg	[1:0]	test_var3;

//Clock cycle generation of 20 units per period
always	#10	i_clock =~ i_clock;

//Countdown counter for i_g2y_timer and i_y2r_timer signal
always @(posedge i_clock, i_reset_b)
	begin
		if(i_reset_b)
			begin
				i_y2r_timer = 1'b0;
				i_g2y_timer = 1'b0;
			end
		else
			begin
				if(!(i % 10)) 			//Every 10th clock cycle
					i_y2r_timer = 1'b1;
				else
					i_y2r_timer = 1'b0;
				if(i == 30)			//Every 30th clock cycle
					begin
						i_g2y_timer = 1'b1;
						i = 0;		//Reset the cycle count upon reaching 30
					end
				else
					i_g2y_timer <= 1'b0;
				//Increment the value of the cycle count
				i = i + 1;
		end
	end

//Assigning of signals for easier viewing
assign o_west = {w_red, w_yellow, w_green};
assign o_south= {s_red, s_yellow, s_green};
assign o_east = {e_red, e_yellow, e_green};
assign o_north= {n_red, n_yellow, n_green};

//Declaration and Instantiating of Traffic Light Controller
tlc	traffic_light_instance	(i_clock, i_reset_b, i_g2y_timer, i_y2r_timer,
				 i_w_sensor, i_s_sensor, i_e_sensor, i_n_sensor,
				 w_red, w_yellow, w_green,
				 s_red, s_yellow, s_green,
				 e_red, e_yellow, e_green,
				 n_red, n_yellow, n_green);

initial
	begin
        $dumpfile("dump.vcd");
        $dumpvars;
		//Setup for testbench
		i_clock = 1'b0;
		i_reset_b = 1'b1;						//Assert reset signal on initial launch
		i_w_sensor = 2'b00;
        i_s_sensor = 2'b00;
        i_e_sensor = 2'b00;
        i_n_sensor = 2'b00;
		#50;
		i_reset_b = 1'b0;
		$display("***Setup Completion - Begin Testing Traffic Light Controller***");
      
		//Case 1 All Lanes no Car 
		i_w_sensor = 2'b00;
		i_s_sensor = 2'b00;
		i_e_sensor = 2'b00;
		i_n_sensor = 2'b00;
		$display("Sensor States: west: %2b south: %2b east: %2b north: %2b", i_w_sensor[1:0], i_s_sensor[1:0], i_e_sensor[1:0], i_n_sensor[1:0]);
		for(j = 0; j < 250; j = j + 1)
			begin
				#20;	
				
				if	((w_green + s_green + e_green + n_green) > 1)	//At any particular time, if two green lights are lit, then there is an error
							begin
								$display("ERROR at time %0d: West [%3b] South [%3b] East [%3b] North [%3b]",$time, o_west, o_south, o_east, o_north);
								$display("Test Failed, Ending Testbench Simulation");
								$finish;
							end
			end
		#50;
      
      //Case 2 West Lane most car 
		i_w_sensor = 2'b11;
		i_s_sensor = 2'b10;
		i_e_sensor = 2'b01;
		i_n_sensor = 2'b00;
		$display("Sensor States: west: %2b south: %2b east: %2b north: %2b", i_w_sensor[1:0], i_s_sensor[1:0], i_e_sensor[1:0], i_n_sensor[1:0]);
		for(j = 0; j < 250; j = j + 1)
			begin
				#20;	
				
				if	((w_green + s_green + e_green + n_green) > 1)	//At any particular time, if two green lights are lit, then there is an error
							begin
								$display("ERROR at time %0d: West [%3b] South [%3b] East [%3b] North [%3b]",$time, o_west, o_south, o_east, o_north);
								$display("Test Failed, Ending Testbench Simulation");
								$finish;
							end
			end
		#50;
      
      	//Case 3 South Lane most car 
		i_w_sensor = 2'b00;
		i_s_sensor = 2'b11;
		i_e_sensor = 2'b10;
		i_n_sensor = 2'b01;
		$display("Sensor States: west: %2b south: %2b east: %2b north: %2b", i_w_sensor[1:0], i_s_sensor[1:0], i_e_sensor[1:0], i_n_sensor[1:0]);
		for(j = 0; j < 250; j = j + 1)
			begin
				#20;	
				
				if	((w_green + s_green + e_green + n_green) > 1)	//At any particular time, if two green lights are lit, then there is an error
							begin
								$display("ERROR at time %0d: West [%3b] South [%3b] East [%3b] North [%3b]",$time, o_west, o_south, o_east, o_north);
								$display("Test Failed, Ending Testbench Simulation");
								$finish;
							end
			end
		#50;
      
      	//Case 4 East Lane most car 
		i_w_sensor = 2'b01;
		i_s_sensor = 2'b00;
		i_e_sensor = 2'b11;
		i_n_sensor = 2'b10;
		$display("Sensor States: west: %2b south: %2b east: %2b north: %2b", i_w_sensor[1:0], i_s_sensor[1:0], i_e_sensor[1:0], i_n_sensor[1:0]);
		for(j = 0; j < 250; j = j + 1)
			begin
				#20;	
				
				if	((w_green + s_green + e_green + n_green) > 1)	//At any particular time, if two green lights are lit, then there is an error
							begin
								$display("ERROR at time %0d: West [%3b] South [%3b] East [%3b] North [%3b]",$time, o_west, o_south, o_east, o_north);
								$display("Test Failed, Ending Testbench Simulation");
								$finish;
							end
			end
		#50;
      
      
      	//Case 5 North Lane most car 
		i_w_sensor = 2'b10;
		i_s_sensor = 2'b01;
		i_e_sensor = 2'b00;
		i_n_sensor = 2'b11;
		$display("Sensor States: west: %2b south: %2b east: %2b north: %2b", i_w_sensor[1:0], i_s_sensor[1:0], i_e_sensor[1:0], i_n_sensor[1:0]);
		for(j = 0; j < 250; j = j + 1)
			begin
				#20;	
				
				if	((w_green + s_green + e_green + n_green) > 1)	//At any particular time, if two green lights are lit, then there is an error
							begin
								$display("ERROR at time %0d: West [%3b] South [%3b] East [%3b] North [%3b]",$time, o_west, o_south, o_east, o_north);
								$display("Test Failed, Ending Testbench Simulation");
								$finish;
							end
			end
		#50;
      
      
		
		
		
		
		
		
		
		$display("*** Testbench Successfully Passed! ***");
		$finish;
		
		
	
		
	end


endmodule