library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--HALF ADDER
entity HA is
	port(
		a : in std_logic;
		b : in std_logic;
		co: out std_logic;
		s: out std_logic);
end HA;

architecture gate of HA is

begin

co <= a AND b;
s  <= a XOR b;

end gate;
