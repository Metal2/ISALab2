library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity FA is
	port(
		a    : in std_logic;
		b    : in std_logic;
		c_in : in std_logic;
		c_out: out std_logic;
		sum  : out std_logic);
end FA;

architecture structural of FA is

component HA is
	port(
		a : in std_logic;
		b : in std_logic;
		s : out std_logic;
		co: out std_logic);
end component;


signal s1,co1,co2: std_logic; --intermediate sum and carry bits

begin

HA1: HA port map(
	a => a,
	b => b,
	s => s1,
	co => co1);

HA2: HA port map(
	a => c_in,
	b => s1,
	s => sum,
	co => co2);

c_out <= co1 OR co2;

end structural;
