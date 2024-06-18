library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- This testbench checks whether the debouncer correctly
-- handled a button eventually setlling to the value 1.

entity tb_debouncer is
end tb_debouncer;

architecture sim of tb_debouncer is

    -- Next we have some signals to bind to the
    -- instantiated component
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal button_in : STD_LOGIC := '0';
    signal debounced_out : STD_LOGIC;

    -- Period for our clock that is used to control
    -- how often the debouncer samples the signal
    constant CLK_PERIOD : time := 1 ms;

    -- We need to have component declarations
    -- so that the compiler knows the interface of
    -- the component
    component debouncer
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            button_in : in STD_LOGIC;
            debounced_out : out STD_LOGIC
        );
    end component;

begin

    DUT: debouncer
        Port map (
            clk => clk,
            reset => reset,
            button_in => button_in,
            debounced_out => debounced_out
        );

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
        variable stable_value : STD_LOGIC := '1'; -- button is initially inactive
    begin

        -- Initialize the DUT using reset
        -- debouncer behaves as if the button is inactive
        reset <= '1';
        wait for 2 * CLK_PERIOD; -- Wait for signal to propagate
        reset <= '0';

        -- We want to simulate button oscillating every 50 ns for 15 ms
        -- to check that the debouncer does not change its value.
        for i in 0 to INTEGER(15 ms / 50 ns) - 1 loop
            button_in <= not button_in;
            wait for 50 ns;
            assert debounced_out = stable_value
                report "Debounced output changed during oscillation period"
                severity error;
        end loop;
        
        report "SUCCESS! debounced_out didn't change during oscillations of the button";

        -- Button settles to the active state
        button_in <= '0';
        wait for 40 ms;
        stable_value := '0';

        assert debounced_out = stable_value
            report "Debounced output did not settle correctly"
            severity error;

        report "SUCCESS! debouced_out correctly changed its value when the signal became stable";
        wait;
        
    end process;
end sim;
