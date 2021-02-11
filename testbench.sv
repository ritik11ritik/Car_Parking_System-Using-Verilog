`timescale 1ns / 1ps
module tb;
  reg clk, sensor_entrance, sensor_exit, rst;
  reg[3:0] password;
  wire green_led, red_led;
  
  Car_Parking cp(
    clk, sensor_entrance, sensor_exit, rst,
    password,
    green_led, red_led
  );
  
  always #5 clk = ~clk;
  
  initial
    begin
      $monitor("Time = %0t clk = %0d sensor_entrance = %0d sensor_exit = %0d rst = %0d password = %0d green_led = %0d red_led = %0d", $time, clk, sensor_entrance, sensor_exit, rst, password, green_led, red_led);
      
      clk = 1'b0;
      rst = 1'b1;
      #20;
      
      rst = 1'b0;
      #20;
      
      rst = 1'b1;
      sensor_entrance = 1'b1;
      #200
      
      sensor_entrance = 1'b1;
      #20;
      
      sensor_entrance = 1'b0;
      password = 4'b0000;
      #50;
      
      password = 4'b1111;
      #20;
      
      password = 4'b0000;
      #20
      
      sensor_entrance = 1'b1;
      sensor_exit = 1'b1;
      #20
      
      password = 4'b1111;
      sensor_entrance = 1'b0;
      sensor_exit = 1'b0;
      #20
      
      sensor_exit = 1'b1;
      #100;
      
      
      $finish;     
    end
    
endmodule
