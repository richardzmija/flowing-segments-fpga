library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity state_controller is
    Port (
        clk : in STD_LOGIC;  -- Clock signal from speed_controller
        button_dir : in STD_LOGIC;  -- Low-active button for direction control
        state : out STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit register output
    );
end state_controller;

architecture behavioral of state_controller is
    -- 3-bit register as a signal of type UNSIGNED with bit width of 3 bits
    -- indexed from 2 to 0, with all bits initialized to '0'.
    -- UNSIGNED is used because we want to have access to arithmetic
    -- operations on the number and the value is always non-negative.
    signal count_reg : UNSIGNED(2 downto 0) := (others => '0');

begin

    process (clk)
    begin

        if rising_edge(clk) then
            -- If we are moving counterclockwise then
            -- decrement the state mod 8
            if button_dir = '0' then
                if count_reg = 0 then
                    count_reg <= to_unsigned(7, 3);  -- Wrap around to maximum value
                else
                    count_reg <= count_reg - 1;
                end if;
            -- Otherwise we must be moving clockwise so
            -- increment the state mod 8
            else
                if count_reg = 7 then
                    count_reg <= to_unsigned(0, 3);  -- Wrap around to minimum value
                else
                    count_reg <= count_reg + 1;
                end if;
            end if;
        end if;

    end process;

    -- Concurrent signal assignment to state of the
    -- value stored in the register.
    -- We need to perform a conversion from UNSIGNED
    -- to STD_LOGIC_VECTOR.
    state <= std_logic_vector(count_reg);

end behavioral;