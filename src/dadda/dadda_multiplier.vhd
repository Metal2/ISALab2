library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity dadda_multiplier is
	port(
		A_in  : in std_logic_vector(31 downto 0); 
		B_in  : in std_logic_vector(31 downto 0);
		P_out : out std_logic_vector(63 downto 0));
end dadda_multiplier;

architecture structural of dadda_multiplier is
	
	type pp             is array (0 to 16) of std_logic_vector(32 downto 0);
	type FA_sum_array   is array (0 to 5 ) of std_logic_vector(119 downto 0);
	type FA_carry_array is array (0 to 5 ) of std_logic_vector(119 downto 0);
	type HA_sum_array   is array (0 to 5 ) of std_logic_vector(11 downto 0);
	type HA_carry_array is array (0 to 5 ) of std_logic_vector(11 downto 0);
	
	signal a : pp;	                          --partial product array							
	signal b : std_logic_vector(34 downto 0); --'0'& multiplier & "00"
	signal s : std_logic_vector(16 downto 0); --sign extension bit   (in realtà s e sn sono 15 downto 0)
	signal sn: std_logic_vector(16 downto 0); --n sign extension bit (ho messo 16 per fare corrisponsdere la lut ma il s(16) e sn(16) non verranno mai usati).

	signal sf: FA_sum_array;
	signal cf: FA_carry_array;
	signal sh: HA_sum_array;
	signal ch: HA_carry_array;

	signal final_sum1: std_logic_vector(64 downto 0);
	signal final_sum2: std_logic_vector(64 downto 0);

	component FA is
	port(
		a    : in std_logic;
		b    : in std_logic;
		c_in : in std_logic;
		c_out: out std_logic;
		sum  : out std_logic);
	end component;

	component HA is
	port(
		a : in std_logic;
		b : in std_logic;
		co: out std_logic;
		s: out std_logic);
	end component;

	component lut is
	port(
		mult  : in std_logic_vector(31 downto 0);		
		in_lut: in std_logic_vector(2 downto 0);
		s     : out std_logic;                   --sign bit
		mbe_pp: out std_logic_vector(32 downto 0));
	end component;

begin

sn <= not(s);
b <= "00"&B_in&'0';

--LUT PORT MAP
LUT_0 : lut  port map(A_in,b(2 downto 0),s(0),a(0));
LUT_1 : lut  port map(A_in,b(4 downto 2),s(1),a(1));
LUT_2 : lut  port map(A_in,b(6 downto 4),s(2),a(2));
LUT_3 : lut  port map(A_in,b(8 downto 6),s(3),a(3));
LUT_4 : lut  port map(A_in,b(10 downto 8),s(4),a(4));
LUT_5 : lut  port map(A_in,b(12 downto 10),s(5),a(5));
LUT_6 : lut  port map(A_in,b(14 downto 12),s(6),a(6));
LUT_7 : lut  port map(A_in,b(16 downto 14),s(7),a(7));
LUT_8 : lut  port map(A_in,b(18 downto 16),s(8),a(8));
LUT_9 : lut  port map(A_in,b(20 downto 18),s(9),a(9));
LUT_10: lut  port map(A_in,b(22 downto 20),s(10),a(10));
LUT_11: lut  port map(A_in,b(24 downto 22),s(11),a(11));
LUT_12: lut  port map(A_in,b(26 downto 24),s(12),a(12));
LUT_13: lut  port map(A_in,b(28 downto 26),s(13),a(13));
LUT_14: lut  port map(A_in,b(30 downto 28),s(14),a(14));
LUT_15: lut  port map(A_in,b(32 downto 30),s(15),a(15));
LUT_16: lut  port map(A_in,b(34 downto 32),s(16),a(16));

------------------------------------------
-----DADDA FAs PORT MAP-------------------
--FAs ITERAZIONE  0
FA_0_0:FA port map ( a(0)(26),a(1)(24),a(2)(22),cf(0)(0),sf(0)(0) );
FA_0_1:FA port map ( a(0)(27),a(1)(25),a(2)(23),cf(0)(1),sf(0)(1) );
FA_0_2:FA port map ( a(0)(28),a(1)(26),a(2)(24),cf(0)(2),sf(0)(2) );
FA_0_3:FA port map ( a(3)(22),a(4)(20),a(5)(18),cf(0)(3),sf(0)(3) );
FA_0_4:FA port map ( a(0)(29),a(1)(27),a(2)(25),cf(0)(4),sf(0)(4) );
FA_0_5:FA port map ( a(3)(23),a(4)(21),a(5)(19),cf(0)(5),sf(0)(5) );
FA_0_6:FA port map ( a(0)(30),a(1)(28),a(2)(26),cf(0)(6),sf(0)(6) );
FA_0_7:FA port map ( a(3)(24),a(4)(22),a(5)(20),cf(0)(7),sf(0)(7) );
FA_0_8:FA port map ( a(6)(18),a(7)(16),a(8)(14),cf(0)(8),sf(0)(8) );
FA_0_9:FA port map ( a(0)(31),a(1)(29),a(2)(27),cf(0)(9),sf(0)(9) );
FA_0_10:FA port map ( a(3)(25),a(4)(23),a(5)(21),cf(0)(10),sf(0)(10) );
FA_0_11:FA port map ( a(6)(19),a(7)(17),a(8)(15),cf(0)(11),sf(0)(11) );
FA_0_12:FA port map ( a(0)(32),a(1)(30),a(2)(28),cf(0)(12),sf(0)(12) );
FA_0_13:FA port map ( a(3)(26),a(4)(24),a(5)(22),cf(0)(13),sf(0)(13) );
FA_0_14:FA port map ( a(6)(20),a(7)(18),a(8)(16),cf(0)(14),sf(0)(14) );
FA_0_15:FA port map ( a(9)(14),a(10)(12),a(11)(10),cf(0)(15),sf(0)(15) );
FA_0_16:FA port map ( s(0),a(1)(31),a(2)(29),cf(0)(16),sf(0)(16) );
FA_0_17:FA port map ( a(3)(27),a(4)(25),a(5)(23),cf(0)(17),sf(0)(17) );
FA_0_18:FA port map ( a(6)(21),a(7)(19),a(8)(17),cf(0)(18),sf(0)(18) );
FA_0_19:FA port map ( a(9)(15),a(10)(13),a(11)(11),cf(0)(19),sf(0)(19) );
FA_0_20:FA port map ( s(0),a(1)(32),a(2)(30),cf(0)(20),sf(0)(20) );
FA_0_21:FA port map ( a(3)(28),a(4)(26),a(5)(24),cf(0)(21),sf(0)(21) );
FA_0_22:FA port map ( a(6)(22),a(7)(20),a(8)(18),cf(0)(22),sf(0)(22) );
FA_0_23:FA port map ( a(9)(16),a(10)(14),a(11)(12),cf(0)(23),sf(0)(23) );
FA_0_24:FA port map ( sn(0),sn(1),a(2)(31),cf(0)(24),sf(0)(24) );
FA_0_25:FA port map ( a(3)(29),a(4)(27),a(5)(25),cf(0)(25),sf(0)(25) );
FA_0_26:FA port map ( a(6)(23),a(7)(21),a(8)(19),cf(0)(26),sf(0)(26) );
FA_0_27:FA port map ( a(9)(17),a(10)(15),a(11)(13),cf(0)(27),sf(0)(27) );
FA_0_28:FA port map ( '1',a(2)(32),a(3)(30),cf(0)(28),sf(0)(28) );
FA_0_29:FA port map ( a(4)(28),a(5)(26),a(6)(24),cf(0)(29),sf(0)(29) );
FA_0_30:FA port map ( a(7)(22),a(8)(20),a(9)(18),cf(0)(30),sf(0)(30) );
FA_0_31:FA port map ( sn(2),a(3)(31),a(4)(29),cf(0)(31),sf(0)(31) );
FA_0_32:FA port map ( a(5)(27),a(6)(25),a(7)(23),cf(0)(32),sf(0)(32) );
FA_0_33:FA port map ( a(8)(21),a(9)(19),a(10)(17),cf(0)(33),sf(0)(33) );
FA_0_34:FA port map ( '1',a(3)(32),a(4)(30),cf(0)(34),sf(0)(34) );
FA_0_35:FA port map ( a(5)(28),a(6)(26),a(7)(24),cf(0)(35),sf(0)(35) );
FA_0_36:FA port map ( sn(3),a(4)(31),a(5)(29),cf(0)(36),sf(0)(36) );
FA_0_37:FA port map ( a(6)(27),a(7)(25),a(8)(23),cf(0)(37),sf(0)(37) );
FA_0_38:FA port map ( '1',a(4)(32),a(5)(30),cf(0)(38),sf(0)(38) );
FA_0_39:FA port map ( sn(4),a(5)(31),a(6)(29),cf(0)(39),sf(0)(39) );


--FAs ITERAZIONE  1

FA_1_0:FA port map ( a(0)(18),a(1)(16),a(2)(14),cf(1)(0),sf(1)(0) );
FA_1_1:FA port map ( a(0)(19),a(1)(17),a(2)(15),cf(1)(1),sf(1)(1) );
FA_1_2:FA port map ( a(0)(20),a(1)(18),a(2)(16),cf(1)(2),sf(1)(2) );
FA_1_3:FA port map ( a(3)(14),a(4)(12),a(5)(10),cf(1)(3),sf(1)(3) );
FA_1_4:FA port map ( a(0)(21),a(1)(19),a(2)(17),cf(1)(4),sf(1)(4) );
FA_1_5:FA port map ( a(3)(15),a(4)(13),a(5)(11),cf(1)(5),sf(1)(5) );
FA_1_6:FA port map ( a(0)(22),a(1)(20),a(2)(18),cf(1)(6),sf(1)(6) );
FA_1_7:FA port map ( a(3)(16),a(4)(14),a(5)(12),cf(1)(7),sf(1)(7) );
FA_1_8:FA port map ( a(6)(10),a(7)(8),a(8)(6),cf(1)(8),sf(1)(8) );
FA_1_9:FA port map ( a(0)(23),a(1)(21),a(2)(19),cf(1)(9),sf(1)(9) );
FA_1_10:FA port map ( a(3)(17),a(4)(15),a(5)(13),cf(1)(10),sf(1)(10) );
FA_1_11:FA port map ( a(6)(11),a(7)(9),a(8)(7),cf(1)(11),sf(1)(11) );
FA_1_12:FA port map ( sh(0)(0),a(2)(20),a(3)(18),cf(1)(12),sf(1)(12) );
FA_1_13:FA port map ( a(4)(16),a(5)(14),a(6)(12),cf(1)(13),sf(1)(13) );
FA_1_14:FA port map ( a(7)(10),a(8)(8),a(9)(6),cf(1)(14),sf(1)(14) );
FA_1_15:FA port map ( a(10)(4),a(11)(2),a(12)(0),cf(1)(15),sf(1)(15) );
FA_1_16:FA port map ( ch(0)(0),sh(0)(1),a(2)(21),cf(1)(16),sf(1)(16) );
FA_1_17:FA port map ( a(3)(19),a(4)(17),a(5)(15),cf(1)(17),sf(1)(17) );
FA_1_18:FA port map ( a(6)(13),a(7)(11),a(8)(9),cf(1)(18),sf(1)(18) );
FA_1_19:FA port map ( a(9)(7),a(10)(5),a(11)(3),cf(1)(19),sf(1)(19) );
FA_1_20:FA port map ( ch(0)(1),sf(0)(0),sh(0)(2),cf(1)(20),sf(1)(20) );
FA_1_21:FA port map ( a(5)(16),a(6)(14),a(7)(12),cf(1)(21),sf(1)(21) );
FA_1_22:FA port map ( a(8)(10),a(9)(8),a(10)(6),cf(1)(22),sf(1)(22) );
FA_1_23:FA port map ( a(11)(4),a(12)(2),a(13)(0),cf(1)(23),sf(1)(23) );
FA_1_24:FA port map ( ch(0)(2),cf(0)(0),sf(0)(1),cf(1)(24),sf(1)(24) );
FA_1_25:FA port map ( sh(0)(3),a(5)(17),a(6)(15),cf(1)(25),sf(1)(25) );
FA_1_26:FA port map ( a(7)(13),a(8)(11),a(9)(9),cf(1)(26),sf(1)(26) );
FA_1_27:FA port map ( a(10)(7),a(11)(5),a(12)(3),cf(1)(27),sf(1)(27) );
FA_1_28:FA port map ( ch(0)(3),cf(0)(1),sf(0)(2),cf(1)(28),sf(1)(28) );
FA_1_29:FA port map ( sf(0)(3),sh(0)(4),a(8)(12),cf(1)(29),sf(1)(29) );
FA_1_30:FA port map ( a(9)(10),a(10)(8),a(11)(6),cf(1)(30),sf(1)(30) );
FA_1_31:FA port map ( a(12)(4),a(13)(2),a(14)(0),cf(1)(31),sf(1)(31) );
FA_1_32:FA port map ( ch(0)(4),cf(0)(3),cf(0)(2),cf(1)(32),sf(1)(32) );
FA_1_33:FA port map ( sf(0)(4),sf(0)(5),sh(0)(5),cf(1)(33),sf(1)(33) );
FA_1_34:FA port map ( a(8)(13),a(9)(11),a(10)(9),cf(1)(34),sf(1)(34) );
FA_1_35:FA port map ( a(11)(7),a(12)(5),a(13)(3),cf(1)(35),sf(1)(35) );
FA_1_36:FA port map ( ch(0)(5),cf(0)(5),cf(0)(4),cf(1)(36),sf(1)(36) );
FA_1_37:FA port map ( sf(0)(6),sf(0)(7),sf(0)(8),cf(1)(37),sf(1)(37) );
FA_1_38:FA port map ( sh(0)(6),a(11)(8),a(12)(6),cf(1)(38),sf(1)(38) );
FA_1_39:FA port map ( a(13)(4),a(14)(2),a(15)(0),cf(1)(39),sf(1)(39) );
FA_1_40:FA port map ( ch(0)(6),cf(0)(8),cf(0)(7),cf(1)(40),sf(1)(40) );
FA_1_41:FA port map ( cf(0)(6),sf(0)(9),sf(0)(10),cf(1)(41),sf(1)(41) );
FA_1_42:FA port map ( sf(0)(11),sh(0)(7),a(11)(9),cf(1)(42),sf(1)(42) );
FA_1_43:FA port map ( a(12)(7),a(13)(5),a(14)(3),cf(1)(43),sf(1)(43) );
FA_1_44:FA port map ( ch(0)(7),cf(0)(11),cf(0)(10),cf(1)(44),sf(1)(44) );
FA_1_45:FA port map ( cf(0)(9),sf(0)(12),sf(0)(13),cf(1)(45),sf(1)(45) );
FA_1_46:FA port map ( sf(0)(14),sf(0)(15),a(12)(8),cf(1)(46),sf(1)(46) );
FA_1_47:FA port map ( a(13)(6),a(14)(4),a(15)(2),cf(1)(47),sf(1)(47) );
FA_1_48:FA port map ( cf(0)(15),cf(0)(14),cf(0)(13),cf(1)(48),sf(1)(48) );
FA_1_49:FA port map ( cf(0)(12),sf(0)(16),sf(0)(17),cf(1)(49),sf(1)(49) );
FA_1_50:FA port map ( sf(0)(18),sf(0)(19),a(12)(9),cf(1)(50),sf(1)(50) );
FA_1_51:FA port map ( a(13)(7),a(14)(5),a(15)(3),cf(1)(51),sf(1)(51) );
FA_1_52:FA port map ( cf(0)(19),cf(0)(18),cf(0)(17),cf(1)(52),sf(1)(52) );
FA_1_53:FA port map ( cf(0)(16),sf(0)(20),sf(0)(21),cf(1)(53),sf(1)(53) );
FA_1_54:FA port map ( sf(0)(22),sf(0)(23),a(12)(10),cf(1)(54),sf(1)(54) );
FA_1_55:FA port map ( a(13)(8),a(14)(6),a(15)(4),cf(1)(55),sf(1)(55) );
FA_1_56:FA port map ( cf(0)(23),cf(0)(22),cf(0)(21),cf(1)(56),sf(1)(56) );
FA_1_57:FA port map ( cf(0)(20),sf(0)(24),sf(0)(25),cf(1)(57),sf(1)(57) );
FA_1_58:FA port map ( sf(0)(26),sf(0)(27),a(12)(11),cf(1)(58),sf(1)(58) );
FA_1_59:FA port map ( a(13)(9),a(14)(7),a(15)(5),cf(1)(59),sf(1)(59) );
FA_1_60:FA port map ( cf(0)(27),cf(0)(26),cf(0)(25),cf(1)(60),sf(1)(60) );
FA_1_61:FA port map ( cf(0)(24),sf(0)(28),sf(0)(29),cf(1)(61),sf(1)(61) );
FA_1_62:FA port map ( sf(0)(30),sh(0)(8),a(12)(12),cf(1)(62),sf(1)(62) );
FA_1_63:FA port map ( a(13)(10),a(14)(8),a(15)(6),cf(1)(63),sf(1)(63) );
FA_1_64:FA port map ( ch(0)(8),cf(0)(30),cf(0)(29),cf(1)(64),sf(1)(64) );
FA_1_65:FA port map ( cf(0)(28),sf(0)(31),sf(0)(32),cf(1)(65),sf(1)(65) );
FA_1_66:FA port map ( sf(0)(33),a(11)(15),a(12)(13),cf(1)(66),sf(1)(66) );
FA_1_67:FA port map ( a(13)(11),a(14)(9),a(15)(7),cf(1)(67),sf(1)(67) );
FA_1_68:FA port map ( cf(0)(33),cf(0)(32),cf(0)(31),cf(1)(68),sf(1)(68) );
FA_1_69:FA port map ( sf(0)(34),sf(0)(35),sh(0)(9),cf(1)(69),sf(1)(69) );
FA_1_70:FA port map ( a(10)(18),a(11)(16),a(12)(14),cf(1)(70),sf(1)(70) );
FA_1_71:FA port map ( a(13)(12),a(14)(10),a(15)(8),cf(1)(71),sf(1)(71) );
FA_1_72:FA port map ( ch(0)(9),cf(0)(35),cf(0)(34),cf(1)(72),sf(1)(72) );
FA_1_73:FA port map ( sf(0)(36),sf(0)(37),a(9)(21),cf(1)(73),sf(1)(73) );
FA_1_74:FA port map ( a(10)(19),a(11)(17),a(12)(15),cf(1)(74),sf(1)(74) );
FA_1_75:FA port map ( a(13)(13),a(14)(11),a(15)(9),cf(1)(75),sf(1)(75) );
FA_1_76:FA port map ( cf(0)(37),cf(0)(36),sf(0)(38),cf(1)(76),sf(1)(76) );
FA_1_77:FA port map ( sh(0)(10),a(8)(24),a(9)(22),cf(1)(77),sf(1)(77) );
FA_1_78:FA port map ( a(10)(20),a(11)(18),a(12)(16),cf(1)(78),sf(1)(78) );
FA_1_79:FA port map ( a(13)(14),a(14)(12),a(15)(10),cf(1)(79),sf(1)(79) );
FA_1_80:FA port map ( ch(0)(10),cf(0)(38),sf(0)(39),cf(1)(80),sf(1)(80) );
FA_1_81:FA port map ( a(7)(27),a(8)(25),a(9)(23),cf(1)(81),sf(1)(81) );
FA_1_82:FA port map ( a(10)(21),a(11)(19),a(12)(17),cf(1)(82),sf(1)(82) );
FA_1_83:FA port map ( a(13)(15),a(14)(13),a(15)(11),cf(1)(83),sf(1)(83) );
FA_1_84:FA port map ( cf(0)(39),sh(0)(11),a(6)(30),cf(1)(84),sf(1)(84) );
FA_1_85:FA port map ( a(7)(28),a(8)(26),a(9)(24),cf(1)(85),sf(1)(85) );
FA_1_86:FA port map ( a(10)(22),a(11)(20),a(12)(18),cf(1)(86),sf(1)(86) );
FA_1_87:FA port map ( a(13)(16),a(14)(14),a(15)(12),cf(1)(87),sf(1)(87) );
FA_1_88:FA port map ( ch(0)(11),sn(5),a(6)(31),cf(1)(88),sf(1)(88) );
FA_1_89:FA port map ( a(7)(29),a(8)(27),a(9)(25),cf(1)(89),sf(1)(89) );
FA_1_90:FA port map ( a(10)(23),a(11)(21),a(12)(19),cf(1)(90),sf(1)(90) );
FA_1_91:FA port map ( a(13)(17),a(14)(15),a(15)(13),cf(1)(91),sf(1)(91) );
FA_1_92:FA port map ( '1',a(6)(32),a(7)(30),cf(1)(92),sf(1)(92) );
FA_1_93:FA port map ( a(8)(28),a(9)(26),a(10)(24),cf(1)(93),sf(1)(93) );
FA_1_94:FA port map ( a(11)(22),a(12)(20),a(13)(18),cf(1)(94),sf(1)(94) );
FA_1_95:FA port map ( sn(6),a(7)(31),a(8)(29),cf(1)(95),sf(1)(95) );
FA_1_96:FA port map ( a(9)(27),a(10)(25),a(11)(23),cf(1)(96),sf(1)(96) );
FA_1_97:FA port map ( a(12)(21),a(13)(19),a(14)(17),cf(1)(97),sf(1)(97) );
FA_1_98:FA port map ( '1',a(7)(32),a(8)(30),cf(1)(98),sf(1)(98) );
FA_1_99:FA port map ( a(9)(28),a(10)(26),a(11)(24),cf(1)(99),sf(1)(99) );
FA_1_100:FA port map ( sn(7),a(8)(31),a(9)(29),cf(1)(100),sf(1)(100) );
FA_1_101:FA port map ( a(10)(27),a(11)(25),a(12)(23),cf(1)(101),sf(1)(101) );
FA_1_102:FA port map ( '1',a(8)(32),a(9)(30),cf(1)(102),sf(1)(102) );
FA_1_103:FA port map ( sn(8),a(9)(31),a(10)(29),cf(1)(103),sf(1)(103) );


--FAs ITERAZIONE  2

FA_2_0:FA port map ( a(0)(12),a(1)(10),a(2)(8),cf(2)(0),sf(2)(0) );
FA_2_1:FA port map ( a(0)(13),a(1)(11),a(2)(9),cf(2)(1),sf(2)(1) );
FA_2_2:FA port map ( a(0)(14),a(1)(12),a(2)(10),cf(2)(2),sf(2)(2) );
FA_2_3:FA port map ( a(3)(8),a(4)(6),a(5)(4),cf(2)(3),sf(2)(3) );
FA_2_4:FA port map ( a(0)(15),a(1)(13),a(2)(11),cf(2)(4),sf(2)(4) );
FA_2_5:FA port map ( a(3)(9),a(4)(7),a(5)(5),cf(2)(5),sf(2)(5) );
FA_2_6:FA port map ( sh(1)(0),a(2)(12),a(3)(10),cf(2)(6),sf(2)(6) );
FA_2_7:FA port map ( a(4)(8),a(5)(6),a(6)(4),cf(2)(7),sf(2)(7) );
FA_2_8:FA port map ( a(7)(2),a(8)(0),s(8),cf(2)(8),sf(2)(8) );
FA_2_9:FA port map ( ch(1)(0),sh(1)(1),a(2)(13),cf(2)(9),sf(2)(9) );
FA_2_10:FA port map ( a(3)(11),a(4)(9),a(5)(7),cf(2)(10),sf(2)(10) );
FA_2_11:FA port map ( a(6)(5),a(7)(3),a(8)(1),cf(2)(11),sf(2)(11) );
FA_2_12:FA port map ( ch(1)(1),sf(1)(0),sh(1)(2),cf(2)(12),sf(2)(12) );
FA_2_13:FA port map ( a(5)(8),a(6)(6),a(7)(4),cf(2)(13),sf(2)(13) );
FA_2_14:FA port map ( a(8)(2),a(9)(0),s(9),cf(2)(14),sf(2)(14) );
FA_2_15:FA port map ( ch(1)(2),cf(1)(0),sf(1)(1),cf(2)(15),sf(2)(15) );
FA_2_16:FA port map ( sh(1)(3),a(5)(9),a(6)(7),cf(2)(16),sf(2)(16) );
FA_2_17:FA port map ( a(7)(5),a(8)(3),a(9)(1),cf(2)(17),sf(2)(17) );
FA_2_18:FA port map ( ch(1)(3),cf(1)(1),sf(1)(2),cf(2)(18),sf(2)(18) );
FA_2_19:FA port map ( sf(1)(3),sh(1)(4),a(8)(4),cf(2)(19),sf(2)(19) );
FA_2_20:FA port map ( a(9)(2),a(10)(0),s(10),cf(2)(20),sf(2)(20) );
FA_2_21:FA port map ( ch(1)(4),cf(1)(3),cf(1)(2),cf(2)(21),sf(2)(21) );
FA_2_22:FA port map ( sf(1)(4),sf(1)(5),sh(1)(5),cf(2)(22),sf(2)(22) );
FA_2_23:FA port map ( a(8)(5),a(9)(3),a(10)(1),cf(2)(23),sf(2)(23) );
FA_2_24:FA port map ( ch(1)(5),cf(1)(5),cf(1)(4),cf(2)(24),sf(2)(24) );
FA_2_25:FA port map ( sf(1)(6),sf(1)(7),sf(1)(8),cf(2)(25),sf(2)(25) );
FA_2_26:FA port map ( sh(1)(6),a(11)(0),s(11),cf(2)(26),sf(2)(26) );
FA_2_27:FA port map ( ch(1)(6),cf(1)(8),cf(1)(7),cf(2)(27),sf(2)(27) );
FA_2_28:FA port map ( cf(1)(6),sf(1)(9),sf(1)(10),cf(2)(28),sf(2)(28) );
FA_2_29:FA port map ( sf(1)(11),sh(1)(7),a(11)(1),cf(2)(29),sf(2)(29) );
FA_2_30:FA port map ( ch(1)(7),cf(1)(11),cf(1)(10),cf(2)(30),sf(2)(30) );
FA_2_31:FA port map ( cf(1)(9),sf(1)(12),sf(1)(13),cf(2)(31),sf(2)(31) );
FA_2_32:FA port map ( sf(1)(14),sf(1)(15),s(12),cf(2)(32),sf(2)(32) );
FA_2_33:FA port map ( cf(1)(15),cf(1)(14),cf(1)(13),cf(2)(33),sf(2)(33) );
FA_2_34:FA port map ( cf(1)(12),sf(1)(16),sf(1)(17),cf(2)(34),sf(2)(34) );
FA_2_35:FA port map ( sf(1)(18),sf(1)(19),a(12)(1),cf(2)(35),sf(2)(35) );
FA_2_36:FA port map ( cf(1)(19),cf(1)(18),cf(1)(17),cf(2)(36),sf(2)(36) );
FA_2_37:FA port map ( cf(1)(16),sf(1)(20),sf(1)(21),cf(2)(37),sf(2)(37) );
FA_2_38:FA port map ( sf(1)(22),sf(1)(23),s(13),cf(2)(38),sf(2)(38) );
FA_2_39:FA port map ( cf(1)(23),cf(1)(22),cf(1)(21),cf(2)(39),sf(2)(39) );
FA_2_40:FA port map ( cf(1)(20),sf(1)(24),sf(1)(25),cf(2)(40),sf(2)(40) );
FA_2_41:FA port map ( sf(1)(26),sf(1)(27),a(13)(1),cf(2)(41),sf(2)(41) );
FA_2_42:FA port map ( cf(1)(27),cf(1)(26),cf(1)(25),cf(2)(42),sf(2)(42) );
FA_2_43:FA port map ( cf(1)(24),sf(1)(28),sf(1)(29),cf(2)(43),sf(2)(43) );
FA_2_44:FA port map ( sf(1)(30),sf(1)(31),s(14),cf(2)(44),sf(2)(44) );
FA_2_45:FA port map ( cf(1)(31),cf(1)(30),cf(1)(29),cf(2)(45),sf(2)(45) );
FA_2_46:FA port map ( cf(1)(28),sf(1)(32),sf(1)(33),cf(2)(46),sf(2)(46) );
FA_2_47:FA port map ( sf(1)(34),sf(1)(35),a(14)(1),cf(2)(47),sf(2)(47) );
FA_2_48:FA port map ( cf(1)(35),cf(1)(34),cf(1)(33),cf(2)(48),sf(2)(48) );
FA_2_49:FA port map ( cf(1)(32),sf(1)(36),sf(1)(37),cf(2)(49),sf(2)(49) );
FA_2_50:FA port map ( sf(1)(38),sf(1)(39),s(15),cf(2)(50),sf(2)(50) );
FA_2_51:FA port map ( cf(1)(39),cf(1)(38),cf(1)(37),cf(2)(51),sf(2)(51) );
FA_2_52:FA port map ( cf(1)(36),sf(1)(40),sf(1)(41),cf(2)(52),sf(2)(52) );
FA_2_53:FA port map ( sf(1)(42),sf(1)(43),a(15)(1),cf(2)(53),sf(2)(53) );
FA_2_54:FA port map ( cf(1)(43),cf(1)(42),cf(1)(41),cf(2)(54),sf(2)(54) );
FA_2_55:FA port map ( cf(1)(40),sf(1)(44),sf(1)(45),cf(2)(55),sf(2)(55) );
FA_2_56:FA port map ( sf(1)(46),sf(1)(47),a(16)(0),cf(2)(56),sf(2)(56) );
FA_2_57:FA port map ( cf(1)(47),cf(1)(46),cf(1)(45),cf(2)(57),sf(2)(57) );
FA_2_58:FA port map ( cf(1)(44),sf(1)(48),sf(1)(49),cf(2)(58),sf(2)(58) );
FA_2_59:FA port map ( sf(1)(50),sf(1)(51),a(16)(1),cf(2)(59),sf(2)(59) );
FA_2_60:FA port map ( cf(1)(51),cf(1)(50),cf(1)(49),cf(2)(60),sf(2)(60) );
FA_2_61:FA port map ( cf(1)(48),sf(1)(52),sf(1)(53),cf(2)(61),sf(2)(61) );
FA_2_62:FA port map ( sf(1)(54),sf(1)(55),a(16)(2),cf(2)(62),sf(2)(62) );
FA_2_63:FA port map ( cf(1)(55),cf(1)(54),cf(1)(53),cf(2)(63),sf(2)(63) );
FA_2_64:FA port map ( cf(1)(52),sf(1)(56),sf(1)(57),cf(2)(64),sf(2)(64) );
FA_2_65:FA port map ( sf(1)(58),sf(1)(59),a(16)(3),cf(2)(65),sf(2)(65) );
FA_2_66:FA port map ( cf(1)(59),cf(1)(58),cf(1)(57),cf(2)(66),sf(2)(66) );
FA_2_67:FA port map ( cf(1)(56),sf(1)(60),sf(1)(61),cf(2)(67),sf(2)(67) );
FA_2_68:FA port map ( sf(1)(62),sf(1)(63),a(16)(4),cf(2)(68),sf(2)(68) );
FA_2_69:FA port map ( cf(1)(63),cf(1)(62),cf(1)(61),cf(2)(69),sf(2)(69) );
FA_2_70:FA port map ( cf(1)(60),sf(1)(64),sf(1)(65),cf(2)(70),sf(2)(70) );
FA_2_71:FA port map ( sf(1)(66),sf(1)(67),a(16)(5),cf(2)(71),sf(2)(71) );
FA_2_72:FA port map ( cf(1)(67),cf(1)(66),cf(1)(65),cf(2)(72),sf(2)(72) );
FA_2_73:FA port map ( cf(1)(64),sf(1)(68),sf(1)(69),cf(2)(73),sf(2)(73) );
FA_2_74:FA port map ( sf(1)(70),sf(1)(71),a(16)(6),cf(2)(74),sf(2)(74) );
FA_2_75:FA port map ( cf(1)(71),cf(1)(70),cf(1)(69),cf(2)(75),sf(2)(75) );
FA_2_76:FA port map ( cf(1)(68),sf(1)(72),sf(1)(73),cf(2)(76),sf(2)(76) );
FA_2_77:FA port map ( sf(1)(74),sf(1)(75),a(16)(7),cf(2)(77),sf(2)(77) );
FA_2_78:FA port map ( cf(1)(75),cf(1)(74),cf(1)(73),cf(2)(78),sf(2)(78) );
FA_2_79:FA port map ( cf(1)(72),sf(1)(76),sf(1)(77),cf(2)(79),sf(2)(79) );
FA_2_80:FA port map ( sf(1)(78),sf(1)(79),a(16)(8),cf(2)(80),sf(2)(80) );
FA_2_81:FA port map ( cf(1)(79),cf(1)(78),cf(1)(77),cf(2)(81),sf(2)(81) );
FA_2_82:FA port map ( cf(1)(76),sf(1)(80),sf(1)(81),cf(2)(82),sf(2)(82) );
FA_2_83:FA port map ( sf(1)(82),sf(1)(83),a(16)(9),cf(2)(83),sf(2)(83) );
FA_2_84:FA port map ( cf(1)(83),cf(1)(82),cf(1)(81),cf(2)(84),sf(2)(84) );
FA_2_85:FA port map ( cf(1)(80),sf(1)(84),sf(1)(85),cf(2)(85),sf(2)(85) );
FA_2_86:FA port map ( sf(1)(86),sf(1)(87),a(16)(10),cf(2)(86),sf(2)(86) );
FA_2_87:FA port map ( cf(1)(87),cf(1)(86),cf(1)(85),cf(2)(87),sf(2)(87) );
FA_2_88:FA port map ( cf(1)(84),sf(1)(88),sf(1)(89),cf(2)(88),sf(2)(88) );
FA_2_89:FA port map ( sf(1)(90),sf(1)(91),a(16)(11),cf(2)(89),sf(2)(89) );
FA_2_90:FA port map ( cf(1)(91),cf(1)(90),cf(1)(89),cf(2)(90),sf(2)(90) );
FA_2_91:FA port map ( cf(1)(88),sf(1)(92),sf(1)(93),cf(2)(91),sf(2)(91) );
FA_2_92:FA port map ( sf(1)(94),sh(1)(8),a(16)(12),cf(2)(92),sf(2)(92) );
FA_2_93:FA port map ( ch(1)(8),cf(1)(94),cf(1)(93),cf(2)(93),sf(2)(93) );
FA_2_94:FA port map ( cf(1)(92),sf(1)(95),sf(1)(96),cf(2)(94),sf(2)(94) );
FA_2_95:FA port map ( sf(1)(97),a(15)(15),a(16)(13),cf(2)(95),sf(2)(95) );
FA_2_96:FA port map ( cf(1)(97),cf(1)(96),cf(1)(95),cf(2)(96),sf(2)(96) );
FA_2_97:FA port map ( sf(1)(98),sf(1)(99),sh(1)(9),cf(2)(97),sf(2)(97) );
FA_2_98:FA port map ( a(14)(18),a(15)(16),a(16)(14),cf(2)(98),sf(2)(98) );
FA_2_99:FA port map ( ch(1)(9),cf(1)(99),cf(1)(98),cf(2)(99),sf(2)(99) );
FA_2_100:FA port map ( sf(1)(100),sf(1)(101),a(13)(21),cf(2)(100),sf(2)(100) );
FA_2_101:FA port map ( a(14)(19),a(15)(17),a(16)(15),cf(2)(101),sf(2)(101) );
FA_2_102:FA port map ( cf(1)(101),cf(1)(100),sf(1)(102),cf(2)(102),sf(2)(102) );
FA_2_103:FA port map ( sh(1)(10),a(12)(24),a(13)(22),cf(2)(103),sf(2)(103) );
FA_2_104:FA port map ( a(14)(20),a(15)(18),a(16)(16),cf(2)(104),sf(2)(104) );
FA_2_105:FA port map ( ch(1)(10),cf(1)(102),sf(1)(103),cf(2)(105),sf(2)(105) );
FA_2_106:FA port map ( a(11)(27),a(12)(25),a(13)(23),cf(2)(106),sf(2)(106) );
FA_2_107:FA port map ( a(14)(21),a(15)(19),a(16)(17),cf(2)(107),sf(2)(107) );
FA_2_108:FA port map ( cf(1)(103),sh(1)(11),a(10)(30),cf(2)(108),sf(2)(108) );
FA_2_109:FA port map ( a(11)(28),a(12)(26),a(13)(24),cf(2)(109),sf(2)(109) );
FA_2_110:FA port map ( a(14)(22),a(15)(20),a(16)(18),cf(2)(110),sf(2)(110) );
FA_2_111:FA port map ( ch(1)(11),sn(9),a(10)(31),cf(2)(111),sf(2)(111) );
FA_2_112:FA port map ( a(11)(29),a(12)(27),a(13)(25),cf(2)(112),sf(2)(112) );
FA_2_113:FA port map ( a(14)(23),a(15)(21),a(16)(19),cf(2)(113),sf(2)(113) );
FA_2_114:FA port map ( '1',a(10)(32),a(11)(30),cf(2)(114),sf(2)(114) );
FA_2_115:FA port map ( a(12)(28),a(13)(26),a(14)(24),cf(2)(115),sf(2)(115) );
FA_2_116:FA port map ( sn(10),a(11)(31),a(12)(29),cf(2)(116),sf(2)(116) );
FA_2_117:FA port map ( a(13)(27),a(14)(25),a(15)(23),cf(2)(117),sf(2)(117) );
FA_2_118:FA port map ( '1',a(11)(32),a(12)(30),cf(2)(118),sf(2)(118) );
FA_2_119:FA port map ( sn(11),a(12)(31),a(13)(29),cf(2)(119),sf(2)(119) );


--FAs ITERAZIONE  3

FA_3_0:FA port map ( a(0)(8),a(1)(6),a(2)(4),cf(3)(0),sf(3)(0) );
FA_3_1:FA port map ( a(0)(9),a(1)(7),a(2)(5),cf(3)(1),sf(3)(1) );
FA_3_2:FA port map ( sh(2)(0),a(2)(6),a(3)(4),cf(3)(2),sf(3)(2) );
FA_3_3:FA port map ( a(4)(2),a(5)(0),s(5),cf(3)(3),sf(3)(3) );
FA_3_4:FA port map ( ch(2)(0),sh(2)(1),a(2)(7),cf(3)(4),sf(3)(4) );
FA_3_5:FA port map ( a(3)(5),a(4)(3),a(5)(1),cf(3)(5),sf(3)(5) );
FA_3_6:FA port map ( ch(2)(1),sf(2)(0),sh(2)(2),cf(3)(6),sf(3)(6) );
FA_3_7:FA port map ( a(5)(2),a(6)(0),s(6),cf(3)(7),sf(3)(7) );
FA_3_8:FA port map ( ch(2)(2),cf(2)(0),sf(2)(1),cf(3)(8),sf(3)(8) );
FA_3_9:FA port map ( sh(2)(3),a(5)(3),a(6)(1),cf(3)(9),sf(3)(9) );
FA_3_10:FA port map ( ch(2)(3),cf(2)(1),sf(2)(2),cf(3)(10),sf(3)(10) );
FA_3_11:FA port map ( sf(2)(3),sh(2)(4),s(7),cf(3)(11),sf(3)(11) );
FA_3_12:FA port map ( ch(2)(4),cf(2)(3),cf(2)(2),cf(3)(12),sf(3)(12) );
FA_3_13:FA port map ( sf(2)(4),sf(2)(5),sh(2)(5),cf(3)(13),sf(3)(13) );
FA_3_14:FA port map ( ch(2)(5),cf(2)(5),cf(2)(4),cf(3)(14),sf(3)(14) );
FA_3_15:FA port map ( sf(2)(6),sf(2)(7),sf(2)(8),cf(3)(15),sf(3)(15) );
FA_3_16:FA port map ( cf(2)(8),cf(2)(7),cf(2)(6),cf(3)(16),sf(3)(16) );
FA_3_17:FA port map ( sf(2)(9),sf(2)(10),sf(2)(11),cf(3)(17),sf(3)(17) );
FA_3_18:FA port map ( cf(2)(11),cf(2)(10),cf(2)(9),cf(3)(18),sf(3)(18) );
FA_3_19:FA port map ( sf(2)(12),sf(2)(13),sf(2)(14),cf(3)(19),sf(3)(19) );
FA_3_20:FA port map ( cf(2)(14),cf(2)(13),cf(2)(12),cf(3)(20),sf(3)(20) );
FA_3_21:FA port map ( sf(2)(15),sf(2)(16),sf(2)(17),cf(3)(21),sf(3)(21) );
FA_3_22:FA port map ( cf(2)(17),cf(2)(16),cf(2)(15),cf(3)(22),sf(3)(22) );
FA_3_23:FA port map ( sf(2)(18),sf(2)(19),sf(2)(20),cf(3)(23),sf(3)(23) );
FA_3_24:FA port map ( cf(2)(20),cf(2)(19),cf(2)(18),cf(3)(24),sf(3)(24) );
FA_3_25:FA port map ( sf(2)(21),sf(2)(22),sf(2)(23),cf(3)(25),sf(3)(25) );
FA_3_26:FA port map ( cf(2)(23),cf(2)(22),cf(2)(21),cf(3)(26),sf(3)(26) );
FA_3_27:FA port map ( sf(2)(24),sf(2)(25),sf(2)(26),cf(3)(27),sf(3)(27) );
FA_3_28:FA port map ( cf(2)(26),cf(2)(25),cf(2)(24),cf(3)(28),sf(3)(28) );
FA_3_29:FA port map ( sf(2)(27),sf(2)(28),sf(2)(29),cf(3)(29),sf(3)(29) );
FA_3_30:FA port map ( cf(2)(29),cf(2)(28),cf(2)(27),cf(3)(30),sf(3)(30) );
FA_3_31:FA port map ( sf(2)(30),sf(2)(31),sf(2)(32),cf(3)(31),sf(3)(31) );
FA_3_32:FA port map ( cf(2)(32),cf(2)(31),cf(2)(30),cf(3)(32),sf(3)(32) );
FA_3_33:FA port map ( sf(2)(33),sf(2)(34),sf(2)(35),cf(3)(33),sf(3)(33) );
FA_3_34:FA port map ( cf(2)(35),cf(2)(34),cf(2)(33),cf(3)(34),sf(3)(34) );
FA_3_35:FA port map ( sf(2)(36),sf(2)(37),sf(2)(38),cf(3)(35),sf(3)(35) );
FA_3_36:FA port map ( cf(2)(38),cf(2)(37),cf(2)(36),cf(3)(36),sf(3)(36) );
FA_3_37:FA port map ( sf(2)(39),sf(2)(40),sf(2)(41),cf(3)(37),sf(3)(37) );
FA_3_38:FA port map ( cf(2)(41),cf(2)(40),cf(2)(39),cf(3)(38),sf(3)(38) );
FA_3_39:FA port map ( sf(2)(42),sf(2)(43),sf(2)(44),cf(3)(39),sf(3)(39) );
FA_3_40:FA port map ( cf(2)(44),cf(2)(43),cf(2)(42),cf(3)(40),sf(3)(40) );
FA_3_41:FA port map ( sf(2)(45),sf(2)(46),sf(2)(47),cf(3)(41),sf(3)(41) );
FA_3_42:FA port map ( cf(2)(47),cf(2)(46),cf(2)(45),cf(3)(42),sf(3)(42) );
FA_3_43:FA port map ( sf(2)(48),sf(2)(49),sf(2)(50),cf(3)(43),sf(3)(43) );
FA_3_44:FA port map ( cf(2)(50),cf(2)(49),cf(2)(48),cf(3)(44),sf(3)(44) );
FA_3_45:FA port map ( sf(2)(51),sf(2)(52),sf(2)(53),cf(3)(45),sf(3)(45) );
FA_3_46:FA port map ( cf(2)(53),cf(2)(52),cf(2)(51),cf(3)(46),sf(3)(46) );
FA_3_47:FA port map ( sf(2)(54),sf(2)(55),sf(2)(56),cf(3)(47),sf(3)(47) );
FA_3_48:FA port map ( cf(2)(56),cf(2)(55),cf(2)(54),cf(3)(48),sf(3)(48) );
FA_3_49:FA port map ( sf(2)(57),sf(2)(58),sf(2)(59),cf(3)(49),sf(3)(49) );
FA_3_50:FA port map ( cf(2)(59),cf(2)(58),cf(2)(57),cf(3)(50),sf(3)(50) );
FA_3_51:FA port map ( sf(2)(60),sf(2)(61),sf(2)(62),cf(3)(51),sf(3)(51) );
FA_3_52:FA port map ( cf(2)(62),cf(2)(61),cf(2)(60),cf(3)(52),sf(3)(52) );
FA_3_53:FA port map ( sf(2)(63),sf(2)(64),sf(2)(65),cf(3)(53),sf(3)(53) );
FA_3_54:FA port map ( cf(2)(65),cf(2)(64),cf(2)(63),cf(3)(54),sf(3)(54) );
FA_3_55:FA port map ( sf(2)(66),sf(2)(67),sf(2)(68),cf(3)(55),sf(3)(55) );
FA_3_56:FA port map ( cf(2)(68),cf(2)(67),cf(2)(66),cf(3)(56),sf(3)(56) );
FA_3_57:FA port map ( sf(2)(69),sf(2)(70),sf(2)(71),cf(3)(57),sf(3)(57) );
FA_3_58:FA port map ( cf(2)(71),cf(2)(70),cf(2)(69),cf(3)(58),sf(3)(58) );
FA_3_59:FA port map ( sf(2)(72),sf(2)(73),sf(2)(74),cf(3)(59),sf(3)(59) );
FA_3_60:FA port map ( cf(2)(74),cf(2)(73),cf(2)(72),cf(3)(60),sf(3)(60) );
FA_3_61:FA port map ( sf(2)(75),sf(2)(76),sf(2)(77),cf(3)(61),sf(3)(61) );
FA_3_62:FA port map ( cf(2)(77),cf(2)(76),cf(2)(75),cf(3)(62),sf(3)(62) );
FA_3_63:FA port map ( sf(2)(78),sf(2)(79),sf(2)(80),cf(3)(63),sf(3)(63) );
FA_3_64:FA port map ( cf(2)(80),cf(2)(79),cf(2)(78),cf(3)(64),sf(3)(64) );
FA_3_65:FA port map ( sf(2)(81),sf(2)(82),sf(2)(83),cf(3)(65),sf(3)(65) );
FA_3_66:FA port map ( cf(2)(83),cf(2)(82),cf(2)(81),cf(3)(66),sf(3)(66) );
FA_3_67:FA port map ( sf(2)(84),sf(2)(85),sf(2)(86),cf(3)(67),sf(3)(67) );
FA_3_68:FA port map ( cf(2)(86),cf(2)(85),cf(2)(84),cf(3)(68),sf(3)(68) );
FA_3_69:FA port map ( sf(2)(87),sf(2)(88),sf(2)(89),cf(3)(69),sf(3)(69) );
FA_3_70:FA port map ( cf(2)(89),cf(2)(88),cf(2)(87),cf(3)(70),sf(3)(70) );
FA_3_71:FA port map ( sf(2)(90),sf(2)(91),sf(2)(92),cf(3)(71),sf(3)(71) );
FA_3_72:FA port map ( cf(2)(92),cf(2)(91),cf(2)(90),cf(3)(72),sf(3)(72) );
FA_3_73:FA port map ( sf(2)(93),sf(2)(94),sf(2)(95),cf(3)(73),sf(3)(73) );
FA_3_74:FA port map ( cf(2)(95),cf(2)(94),cf(2)(93),cf(3)(74),sf(3)(74) );
FA_3_75:FA port map ( sf(2)(96),sf(2)(97),sf(2)(98),cf(3)(75),sf(3)(75) );
FA_3_76:FA port map ( cf(2)(98),cf(2)(97),cf(2)(96),cf(3)(76),sf(3)(76) );
FA_3_77:FA port map ( sf(2)(99),sf(2)(100),sf(2)(101),cf(3)(77),sf(3)(77) );
FA_3_78:FA port map ( cf(2)(101),cf(2)(100),cf(2)(99),cf(3)(78),sf(3)(78) );
FA_3_79:FA port map ( sf(2)(102),sf(2)(103),sf(2)(104),cf(3)(79),sf(3)(79) );
FA_3_80:FA port map ( cf(2)(104),cf(2)(103),cf(2)(102),cf(3)(80),sf(3)(80) );
FA_3_81:FA port map ( sf(2)(105),sf(2)(106),sf(2)(107),cf(3)(81),sf(3)(81) );
FA_3_82:FA port map ( cf(2)(107),cf(2)(106),cf(2)(105),cf(3)(82),sf(3)(82) );
FA_3_83:FA port map ( sf(2)(108),sf(2)(109),sf(2)(110),cf(3)(83),sf(3)(83) );
FA_3_84:FA port map ( cf(2)(110),cf(2)(109),cf(2)(108),cf(3)(84),sf(3)(84) );
FA_3_85:FA port map ( sf(2)(111),sf(2)(112),sf(2)(113),cf(3)(85),sf(3)(85) );
FA_3_86:FA port map ( cf(2)(113),cf(2)(112),cf(2)(111),cf(3)(86),sf(3)(86) );
FA_3_87:FA port map ( sf(2)(114),sf(2)(115),sh(2)(6),cf(3)(87),sf(3)(87) );
FA_3_88:FA port map ( ch(2)(6),cf(2)(115),cf(2)(114),cf(3)(88),sf(3)(88) );
FA_3_89:FA port map ( sf(2)(116),sf(2)(117),a(16)(21),cf(3)(89),sf(3)(89) );
FA_3_90:FA port map ( cf(2)(117),cf(2)(116),sf(2)(118),cf(3)(90),sf(3)(90) );
FA_3_91:FA port map ( sh(2)(7),a(15)(24),a(16)(22),cf(3)(91),sf(3)(91) );
FA_3_92:FA port map ( ch(2)(7),cf(2)(118),sf(2)(119),cf(3)(92),sf(3)(92) );
FA_3_93:FA port map ( a(14)(27),a(15)(25),a(16)(23),cf(3)(93),sf(3)(93) );
FA_3_94:FA port map ( cf(2)(119),sh(2)(8),a(13)(30),cf(3)(94),sf(3)(94) );
FA_3_95:FA port map ( a(14)(28),a(15)(26),a(16)(24),cf(3)(95),sf(3)(95) );
FA_3_96:FA port map ( ch(2)(8),sn(12),a(13)(31),cf(3)(96),sf(3)(96) );
FA_3_97:FA port map ( a(14)(29),a(15)(27),a(16)(25),cf(3)(97),sf(3)(97) );
FA_3_98:FA port map ( '1',a(13)(32),a(14)(30),cf(3)(98),sf(3)(98) );
FA_3_99:FA port map ( sn(13),a(14)(31),a(15)(29),cf(3)(99),sf(3)(99) );


--FAs ITERAZIONE  4

FA_4_0:FA port map ( sh(3)(0),a(2)(2),a(3)(0),cf(4)(0),sf(4)(0) );
FA_4_1:FA port map ( ch(3)(0),sh(3)(1),a(2)(3),cf(4)(1),sf(4)(1) );
FA_4_2:FA port map ( ch(3)(1),sf(3)(0),sh(3)(2),cf(4)(2),sf(4)(2) );
FA_4_3:FA port map ( ch(3)(2),cf(3)(0),sf(3)(1),cf(4)(3),sf(4)(3) );
FA_4_4:FA port map ( ch(3)(3),cf(3)(1),sf(3)(2),cf(4)(4),sf(4)(4) );
FA_4_5:FA port map ( cf(3)(3),cf(3)(2),sf(3)(4),cf(4)(5),sf(4)(5) );
FA_4_6:FA port map ( cf(3)(5),cf(3)(4),sf(3)(6),cf(4)(6),sf(4)(6) );
FA_4_7:FA port map ( cf(3)(7),cf(3)(6),sf(3)(8),cf(4)(7),sf(4)(7) );
FA_4_8:FA port map ( cf(3)(9),cf(3)(8),sf(3)(10),cf(4)(8),sf(4)(8) );
FA_4_9:FA port map ( cf(3)(11),cf(3)(10),sf(3)(12),cf(4)(9),sf(4)(9) );
FA_4_10:FA port map ( cf(3)(13),cf(3)(12),sf(3)(14),cf(4)(10),sf(4)(10) );
FA_4_11:FA port map ( cf(3)(15),cf(3)(14),sf(3)(16),cf(4)(11),sf(4)(11) );
FA_4_12:FA port map ( cf(3)(17),cf(3)(16),sf(3)(18),cf(4)(12),sf(4)(12) );
FA_4_13:FA port map ( cf(3)(19),cf(3)(18),sf(3)(20),cf(4)(13),sf(4)(13) );
FA_4_14:FA port map ( cf(3)(21),cf(3)(20),sf(3)(22),cf(4)(14),sf(4)(14) );
FA_4_15:FA port map ( cf(3)(23),cf(3)(22),sf(3)(24),cf(4)(15),sf(4)(15) );
FA_4_16:FA port map ( cf(3)(25),cf(3)(24),sf(3)(26),cf(4)(16),sf(4)(16) );
FA_4_17:FA port map ( cf(3)(27),cf(3)(26),sf(3)(28),cf(4)(17),sf(4)(17) );
FA_4_18:FA port map ( cf(3)(29),cf(3)(28),sf(3)(30),cf(4)(18),sf(4)(18) );
FA_4_19:FA port map ( cf(3)(31),cf(3)(30),sf(3)(32),cf(4)(19),sf(4)(19) );
FA_4_20:FA port map ( cf(3)(33),cf(3)(32),sf(3)(34),cf(4)(20),sf(4)(20) );
FA_4_21:FA port map ( cf(3)(35),cf(3)(34),sf(3)(36),cf(4)(21),sf(4)(21) );
FA_4_22:FA port map ( cf(3)(37),cf(3)(36),sf(3)(38),cf(4)(22),sf(4)(22) );
FA_4_23:FA port map ( cf(3)(39),cf(3)(38),sf(3)(40),cf(4)(23),sf(4)(23) );
FA_4_24:FA port map ( cf(3)(41),cf(3)(40),sf(3)(42),cf(4)(24),sf(4)(24) );
FA_4_25:FA port map ( cf(3)(43),cf(3)(42),sf(3)(44),cf(4)(25),sf(4)(25) );
FA_4_26:FA port map ( cf(3)(45),cf(3)(44),sf(3)(46),cf(4)(26),sf(4)(26) );
FA_4_27:FA port map ( cf(3)(47),cf(3)(46),sf(3)(48),cf(4)(27),sf(4)(27) );
FA_4_28:FA port map ( cf(3)(49),cf(3)(48),sf(3)(50),cf(4)(28),sf(4)(28) );
FA_4_29:FA port map ( cf(3)(51),cf(3)(50),sf(3)(52),cf(4)(29),sf(4)(29) );
FA_4_30:FA port map ( cf(3)(53),cf(3)(52),sf(3)(54),cf(4)(30),sf(4)(30) );
FA_4_31:FA port map ( cf(3)(55),cf(3)(54),sf(3)(56),cf(4)(31),sf(4)(31) );
FA_4_32:FA port map ( cf(3)(57),cf(3)(56),sf(3)(58),cf(4)(32),sf(4)(32) );
FA_4_33:FA port map ( cf(3)(59),cf(3)(58),sf(3)(60),cf(4)(33),sf(4)(33) );
FA_4_34:FA port map ( cf(3)(61),cf(3)(60),sf(3)(62),cf(4)(34),sf(4)(34) );
FA_4_35:FA port map ( cf(3)(63),cf(3)(62),sf(3)(64),cf(4)(35),sf(4)(35) );
FA_4_36:FA port map ( cf(3)(65),cf(3)(64),sf(3)(66),cf(4)(36),sf(4)(36) );
FA_4_37:FA port map ( cf(3)(67),cf(3)(66),sf(3)(68),cf(4)(37),sf(4)(37) );
FA_4_38:FA port map ( cf(3)(69),cf(3)(68),sf(3)(70),cf(4)(38),sf(4)(38) );
FA_4_39:FA port map ( cf(3)(71),cf(3)(70),sf(3)(72),cf(4)(39),sf(4)(39) );
FA_4_40:FA port map ( cf(3)(73),cf(3)(72),sf(3)(74),cf(4)(40),sf(4)(40) );
FA_4_41:FA port map ( cf(3)(75),cf(3)(74),sf(3)(76),cf(4)(41),sf(4)(41) );
FA_4_42:FA port map ( cf(3)(77),cf(3)(76),sf(3)(78),cf(4)(42),sf(4)(42) );
FA_4_43:FA port map ( cf(3)(79),cf(3)(78),sf(3)(80),cf(4)(43),sf(4)(43) );
FA_4_44:FA port map ( cf(3)(81),cf(3)(80),sf(3)(82),cf(4)(44),sf(4)(44) );
FA_4_45:FA port map ( cf(3)(83),cf(3)(82),sf(3)(84),cf(4)(45),sf(4)(45) );
FA_4_46:FA port map ( cf(3)(85),cf(3)(84),sf(3)(86),cf(4)(46),sf(4)(46) );
FA_4_47:FA port map ( cf(3)(87),cf(3)(86),sf(3)(88),cf(4)(47),sf(4)(47) );
FA_4_48:FA port map ( cf(3)(89),cf(3)(88),sf(3)(90),cf(4)(48),sf(4)(48) );
FA_4_49:FA port map ( cf(3)(91),cf(3)(90),sf(3)(92),cf(4)(49),sf(4)(49) );
FA_4_50:FA port map ( cf(3)(93),cf(3)(92),sf(3)(94),cf(4)(50),sf(4)(50) );
FA_4_51:FA port map ( cf(3)(95),cf(3)(94),sf(3)(96),cf(4)(51),sf(4)(51) );
FA_4_52:FA port map ( cf(3)(97),cf(3)(96),sf(3)(98),cf(4)(52),sf(4)(52) );
FA_4_53:FA port map ( ch(3)(4),cf(3)(98),sf(3)(99),cf(4)(53),sf(4)(53) );
FA_4_54:FA port map ( cf(3)(99),sh(3)(5),a(15)(30),cf(4)(54),sf(4)(54) );
FA_4_55:FA port map ( ch(3)(5),sn(14),a(15)(31),cf(4)(55),sf(4)(55) );


--FAs ITERAZIONE  5

FA_5_0:FA port map ( sh(4)(0),a(2)(0),s(2),cf(5)(0),sf(5)(0) );
FA_5_1:FA port map ( ch(4)(0),sh(4)(1),a(2)(1),cf(5)(1),sf(5)(1) );
FA_5_2:FA port map ( ch(4)(1),sf(4)(0),s(3),cf(5)(2),sf(5)(2) );
FA_5_3:FA port map ( cf(4)(0),sf(4)(1),a(3)(1),cf(5)(3),sf(5)(3) );
FA_5_4:FA port map ( cf(4)(1),sf(4)(2),s(4),cf(5)(4),sf(5)(4) );
FA_5_5:FA port map ( cf(4)(2),sf(4)(3),sh(3)(3),cf(5)(5),sf(5)(5) );
FA_5_6:FA port map ( cf(4)(3),sf(4)(4),sf(3)(3),cf(5)(6),sf(5)(6) );
FA_5_7:FA port map ( cf(4)(4),sf(4)(5),sf(3)(5),cf(5)(7),sf(5)(7) );
FA_5_8:FA port map ( cf(4)(5),sf(4)(6),sf(3)(7),cf(5)(8),sf(5)(8) );
FA_5_9:FA port map ( cf(4)(6),sf(4)(7),sf(3)(9),cf(5)(9),sf(5)(9) );
FA_5_10:FA port map ( cf(4)(7),sf(4)(8),sf(3)(11),cf(5)(10),sf(5)(10) );
FA_5_11:FA port map ( cf(4)(8),sf(4)(9),sf(3)(13),cf(5)(11),sf(5)(11) );
FA_5_12:FA port map ( cf(4)(9),sf(4)(10),sf(3)(15),cf(5)(12),sf(5)(12) );
FA_5_13:FA port map ( cf(4)(10),sf(4)(11),sf(3)(17),cf(5)(13),sf(5)(13) );
FA_5_14:FA port map ( cf(4)(11),sf(4)(12),sf(3)(19),cf(5)(14),sf(5)(14) );
FA_5_15:FA port map ( cf(4)(12),sf(4)(13),sf(3)(21),cf(5)(15),sf(5)(15) );
FA_5_16:FA port map ( cf(4)(13),sf(4)(14),sf(3)(23),cf(5)(16),sf(5)(16) );
FA_5_17:FA port map ( cf(4)(14),sf(4)(15),sf(3)(25),cf(5)(17),sf(5)(17) );
FA_5_18:FA port map ( cf(4)(15),sf(4)(16),sf(3)(27),cf(5)(18),sf(5)(18) );
FA_5_19:FA port map ( cf(4)(16),sf(4)(17),sf(3)(29),cf(5)(19),sf(5)(19) );
FA_5_20:FA port map ( cf(4)(17),sf(4)(18),sf(3)(31),cf(5)(20),sf(5)(20) );
FA_5_21:FA port map ( cf(4)(18),sf(4)(19),sf(3)(33),cf(5)(21),sf(5)(21) );
FA_5_22:FA port map ( cf(4)(19),sf(4)(20),sf(3)(35),cf(5)(22),sf(5)(22) );
FA_5_23:FA port map ( cf(4)(20),sf(4)(21),sf(3)(37),cf(5)(23),sf(5)(23) );
FA_5_24:FA port map ( cf(4)(21),sf(4)(22),sf(3)(39),cf(5)(24),sf(5)(24) );
FA_5_25:FA port map ( cf(4)(22),sf(4)(23),sf(3)(41),cf(5)(25),sf(5)(25) );
FA_5_26:FA port map ( cf(4)(23),sf(4)(24),sf(3)(43),cf(5)(26),sf(5)(26) );
FA_5_27:FA port map ( cf(4)(24),sf(4)(25),sf(3)(45),cf(5)(27),sf(5)(27) );
FA_5_28:FA port map ( cf(4)(25),sf(4)(26),sf(3)(47),cf(5)(28),sf(5)(28) );
FA_5_29:FA port map ( cf(4)(26),sf(4)(27),sf(3)(49),cf(5)(29),sf(5)(29) );
FA_5_30:FA port map ( cf(4)(27),sf(4)(28),sf(3)(51),cf(5)(30),sf(5)(30) );
FA_5_31:FA port map ( cf(4)(28),sf(4)(29),sf(3)(53),cf(5)(31),sf(5)(31) );
FA_5_32:FA port map ( cf(4)(29),sf(4)(30),sf(3)(55),cf(5)(32),sf(5)(32) );
FA_5_33:FA port map ( cf(4)(30),sf(4)(31),sf(3)(57),cf(5)(33),sf(5)(33) );
FA_5_34:FA port map ( cf(4)(31),sf(4)(32),sf(3)(59),cf(5)(34),sf(5)(34) );
FA_5_35:FA port map ( cf(4)(32),sf(4)(33),sf(3)(61),cf(5)(35),sf(5)(35) );
FA_5_36:FA port map ( cf(4)(33),sf(4)(34),sf(3)(63),cf(5)(36),sf(5)(36) );
FA_5_37:FA port map ( cf(4)(34),sf(4)(35),sf(3)(65),cf(5)(37),sf(5)(37) );
FA_5_38:FA port map ( cf(4)(35),sf(4)(36),sf(3)(67),cf(5)(38),sf(5)(38) );
FA_5_39:FA port map ( cf(4)(36),sf(4)(37),sf(3)(69),cf(5)(39),sf(5)(39) );
FA_5_40:FA port map ( cf(4)(37),sf(4)(38),sf(3)(71),cf(5)(40),sf(5)(40) );
FA_5_41:FA port map ( cf(4)(38),sf(4)(39),sf(3)(73),cf(5)(41),sf(5)(41) );
FA_5_42:FA port map ( cf(4)(39),sf(4)(40),sf(3)(75),cf(5)(42),sf(5)(42) );
FA_5_43:FA port map ( cf(4)(40),sf(4)(41),sf(3)(77),cf(5)(43),sf(5)(43) );
FA_5_44:FA port map ( cf(4)(41),sf(4)(42),sf(3)(79),cf(5)(44),sf(5)(44) );
FA_5_45:FA port map ( cf(4)(42),sf(4)(43),sf(3)(81),cf(5)(45),sf(5)(45) );
FA_5_46:FA port map ( cf(4)(43),sf(4)(44),sf(3)(83),cf(5)(46),sf(5)(46) );
FA_5_47:FA port map ( cf(4)(44),sf(4)(45),sf(3)(85),cf(5)(47),sf(5)(47) );
FA_5_48:FA port map ( cf(4)(45),sf(4)(46),sf(3)(87),cf(5)(48),sf(5)(48) );
FA_5_49:FA port map ( cf(4)(46),sf(4)(47),sf(3)(89),cf(5)(49),sf(5)(49) );
FA_5_50:FA port map ( cf(4)(47),sf(4)(48),sf(3)(91),cf(5)(50),sf(5)(50) );
FA_5_51:FA port map ( cf(4)(48),sf(4)(49),sf(3)(93),cf(5)(51),sf(5)(51) );
FA_5_52:FA port map ( cf(4)(49),sf(4)(50),sf(3)(95),cf(5)(52),sf(5)(52) );
FA_5_53:FA port map ( cf(4)(50),sf(4)(51),sf(3)(97),cf(5)(53),sf(5)(53) );
FA_5_54:FA port map ( cf(4)(51),sf(4)(52),sh(3)(4),cf(5)(54),sf(5)(54) );
FA_5_55:FA port map ( cf(4)(52),sf(4)(53),a(16)(27),cf(5)(55),sf(5)(55) );
FA_5_56:FA port map ( cf(4)(53),sf(4)(54),a(16)(28),cf(5)(56),sf(5)(56) );
FA_5_57:FA port map ( cf(4)(54),sf(4)(55),a(16)(29),cf(5)(57),sf(5)(57) );
FA_5_58:FA port map ( cf(4)(55),sh(4)(2),a(16)(30),cf(5)(58),sf(5)(58) );
FA_5_59:FA port map ( ch(4)(2),sn(15),a(16)(31),cf(5)(59),sf(5)(59) );

---------------------------------------
--HAs PORT MAP-------------------------
--HAs ITERAZIONE  0
HA_0_0:HA port map ( a(0)(24),a(1)(22),ch(0)(0),sh(0)(0) );
HA_0_1:HA port map ( a(0)(25),a(1)(23),ch(0)(1),sh(0)(1) );
HA_0_2:HA port map ( a(3)(20),a(4)(18),ch(0)(2),sh(0)(2) );
HA_0_3:HA port map ( a(3)(21),a(4)(19),ch(0)(3),sh(0)(3) );
HA_0_4:HA port map ( a(6)(16),a(7)(14),ch(0)(4),sh(0)(4) );
HA_0_5:HA port map ( a(6)(17),a(7)(15),ch(0)(5),sh(0)(5) );
HA_0_6:HA port map ( a(9)(12),a(10)(10),ch(0)(6),sh(0)(6) );
HA_0_7:HA port map ( a(9)(13),a(10)(11),ch(0)(7),sh(0)(7) );
HA_0_8:HA port map ( a(10)(16),a(11)(14),ch(0)(8),sh(0)(8) );
HA_0_9:HA port map ( a(8)(22),a(9)(20),ch(0)(9),sh(0)(9) );
HA_0_10:HA port map ( a(6)(28),a(7)(26),ch(0)(10),sh(0)(10) );
HA_0_11:HA port map ( '1',a(5)(32),ch(0)(11),sh(0)(11) );

--HAs ITERAZIONE  1
HA_1_0:HA port map ( a(0)(16),a(1)(14),ch(1)(0),sh(1)(0) );
HA_1_1:HA port map ( a(0)(17),a(1)(15),ch(1)(1),sh(1)(1) );
HA_1_2:HA port map ( a(3)(12),a(4)(10),ch(1)(2),sh(1)(2) );
HA_1_3:HA port map ( a(3)(13),a(4)(11),ch(1)(3),sh(1)(3) );
HA_1_4:HA port map ( a(6)(8),a(7)(6),ch(1)(4),sh(1)(4) );
HA_1_5:HA port map ( a(6)(9),a(7)(7),ch(1)(5),sh(1)(5) );
HA_1_6:HA port map ( a(9)(4),a(10)(2),ch(1)(6),sh(1)(6) );
HA_1_7:HA port map ( a(9)(5),a(10)(3),ch(1)(7),sh(1)(7) );
HA_1_8:HA port map ( a(14)(16),a(15)(14),ch(1)(8),sh(1)(8) );
HA_1_9:HA port map ( a(12)(22),a(13)(20),ch(1)(9),sh(1)(9) );
HA_1_10:HA port map ( a(10)(28),a(11)(26),ch(1)(10),sh(1)(10) );
HA_1_11:HA port map ( '1',a(9)(32),ch(1)(11),sh(1)(11) );


--HAs ITERAZIONE  2
HA_2_0:HA port map ( a(0)(10),a(1)(8),ch(2)(0),sh(2)(0) );
HA_2_1:HA port map ( a(0)(11),a(1)(9),ch(2)(1),sh(2)(1) );
HA_2_2:HA port map ( a(3)(6),a(4)(4),ch(2)(2),sh(2)(2) );
HA_2_3:HA port map ( a(3)(7),a(4)(5),ch(2)(3),sh(2)(3) );
HA_2_4:HA port map ( a(6)(2),a(7)(0),ch(2)(4),sh(2)(4) );
HA_2_5:HA port map ( a(6)(3),a(7)(1),ch(2)(5),sh(2)(5) );
HA_2_6:HA port map ( a(15)(22),a(16)(20),ch(2)(6),sh(2)(6) );
HA_2_7:HA port map ( a(13)(28),a(14)(26),ch(2)(7),sh(2)(7) );
HA_2_8:HA port map ( '1',a(12)(32),ch(2)(8),sh(2)(8) );

--HAs ITERAZIONE  3
HA_3_0:HA port map ( a(0)(6),a(1)(4),ch(3)(0),sh(3)(0) );
HA_3_1:HA port map ( a(0)(7),a(1)(5),ch(3)(1),sh(3)(1) );
HA_3_2:HA port map ( a(3)(2),a(4)(0),ch(3)(2),sh(3)(2) );
HA_3_3:HA port map ( a(3)(3),a(4)(1),ch(3)(3),sh(3)(3) );
HA_3_4:HA port map ( a(15)(28),a(16)(26),ch(3)(4),sh(3)(4) );
HA_3_5:HA port map ( '1',a(14)(32),ch(3)(5),sh(3)(5) );


--HAs ITERAZIONE  4
HA_4_0:HA port map ( a(0)(4),a(1)(2),ch(4)(0),sh(4)(0) );
HA_4_1:HA port map ( a(0)(5),a(1)(3),ch(4)(1),sh(4)(1) );
HA_4_2:HA port map ( '1',a(15)(32),ch(4)(2),sh(4)(2) );

--HAs ITERAZIONE  5
HA_5_0:HA port map ( a(0)(2),a(1)(0),ch(5)(0),sh(5)(0) );
HA_5_1:HA port map ( a(0)(3),a(1)(1),ch(5)(1),sh(5)(1) );


-------------------
---FINAL ADDER-----

--final_sum1<=
--a(0)(0)&a(0)(1)&sh(5)(0)&ch(5)(0)&ch(5)(1)&cf(5)(0)&cf(5)(1)&cf(5)(2)&cf(5)(3)&cf(5)(4)&cf(5)(5)&cf(5)(6)&cf(5)(7)&cf(5)(8)&cf(5)(9)&cf(5)(10)&cf(5)(11)&cf(5)(12)&cf(5)(13)&cf(5)(14)&cf(5)(15)&cf(5)(16)&cf(5)(17)&cf(5)(18)&cf(5)(19)&cf(5)(20)&cf(5)(21)&cf(5)(22)&cf(5)(23)&cf(5)(24)&cf(5)(25)&cf(5)(26)&cf(5)(27)&cf(5)(28)&cf(5)(29)&cf(5)(30)&cf(5)(31)&cf(5)(32)&cf(5)(33)&cf(5)(34)&cf(5)(35)&cf(5)(36)&cf(5)(37)&cf(5)(38)&cf(5)(39)&cf(5)(40)&cf(5)(41)&cf(5)(42)&cf(5)(43)&cf(5)(44)&cf(5)(45)&cf(5)(46)&cf(5)(47)&cf(5)(48)&cf(5)(49)&cf(5)(50)&cf(5)(51)&cf(5)(52)&cf(5)(53)&cf(5)(54)&cf(5)(55)&cf(5)(56)&cf(5)(57)&cf(5)(58)&cf(5)(59);
--final_sum2<=
--s(0)&'0'&s(1)&sh(5)(1)&sf(5)(0)&sf(5)(1)&sf(5)(2)&sf(5)(3)&sf(5)(4)&sf(5)(5)&sf(5)(6)&sf(5)(7)&sf(5)(8)&sf(5)(9)&sf(5)(10)&sf(5)(11)&sf(5)(12)&sf(5)(13)&sf(5)(14)&sf(5)(15)&sf(5)(16)&sf(5)(17)&sf(5)(18)&sf(5)(19)&sf(5)(20)&sf(5)(21)&sf(5)(22)&sf(5)(23)&sf(5)(24)&sf(5)(25)&sf(5)(26)&sf(5)(27)&sf(5)(28)&sf(5)(29)&sf(5)(30)&sf(5)(31)&sf(5)(32)&sf(5)(33)&sf(5)(34)&sf(5)(35)&sf(5)(36)&sf(5)(37)&sf(5)(38)&sf(5)(39)&sf(5)(40)&sf(5)(41)&sf(5)(42)&sf(5)(43)&sf(5)(44)&sf(5)(45)&sf(5)(46)&sf(5)(47)&sf(5)(48)&sf(5)(49)&sf(5)(50)&sf(5)(51)&sf(5)(52)&sf(5)(53)&sf(5)(54)&sf(5)(55)&sf(5)(56)&sf(5)(57)&sf(5)(58)&sf(5)(59)&'0';

P_out <= final_sum1(63 downto 0)+final_sum2(63 downto 0);
final_sum1<=
cf(5)(59)&cf(5)(58)&cf(5)(57)&cf(5)(56)&cf(5)(55)&cf(5)(54)&cf(5)(53)&cf(5)(52)&cf(5)(51)&cf(5)(50)&cf(5)(49)&cf(5)(48)&cf(5)(47)&cf(5)(46)&cf(5)(45)&cf(5)(44)&cf(5)(43)&cf(5)(42)&cf(5)(41)&cf(5)(40)&cf(5)(39)&cf(5)(38)&cf(5)(37)&cf(5)(36)&cf(5)(35)&cf(5)(34)&cf(5)(33)&cf(5)(32)&cf(5)(31)&cf(5)(30)&cf(5)(29)&cf(5)(28)&cf(5)(27)&cf(5)(26)&cf(5)(25)&cf(5)(24)&cf(5)(23)&cf(5)(22)&cf(5)(21)&cf(5)(20)&cf(5)(19)&cf(5)(18)&cf(5)(17)&cf(5)(16)&cf(5)(15)&cf(5)(14)&cf(5)(13)&cf(5)(12)&cf(5)(11)&cf(5)(10)&cf(5)(9)&cf(5)(8)&cf(5)(7)&cf(5)(6)&cf(5)(5)&cf(5)(4)&cf(5)(3)&cf(5)(2)&cf(5)(1)&cf(5)(0)&ch(5)(1)&ch(5)(0)&sh(5)(0)&a(0)(1)&a(0)(0);
final_sum2<=
'0'&sf(5)(59)&sf(5)(58)&sf(5)(57)&sf(5)(56)&sf(5)(55)&sf(5)(54)&sf(5)(53)&sf(5)(52)&sf(5)(51)&sf(5)(50)&sf(5)(49)&sf(5)(48)&sf(5)(47)&sf(5)(46)&sf(5)(45)&sf(5)(44)&sf(5)(43)&sf(5)(42)&sf(5)(41)&sf(5)(40)&sf(5)(39)&sf(5)(38)&sf(5)(37)&sf(5)(36)&sf(5)(35)&sf(5)(34)&sf(5)(33)&sf(5)(32)&sf(5)(31)&sf(5)(30)&sf(5)(29)&sf(5)(28)&sf(5)(27)&sf(5)(26)&sf(5)(25)&sf(5)(24)&sf(5)(23)&sf(5)(22)&sf(5)(21)&sf(5)(20)&sf(5)(19)&sf(5)(18)&sf(5)(17)&sf(5)(16)&sf(5)(15)&sf(5)(14)&sf(5)(13)&sf(5)(12)&sf(5)(11)&sf(5)(10)&sf(5)(9)&sf(5)(8)&sf(5)(7)&sf(5)(6)&sf(5)(5)&sf(5)(4)&sf(5)(3)&sf(5)(2)&sf(5)(1)&sf(5)(0)&sh(5)(1)&s(1)&'0'&s(0);


end structural;
