library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This is for converting STD_LOGIC_VECTOR
-- to a string for reporting
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity tb_state_controller is
end tb_state_controller;

architecture sim of tb_state_controller is
    
    -- Signals to bind to the instantiated component
    signal clk : STD_LOGIC := '0';
    signal button_dir : STD_LOGIC := '0';
    signal state : STD_LOGIC_VECTOR(2 downto 0);

    -- Constants for clock periods
    constant CLK_PERIOD : time := 1 sec;  -- 1 Hz clock

    -- Component declaration for the state_controller
    component state_controller
        Port (
            clk : in STD_LOGIC;
            button_dir : in STD_LOGIC;
            state : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

begin

    -- First we instantiate the component
    DUT: state_controller
        Port map (
            clk => clk,
            button_dir => button_dir,
            state => state
        );

    -- Clock process to generate the input clock signal
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    test : process
        variable state_str : LINE;
    begin
        
        -- Wait to make sure the signals are initialized
        wait for CLK_PERIOD;

        -- Remember that the buttons we are working with are zero-active

        -- Test 1: button_dir = '0' (state should be decremented)
        button_dir <= '0';
        wait for CLK_PERIOD; -- wait for button_dir value to change
        report "Test 1: button_dir = '0' (state should be decremented)";
        for i in 0 to 7 loop
            wait for CLK_PERIOD;
            state_str := new STRING'("");
            write(state_str, state);
            report "state = " & state_str.ALL;
        end loop;

        -- Test 2: button_dir = '1' (state should be incremented)
        button_dir <= '1';
        wait for CLK_PERIOD;
        report "Test 2: button_dir = '1' (state should be incremented)";
        for i in 0 to 7 loop
            wait for CLK_PERIOD;
            state_str := new STRING'("");
            write(state_str, state);
            report "state = " & state_str.ALL;
        end loop;

        -- Test 3: Change button_dir back to '0' (state should be decremented)
        button_dir <= '0';
        wait for CLK_PERIOD;
        report "Test 3: button_dir = '0' (state should be decremented again)";
        for i in 0 to 7 loop
            wait for CLK_PERIOD;
            state_str := new STRING'("");
            write(state_str, state);
            report "state = " & state_str.ALL;
        end loop;

        -- Wait indefinitely and end
        -- the simulation
        wait;
    end process;

end sim;