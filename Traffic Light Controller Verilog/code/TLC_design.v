// Code your design here
module	tlc	(input i_clock, input i_reset_b, input i_g2y_timer, input i_y2r_timer,
             input [1:0] i_w_sensor, input [1:0] i_s_sensor, input [1:0] i_e_sensor, input [1:0] i_n_sensor,
		 output reg w_red, output reg w_yellow, output reg w_green,
		 output reg s_red, output reg s_yellow, output reg s_green,
		 output reg e_red, output reg e_yellow, output reg e_green,
		 output reg n_red, output reg n_yellow, output reg n_green);
		 
//Registers for storing of transition states
reg	w_green_to_yellow 	= 0;
reg	w_yellow_to_red 	= 0;
reg	s_green_to_yellow 	= 0;
reg	s_yellow_to_red 		= 0;
reg	e_green_to_yellow 	= 0;
reg	e_yellow_to_red 		= 0;
reg	n_green_to_yellow 	= 0;
reg	n_yellow_to_red 		= 0;
reg	green_to_yellow		= 0;
reg	yellow_to_red		= 0;

//Registers for next priority lane with most vehicle
reg	w_go		= 0;		//Skipping to West
reg	s_go		= 0;		//Skipping to South
reg	e_go		= 0;		//Skipping to East
reg	n_go		= 0;		//Skipping to North


always @(posedge i_clock, posedge i_g2y_timer, posedge i_y2r_timer, i_reset_b)
	begin
		if(i_reset_b)
			begin
				//Upon reset, the west pathway is green
				w_green		<= 1'b1;
				w_yellow 	<= 1'b0;
				w_red		<= 1'b0;

				//Other pathways must be set to red
				s_green		<= 1'b0;
				s_yellow 	<= 1'b0;
				s_red		<= 1'b1;

				e_green		<= 1'b0;
				e_yellow 	<= 1'b0;
				e_red		<= 1'b1;

				n_green		<= 1'b0;
				n_yellow 	<= 1'b0;
				n_red		<= 1'b1;

			end
		else
			begin
				if(green_to_yellow)	//Changing the states of traffic light for green to yellow transitions
					begin
							
							green_to_yellow				<= 1'b0;
							if(w_green_to_yellow)
								begin
									w_green_to_yellow	<= 1'b0;
									w_green			<= 1'b0;
									w_yellow		<= 1'b1;
								end
							else if(s_green_to_yellow)
								begin
									s_green_to_yellow	<= 1'b0;
									s_green			<= 1'b0;
									s_yellow			<= 1'b1;

								end
							else if(e_green_to_yellow)
								begin
									e_green_to_yellow	<= 1'b0;
									e_green		<= 1'b0;
									e_yellow		<= 1'b1;
								end
							else if(n_green_to_yellow)
								begin
									n_green_to_yellow	<= 1'b0;
									n_green		<= 1'b0;
									n_yellow		<= 1'b1;
								end
					end
				
				
				if(i_g2y_timer)			//Detection of transition cycle
					begin			//Detection of present state according to traffic light states
						if(w_green)
							begin
								w_green_to_yellow	<= 1'b1;
								green_to_yellow		<= 1'b1;
	
							end
						else if(s_green)
							begin
								s_green_to_yellow	<= 1'b1;
								green_to_yellow		<= 1'b1;
	
							end
						else if(e_green)
							begin
								e_green_to_yellow	<= 1'b1;
								green_to_yellow		<= 1'b1;
	
							end
						else if(n_green)
							begin
								n_green_to_yellow	<= 1'b1;
								green_to_yellow		<= 1'b1;
	
							end
					end

				if(yellow_to_red)		//Changing the states of traffic light for yellow to red transitions
					begin
						yellow_to_red	<= 1'b0;
						if(w_yellow_to_red)
							begin
								if(e_go)
									begin
										e_red		<= 1'b0;
										e_green	<= 1'b1;
										e_go		<= 1'b0;
									end
								else if(n_go)
									begin
										n_red		<= 1'b0;
										n_green	<= 1'b1;
										n_go		<= 1'b0;
									end
								else if(s_go)
									begin
										s_red 	<= 1'b0;
										s_green	<= 1'b1;
										s_go    <= 1'b0;
									end
								w_yellow_to_red	<= 1'b0;
							end
							
						else if(s_yellow_to_red)
							begin
								if(n_go)
									begin
										n_red		<= 1'b0;
										n_green	<= 1'b1;
										n_go		<= 1'b0;
									end
								else if(w_go)
									begin
										w_red		<= 1'b0;
										w_green	<= 1'b1;
										w_go		<= 1'b0;
									end
								else if(e_go)
									begin
										e_red 	<= 1'b0;
										e_green	<= 1'b1;
										e_go <= 1'b0;
									end
								s_yellow_to_red	<= 1'b0;
							end
							
						else if(e_yellow_to_red)
							begin
								if(w_go)
									begin
										w_red		<= 1'b0;
										w_green	<= 1'b1;
										w_go		<= 1'b0;
									end
								else if(s_go)
									begin
										s_red		<= 1'b0;
										s_green	<= 1'b1;
										s_go		<= 1'b0;
									end
								else if(n_go)
									begin
										n_red 	<= 1'b0;
										n_green	<= 1'b1;
										n_go <= 1'b0;
									end
								e_yellow_to_red	<= 1'b0;
							end
							
						
						else if(n_yellow_to_red)
							begin
								if(s_go)

									begin
										s_red		<= 1'b0;
										s_green	<= 1'b1;
										s_go		<= 1'b0;
									end
								else if(e_go)
									begin
										e_red		<= 1'b0;
										e_green	<= 1'b1;
										e_go		<= 1'b0;
									end
								else if(w_go)
									begin 
										w_red 	<= 1'b0;
										w_green	<= 1'b1;
										w_go <= 1'b0;
									end
								n_yellow_to_red	<= 1'b0;
							end		
					end
								
							

				if(i_y2r_timer)	//Changing from yellow to red
					begin
						if(w_yellow)
							begin
								w_yellow_to_red	<= 1'b1;
								yellow_to_red	<= 1'b1;
								w_yellow	<= 1'b0;
								w_red		<= 1'b1;
								if (i_s_sensor >= i_e_sensor && i_s_sensor >= i_n_sensor)
										s_go <= 1'b1;
								

								else if (i_e_sensor >= i_s_sensor && i_e_sensor >= i_n_sensor)
										e_go <= 1'b1;
								 
								else
										n_go <= 1'b1;
							end
						else if(s_yellow)
							begin
								s_yellow_to_red	<= 1'b1;
								yellow_to_red	<= 1'b1;
								s_yellow	<= 1'b0;
								s_red		<= 1'b1;
								if (i_e_sensor >= i_n_sensor && i_e_sensor >= i_w_sensor)
									e_go <= 1'b1;
								

								else if (i_n_sensor >= i_e_sensor && i_n_sensor >= i_w_sensor)
									n_go <= 1'b1;
								 
								else
									w_go <= 1'b1;
							end
						else if(e_yellow)
							begin
								e_yellow_to_red	<= 1'b1;
								yellow_to_red	<= 1'b1;
								e_yellow	<= 1'b0;
								e_red		<= 1'b1;
								if (i_n_sensor >= i_w_sensor && i_n_sensor >= i_s_sensor)
									n_go <= 1'b1;
								

								else if (i_w_sensor >= i_n_sensor && i_w_sensor >= i_s_sensor)
									w_go <= 1'b1;
								 
								else
									s_go <= 1'b1;
							end
						else if(n_yellow)
							begin
								n_yellow_to_red	<= 1'b1;
								yellow_to_red	<= 1'b1;
								n_yellow	<= 1'b0;
								n_red		<= 1'b1;
								if (i_w_sensor >= i_s_sensor && i_w_sensor >= i_e_sensor)
									w_go <= 1'b1;
								

								else if (i_s_sensor >= i_w_sensor && i_s_sensor >= i_e_sensor)
									s_go <= 1'b1;
								 
								else
									e_go <= 1'b1;
							end
					end
			end
	end
endmodule