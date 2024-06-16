library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_s is
    Port (
        clk_in : in STD_LOGIC;  -- Input clock signal at 25.175 MHz
        reset : in STD_LOGIC;  -- Input reset signal for initialization and testing
        clk_out : out STD_LOGIC;  -- Output clock signal at 1 Hz
    );
end clk_s;

-- Name 'behavioral' is a conventional name used for
-- an architecture of an entity that specifies the behavior
-- of the entity in a high-level, algorithmic way
architecture behavioral of clk_s is

    -- FPGA clock has frequency 25.175 MHz
    -- 25.175 * 1000000 / 2
    constant DIVISOR : integer := 12587500;
    signal counter : integer := 0;

    -- It is created to separate the logic of the process
    -- from the interface of the component
    signal clk_out_internal : STD_LOGIC := '0';

begin

    process (clk_in, reset)
    begin
        
        -- If reset was signalled then reset the component
        if reset = '1' then
            counter <= 0;
            clk_out_internal <= '0';
        -- Otherwise check if the FPGA clock has rising edge
        elsif rising_edge(clk_in) then
            -- If counter is full then change the value
            -- of the internal clock signal.
            if counter = (DIVISOR - 1) then
                counter <= 0;
                clk_out_internal <= not clk_out_internal;
            else
                -- Otherwise increment the counter
                counter <= counter + 1;
            end if;
        end if;

    end process;

    -- Concurrent signal assigment to clk_out of the internal clock.
    -- This ensures that the output reflects the state of the internal
    -- signal.
    clk_out <= clk_out_internal;

end behavioral;