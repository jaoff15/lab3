

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity led_matrix is
    Port (  clk          : in std_logic;
            row          : out std_logic_vector (7 downto 0);
            red          : out std_logic_vector (7 downto 0);
            green        : out std_logic_vector (7 downto 0);
            blue         : out std_logic_vector (7 downto 0)
           );
end led_matrix;


architecture Behavioral of led_matrix is
     -- Define interface with row
    component m_row is
    Port (  
            counter     : in  unsigned(7 downto 0)          := "00000000";
            red         : in  std_logic_vector(63 downto 0) := x"0000000000000000"; 
            green       : in  std_logic_vector(63 downto 0) := x"0000000000000000";
            blue        : in  std_logic_vector(63 downto 0) := x"0000000000000000";
            red_pwm     : out std_logic_vector(7  downto 0) := "00000000";
            green_pwm   : out std_logic_vector(7  downto 0) := "00000000";
            blue_pwm    : out std_logic_vector(7  downto 0) := "00000000"
           );
    end component;
    
    component mem_interface is
    Port ( 
            clk          : in  std_logic;
            start        : in  std_logic                     := '0';
            row          : in  std_logic_vector(2 downto 0)  := "000";
            done         : out std_logic                     := '0';
            red          : out std_logic_vector(63 downto 0) := x"0000000000000000"; 
            green        : out std_logic_vector(63 downto 0) := x"0000000000000000";
            blue         : out std_logic_vector(63 downto 0) := x"0000000000000000"
            );
    end component;
    
    -- Prescaled clock counter
    signal counter              : unsigned(7 downto 0)  := "00000000";
    
    -- clock prescaler
    signal prescaler            : unsigned(63 downto 0) := x"0000000000000000";
    
    -- Row counter
    signal row_counter          : unsigned(2 downto 0) := "000";
    signal row_sig              : std_logic_vector(2 downto 0) := "000";
    
    -- Define states
    type state_type is (STATE_SHIFT_ROW, STATE_GET, STATE_WAIT, STATE_READY);
    signal state : state_type := STATE_READY;
    

    -- Color threshold signals
    signal red_sig              : std_logic_vector(63 downto 0) := x"0000000000000000";
    signal green_sig            : std_logic_vector(63 downto 0) := x"0000000000000000";
    signal blue_sig             : std_logic_vector(63 downto 0) := x"0000000000000000";
    
    -- Color pwm signals
    signal red_pwm_sig          : std_logic_vector(7 downto 0) := "00000000";
    signal green_pwm_sig        : std_logic_vector(7 downto 0) := "00000000";
    signal blue_pwm_sig         : std_logic_vector(7 downto 0) := "00000000";
    
    -- Memory interface signals
    signal start_sig, done_sig            : std_logic := '0';

    -- Clock prescalings
    signal pwm_clock            : std_logic := '0';
    signal row_clock            : std_logic := '0';
begin

-- prescale clock
prescale_clock_process: process (clk)
begin
   if rising_edge(clk) then
        prescaler <= prescaler + 1;
   end if;
end process;

-- Increment counter
counter_process: process (pwm_clock)
begin
   if rising_edge(pwm_clock) then
        counter <= counter + 1;
   end if;
end process;


-- State machine
row_counter_process: process (row_clock)
begin
   if rising_edge(row_clock) then
       -- State Shift Row
       if state = STATE_SHIFT_ROW then
            red     <= red_pwm_sig;
            green   <= green_pwm_sig;
            blue    <= blue_pwm_sig;
            
           case row_counter is
              when "000"  => row <= "01111111";
              when "001"  => row <= "10111111";
              when "010"  => row <= "11011111";
              when "011"  => row <= "11101111";
              when "100"  => row <= "11110111";
              when "101"  => row <= "11111011";
              when "110"  => row <= "11111101";
              when "111"  => row <= "11111110";
              when others => row <= "11111111";
           end case;
 
            state  <= STATE_GET;
       
       -- State Get
       elsif state = STATE_GET then
            row_counter <= row_counter + 1;
            start_sig   <= '1';
            state       <= STATE_WAIT;
       
       -- State Wait
       elsif state = STATE_WAIT then
            start_sig <= '0';
            -- Wait for done signal
           if done_sig = '1' then
                state   <= STATE_READY;
           end if;
           
       -- State Ready
       elsif state = STATE_READY then
            state   <= STATE_SHIFT_ROW;
       
       else
            state <= STATE_SHIFT_ROW;
       end if;
   end if;
end process;


-- Clock prescalings
pwm_clock <= prescaler(12); -- 12
row_clock <= prescaler(11); -- 11

-- Row signal
row_sig <= std_logic_vector(row_counter);

-- Memory interface
mem_interface0:mem_interface
port map(
    clk          => clk,
    start        => start_sig,
    row          => row_sig,
    done         => done_sig,
    red          => red_sig, 
    green        => green_sig,
    blue         => blue_sig
);

-- Create instance of row component
row0:m_row
port map(
    counter     => counter,
    red         => red_sig,
    green       => green_sig,
    blue        => blue_sig,
    red_pwm     => red_pwm_sig,
    green_pwm   => green_pwm_sig,                                                                                                                                                                                  
    blue_pwm    => blue_pwm_sig
);


end Behavioral;
