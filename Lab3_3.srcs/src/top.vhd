 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (  
            clk         : in  std_logic;
            red         : out std_logic_vector (7 downto 0) := "00000000";
            green       : out std_logic_vector (7 downto 0) := "00000000";
            blue        : out std_logic_vector (7 downto 0) := "00000000";
            row         : out std_logic_vector (7 downto 0) := "00000000"
           );
end top;

architecture Behavioral of top is
    component led_matrix is
    port (  
           clk          : in STD_LOGIC;
           row          : out STD_LOGIC_VECTOR (7 downto 0);
           red          : out STD_LOGIC_VECTOR (7 downto 0);
           green        : out STD_LOGIC_VECTOR (7 downto 0);
           blue         : out STD_LOGIC_VECTOR (7 downto 0)
           );
    end component;
begin



led_matrix0:led_matrix
port map(
    clk          => clk,
    row          => row,
    red          => red,
    green        => green,
    blue         => blue
);



end Behavioral;
