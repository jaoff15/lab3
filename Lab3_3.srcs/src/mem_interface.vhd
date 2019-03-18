
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_interface is
    Port ( clk          : in  std_logic;
           start        : in  std_logic                     := '0';
           row          : in  std_logic_vector(2 downto 0)  := "000";
           done         : out std_logic                     := '0';
           red          : out std_logic_vector(63 downto 0) := x"0000000000000000"; 
           green        : out std_logic_vector(63 downto 0) := x"0000000000000000";
           blue         : out std_logic_vector(63 downto 0) := x"0000000000000000"
    );
end mem_interface;

architecture Behavioral of mem_interface is
    
    component LED_RAM_wrapper is
      port (
            BRAM_PORTB_0_addr : in  std_logic_vector ( 31 downto 0 );
            BRAM_PORTB_0_clk  : in  std_logic;
            BRAM_PORTB_0_din  : in  std_logic_vector ( 31 downto 0 );
            BRAM_PORTB_0_dout : out std_logic_vector ( 31 downto 0 );
            BRAM_PORTB_0_we   : in  std_logic_vector (  3 downto 0 )
      );
    end component;
    
    
    -- Memory interface states
    type state_type is (STATE_RESET, STATE_SETUP, STATE_LATCH, STATE_READY);
    signal state : state_type := STATE_READY;
    
    

    -- Temporary signals for colors
    signal values_red           : std_logic_vector(63 downto 0) := x"0000000000000000";
    signal values_green         : std_logic_vector(63 downto 0) := x"0000000000000000";
    signal values_blue          : std_logic_vector(63 downto 0) := x"0000000000000000";
    

    -- Memory addressing
    signal address_counter      : unsigned(2 downto 0)          := "000";
    signal address_row          : unsigned(2 downto 0)          := "000";
    signal addr                 : std_logic_vector(31 downto 0) := x"00000000";
    
    -- Memory output
    signal data_out             : std_logic_vector(31 downto 0) := x"00000000";

    
begin

--  Memory state
memory_state_process: process (clk)
begin
    
   if rising_edge(clk) then
       -- State Reset
       if state = STATE_RESET then
            -- Reset Address
            address_counter <= "000";
            
            -- Clear done
            done    <= '0';
            state   <= STATE_SETUP;
       
       -- State Setup
       elsif state = STATE_SETUP then
            -- Set address out
            state   <= STATE_LATCH;
       
       -- State Latch
       elsif state = STATE_LATCH then
           -- Latch partial
           case address_counter is
              when "000" =>
                 values_red  (7  downto  0) <= data_out(23 downto 16);
                 values_green(7  downto  0) <= data_out(15 downto 8);
                 values_blue (7  downto  0) <= data_out(7  downto 0);
              when "001" =>
                 values_red  (15 downto  8) <= data_out(23 downto 16);
                 values_green(15 downto  8) <= data_out(15 downto 8);
                 values_blue (15 downto  8) <= data_out(7  downto 0);
              when "010" =>
                 values_red  (23 downto 16) <= data_out(23 downto 16);
                 values_green(23 downto 16) <= data_out(15 downto 8);
                 values_blue (23 downto 16) <= data_out(7  downto 0);
              when "011" =>
                 values_red  (31 downto 24) <= data_out(23 downto 16);
                 values_green(31 downto 24) <= data_out(15 downto 8);
                 values_blue (31 downto 24) <= data_out(7  downto 0);
              when "100" =>
                 values_red  (39 downto 32) <= data_out(23 downto 16);
                 values_green(39 downto 32) <= data_out(15 downto 8);
                 values_blue (39 downto 32) <= data_out(7  downto 0);
              when "101" =>
                 values_red  (47 downto 40) <= data_out(23 downto 16);
                 values_green(47 downto 40) <= data_out(15 downto 8);
                 values_blue (47 downto 40) <= data_out(7  downto 0);
              when "110" =>
                 values_red  (55 downto 48) <= data_out(23 downto 16);
                 values_green(55 downto 48) <= data_out(15 downto 8);
                 values_blue (55 downto 48) <= data_out(7  downto 0);
              when "111" =>
                 values_red  (63 downto 56) <= data_out(23 downto 16);
                 values_green(63 downto 56) <= data_out(15 downto 8);
                 values_blue (63 downto 56) <= data_out(7  downto 0);
              when others => 
                 address_counter <= "000";
           end case;
           
           
           if address_counter = "111" then
                -- Change state if max has been reached
                address_counter <= "000";
                state   <= STATE_READY;
            else 
                state   <= STATE_SETUP;
            end if;
            
            -- Increment address
            address_counter <= address_counter + 1;
            
            
       -- State Ready
       elsif state = STATE_READY then
            -- set outputs
            red   <= values_red;
            green <= values_green;
            blue  <= values_blue;
       
            -- set done
            done <= '1';
            if start = '1' then
                state   <= STATE_RESET;
            end if;
            
       else
            state <= STATE_RESET;
       end if;
   end if;
end process;

address_row <= unsigned(row);

addr(4 downto 2) <= std_logic_vector(address_counter);
addr(7 downto 5) <= std_logic_vector(address_row);

-- Create instance of row component
block_ram_interface0:LED_RAM_wrapper
port map(
        BRAM_PORTB_0_addr   => addr,
        BRAM_PORTB_0_clk    => clk,
        BRAM_PORTB_0_dout   => data_out,
        BRAM_PORTB_0_din    => x"00000000",
        BRAM_PORTB_0_we     => "0000"
);

end Behavioral;
