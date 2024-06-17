library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_slow_down_clk is
end tb_slow_down_clk;

architecture sim of tb_slow_down_clk is
    -- Signals for testing
    signal clk_in : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal clk_out : STD_LOGIC;

    -- Approximate period of the FPGA 25.175 MHz clock
    -- 1 / (25.175 MHz) s
    constant clk_period : TIME := 39.7 ns;
    signal clk_count : INTEGER := 0;

    -- Declare the DUT
    component clk_s
        port (
            clk_in : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

begin

    -- Innstantiate the DUT
    DUT: clk_s
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

    -- Now we need to find a clever way to check whether
    -- the frequency approximately agrees with the one we want (1 Hz)
    test : process
    begin
        
        -- First we reset the clock
        reset <= '1';
        -- Wait for some time for signal to propagate
        wait for 10 * clk_period;
        reset <= '0';

        -- Run the simulation for half a minute to get an accurate estimate
        -- of the clock that we are sampling
        wait for 30 sec;

        -- End the simulation i.e. block indefinitely
        wait;
    end process;

    -- We set up another process which will monitor the changes to the
    -- output of the DUT, which is supposed to be a 1 Hz clock
    monitor : process (clk_out)
    begin

        clk_count <= clk_count + 1;
        report "clk_out changed: " & integer'image(clk_count) severity note;

    end process;

end sim;