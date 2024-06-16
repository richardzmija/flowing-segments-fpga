library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        clk : in STD_LOGIC;  -- FPGA clock input (25.175 MHz)
        button_speed : in STD_LOGIC;  -- Button for speed control
        button_dir : in STD_LOGIC;  -- Button for direction control
        display1 : out STD_LOGIC_VECTOR(6 downto 0);  -- Values for the first digit
        display2 : out STD_LOGIC_VECTOR(6 downto 0);  -- Values for the second digit
    );
end top_level;

architecture structural of top_level is
    -- Component declarations
    component clk_s is
        Port (
        clk_in : in STD_LOGIC;  -- Input clock signal at 25.175 MHz
        reset : in STD_LOGIC;  -- Input reset signal for initialization and testing
        clk_out : out STD_LOGIC;  -- Output clock signal at 1 Hz
    );
    end component;

    component dbc_clock_s is
        Port (
        clk_in : in STD_LOGIC;  -- Input clock signal at 25.175 MHz
        reset : in STD_LOGIC;  -- Input reset signal for initialization and testing
        clk_out : out STD_LOGIC;  -- Output clock signal at 1 kHz
    );
    end component;

    component debouncer is
        Port (
        clk : in STD_LOGIC;  -- 1kHz clock signal
        reset : in STD_LOGIC;  -- Reset signal
        button_in : in STD_LOGIC;  -- Raw button input (active-low)
        debounced_out : out STD_LOGIC;  -- Debounced button output
    );
    end component;

    component speed_controller is
        Port (
        clk_in : in STD_LOGIC;  -- Slowed input clock signal
        button_speed : in STD_LOGIC;  -- Control signal for frequency adjustment
        clk_out : out STD_LOGIC;  -- Output transformed clock signal
    );
    end component;

    component state_controller is
        Port (
        clk : in STD_LOGIC;  -- Clock signal from speed_controller
        button_dir : in STD_LOGIC;  -- Low-active button for direction control
        state : out STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit register output
    );
    end component;

    component seven_segment_mapper is
        Port (
        clk : in STD_LOGIC;  -- The same block signal as for state_controller
        reset : in STD_LOGIC;  -- Reset signal
        state : in STD_LOGIC_VECTOR(2 downto 0)  -- 3-bit input from state_controller
        seg1 : out STD_LOGIC_VECTOR(6 downto 0)  -- Segments for the first digit
        seg2 : out STD_LOGIC_VECTOR(6 downto 0)  -- Segments for the second digit
    );
    end component;


    -- Signals for connecting the components
    signal slow_clock : STD_LOGIC;
    signal slow_clock_dbc : STD_LOGIC;
    signal debounced_speed : STD_LOGIC;
    signal debounced_dir : STD_LOGIC;
    signal speed_clk : STD_LOGIC;
    signal state_sig : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantiate clk_s (1Hz clock signal)
    clk_s_inst: clk_s
        port map (
            clk_in => clk,
            reset => '0',
            clk_out => slow_clock
        );

    -- Instantiate dbc_clock_s (1kHz clock signal)
    dbc_clock_s_inst: dbc_clock_s
        port map (
            clk_in => clk,
            reset => '0',
            clk_out => slow_clock_dbc
        );

    -- Instantiate debouncer_s (debouncer for speed button)
    debouncer_s_inst: debouncer
        port map (
            clk => slow_clock_dbc,
            reset => '0',
            button_in => button_speed,
            debounced_out => debounced_speed
        );

    -- Instantiate debouncer_d (debouncer for direction button)
    debouncer_d_inst: debouncer
        port map (
            clk => slow_clock_dbc,
            reset => '0',
            button_in => button_dir,
            debounced_out => debounced_dir
        );

    -- Instantiate speed_controller
    speed_controller_inst: speed_controller
        port map (
            clk_in => slow_clock,
            button_speed => debounced_speed,
            clk_out => speed_clk
        );

    -- Instantiate state_controller
    state_controller_inst: state_controller
        port map (
            clk => speed_clk,
            button_dir => debounced_dir,
            state => state_sig
        );
    
    -- Instantiate seven_segment_mapper
    seven_segment_mapper_inst: seven_segment_mapper
        port map (
            clk => speed_clk,
            reset => '0',
            state => state_sig,
            seg1 => display1,
            seg2 => display2
        );

end structural;
