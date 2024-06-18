library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_slow_down_clk_dbc is
end tb_slow_down_clk_dbc;

architecture sim of tb_slow_down_clk_dbc is

    -- Signals for testing
    signal clk_in : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal clk_out : STD_LOGIC;

    -- Approximate period of the FPGA 25.175 MHz clock
    -- 1 / (25.175 MHz) s
    constant clk_period : TIME := 39.7 ns;
    signal clk_count : INTEGER := 0;

    -- Declare the DUT
    component dbc_clock_s
        port (
            clk_in : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

begin

    -- Innstantiate the DUT
    DUT: dbc_clock_s
        port map (
            clk_in => clk_in,
            reset => reset,
            clk_out => clk_out
        );

    -- Generate a clock with a very similar frequency
    -- to the one on the FPGA
    clk_process : process
    begin

        while true loop
            clk_in <= '0';
            wait for clk_period / 2;
            clk_in <= '1';
            wait for clk_period / 2;
        end loop;

    end process;

    test : process
    begin

        reset <= '1';
        wait for 10 * clk_period;
        reset <= '0';
        wait for 30 sec;
        wait;
    end process;

    monitor : process (clk_out)
    begin

        clk_count <= clk_count + 1;
        report "clk_out changed: " & integer'image(clk_count) severity note;
        
    end process;
end sim;