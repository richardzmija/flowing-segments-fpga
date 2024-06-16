library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dbc_clock_s is
    Port (
        clk_in : in STD_LOGIC;  -- Input clock signal at 25.175 MHz
        reset : in STD_LOGIC;  -- Input reset signal for initialization and testing
        clk_out : out STD_LOGIC;  -- Output clock signal at 1 kHz
    );
end dbc_clock_s;

architecture behavioral of dbc_clock_s is

    -- 25.175 MHz / (2 * 1kHz)
    constant DIVISOR : integer := 12587;
    signal counter : integer := 0;
    signal clk_out_internal : STD_LOGIC := '0';

begin

    process (clk_in, reset)
    begin

        -- If reset signal is sent then reset the internal
        -- state of the component.
        if reset = '1' then
            counter <= 0;
            clk_out_internal <= '0';
        -- Otherwise keep counting clock signals
        elsif rising_edge(clk_in) then
            if counter = (DIVISOR - 1) then
                counter <= 0;
                clk_out_internal <= not clk_out_internal;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Concurrent signal assignment to continuously
    -- update the input signal from the component.
    clk_out <= clk_out_internal;

end behavioral;