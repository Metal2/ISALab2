library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity lut is
	port(
		mult  : in std_logic_vector(31 downto 0);	--multiplicand
		in_lut: in std_logic_vector(2 downto 0); 	--multiplier bits
		s     : out std_logic;                      --sign bit
		mbe_pp: out std_logic_vector(32 downto 0)); --modified booth partial product
end lut;

architecture behavioral of lut is

signal tmp_mbe: std_logic_vector(32 downto 0);
signal tmp_s  : std_logic;

signal n_A    : std_logic_vector(32 downto 0);
signal A      : std_logic_vector(32 downto 0);


begin



--output assignment--
mbe_pp<=tmp_mbe;
s<=tmp_s;
---------------------


--partial products
A   <= '0'&mult;  --multiplicand
n_A <= not(A); --inverted multiplicand

  

p_LUT: process(in_lut,A,n_A)
	begin
	case in_lut is
		when "000" => tmp_mbe <= (others=>'0'); -- 0
					  tmp_s <= '0';
		when "001" => tmp_mbe <= A; -- A
					  tmp_s <= '0';
		when "010" => tmp_mbe <= A; -- A
					  tmp_s <= '0';
		when "011" => tmp_mbe <= A(31 downto 0)&'0'; -- 2A
					  tmp_s <= '0';
		when "100" => tmp_mbe <= n_A(31 downto 0)&'1'; -- -2A
					  tmp_s <= '1';
		when "101" => tmp_mbe <= n_A; -- -A
					  tmp_s <= '1';
		when "110" => tmp_mbe <= n_A; -- -A
					  tmp_s <= '1';
		when "111" => tmp_mbe <= (others=> '1'); -- -0
					  tmp_s <= '1';
		when others =>tmp_mbe <= (others=>'0');
					  tmp_s <= '1';
		end case;
	end process;

end behavioral;
