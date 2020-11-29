library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity lut is
	port(
		mult  : in std_logic_vector(31 downto 0);		
		in_lut: in std_logic_vector(2 downto 0);
		s     : out std_logic;                   --sign bit
		mbe_pp: out std_logic_vector(32 downto 0));
end lut;

architecture behavioral of lut is

signal tmp_mbe: std_logic_vector(32 downto 0);
signal tmp_s  : std_logic;
signal n_A    : std_logic_vector(31 downto 0);

begin

n_A <= not(mult)+1;

p_LUT: process(in_lut)
	begin
	case in_lut is
		when "000" => tmp_mbe <= (others=>'0');
					  tmp_s <= '0';
		when "001" => tmp_mbe <= '0'&mult;
					  tmp_s <= '0';
		when "010" => tmp_mbe <= '0'&mult;
					  tmp_s <= '0';
		when "011" => tmp_mbe <= mult(31 downto 0)&'0';
					  tmp_s <= '0';
		when "100" => tmp_mbe <= n_A&'0';
					  tmp_s <= '1';
		when "101" => tmp_mbe <= '1'&n_A;
					  tmp_s <= '1';
		when "110" => tmp_mbe <= '1'&n_A;
					  tmp_s <= '1';
		when "111" => tmp_mbe <= (others=> '0');
					  tmp_s <= '1';
		when others =>tmp_mbe <= (others=>'0');
					  tmp_s <= '1';
	end process;

end behavioral;
