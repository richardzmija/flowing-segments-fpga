library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    Port (
        clk : in STD_LOGIC;  -- 1kHz clock signal
        reset : in STD_LOGIC;  -- Reset signal
        button_in : in STD_LOGIC;  -- Raw button input (active-low)
        debounced_out : out STD_LOGIC  -- Debounced button output
    );
end debouncer;

-- This component implements a debouncer that uses a 20-bit
-- shift register that acts like a FIFO queue.
-- New button state is shifted in on each clock cycle, and the
-- oldest state is shifted out. The stability of the button
-- is checked over a 20 ms interval ensuring a reliable and
-- stable debounced output signal.
architecture behavioral of debouncer is
    -- 20-bit shift register
    signal shift_reg : STD_LOGIC_VECTOR(19 downto 0) := (others => '1');
    signal debounced_out_internal : STD_LOGIC := '1';

    -- Constants for checking if the signal is stable
    constant ALL_ZEROS : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
    constant ALL_ONES : STD_LOGIC_VECTOR(19 downto 0) := (others => '1');

begin

    process (clk, reset)
    begin

        if reset = '1' then
            shift_reg <= ALL_ONES;  -- Reset to '1' for active-low logic
            debounced_out_internal <= '1';
        elsif rising_edge(clk) then
            -- Enqueue a new sample
            shift_reg <= shift_reg(18 downto 0) & button_in;

            -- Check if all bits in the shift register are '0' (button pressed)
            if shift_reg = ALL_ZEROS then
                debounced_out_internal <= '0';
            -- Check if all bits in the shift register are '1' (button released)
            elsif shift_reg = ALL_ONES then
                debounced_out_internal <= '1';
            end if;
        end if;
    end process;


    -- Concurrent signal assignment to debounced_out of the
    -- internal signal. This ensures the output signal out
    -- of the component reflects the state of the internal
    -- signal.
    debounced_out <= debounced_out_internal;

end behavioral;