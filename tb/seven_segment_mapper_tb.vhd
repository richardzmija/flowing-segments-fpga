library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- There are no ports in the entity declaration
-- because this is a test bench
entity tb_seven_segment_mapper is
end tb_seven_segment_mapper;

architecture sim of tb_seven_segment_mapper is
    -- Signals for testing
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal state : STD_LOGIC_VECTOR(2 downto 0);
    signal seg1 : STD_LOGIC_VECTOR(6 downto 0);
    signal seg2 : STD_LOGIC_VECTOR(6 downto 0);

    -- Period of the clock used as input clock
    constant clk_period : time := 10 ns;

    -- Before we instantiate the component we need to
    -- declare it so that the architecture knows its
    -- interface.
    component seven_segment_mapper
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            state : in STD_LOGIC_VECTOR(2 downto 0);
            seg1 : out STD_LOGIC_VECTOR(6 downto 0);
            seg2 : out STD_LOGIC_VECTOR(6 downto 0)
        );
        end component;

begin

    -- Here we need to instantiate the DUT (design under test) and
    -- write processes for testing it

    -- Instantiate the DUT
    DUT: seven_segment_mapper
        port map (
            clk => clk,
            reset => reset,
            state => state,
            seg1 => seg1,
            seg2 => seg2
        );

    -- Clock signal generation
    clk_process : process is
    begin
        -- Loop indefinitely
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- This process uses everything that we have written above
    -- to test the DUT
    test : process is
    begin
        -- The reset port included for testing purposes will now be used
        -- Reset the DUT
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- We will give it different states (3-bit std_logic_vector)
        -- and check its outputs.
        state <= "000";
        wait for clk_period;
        assert (seg1 = "0111111" and seg2 = "0111111") report "Test Case 000 Failed" severity error;
        report "Test case 000 Sucessful!";

        state <= "001";
        wait for clk_period;
        assert (seg1 = "1111111" and seg2 = "0011111") report "Test Case 001 Failed" severity error;
        report "Test case 001 Successful!";

        state <= "010";
        wait for clk_period;
        assert (seg1 = "1111111" and seg2 = "1001111") report "Test Case 010 Failed" severity error;
        report "Test case 010 Successful!";

        state <= "011";
        wait for clk_period;
        assert (seg1 = "1111111" and seg2 = "1100111") report "Test Case 011 Failed" severity error;
        report "Test case 011 Successful!";

        state <= "100";
        wait for clk_period;
        assert (seg1 = "1110111" and seg2 = "1110111") report "Test Case 100 Failed" severity error;
        report "Test case 100 Successful!";

        state <= "101";
        wait for clk_period;
        assert (seg1 = "1110011" and seg2 = "1111111") report "Test Case 101 Failed" severity error;
        report "Test case 101 Successful";

        state <= "110";
        wait for clk_period;
        assert (seg1 = "1111001" and seg2 = "1111111") report "Test Case 110 Failed" severity error;
        report "Test case 110 Successful!";

        state <= "111";
        wait for clk_period;
        assert (seg1 = "0111101" and seg2 = "1111111") report "Test Case 111 Failed" severity error;
        report "Test case 111 Successful!";

        report "All tests passed!";
        -- After every assertion is checked then we wait indefinitely until the simulation
        -- is terminated
        wait;
    end process;
end sim;
