library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_speed_controller is
end tb_speed_controller;

-- In this testbench we test whether the speed controller
-- properly halves the frequency of the input clock
-- when the 'slow mode' is enabled
architecture sim of tb_speed_controller is

    -- Signals to bind to the instantiated component
    signal clk_in : STD_LOGIC := '0';
    signal button_speed : STD_LOGIC := '0';
    signal clk_out : STD_LOGIC;

    -- Constants for clock periods
    constant CLK_PERIOD : TIME := 1 sec;  -- 1 Hz clock

    -- Component declaration for the speed_controller
    component speed_controller
        Port (
            clk_in : in STD_LOGIC;
            button_speed : in STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

begin

    -- First we instantiate the component
    DUT: speed_controller
        Port map (
            clk_in => clk_in,
            button_speed => button_speed,
            clk_out => clk_out
        );

    -- Next we define a process that simulates the clock signal
    -- from the slowed down FPGA clock
    clk_process : process
    begin
        while true loop
            clk_in <= '0';
            wait for CLK_PERIOD / 2;
            clk_in <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    test : process
    begin

        -- Wait for a clock period before starting the test to make sure
        -- that signals are initialized.
        -- Test 1: button_speed = '0' (clk_out should follow clk_in)
        button_speed <= '0';
        wait for CLK_PERIOD;
        report "Test 1: button_speed = '0'";
        for i in 0 to 5 loop
            wait for CLK_PERIOD / 2;
            -- Use attributes of the data types and concatenation
            -- to display the frequency
            report "Time: " & TIME'image(now) & " clk_out = " & STD_LOGIC'image(clk_out);
        end loop;

        -- Test 2: button_speed = '1' (clk_out frequency should be halved)
        button_speed <= '1';
        wait for CLK_PERIOD;
        report "Test 2: button_speed = '1'";
        for i in 0 to 5 loop
            wait for CLK_PERIOD / 2;
            report "Time: " & TIME'image(now) & " clk_out = " & STD_LOGIC'image(clk_out);
        end loop;

        -- Test 3: Change button_speed back to '0'
        button_speed <= '0';
        wait for CLK_PERIOD;
        report "Test 3: button_speed = '0'";
        for i in 0 to 5 loop
            wait for CLK_PERIOD / 2;
            report "Time: " & TIME'image(now) & " clk_out = " & STD_LOGIC'image(clk_out);
        end loop;

        -- Wait indefinitely and end
        -- the simulation
        wait;
    end process;

end sim;