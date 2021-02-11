`timescale 1ns / 1ps
module Car_Parking(
  input clk, sensor_entrance, sensor_exit, rst,
  input[3:0] password,
  output reg green_led, red_led
);
  parameter [2:0] IDLE = 3'b000,
  				  WAIT_PASSWORD = 3'b001,
  				  RIGHT_PASS = 3'b010,
  				  WRONG_PASS = 3'b011,
  				  STOP = 3'b100;
  
  reg [2:0] present_state, next_state;
  reg [4:0] counter_wait, counter_wrong, counter_stop, counter_led;
  parameter [3:0] default_password = 4'b1111;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1, Car_Parking);
    end
  
  always @(posedge clk or negedge rst)
    begin
      if (~rst)
        begin
          present_state = IDLE;
          green_led = 1'b0;
          red_led = 1'b1;
        end
      else
        begin
          present_state = next_state;
        end
    end
  
  always @(posedge clk or negedge rst)
    begin
      if (~rst)
        begin
          counter_wait = 0;
          counter_wrong = 0; 
          counter_stop = 0;
          counter_led = 0;
        end
      
      else if(present_state == WAIT_PASSWORD)
        begin
          counter_wait = counter_wait + 1;
          counter_wrong = 0;
          counter_stop = 0;
        end
      
      else if(present_state == WRONG_PASS)
        begin
          counter_wait = 0;
          counter_wrong = counter_wrong + 1;
          counter_stop = 0;
        end
      
      else if(present_state == STOP)
        begin
          counter_wait = 0;
          counter_wrong = 0;
          counter_stop = counter_stop + 1;
        end
      
      else
        begin
          counter_wait = 0;
          counter_wrong = 0;
          counter_stop = 0;
        end
      
      if(green_led == 1)
        counter_led = counter_led + 1;
      else
        counter_led = 0;
        
    end
  
  always @(*)
    begin
      case(present_state)
        IDLE:
          begin
            if (sensor_entrance)
              next_state = WAIT_PASSWORD;
            else
              next_state = present_state;
          end
        
        WAIT_PASSWORD:
          begin
            if (password == default_password)
              next_state = RIGHT_PASS;
            else if (counter_wait >= 10)
              next_state = IDLE;
            else if (password != default_password)
              next_state = WRONG_PASS;
            else
              next_state = present_state;
          end
        
        RIGHT_PASS:
          begin
            if(sensor_exit && sensor_entrance)
              next_state = STOP;
            else if(sensor_exit)
              next_state = IDLE;
            else
              next_state = present_state;
          end
        
        WRONG_PASS:
          begin
            if (password != default_password)
              next_state = present_state;
            else if(password == default_password)
              next_state = RIGHT_PASS;
            else if(counter_wrong >= 10)
              next_state = IDLE;
          end
        
        STOP:
          begin
            if (password != default_password)
              next_state = present_state;
            else if(password == default_password)
              next_state = RIGHT_PASS;
            else if(counter_stop >= 10)
              next_state = IDLE;
          end
        
        default:
          next_state = IDLE;  
      endcase
    end
  
  always @(*)
    begin
      if(present_state == RIGHT_PASS && sensor_exit == 1'b1)
        begin
          green_led = 1'b1;
          red_led = 1'b0;
        end
      
      else if(counter_led >= 10)
        begin
          green_led = 1'b0;
          red_led = 1'b1;
        end
    end
  
endmodule
        
      
              
            
                
        
        
  
  
