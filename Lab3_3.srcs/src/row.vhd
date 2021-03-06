

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity m_row is
    Port ( 
            counter      : in  unsigned(7 downto 0)  := "00000000";
            red          : in  std_logic_vector (63 downto 0);
            green        : in  std_logic_vector (63 downto 0);
            blue         : in  std_logic_vector (63 downto 0);
            red_pwm      : out std_logic_vector (7 downto 0) := "00000000";
            green_pwm    : out std_logic_vector (7 downto 0) := "00000000";
            blue_pwm     : out std_logic_vector (7 downto 0) := "00000000"
            );
end m_row;

architecture Behavioral of m_row is
    component m_color_channel is
    Port (  
            counter     : in  unsigned(7 downto 0)          := "00000000";
            red         : in  std_logic_vector(7 downto 0)  := "00000000";
            green       : in  std_logic_vector(7 downto 0)  := "00000000";
            blue        : in  std_logic_vector(7 downto 0)  := "00000000";
            red_pwm     : out std_logic                     := '0';
            green_pwm   : out std_logic                     := '0';
            blue_pwm    : out std_logic                     := '0'
           );
    end component;
begin

-- Generate color channel
gen_color_channels: 
for cc in 0 to 7 generate
  m_color_channel_nr: m_color_channel port map
    (   counter     => counter,
        red         => red(  (8*(cc+1))-1 downto (8*cc)),
        green       => green((8*(cc+1))-1 downto (8*cc)),
        blue        => blue( (8*(cc+1))-1 downto (8*cc)),
        red_pwm     => red_pwm(cc),
        green_pwm   => green_pwm(cc),
        blue_pwm    => blue_pwm(cc)
    );
end generate gen_color_channels;



end Behavioral;
