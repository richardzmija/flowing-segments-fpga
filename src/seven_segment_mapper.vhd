library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_segment_mapper is
    Port (
        clk : in STD_LOGIC;  -- The same block signal as for state_controller
        reset : in STD_LOGIC;  -- Reset signal
        state : in STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit input from state_controller
        seg1 : out STD_LOGIC_VECTOR(6 downto 0);  -- Segments for the first digit
        seg2 : out STD_LOGIC_VECTOR(6 downto 0)  -- Segments for the second digit
    );
end seven_segment_mapper;

-- seg1 and seg2 are vectors representing the state of the
-- displays. Each holds values for the sequene of segments 'a'-'g'.
architecture behavioral of seven_segment_mapper is
begin

    process (clk, reset)
    begin

        if reset = '1' then
            -- Turn off all segments for the digits
            seg1 <= "1111111";
            seg2 <= "1111111";
        elsif rising_edge(clk) then
            case state is
                when "000" =>  -- state 0
                    seg1 <= "0111111"; -- segment 'a' first digit
                    seg2 <= "0111111"; -- segment 'a' second digit
                when "001" =>  -- state 1
                    seg1 <= "1111111"; -- all segments off
                    seg2 <= "0011111"; -- segments 'a' and 'b'
                when "010" =>  -- state 2
                    seg1 <= "1111111"; -- all segments off
                    seg2 <= "1001111"; -- segments 'b' and 'c'
                when "011" =>  -- state 3
                    seg1 <= "1111111";  -- all segments off
                    seg2 <= "1100111";  -- segments 'c' and 'd'
                when "100" =>  -- state 4
                    seg1 <= "1110111";  -- segment 'd'
                    seg2 <= "1110111";  -- segment 'd'
                when "101" =>  -- state 5
                    seg1 <= "1110011";  -- segments 'd' and 'e'
                    seg2 <= "1111111";  -- all segments off
                when "110" =>  -- state 6
                    seg1 <= "1111001";  -- segments 'e' and 'f'
                    seg2 <= "1111111";  -- all segments off
                when "111" =>  -- state 7
                    seg1 <= "0111101";  -- segments 'a' and 'f'
                    seg2 <= "1111111";  -- all segments off
                when others =>
                    -- For anything else turn off all segments
                    seg1 <= "1111111";
                    seg2 <= "1111111";
            end case;
        end if;

    end process;
end behavioral;