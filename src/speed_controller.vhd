library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity speed_controller is
    Port (
        clk_in : in STD_LOGIC;  -- Slowed input clock signal
        button_speed : in STD_LOGIC;  -- Control signal for frequency adjustment
        clk_out : out STD_LOGIC  -- Output transformed clock signal
    );
end speed_controller;

architecture behavioral of speed_controller is
    -- It is created to separate the logic of the process
    -- from the interface of the component
    signal clk_out_internal : STD_LOGIC := '0';
    signal counter : integer := 0;

begin

    -- If the slowed FPGA clock changes
    process (clk_in)
    begin

        if rising_edge(clk_in) then
            -- If the slow mode is enabled then
            -- we divide the frequency by two
            -- using a counter
            if button_speed = '1' then
                if counter = 1 then
                    counter <= 0;
                    clk_out_internal <= not clk_out_internal;
                else
                    counter <= counter + 1;
                end if;
            -- Otherwise, pass the signal unchanged
            else
                clk_out_internal <= clk_in;
            end if;
        end if;

    end process;
    
    -- Concurrent signal assigment to clk_out of the internal clock.
    -- This ensures that the output reflects the state of the internal
    -- signal.
    clk_out <= clk_out_internal;

end behavioral;