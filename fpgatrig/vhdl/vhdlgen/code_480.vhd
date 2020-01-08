LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY code_480 IS
   PORT(
      --*************************************************
      -- V1495 Front Panel Ports (PORT A,B,C,G)
      --*************************************************
      A_DIN_L       : IN     std_logic_vector (31 DOWNTO 0);  -- In A (32 x LVDS/ECL)
      B_DIN_L       : IN     std_logic_vector (31 DOWNTO 0);  -- In B (32 x LVDS/ECL)
      D_DIN_L       : IN     std_logic_vector (31 DOWNTO 0);  -- In D (32 x LVDS/ECL)
      E_DIN_L       : IN     std_logic_vector (31 DOWNTO 0);  -- In E (32 x LVDS/ECL)
      F_DOUT_L      : OUT    std_logic_vector (31 DOWNTO 0);  -- OUT F (32 x LVDS/ECL)
      C_DOUT_L      : OUT    std_logic_vector (31 DOWNTO 0);  -- Out C (32 x LVDS)
      c1            : IN STD_LOGIC                            -- the PLL1 output
   );
END code_480 ;
ARCHITECTURE rtl OF code_480 IS
        signal XTnim     : std_logic_vector(31 downto 0);
        signal XBnim     : std_logic_vector(31 downto 0);
        signal YTnim     : std_logic_vector(31 downto 0);
        signal YBnim     : std_logic_vector(31 downto 0);
        signal XTp     : std_logic_vector(31 downto 0);
        signal XTm     : std_logic_vector(31 downto 0);
        signal XBp     : std_logic_vector(31 downto 0);
        signal XBm     : std_logic_vector(31 downto 0);
        signal T1_L1: std_logic_vector(140 downto 0);
        signal T1_L2: std_logic_vector(35 downto 0);
        signal T1_L3: std_logic_vector(8 downto 0);
        signal T1_L4: std_logic_vector(2 downto 0);
        signal T2_L1: std_logic_vector(140 downto 0);
        signal T2_L2: std_logic_vector(35 downto 0);
        signal T2_L3: std_logic_vector(8 downto 0);
        signal T2_L4: std_logic_vector(2 downto 0);
        signal T3_L1: std_logic_vector(140 downto 0);
        signal T3_L2: std_logic_vector(35 downto 0);
        signal T3_L3: std_logic_vector(8 downto 0);
        signal T3_L4: std_logic_vector(2 downto 0);
        signal T4_L1: std_logic_vector(11 downto 0);
        signal T4_L2: std_logic_vector(2 downto 0);
        signal T4_L3: std_logic_vector(0 downto 0);
        signal T4_L4: std_logic_vector(0 downto 0);
        signal T5_L1: std_logic_vector(5 downto 0);
        signal T5_L2: std_logic_vector(1 downto 0);
        signal T5_L3: std_logic_vector(0 downto 0);
        signal T5_L4: std_logic_vector(0 downto 0);

        signal F_lvl_5: std_logic_vector(31 downto 0);

BEGIN
        YTnim (3 downto 0) <= D_DIN_L (5 downto 2);
        YBnim (3 downto 0) <= D_DIN_L (20 downto 17);
        XTp (11 downto 0) <= A_DIN_L (11 downto 0);
        XTm (11 downto 0) <= A_DIN_L (23 downto 12);
        XTnim (3 downto 0) <= A_DIN_L (27 downto 24);
        XBp (11 downto 0) <= B_DIN_L (11 downto 0);
        XBm (11 downto 0) <= B_DIN_L (23 downto 12);
        XBnim (3 downto 0) <= B_DIN_L (27 downto 24);
        
        F_DOUT_L (31 downto 0) <= F_lvl_5 (31 downto 0);
        C_DOUT_L (31 downto 0) <= F_lvl_5 (31 downto 0);
        
--  YTnim, YBnim,   ----These are NIM-clone
--  0- H1 , 1- H2 , 2- H4Y1 , 3- H4Y2

--  XTnim, XBnim    ----These are NIM-clone (not yet implemented)
--  0- H1 , 1- H2 , 2- H3 , 3- H4

--  XTp, XTm, XBp, XBm 
--  0=(0-.5),  1=(.5-1),  2=(1-1.5),  3=(1.5-2),  4=(2-2.5),  5=(2.5-3),  6=(3-3.5),  7=(3.5-4),  8=(4-4.5),  9=(4.5-5), 10=(5-5.5), 11=(>5.5)

--    OUTPUT TRIGGERS
--  1- dimuon	TB/BT	+-/-+	pXMin=-1.0	pXMax=100.0	pXSumMin=1.0	pXSumMax=100.0	pXDiffMin=-1.0	pXDiffMax=100.0
--  2- dimuon	TT/BB	+-/-+	pXMin=-1.0	pXMax=100.0	pXSumMin=1.0	pXSumMax=100.0	pXDiffMin=-1.0	pXDiffMax=100.0
--  3- dimuon	TB/BT	++/--	pXMin=-1.0	pXMax=100.0	pXSumMin=1.0	pXSumMax=100.0	pXDiffMin=-1.0	pXDiffMax=100.0
--  4- single	T/B	+/-	pXMin=-1.0	pXMax=100.0
--  5- single	T/B	+/-	pXMin=3.0	pXMax=100.0
lookuptablelv1 : process(c1)
begin
 if c1'event and c1 = '1' then

-------------------------BEGIN Trigger 1 Level 1--------------------------------
  if( (XTp(0)='1' AND XBm(2)='1') OR (XTp(0)='1' AND XBm(3)='1') )then
   T1_L1(0) <= '1';
  else
   T1_L1(0) <= '0';
  end if;

  if( (XTp(0)='1' AND XBm(4)='1') OR (XTp(0)='1' AND XBm(5)='1') )then
   T1_L1(1) <= '1';
  else
   T1_L1(1) <= '0';
  end if;

  if( (XTp(0)='1' AND XBm(6)='1') OR (XTp(0)='1' AND XBm(7)='1') )then
   T1_L1(2) <= '1';
  else
   T1_L1(2) <= '0';
  end if;

  if( (XTp(0)='1' AND XBm(8)='1') OR (XTp(0)='1' AND XBm(9)='1') )then
   T1_L1(3) <= '1';
  else
   T1_L1(3) <= '0';
  end if;

  if( (XTp(0)='1' AND XBm(10)='1') OR (XTp(0)='1' AND XBm(11)='1') )then
   T1_L1(4) <= '1';
  else
   T1_L1(4) <= '0';
  end if;

  if( (XTp(1)='1' AND XBm(1)='1') OR (XTp(1)='1' AND XBm(2)='1') )then
   T1_L1(5) <= '1';
  else
   T1_L1(5) <= '0';
  end if;

  if( (XTp(1)='1' AND XBm(3)='1') OR (XTp(1)='1' AND XBm(4)='1') )then
   T1_L1(6) <= '1';
  else
   T1_L1(6) <= '0';
  end if;

  if( (XTp(1)='1' AND XBm(5)='1') OR (XTp(1)='1' AND XBm(6)='1') )then
   T1_L1(7) <= '1';
  else
   T1_L1(7) <= '0';
  end if;

  if( (XTp(1)='1' AND XBm(7)='1') OR (XTp(1)='1' AND XBm(8)='1') )then
   T1_L1(8) <= '1';
  else
   T1_L1(8) <= '0';
  end if;

  if( (XTp(1)='1' AND XBm(9)='1') OR (XTp(1)='1' AND XBm(10)='1') )then
   T1_L1(9) <= '1';
  else
   T1_L1(9) <= '0';
  end if;

  if( (XTp(1)='1' AND XBm(11)='1') OR (XTp(2)='1' AND XBm(0)='1') )then
   T1_L1(10) <= '1';
  else
   T1_L1(10) <= '0';
  end if;

  if( (XTp(2)='1' AND XBm(1)='1') OR (XTp(2)='1' AND XBm(2)='1') )then
   T1_L1(11) <= '1';
  else
   T1_L1(11) <= '0';
  end if;

  if( (XTp(2)='1' AND XBm(3)='1') OR (XTp(2)='1' AND XBm(4)='1') )then
   T1_L1(12) <= '1';
  else
   T1_L1(12) <= '0';
  end if;

  if( (XTp(2)='1' AND XBm(5)='1') OR (XTp(2)='1' AND XBm(6)='1') )then
   T1_L1(13) <= '1';
  else
   T1_L1(13) <= '0';
  end if;

  if( (XTp(2)='1' AND XBm(7)='1') OR (XTp(2)='1' AND XBm(8)='1') )then
   T1_L1(14) <= '1';
  else
   T1_L1(14) <= '0';
  end if;

  if( (XTp(2)='1' AND XBm(9)='1') OR (XTp(2)='1' AND XBm(10)='1') )then
   T1_L1(15) <= '1';
  else
   T1_L1(15) <= '0';
  end if;

  if( (XTp(2)='1' AND XBm(11)='1') OR (XTp(3)='1' AND XBm(0)='1') )then
   T1_L1(16) <= '1';
  else
   T1_L1(16) <= '0';
  end if;

  if( (XTp(3)='1' AND XBm(1)='1') OR (XTp(3)='1' AND XBm(2)='1') )then
   T1_L1(17) <= '1';
  else
   T1_L1(17) <= '0';
  end if;

  if( (XTp(3)='1' AND XBm(3)='1') OR (XTp(3)='1' AND XBm(4)='1') )then
   T1_L1(18) <= '1';
  else
   T1_L1(18) <= '0';
  end if;

  if( (XTp(3)='1' AND XBm(5)='1') OR (XTp(3)='1' AND XBm(6)='1') )then
   T1_L1(19) <= '1';
  else
   T1_L1(19) <= '0';
  end if;

  if( (XTp(3)='1' AND XBm(7)='1') OR (XTp(3)='1' AND XBm(8)='1') )then
   T1_L1(20) <= '1';
  else
   T1_L1(20) <= '0';
  end if;

  if( (XTp(3)='1' AND XBm(9)='1') OR (XTp(3)='1' AND XBm(10)='1') )then
   T1_L1(21) <= '1';
  else
   T1_L1(21) <= '0';
  end if;

  if( (XTp(3)='1' AND XBm(11)='1') OR (XTp(4)='1' AND XBm(0)='1') )then
   T1_L1(22) <= '1';
  else
   T1_L1(22) <= '0';
  end if;

  if( (XTp(4)='1' AND XBm(1)='1') OR (XTp(4)='1' AND XBm(2)='1') )then
   T1_L1(23) <= '1';
  else
   T1_L1(23) <= '0';
  end if;

  if( (XTp(4)='1' AND XBm(3)='1') OR (XTp(4)='1' AND XBm(4)='1') )then
   T1_L1(24) <= '1';
  else
   T1_L1(24) <= '0';
  end if;

  if( (XTp(4)='1' AND XBm(5)='1') OR (XTp(4)='1' AND XBm(6)='1') )then
   T1_L1(25) <= '1';
  else
   T1_L1(25) <= '0';
  end if;

  if( (XTp(4)='1' AND XBm(7)='1') OR (XTp(4)='1' AND XBm(8)='1') )then
   T1_L1(26) <= '1';
  else
   T1_L1(26) <= '0';
  end if;

  if( (XTp(4)='1' AND XBm(9)='1') OR (XTp(4)='1' AND XBm(10)='1') )then
   T1_L1(27) <= '1';
  else
   T1_L1(27) <= '0';
  end if;

  if( (XTp(4)='1' AND XBm(11)='1') OR (XTp(5)='1' AND XBm(0)='1') )then
   T1_L1(28) <= '1';
  else
   T1_L1(28) <= '0';
  end if;

  if( (XTp(5)='1' AND XBm(1)='1') OR (XTp(5)='1' AND XBm(2)='1') )then
   T1_L1(29) <= '1';
  else
   T1_L1(29) <= '0';
  end if;

  if( (XTp(5)='1' AND XBm(3)='1') OR (XTp(5)='1' AND XBm(4)='1') )then
   T1_L1(30) <= '1';
  else
   T1_L1(30) <= '0';
  end if;

  if( (XTp(5)='1' AND XBm(5)='1') OR (XTp(5)='1' AND XBm(6)='1') )then
   T1_L1(31) <= '1';
  else
   T1_L1(31) <= '0';
  end if;

  if( (XTp(5)='1' AND XBm(7)='1') OR (XTp(5)='1' AND XBm(8)='1') )then
   T1_L1(32) <= '1';
  else
   T1_L1(32) <= '0';
  end if;

  if( (XTp(5)='1' AND XBm(9)='1') OR (XTp(5)='1' AND XBm(10)='1') )then
   T1_L1(33) <= '1';
  else
   T1_L1(33) <= '0';
  end if;

  if( (XTp(5)='1' AND XBm(11)='1') OR (XTp(6)='1' AND XBm(0)='1') )then
   T1_L1(34) <= '1';
  else
   T1_L1(34) <= '0';
  end if;

  if( (XTp(6)='1' AND XBm(1)='1') OR (XTp(6)='1' AND XBm(2)='1') )then
   T1_L1(35) <= '1';
  else
   T1_L1(35) <= '0';
  end if;

  if( (XTp(6)='1' AND XBm(3)='1') OR (XTp(6)='1' AND XBm(4)='1') )then
   T1_L1(36) <= '1';
  else
   T1_L1(36) <= '0';
  end if;

  if( (XTp(6)='1' AND XBm(5)='1') OR (XTp(6)='1' AND XBm(6)='1') )then
   T1_L1(37) <= '1';
  else
   T1_L1(37) <= '0';
  end if;

  if( (XTp(6)='1' AND XBm(7)='1') OR (XTp(6)='1' AND XBm(8)='1') )then
   T1_L1(38) <= '1';
  else
   T1_L1(38) <= '0';
  end if;

  if( (XTp(6)='1' AND XBm(9)='1') OR (XTp(6)='1' AND XBm(10)='1') )then
   T1_L1(39) <= '1';
  else
   T1_L1(39) <= '0';
  end if;

  if( (XTp(6)='1' AND XBm(11)='1') OR (XTp(7)='1' AND XBm(0)='1') )then
   T1_L1(40) <= '1';
  else
   T1_L1(40) <= '0';
  end if;

  if( (XTp(7)='1' AND XBm(1)='1') OR (XTp(7)='1' AND XBm(2)='1') )then
   T1_L1(41) <= '1';
  else
   T1_L1(41) <= '0';
  end if;

  if( (XTp(7)='1' AND XBm(3)='1') OR (XTp(7)='1' AND XBm(4)='1') )then
   T1_L1(42) <= '1';
  else
   T1_L1(42) <= '0';
  end if;

  if( (XTp(7)='1' AND XBm(5)='1') OR (XTp(7)='1' AND XBm(6)='1') )then
   T1_L1(43) <= '1';
  else
   T1_L1(43) <= '0';
  end if;

  if( (XTp(7)='1' AND XBm(7)='1') OR (XTp(7)='1' AND XBm(8)='1') )then
   T1_L1(44) <= '1';
  else
   T1_L1(44) <= '0';
  end if;

  if( (XTp(7)='1' AND XBm(9)='1') OR (XTp(7)='1' AND XBm(10)='1') )then
   T1_L1(45) <= '1';
  else
   T1_L1(45) <= '0';
  end if;

  if( (XTp(7)='1' AND XBm(11)='1') OR (XTp(8)='1' AND XBm(0)='1') )then
   T1_L1(46) <= '1';
  else
   T1_L1(46) <= '0';
  end if;

  if( (XTp(8)='1' AND XBm(1)='1') OR (XTp(8)='1' AND XBm(2)='1') )then
   T1_L1(47) <= '1';
  else
   T1_L1(47) <= '0';
  end if;

  if( (XTp(8)='1' AND XBm(3)='1') OR (XTp(8)='1' AND XBm(4)='1') )then
   T1_L1(48) <= '1';
  else
   T1_L1(48) <= '0';
  end if;

  if( (XTp(8)='1' AND XBm(5)='1') OR (XTp(8)='1' AND XBm(6)='1') )then
   T1_L1(49) <= '1';
  else
   T1_L1(49) <= '0';
  end if;

  if( (XTp(8)='1' AND XBm(7)='1') OR (XTp(8)='1' AND XBm(8)='1') )then
   T1_L1(50) <= '1';
  else
   T1_L1(50) <= '0';
  end if;

  if( (XTp(8)='1' AND XBm(9)='1') OR (XTp(8)='1' AND XBm(10)='1') )then
   T1_L1(51) <= '1';
  else
   T1_L1(51) <= '0';
  end if;

  if( (XTp(8)='1' AND XBm(11)='1') OR (XTp(9)='1' AND XBm(0)='1') )then
   T1_L1(52) <= '1';
  else
   T1_L1(52) <= '0';
  end if;

  if( (XTp(9)='1' AND XBm(1)='1') OR (XTp(9)='1' AND XBm(2)='1') )then
   T1_L1(53) <= '1';
  else
   T1_L1(53) <= '0';
  end if;

  if( (XTp(9)='1' AND XBm(3)='1') OR (XTp(9)='1' AND XBm(4)='1') )then
   T1_L1(54) <= '1';
  else
   T1_L1(54) <= '0';
  end if;

  if( (XTp(9)='1' AND XBm(5)='1') OR (XTp(9)='1' AND XBm(6)='1') )then
   T1_L1(55) <= '1';
  else
   T1_L1(55) <= '0';
  end if;

  if( (XTp(9)='1' AND XBm(7)='1') OR (XTp(9)='1' AND XBm(8)='1') )then
   T1_L1(56) <= '1';
  else
   T1_L1(56) <= '0';
  end if;

  if( (XTp(9)='1' AND XBm(9)='1') OR (XTp(9)='1' AND XBm(10)='1') )then
   T1_L1(57) <= '1';
  else
   T1_L1(57) <= '0';
  end if;

  if( (XTp(9)='1' AND XBm(11)='1') OR (XTp(10)='1' AND XBm(0)='1') )then
   T1_L1(58) <= '1';
  else
   T1_L1(58) <= '0';
  end if;

  if( (XTp(10)='1' AND XBm(1)='1') OR (XTp(10)='1' AND XBm(2)='1') )then
   T1_L1(59) <= '1';
  else
   T1_L1(59) <= '0';
  end if;

  if( (XTp(10)='1' AND XBm(3)='1') OR (XTp(10)='1' AND XBm(4)='1') )then
   T1_L1(60) <= '1';
  else
   T1_L1(60) <= '0';
  end if;

  if( (XTp(10)='1' AND XBm(5)='1') OR (XTp(10)='1' AND XBm(6)='1') )then
   T1_L1(61) <= '1';
  else
   T1_L1(61) <= '0';
  end if;

  if( (XTp(10)='1' AND XBm(7)='1') OR (XTp(10)='1' AND XBm(8)='1') )then
   T1_L1(62) <= '1';
  else
   T1_L1(62) <= '0';
  end if;

  if( (XTp(10)='1' AND XBm(9)='1') OR (XTp(10)='1' AND XBm(10)='1') )then
   T1_L1(63) <= '1';
  else
   T1_L1(63) <= '0';
  end if;

  if( (XTp(10)='1' AND XBm(11)='1') OR (XTp(11)='1' AND XBm(0)='1') )then
   T1_L1(64) <= '1';
  else
   T1_L1(64) <= '0';
  end if;

  if( (XTp(11)='1' AND XBm(1)='1') OR (XTp(11)='1' AND XBm(2)='1') )then
   T1_L1(65) <= '1';
  else
   T1_L1(65) <= '0';
  end if;

  if( (XTp(11)='1' AND XBm(3)='1') OR (XTp(11)='1' AND XBm(4)='1') )then
   T1_L1(66) <= '1';
  else
   T1_L1(66) <= '0';
  end if;

  if( (XTp(11)='1' AND XBm(5)='1') OR (XTp(11)='1' AND XBm(6)='1') )then
   T1_L1(67) <= '1';
  else
   T1_L1(67) <= '0';
  end if;

  if( (XTp(11)='1' AND XBm(7)='1') OR (XTp(11)='1' AND XBm(8)='1') )then
   T1_L1(68) <= '1';
  else
   T1_L1(68) <= '0';
  end if;

  if( (XTp(11)='1' AND XBm(9)='1') OR (XTp(11)='1' AND XBm(10)='1') )then
   T1_L1(69) <= '1';
  else
   T1_L1(69) <= '0';
  end if;

  if( (XTp(11)='1' AND XBm(11)='1') OR (XTm(0)='1' AND XBp(2)='1') )then
   T1_L1(70) <= '1';
  else
   T1_L1(70) <= '0';
  end if;

  if( (XTm(0)='1' AND XBp(3)='1') OR (XTm(0)='1' AND XBp(4)='1') )then
   T1_L1(71) <= '1';
  else
   T1_L1(71) <= '0';
  end if;

  if( (XTm(0)='1' AND XBp(5)='1') OR (XTm(0)='1' AND XBp(6)='1') )then
   T1_L1(72) <= '1';
  else
   T1_L1(72) <= '0';
  end if;

  if( (XTm(0)='1' AND XBp(7)='1') OR (XTm(0)='1' AND XBp(8)='1') )then
   T1_L1(73) <= '1';
  else
   T1_L1(73) <= '0';
  end if;

  if( (XTm(0)='1' AND XBp(9)='1') OR (XTm(0)='1' AND XBp(10)='1') )then
   T1_L1(74) <= '1';
  else
   T1_L1(74) <= '0';
  end if;

  if( (XTm(0)='1' AND XBp(11)='1') OR (XTm(1)='1' AND XBp(1)='1') )then
   T1_L1(75) <= '1';
  else
   T1_L1(75) <= '0';
  end if;

  if( (XTm(1)='1' AND XBp(2)='1') OR (XTm(1)='1' AND XBp(3)='1') )then
   T1_L1(76) <= '1';
  else
   T1_L1(76) <= '0';
  end if;

  if( (XTm(1)='1' AND XBp(4)='1') OR (XTm(1)='1' AND XBp(5)='1') )then
   T1_L1(77) <= '1';
  else
   T1_L1(77) <= '0';
  end if;

  if( (XTm(1)='1' AND XBp(6)='1') OR (XTm(1)='1' AND XBp(7)='1') )then
   T1_L1(78) <= '1';
  else
   T1_L1(78) <= '0';
  end if;

  if( (XTm(1)='1' AND XBp(8)='1') OR (XTm(1)='1' AND XBp(9)='1') )then
   T1_L1(79) <= '1';
  else
   T1_L1(79) <= '0';
  end if;

  if( (XTm(1)='1' AND XBp(10)='1') OR (XTm(1)='1' AND XBp(11)='1') )then
   T1_L1(80) <= '1';
  else
   T1_L1(80) <= '0';
  end if;

  if( (XTm(2)='1' AND XBp(0)='1') OR (XTm(2)='1' AND XBp(1)='1') )then
   T1_L1(81) <= '1';
  else
   T1_L1(81) <= '0';
  end if;

  if( (XTm(2)='1' AND XBp(2)='1') OR (XTm(2)='1' AND XBp(3)='1') )then
   T1_L1(82) <= '1';
  else
   T1_L1(82) <= '0';
  end if;

  if( (XTm(2)='1' AND XBp(4)='1') OR (XTm(2)='1' AND XBp(5)='1') )then
   T1_L1(83) <= '1';
  else
   T1_L1(83) <= '0';
  end if;

  if( (XTm(2)='1' AND XBp(6)='1') OR (XTm(2)='1' AND XBp(7)='1') )then
   T1_L1(84) <= '1';
  else
   T1_L1(84) <= '0';
  end if;

  if( (XTm(2)='1' AND XBp(8)='1') OR (XTm(2)='1' AND XBp(9)='1') )then
   T1_L1(85) <= '1';
  else
   T1_L1(85) <= '0';
  end if;

  if( (XTm(2)='1' AND XBp(10)='1') OR (XTm(2)='1' AND XBp(11)='1') )then
   T1_L1(86) <= '1';
  else
   T1_L1(86) <= '0';
  end if;

  if( (XTm(3)='1' AND XBp(0)='1') OR (XTm(3)='1' AND XBp(1)='1') )then
   T1_L1(87) <= '1';
  else
   T1_L1(87) <= '0';
  end if;

  if( (XTm(3)='1' AND XBp(2)='1') OR (XTm(3)='1' AND XBp(3)='1') )then
   T1_L1(88) <= '1';
  else
   T1_L1(88) <= '0';
  end if;

  if( (XTm(3)='1' AND XBp(4)='1') OR (XTm(3)='1' AND XBp(5)='1') )then
   T1_L1(89) <= '1';
  else
   T1_L1(89) <= '0';
  end if;

  if( (XTm(3)='1' AND XBp(6)='1') OR (XTm(3)='1' AND XBp(7)='1') )then
   T1_L1(90) <= '1';
  else
   T1_L1(90) <= '0';
  end if;

  if( (XTm(3)='1' AND XBp(8)='1') OR (XTm(3)='1' AND XBp(9)='1') )then
   T1_L1(91) <= '1';
  else
   T1_L1(91) <= '0';
  end if;

  if( (XTm(3)='1' AND XBp(10)='1') OR (XTm(3)='1' AND XBp(11)='1') )then
   T1_L1(92) <= '1';
  else
   T1_L1(92) <= '0';
  end if;

  if( (XTm(4)='1' AND XBp(0)='1') OR (XTm(4)='1' AND XBp(1)='1') )then
   T1_L1(93) <= '1';
  else
   T1_L1(93) <= '0';
  end if;

  if( (XTm(4)='1' AND XBp(2)='1') OR (XTm(4)='1' AND XBp(3)='1') )then
   T1_L1(94) <= '1';
  else
   T1_L1(94) <= '0';
  end if;

  if( (XTm(4)='1' AND XBp(4)='1') OR (XTm(4)='1' AND XBp(5)='1') )then
   T1_L1(95) <= '1';
  else
   T1_L1(95) <= '0';
  end if;

  if( (XTm(4)='1' AND XBp(6)='1') OR (XTm(4)='1' AND XBp(7)='1') )then
   T1_L1(96) <= '1';
  else
   T1_L1(96) <= '0';
  end if;

  if( (XTm(4)='1' AND XBp(8)='1') OR (XTm(4)='1' AND XBp(9)='1') )then
   T1_L1(97) <= '1';
  else
   T1_L1(97) <= '0';
  end if;

  if( (XTm(4)='1' AND XBp(10)='1') OR (XTm(4)='1' AND XBp(11)='1') )then
   T1_L1(98) <= '1';
  else
   T1_L1(98) <= '0';
  end if;

  if( (XTm(5)='1' AND XBp(0)='1') OR (XTm(5)='1' AND XBp(1)='1') )then
   T1_L1(99) <= '1';
  else
   T1_L1(99) <= '0';
  end if;

  if( (XTm(5)='1' AND XBp(2)='1') OR (XTm(5)='1' AND XBp(3)='1') )then
   T1_L1(100) <= '1';
  else
   T1_L1(100) <= '0';
  end if;

  if( (XTm(5)='1' AND XBp(4)='1') OR (XTm(5)='1' AND XBp(5)='1') )then
   T1_L1(101) <= '1';
  else
   T1_L1(101) <= '0';
  end if;

  if( (XTm(5)='1' AND XBp(6)='1') OR (XTm(5)='1' AND XBp(7)='1') )then
   T1_L1(102) <= '1';
  else
   T1_L1(102) <= '0';
  end if;

  if( (XTm(5)='1' AND XBp(8)='1') OR (XTm(5)='1' AND XBp(9)='1') )then
   T1_L1(103) <= '1';
  else
   T1_L1(103) <= '0';
  end if;

  if( (XTm(5)='1' AND XBp(10)='1') OR (XTm(5)='1' AND XBp(11)='1') )then
   T1_L1(104) <= '1';
  else
   T1_L1(104) <= '0';
  end if;

  if( (XTm(6)='1' AND XBp(0)='1') OR (XTm(6)='1' AND XBp(1)='1') )then
   T1_L1(105) <= '1';
  else
   T1_L1(105) <= '0';
  end if;

  if( (XTm(6)='1' AND XBp(2)='1') OR (XTm(6)='1' AND XBp(3)='1') )then
   T1_L1(106) <= '1';
  else
   T1_L1(106) <= '0';
  end if;

  if( (XTm(6)='1' AND XBp(4)='1') OR (XTm(6)='1' AND XBp(5)='1') )then
   T1_L1(107) <= '1';
  else
   T1_L1(107) <= '0';
  end if;

  if( (XTm(6)='1' AND XBp(6)='1') OR (XTm(6)='1' AND XBp(7)='1') )then
   T1_L1(108) <= '1';
  else
   T1_L1(108) <= '0';
  end if;

  if( (XTm(6)='1' AND XBp(8)='1') OR (XTm(6)='1' AND XBp(9)='1') )then
   T1_L1(109) <= '1';
  else
   T1_L1(109) <= '0';
  end if;

  if( (XTm(6)='1' AND XBp(10)='1') OR (XTm(6)='1' AND XBp(11)='1') )then
   T1_L1(110) <= '1';
  else
   T1_L1(110) <= '0';
  end if;

  if( (XTm(7)='1' AND XBp(0)='1') OR (XTm(7)='1' AND XBp(1)='1') )then
   T1_L1(111) <= '1';
  else
   T1_L1(111) <= '0';
  end if;

  if( (XTm(7)='1' AND XBp(2)='1') OR (XTm(7)='1' AND XBp(3)='1') )then
   T1_L1(112) <= '1';
  else
   T1_L1(112) <= '0';
  end if;

  if( (XTm(7)='1' AND XBp(4)='1') OR (XTm(7)='1' AND XBp(5)='1') )then
   T1_L1(113) <= '1';
  else
   T1_L1(113) <= '0';
  end if;

  if( (XTm(7)='1' AND XBp(6)='1') OR (XTm(7)='1' AND XBp(7)='1') )then
   T1_L1(114) <= '1';
  else
   T1_L1(114) <= '0';
  end if;

  if( (XTm(7)='1' AND XBp(8)='1') OR (XTm(7)='1' AND XBp(9)='1') )then
   T1_L1(115) <= '1';
  else
   T1_L1(115) <= '0';
  end if;

  if( (XTm(7)='1' AND XBp(10)='1') OR (XTm(7)='1' AND XBp(11)='1') )then
   T1_L1(116) <= '1';
  else
   T1_L1(116) <= '0';
  end if;

  if( (XTm(8)='1' AND XBp(0)='1') OR (XTm(8)='1' AND XBp(1)='1') )then
   T1_L1(117) <= '1';
  else
   T1_L1(117) <= '0';
  end if;

  if( (XTm(8)='1' AND XBp(2)='1') OR (XTm(8)='1' AND XBp(3)='1') )then
   T1_L1(118) <= '1';
  else
   T1_L1(118) <= '0';
  end if;

  if( (XTm(8)='1' AND XBp(4)='1') OR (XTm(8)='1' AND XBp(5)='1') )then
   T1_L1(119) <= '1';
  else
   T1_L1(119) <= '0';
  end if;

  if( (XTm(8)='1' AND XBp(6)='1') OR (XTm(8)='1' AND XBp(7)='1') )then
   T1_L1(120) <= '1';
  else
   T1_L1(120) <= '0';
  end if;

  if( (XTm(8)='1' AND XBp(8)='1') OR (XTm(8)='1' AND XBp(9)='1') )then
   T1_L1(121) <= '1';
  else
   T1_L1(121) <= '0';
  end if;

  if( (XTm(8)='1' AND XBp(10)='1') OR (XTm(8)='1' AND XBp(11)='1') )then
   T1_L1(122) <= '1';
  else
   T1_L1(122) <= '0';
  end if;

  if( (XTm(9)='1' AND XBp(0)='1') OR (XTm(9)='1' AND XBp(1)='1') )then
   T1_L1(123) <= '1';
  else
   T1_L1(123) <= '0';
  end if;

  if( (XTm(9)='1' AND XBp(2)='1') OR (XTm(9)='1' AND XBp(3)='1') )then
   T1_L1(124) <= '1';
  else
   T1_L1(124) <= '0';
  end if;

  if( (XTm(9)='1' AND XBp(4)='1') OR (XTm(9)='1' AND XBp(5)='1') )then
   T1_L1(125) <= '1';
  else
   T1_L1(125) <= '0';
  end if;

  if( (XTm(9)='1' AND XBp(6)='1') OR (XTm(9)='1' AND XBp(7)='1') )then
   T1_L1(126) <= '1';
  else
   T1_L1(126) <= '0';
  end if;

  if( (XTm(9)='1' AND XBp(8)='1') OR (XTm(9)='1' AND XBp(9)='1') )then
   T1_L1(127) <= '1';
  else
   T1_L1(127) <= '0';
  end if;

  if( (XTm(9)='1' AND XBp(10)='1') OR (XTm(9)='1' AND XBp(11)='1') )then
   T1_L1(128) <= '1';
  else
   T1_L1(128) <= '0';
  end if;

  if( (XTm(10)='1' AND XBp(0)='1') OR (XTm(10)='1' AND XBp(1)='1') )then
   T1_L1(129) <= '1';
  else
   T1_L1(129) <= '0';
  end if;

  if( (XTm(10)='1' AND XBp(2)='1') OR (XTm(10)='1' AND XBp(3)='1') )then
   T1_L1(130) <= '1';
  else
   T1_L1(130) <= '0';
  end if;

  if( (XTm(10)='1' AND XBp(4)='1') OR (XTm(10)='1' AND XBp(5)='1') )then
   T1_L1(131) <= '1';
  else
   T1_L1(131) <= '0';
  end if;

  if( (XTm(10)='1' AND XBp(6)='1') OR (XTm(10)='1' AND XBp(7)='1') )then
   T1_L1(132) <= '1';
  else
   T1_L1(132) <= '0';
  end if;

  if( (XTm(10)='1' AND XBp(8)='1') OR (XTm(10)='1' AND XBp(9)='1') )then
   T1_L1(133) <= '1';
  else
   T1_L1(133) <= '0';
  end if;

  if( (XTm(10)='1' AND XBp(10)='1') OR (XTm(10)='1' AND XBp(11)='1') )then
   T1_L1(134) <= '1';
  else
   T1_L1(134) <= '0';
  end if;

  if( (XTm(11)='1' AND XBp(0)='1') OR (XTm(11)='1' AND XBp(1)='1') )then
   T1_L1(135) <= '1';
  else
   T1_L1(135) <= '0';
  end if;

  if( (XTm(11)='1' AND XBp(2)='1') OR (XTm(11)='1' AND XBp(3)='1') )then
   T1_L1(136) <= '1';
  else
   T1_L1(136) <= '0';
  end if;

  if( (XTm(11)='1' AND XBp(4)='1') OR (XTm(11)='1' AND XBp(5)='1') )then
   T1_L1(137) <= '1';
  else
   T1_L1(137) <= '0';
  end if;

  if( (XTm(11)='1' AND XBp(6)='1') OR (XTm(11)='1' AND XBp(7)='1') )then
   T1_L1(138) <= '1';
  else
   T1_L1(138) <= '0';
  end if;

  if( (XTm(11)='1' AND XBp(8)='1') OR (XTm(11)='1' AND XBp(9)='1') )then
   T1_L1(139) <= '1';
  else
   T1_L1(139) <= '0';
  end if;

  if( (XTm(11)='1' AND XBp(10)='1') OR (XTm(11)='1' AND XBp(11)='1') )then
   T1_L1(140) <= '1';
  else
   T1_L1(140) <= '0';
  end if;

-------------------------END Trigger 1 Level 1--------------------------------

-------------------------BEGIN Trigger 2 Level 1--------------------------------
  if( (XTp(0)='1' AND XTm(2)='1') OR (XTp(0)='1' AND XTm(3)='1') )then
   T2_L1(0) <= '1';
  else
   T2_L1(0) <= '0';
  end if;

  if( (XTp(0)='1' AND XTm(4)='1') OR (XTp(0)='1' AND XTm(5)='1') )then
   T2_L1(1) <= '1';
  else
   T2_L1(1) <= '0';
  end if;

  if( (XTp(0)='1' AND XTm(6)='1') OR (XTp(0)='1' AND XTm(7)='1') )then
   T2_L1(2) <= '1';
  else
   T2_L1(2) <= '0';
  end if;

  if( (XTp(0)='1' AND XTm(8)='1') OR (XTp(0)='1' AND XTm(9)='1') )then
   T2_L1(3) <= '1';
  else
   T2_L1(3) <= '0';
  end if;

  if( (XTp(0)='1' AND XTm(10)='1') OR (XTp(0)='1' AND XTm(11)='1') )then
   T2_L1(4) <= '1';
  else
   T2_L1(4) <= '0';
  end if;

  if( (XTp(1)='1' AND XTm(1)='1') OR (XTp(1)='1' AND XTm(2)='1') )then
   T2_L1(5) <= '1';
  else
   T2_L1(5) <= '0';
  end if;

  if( (XTp(1)='1' AND XTm(3)='1') OR (XTp(1)='1' AND XTm(4)='1') )then
   T2_L1(6) <= '1';
  else
   T2_L1(6) <= '0';
  end if;

  if( (XTp(1)='1' AND XTm(5)='1') OR (XTp(1)='1' AND XTm(6)='1') )then
   T2_L1(7) <= '1';
  else
   T2_L1(7) <= '0';
  end if;

  if( (XTp(1)='1' AND XTm(7)='1') OR (XTp(1)='1' AND XTm(8)='1') )then
   T2_L1(8) <= '1';
  else
   T2_L1(8) <= '0';
  end if;

  if( (XTp(1)='1' AND XTm(9)='1') OR (XTp(1)='1' AND XTm(10)='1') )then
   T2_L1(9) <= '1';
  else
   T2_L1(9) <= '0';
  end if;

  if( (XTp(1)='1' AND XTm(11)='1') OR (XTp(2)='1' AND XTm(0)='1') )then
   T2_L1(10) <= '1';
  else
   T2_L1(10) <= '0';
  end if;

  if( (XTp(2)='1' AND XTm(1)='1') OR (XTp(2)='1' AND XTm(2)='1') )then
   T2_L1(11) <= '1';
  else
   T2_L1(11) <= '0';
  end if;

  if( (XTp(2)='1' AND XTm(3)='1') OR (XTp(2)='1' AND XTm(4)='1') )then
   T2_L1(12) <= '1';
  else
   T2_L1(12) <= '0';
  end if;

  if( (XTp(2)='1' AND XTm(5)='1') OR (XTp(2)='1' AND XTm(6)='1') )then
   T2_L1(13) <= '1';
  else
   T2_L1(13) <= '0';
  end if;

  if( (XTp(2)='1' AND XTm(7)='1') OR (XTp(2)='1' AND XTm(8)='1') )then
   T2_L1(14) <= '1';
  else
   T2_L1(14) <= '0';
  end if;

  if( (XTp(2)='1' AND XTm(9)='1') OR (XTp(2)='1' AND XTm(10)='1') )then
   T2_L1(15) <= '1';
  else
   T2_L1(15) <= '0';
  end if;

  if( (XTp(2)='1' AND XTm(11)='1') OR (XTp(3)='1' AND XTm(0)='1') )then
   T2_L1(16) <= '1';
  else
   T2_L1(16) <= '0';
  end if;

  if( (XTp(3)='1' AND XTm(1)='1') OR (XTp(3)='1' AND XTm(2)='1') )then
   T2_L1(17) <= '1';
  else
   T2_L1(17) <= '0';
  end if;

  if( (XTp(3)='1' AND XTm(3)='1') OR (XTp(3)='1' AND XTm(4)='1') )then
   T2_L1(18) <= '1';
  else
   T2_L1(18) <= '0';
  end if;

  if( (XTp(3)='1' AND XTm(5)='1') OR (XTp(3)='1' AND XTm(6)='1') )then
   T2_L1(19) <= '1';
  else
   T2_L1(19) <= '0';
  end if;

  if( (XTp(3)='1' AND XTm(7)='1') OR (XTp(3)='1' AND XTm(8)='1') )then
   T2_L1(20) <= '1';
  else
   T2_L1(20) <= '0';
  end if;

  if( (XTp(3)='1' AND XTm(9)='1') OR (XTp(3)='1' AND XTm(10)='1') )then
   T2_L1(21) <= '1';
  else
   T2_L1(21) <= '0';
  end if;

  if( (XTp(3)='1' AND XTm(11)='1') OR (XTp(4)='1' AND XTm(0)='1') )then
   T2_L1(22) <= '1';
  else
   T2_L1(22) <= '0';
  end if;

  if( (XTp(4)='1' AND XTm(1)='1') OR (XTp(4)='1' AND XTm(2)='1') )then
   T2_L1(23) <= '1';
  else
   T2_L1(23) <= '0';
  end if;

  if( (XTp(4)='1' AND XTm(3)='1') OR (XTp(4)='1' AND XTm(4)='1') )then
   T2_L1(24) <= '1';
  else
   T2_L1(24) <= '0';
  end if;

  if( (XTp(4)='1' AND XTm(5)='1') OR (XTp(4)='1' AND XTm(6)='1') )then
   T2_L1(25) <= '1';
  else
   T2_L1(25) <= '0';
  end if;

  if( (XTp(4)='1' AND XTm(7)='1') OR (XTp(4)='1' AND XTm(8)='1') )then
   T2_L1(26) <= '1';
  else
   T2_L1(26) <= '0';
  end if;

  if( (XTp(4)='1' AND XTm(9)='1') OR (XTp(4)='1' AND XTm(10)='1') )then
   T2_L1(27) <= '1';
  else
   T2_L1(27) <= '0';
  end if;

  if( (XTp(4)='1' AND XTm(11)='1') OR (XTp(5)='1' AND XTm(0)='1') )then
   T2_L1(28) <= '1';
  else
   T2_L1(28) <= '0';
  end if;

  if( (XTp(5)='1' AND XTm(1)='1') OR (XTp(5)='1' AND XTm(2)='1') )then
   T2_L1(29) <= '1';
  else
   T2_L1(29) <= '0';
  end if;

  if( (XTp(5)='1' AND XTm(3)='1') OR (XTp(5)='1' AND XTm(4)='1') )then
   T2_L1(30) <= '1';
  else
   T2_L1(30) <= '0';
  end if;

  if( (XTp(5)='1' AND XTm(5)='1') OR (XTp(5)='1' AND XTm(6)='1') )then
   T2_L1(31) <= '1';
  else
   T2_L1(31) <= '0';
  end if;

  if( (XTp(5)='1' AND XTm(7)='1') OR (XTp(5)='1' AND XTm(8)='1') )then
   T2_L1(32) <= '1';
  else
   T2_L1(32) <= '0';
  end if;

  if( (XTp(5)='1' AND XTm(9)='1') OR (XTp(5)='1' AND XTm(10)='1') )then
   T2_L1(33) <= '1';
  else
   T2_L1(33) <= '0';
  end if;

  if( (XTp(5)='1' AND XTm(11)='1') OR (XTp(6)='1' AND XTm(0)='1') )then
   T2_L1(34) <= '1';
  else
   T2_L1(34) <= '0';
  end if;

  if( (XTp(6)='1' AND XTm(1)='1') OR (XTp(6)='1' AND XTm(2)='1') )then
   T2_L1(35) <= '1';
  else
   T2_L1(35) <= '0';
  end if;

  if( (XTp(6)='1' AND XTm(3)='1') OR (XTp(6)='1' AND XTm(4)='1') )then
   T2_L1(36) <= '1';
  else
   T2_L1(36) <= '0';
  end if;

  if( (XTp(6)='1' AND XTm(5)='1') OR (XTp(6)='1' AND XTm(6)='1') )then
   T2_L1(37) <= '1';
  else
   T2_L1(37) <= '0';
  end if;

  if( (XTp(6)='1' AND XTm(7)='1') OR (XTp(6)='1' AND XTm(8)='1') )then
   T2_L1(38) <= '1';
  else
   T2_L1(38) <= '0';
  end if;

  if( (XTp(6)='1' AND XTm(9)='1') OR (XTp(6)='1' AND XTm(10)='1') )then
   T2_L1(39) <= '1';
  else
   T2_L1(39) <= '0';
  end if;

  if( (XTp(6)='1' AND XTm(11)='1') OR (XTp(7)='1' AND XTm(0)='1') )then
   T2_L1(40) <= '1';
  else
   T2_L1(40) <= '0';
  end if;

  if( (XTp(7)='1' AND XTm(1)='1') OR (XTp(7)='1' AND XTm(2)='1') )then
   T2_L1(41) <= '1';
  else
   T2_L1(41) <= '0';
  end if;

  if( (XTp(7)='1' AND XTm(3)='1') OR (XTp(7)='1' AND XTm(4)='1') )then
   T2_L1(42) <= '1';
  else
   T2_L1(42) <= '0';
  end if;

  if( (XTp(7)='1' AND XTm(5)='1') OR (XTp(7)='1' AND XTm(6)='1') )then
   T2_L1(43) <= '1';
  else
   T2_L1(43) <= '0';
  end if;

  if( (XTp(7)='1' AND XTm(7)='1') OR (XTp(7)='1' AND XTm(8)='1') )then
   T2_L1(44) <= '1';
  else
   T2_L1(44) <= '0';
  end if;

  if( (XTp(7)='1' AND XTm(9)='1') OR (XTp(7)='1' AND XTm(10)='1') )then
   T2_L1(45) <= '1';
  else
   T2_L1(45) <= '0';
  end if;

  if( (XTp(7)='1' AND XTm(11)='1') OR (XTp(8)='1' AND XTm(0)='1') )then
   T2_L1(46) <= '1';
  else
   T2_L1(46) <= '0';
  end if;

  if( (XTp(8)='1' AND XTm(1)='1') OR (XTp(8)='1' AND XTm(2)='1') )then
   T2_L1(47) <= '1';
  else
   T2_L1(47) <= '0';
  end if;

  if( (XTp(8)='1' AND XTm(3)='1') OR (XTp(8)='1' AND XTm(4)='1') )then
   T2_L1(48) <= '1';
  else
   T2_L1(48) <= '0';
  end if;

  if( (XTp(8)='1' AND XTm(5)='1') OR (XTp(8)='1' AND XTm(6)='1') )then
   T2_L1(49) <= '1';
  else
   T2_L1(49) <= '0';
  end if;

  if( (XTp(8)='1' AND XTm(7)='1') OR (XTp(8)='1' AND XTm(8)='1') )then
   T2_L1(50) <= '1';
  else
   T2_L1(50) <= '0';
  end if;

  if( (XTp(8)='1' AND XTm(9)='1') OR (XTp(8)='1' AND XTm(10)='1') )then
   T2_L1(51) <= '1';
  else
   T2_L1(51) <= '0';
  end if;

  if( (XTp(8)='1' AND XTm(11)='1') OR (XTp(9)='1' AND XTm(0)='1') )then
   T2_L1(52) <= '1';
  else
   T2_L1(52) <= '0';
  end if;

  if( (XTp(9)='1' AND XTm(1)='1') OR (XTp(9)='1' AND XTm(2)='1') )then
   T2_L1(53) <= '1';
  else
   T2_L1(53) <= '0';
  end if;

  if( (XTp(9)='1' AND XTm(3)='1') OR (XTp(9)='1' AND XTm(4)='1') )then
   T2_L1(54) <= '1';
  else
   T2_L1(54) <= '0';
  end if;

  if( (XTp(9)='1' AND XTm(5)='1') OR (XTp(9)='1' AND XTm(6)='1') )then
   T2_L1(55) <= '1';
  else
   T2_L1(55) <= '0';
  end if;

  if( (XTp(9)='1' AND XTm(7)='1') OR (XTp(9)='1' AND XTm(8)='1') )then
   T2_L1(56) <= '1';
  else
   T2_L1(56) <= '0';
  end if;

  if( (XTp(9)='1' AND XTm(9)='1') OR (XTp(9)='1' AND XTm(10)='1') )then
   T2_L1(57) <= '1';
  else
   T2_L1(57) <= '0';
  end if;

  if( (XTp(9)='1' AND XTm(11)='1') OR (XTp(10)='1' AND XTm(0)='1') )then
   T2_L1(58) <= '1';
  else
   T2_L1(58) <= '0';
  end if;

  if( (XTp(10)='1' AND XTm(1)='1') OR (XTp(10)='1' AND XTm(2)='1') )then
   T2_L1(59) <= '1';
  else
   T2_L1(59) <= '0';
  end if;

  if( (XTp(10)='1' AND XTm(3)='1') OR (XTp(10)='1' AND XTm(4)='1') )then
   T2_L1(60) <= '1';
  else
   T2_L1(60) <= '0';
  end if;

  if( (XTp(10)='1' AND XTm(5)='1') OR (XTp(10)='1' AND XTm(6)='1') )then
   T2_L1(61) <= '1';
  else
   T2_L1(61) <= '0';
  end if;

  if( (XTp(10)='1' AND XTm(7)='1') OR (XTp(10)='1' AND XTm(8)='1') )then
   T2_L1(62) <= '1';
  else
   T2_L1(62) <= '0';
  end if;

  if( (XTp(10)='1' AND XTm(9)='1') OR (XTp(10)='1' AND XTm(10)='1') )then
   T2_L1(63) <= '1';
  else
   T2_L1(63) <= '0';
  end if;

  if( (XTp(10)='1' AND XTm(11)='1') OR (XTp(11)='1' AND XTm(0)='1') )then
   T2_L1(64) <= '1';
  else
   T2_L1(64) <= '0';
  end if;

  if( (XTp(11)='1' AND XTm(1)='1') OR (XTp(11)='1' AND XTm(2)='1') )then
   T2_L1(65) <= '1';
  else
   T2_L1(65) <= '0';
  end if;

  if( (XTp(11)='1' AND XTm(3)='1') OR (XTp(11)='1' AND XTm(4)='1') )then
   T2_L1(66) <= '1';
  else
   T2_L1(66) <= '0';
  end if;

  if( (XTp(11)='1' AND XTm(5)='1') OR (XTp(11)='1' AND XTm(6)='1') )then
   T2_L1(67) <= '1';
  else
   T2_L1(67) <= '0';
  end if;

  if( (XTp(11)='1' AND XTm(7)='1') OR (XTp(11)='1' AND XTm(8)='1') )then
   T2_L1(68) <= '1';
  else
   T2_L1(68) <= '0';
  end if;

  if( (XTp(11)='1' AND XTm(9)='1') OR (XTp(11)='1' AND XTm(10)='1') )then
   T2_L1(69) <= '1';
  else
   T2_L1(69) <= '0';
  end if;

  if( (XTp(11)='1' AND XTm(11)='1') OR (XBp(0)='1' AND XBm(2)='1') )then
   T2_L1(70) <= '1';
  else
   T2_L1(70) <= '0';
  end if;

  if( (XBp(0)='1' AND XBm(3)='1') OR (XBp(0)='1' AND XBm(4)='1') )then
   T2_L1(71) <= '1';
  else
   T2_L1(71) <= '0';
  end if;

  if( (XBp(0)='1' AND XBm(5)='1') OR (XBp(0)='1' AND XBm(6)='1') )then
   T2_L1(72) <= '1';
  else
   T2_L1(72) <= '0';
  end if;

  if( (XBp(0)='1' AND XBm(7)='1') OR (XBp(0)='1' AND XBm(8)='1') )then
   T2_L1(73) <= '1';
  else
   T2_L1(73) <= '0';
  end if;

  if( (XBp(0)='1' AND XBm(9)='1') OR (XBp(0)='1' AND XBm(10)='1') )then
   T2_L1(74) <= '1';
  else
   T2_L1(74) <= '0';
  end if;

  if( (XBp(0)='1' AND XBm(11)='1') OR (XBp(1)='1' AND XBm(1)='1') )then
   T2_L1(75) <= '1';
  else
   T2_L1(75) <= '0';
  end if;

  if( (XBp(1)='1' AND XBm(2)='1') OR (XBp(1)='1' AND XBm(3)='1') )then
   T2_L1(76) <= '1';
  else
   T2_L1(76) <= '0';
  end if;

  if( (XBp(1)='1' AND XBm(4)='1') OR (XBp(1)='1' AND XBm(5)='1') )then
   T2_L1(77) <= '1';
  else
   T2_L1(77) <= '0';
  end if;

  if( (XBp(1)='1' AND XBm(6)='1') OR (XBp(1)='1' AND XBm(7)='1') )then
   T2_L1(78) <= '1';
  else
   T2_L1(78) <= '0';
  end if;

  if( (XBp(1)='1' AND XBm(8)='1') OR (XBp(1)='1' AND XBm(9)='1') )then
   T2_L1(79) <= '1';
  else
   T2_L1(79) <= '0';
  end if;

  if( (XBp(1)='1' AND XBm(10)='1') OR (XBp(1)='1' AND XBm(11)='1') )then
   T2_L1(80) <= '1';
  else
   T2_L1(80) <= '0';
  end if;

  if( (XBp(2)='1' AND XBm(0)='1') OR (XBp(2)='1' AND XBm(1)='1') )then
   T2_L1(81) <= '1';
  else
   T2_L1(81) <= '0';
  end if;

  if( (XBp(2)='1' AND XBm(2)='1') OR (XBp(2)='1' AND XBm(3)='1') )then
   T2_L1(82) <= '1';
  else
   T2_L1(82) <= '0';
  end if;

  if( (XBp(2)='1' AND XBm(4)='1') OR (XBp(2)='1' AND XBm(5)='1') )then
   T2_L1(83) <= '1';
  else
   T2_L1(83) <= '0';
  end if;

  if( (XBp(2)='1' AND XBm(6)='1') OR (XBp(2)='1' AND XBm(7)='1') )then
   T2_L1(84) <= '1';
  else
   T2_L1(84) <= '0';
  end if;

  if( (XBp(2)='1' AND XBm(8)='1') OR (XBp(2)='1' AND XBm(9)='1') )then
   T2_L1(85) <= '1';
  else
   T2_L1(85) <= '0';
  end if;

  if( (XBp(2)='1' AND XBm(10)='1') OR (XBp(2)='1' AND XBm(11)='1') )then
   T2_L1(86) <= '1';
  else
   T2_L1(86) <= '0';
  end if;

  if( (XBp(3)='1' AND XBm(0)='1') OR (XBp(3)='1' AND XBm(1)='1') )then
   T2_L1(87) <= '1';
  else
   T2_L1(87) <= '0';
  end if;

  if( (XBp(3)='1' AND XBm(2)='1') OR (XBp(3)='1' AND XBm(3)='1') )then
   T2_L1(88) <= '1';
  else
   T2_L1(88) <= '0';
  end if;

  if( (XBp(3)='1' AND XBm(4)='1') OR (XBp(3)='1' AND XBm(5)='1') )then
   T2_L1(89) <= '1';
  else
   T2_L1(89) <= '0';
  end if;

  if( (XBp(3)='1' AND XBm(6)='1') OR (XBp(3)='1' AND XBm(7)='1') )then
   T2_L1(90) <= '1';
  else
   T2_L1(90) <= '0';
  end if;

  if( (XBp(3)='1' AND XBm(8)='1') OR (XBp(3)='1' AND XBm(9)='1') )then
   T2_L1(91) <= '1';
  else
   T2_L1(91) <= '0';
  end if;

  if( (XBp(3)='1' AND XBm(10)='1') OR (XBp(3)='1' AND XBm(11)='1') )then
   T2_L1(92) <= '1';
  else
   T2_L1(92) <= '0';
  end if;

  if( (XBp(4)='1' AND XBm(0)='1') OR (XBp(4)='1' AND XBm(1)='1') )then
   T2_L1(93) <= '1';
  else
   T2_L1(93) <= '0';
  end if;

  if( (XBp(4)='1' AND XBm(2)='1') OR (XBp(4)='1' AND XBm(3)='1') )then
   T2_L1(94) <= '1';
  else
   T2_L1(94) <= '0';
  end if;

  if( (XBp(4)='1' AND XBm(4)='1') OR (XBp(4)='1' AND XBm(5)='1') )then
   T2_L1(95) <= '1';
  else
   T2_L1(95) <= '0';
  end if;

  if( (XBp(4)='1' AND XBm(6)='1') OR (XBp(4)='1' AND XBm(7)='1') )then
   T2_L1(96) <= '1';
  else
   T2_L1(96) <= '0';
  end if;

  if( (XBp(4)='1' AND XBm(8)='1') OR (XBp(4)='1' AND XBm(9)='1') )then
   T2_L1(97) <= '1';
  else
   T2_L1(97) <= '0';
  end if;

  if( (XBp(4)='1' AND XBm(10)='1') OR (XBp(4)='1' AND XBm(11)='1') )then
   T2_L1(98) <= '1';
  else
   T2_L1(98) <= '0';
  end if;

  if( (XBp(5)='1' AND XBm(0)='1') OR (XBp(5)='1' AND XBm(1)='1') )then
   T2_L1(99) <= '1';
  else
   T2_L1(99) <= '0';
  end if;

  if( (XBp(5)='1' AND XBm(2)='1') OR (XBp(5)='1' AND XBm(3)='1') )then
   T2_L1(100) <= '1';
  else
   T2_L1(100) <= '0';
  end if;

  if( (XBp(5)='1' AND XBm(4)='1') OR (XBp(5)='1' AND XBm(5)='1') )then
   T2_L1(101) <= '1';
  else
   T2_L1(101) <= '0';
  end if;

  if( (XBp(5)='1' AND XBm(6)='1') OR (XBp(5)='1' AND XBm(7)='1') )then
   T2_L1(102) <= '1';
  else
   T2_L1(102) <= '0';
  end if;

  if( (XBp(5)='1' AND XBm(8)='1') OR (XBp(5)='1' AND XBm(9)='1') )then
   T2_L1(103) <= '1';
  else
   T2_L1(103) <= '0';
  end if;

  if( (XBp(5)='1' AND XBm(10)='1') OR (XBp(5)='1' AND XBm(11)='1') )then
   T2_L1(104) <= '1';
  else
   T2_L1(104) <= '0';
  end if;

  if( (XBp(6)='1' AND XBm(0)='1') OR (XBp(6)='1' AND XBm(1)='1') )then
   T2_L1(105) <= '1';
  else
   T2_L1(105) <= '0';
  end if;

  if( (XBp(6)='1' AND XBm(2)='1') OR (XBp(6)='1' AND XBm(3)='1') )then
   T2_L1(106) <= '1';
  else
   T2_L1(106) <= '0';
  end if;

  if( (XBp(6)='1' AND XBm(4)='1') OR (XBp(6)='1' AND XBm(5)='1') )then
   T2_L1(107) <= '1';
  else
   T2_L1(107) <= '0';
  end if;

  if( (XBp(6)='1' AND XBm(6)='1') OR (XBp(6)='1' AND XBm(7)='1') )then
   T2_L1(108) <= '1';
  else
   T2_L1(108) <= '0';
  end if;

  if( (XBp(6)='1' AND XBm(8)='1') OR (XBp(6)='1' AND XBm(9)='1') )then
   T2_L1(109) <= '1';
  else
   T2_L1(109) <= '0';
  end if;

  if( (XBp(6)='1' AND XBm(10)='1') OR (XBp(6)='1' AND XBm(11)='1') )then
   T2_L1(110) <= '1';
  else
   T2_L1(110) <= '0';
  end if;

  if( (XBp(7)='1' AND XBm(0)='1') OR (XBp(7)='1' AND XBm(1)='1') )then
   T2_L1(111) <= '1';
  else
   T2_L1(111) <= '0';
  end if;

  if( (XBp(7)='1' AND XBm(2)='1') OR (XBp(7)='1' AND XBm(3)='1') )then
   T2_L1(112) <= '1';
  else
   T2_L1(112) <= '0';
  end if;

  if( (XBp(7)='1' AND XBm(4)='1') OR (XBp(7)='1' AND XBm(5)='1') )then
   T2_L1(113) <= '1';
  else
   T2_L1(113) <= '0';
  end if;

  if( (XBp(7)='1' AND XBm(6)='1') OR (XBp(7)='1' AND XBm(7)='1') )then
   T2_L1(114) <= '1';
  else
   T2_L1(114) <= '0';
  end if;

  if( (XBp(7)='1' AND XBm(8)='1') OR (XBp(7)='1' AND XBm(9)='1') )then
   T2_L1(115) <= '1';
  else
   T2_L1(115) <= '0';
  end if;

  if( (XBp(7)='1' AND XBm(10)='1') OR (XBp(7)='1' AND XBm(11)='1') )then
   T2_L1(116) <= '1';
  else
   T2_L1(116) <= '0';
  end if;

  if( (XBp(8)='1' AND XBm(0)='1') OR (XBp(8)='1' AND XBm(1)='1') )then
   T2_L1(117) <= '1';
  else
   T2_L1(117) <= '0';
  end if;

  if( (XBp(8)='1' AND XBm(2)='1') OR (XBp(8)='1' AND XBm(3)='1') )then
   T2_L1(118) <= '1';
  else
   T2_L1(118) <= '0';
  end if;

  if( (XBp(8)='1' AND XBm(4)='1') OR (XBp(8)='1' AND XBm(5)='1') )then
   T2_L1(119) <= '1';
  else
   T2_L1(119) <= '0';
  end if;

  if( (XBp(8)='1' AND XBm(6)='1') OR (XBp(8)='1' AND XBm(7)='1') )then
   T2_L1(120) <= '1';
  else
   T2_L1(120) <= '0';
  end if;

  if( (XBp(8)='1' AND XBm(8)='1') OR (XBp(8)='1' AND XBm(9)='1') )then
   T2_L1(121) <= '1';
  else
   T2_L1(121) <= '0';
  end if;

  if( (XBp(8)='1' AND XBm(10)='1') OR (XBp(8)='1' AND XBm(11)='1') )then
   T2_L1(122) <= '1';
  else
   T2_L1(122) <= '0';
  end if;

  if( (XBp(9)='1' AND XBm(0)='1') OR (XBp(9)='1' AND XBm(1)='1') )then
   T2_L1(123) <= '1';
  else
   T2_L1(123) <= '0';
  end if;

  if( (XBp(9)='1' AND XBm(2)='1') OR (XBp(9)='1' AND XBm(3)='1') )then
   T2_L1(124) <= '1';
  else
   T2_L1(124) <= '0';
  end if;

  if( (XBp(9)='1' AND XBm(4)='1') OR (XBp(9)='1' AND XBm(5)='1') )then
   T2_L1(125) <= '1';
  else
   T2_L1(125) <= '0';
  end if;

  if( (XBp(9)='1' AND XBm(6)='1') OR (XBp(9)='1' AND XBm(7)='1') )then
   T2_L1(126) <= '1';
  else
   T2_L1(126) <= '0';
  end if;

  if( (XBp(9)='1' AND XBm(8)='1') OR (XBp(9)='1' AND XBm(9)='1') )then
   T2_L1(127) <= '1';
  else
   T2_L1(127) <= '0';
  end if;

  if( (XBp(9)='1' AND XBm(10)='1') OR (XBp(9)='1' AND XBm(11)='1') )then
   T2_L1(128) <= '1';
  else
   T2_L1(128) <= '0';
  end if;

  if( (XBp(10)='1' AND XBm(0)='1') OR (XBp(10)='1' AND XBm(1)='1') )then
   T2_L1(129) <= '1';
  else
   T2_L1(129) <= '0';
  end if;

  if( (XBp(10)='1' AND XBm(2)='1') OR (XBp(10)='1' AND XBm(3)='1') )then
   T2_L1(130) <= '1';
  else
   T2_L1(130) <= '0';
  end if;

  if( (XBp(10)='1' AND XBm(4)='1') OR (XBp(10)='1' AND XBm(5)='1') )then
   T2_L1(131) <= '1';
  else
   T2_L1(131) <= '0';
  end if;

  if( (XBp(10)='1' AND XBm(6)='1') OR (XBp(10)='1' AND XBm(7)='1') )then
   T2_L1(132) <= '1';
  else
   T2_L1(132) <= '0';
  end if;

  if( (XBp(10)='1' AND XBm(8)='1') OR (XBp(10)='1' AND XBm(9)='1') )then
   T2_L1(133) <= '1';
  else
   T2_L1(133) <= '0';
  end if;

  if( (XBp(10)='1' AND XBm(10)='1') OR (XBp(10)='1' AND XBm(11)='1') )then
   T2_L1(134) <= '1';
  else
   T2_L1(134) <= '0';
  end if;

  if( (XBp(11)='1' AND XBm(0)='1') OR (XBp(11)='1' AND XBm(1)='1') )then
   T2_L1(135) <= '1';
  else
   T2_L1(135) <= '0';
  end if;

  if( (XBp(11)='1' AND XBm(2)='1') OR (XBp(11)='1' AND XBm(3)='1') )then
   T2_L1(136) <= '1';
  else
   T2_L1(136) <= '0';
  end if;

  if( (XBp(11)='1' AND XBm(4)='1') OR (XBp(11)='1' AND XBm(5)='1') )then
   T2_L1(137) <= '1';
  else
   T2_L1(137) <= '0';
  end if;

  if( (XBp(11)='1' AND XBm(6)='1') OR (XBp(11)='1' AND XBm(7)='1') )then
   T2_L1(138) <= '1';
  else
   T2_L1(138) <= '0';
  end if;

  if( (XBp(11)='1' AND XBm(8)='1') OR (XBp(11)='1' AND XBm(9)='1') )then
   T2_L1(139) <= '1';
  else
   T2_L1(139) <= '0';
  end if;

  if( (XBp(11)='1' AND XBm(10)='1') OR (XBp(11)='1' AND XBm(11)='1') )then
   T2_L1(140) <= '1';
  else
   T2_L1(140) <= '0';
  end if;

-------------------------END Trigger 2 Level 1--------------------------------

-------------------------BEGIN Trigger 3 Level 1--------------------------------
  if( (XTp(0)='1' AND XBp(2)='1') OR (XTp(0)='1' AND XBp(3)='1') )then
   T3_L1(0) <= '1';
  else
   T3_L1(0) <= '0';
  end if;

  if( (XTp(0)='1' AND XBp(4)='1') OR (XTp(0)='1' AND XBp(5)='1') )then
   T3_L1(1) <= '1';
  else
   T3_L1(1) <= '0';
  end if;

  if( (XTp(0)='1' AND XBp(6)='1') OR (XTp(0)='1' AND XBp(7)='1') )then
   T3_L1(2) <= '1';
  else
   T3_L1(2) <= '0';
  end if;

  if( (XTp(0)='1' AND XBp(8)='1') OR (XTp(0)='1' AND XBp(9)='1') )then
   T3_L1(3) <= '1';
  else
   T3_L1(3) <= '0';
  end if;

  if( (XTp(0)='1' AND XBp(10)='1') OR (XTp(0)='1' AND XBp(11)='1') )then
   T3_L1(4) <= '1';
  else
   T3_L1(4) <= '0';
  end if;

  if( (XTp(1)='1' AND XBp(1)='1') OR (XTp(1)='1' AND XBp(2)='1') )then
   T3_L1(5) <= '1';
  else
   T3_L1(5) <= '0';
  end if;

  if( (XTp(1)='1' AND XBp(3)='1') OR (XTp(1)='1' AND XBp(4)='1') )then
   T3_L1(6) <= '1';
  else
   T3_L1(6) <= '0';
  end if;

  if( (XTp(1)='1' AND XBp(5)='1') OR (XTp(1)='1' AND XBp(6)='1') )then
   T3_L1(7) <= '1';
  else
   T3_L1(7) <= '0';
  end if;

  if( (XTp(1)='1' AND XBp(7)='1') OR (XTp(1)='1' AND XBp(8)='1') )then
   T3_L1(8) <= '1';
  else
   T3_L1(8) <= '0';
  end if;

  if( (XTp(1)='1' AND XBp(9)='1') OR (XTp(1)='1' AND XBp(10)='1') )then
   T3_L1(9) <= '1';
  else
   T3_L1(9) <= '0';
  end if;

  if( (XTp(1)='1' AND XBp(11)='1') OR (XTp(2)='1' AND XBp(0)='1') )then
   T3_L1(10) <= '1';
  else
   T3_L1(10) <= '0';
  end if;

  if( (XTp(2)='1' AND XBp(1)='1') OR (XTp(2)='1' AND XBp(2)='1') )then
   T3_L1(11) <= '1';
  else
   T3_L1(11) <= '0';
  end if;

  if( (XTp(2)='1' AND XBp(3)='1') OR (XTp(2)='1' AND XBp(4)='1') )then
   T3_L1(12) <= '1';
  else
   T3_L1(12) <= '0';
  end if;

  if( (XTp(2)='1' AND XBp(5)='1') OR (XTp(2)='1' AND XBp(6)='1') )then
   T3_L1(13) <= '1';
  else
   T3_L1(13) <= '0';
  end if;

  if( (XTp(2)='1' AND XBp(7)='1') OR (XTp(2)='1' AND XBp(8)='1') )then
   T3_L1(14) <= '1';
  else
   T3_L1(14) <= '0';
  end if;

  if( (XTp(2)='1' AND XBp(9)='1') OR (XTp(2)='1' AND XBp(10)='1') )then
   T3_L1(15) <= '1';
  else
   T3_L1(15) <= '0';
  end if;

  if( (XTp(2)='1' AND XBp(11)='1') OR (XTp(3)='1' AND XBp(0)='1') )then
   T3_L1(16) <= '1';
  else
   T3_L1(16) <= '0';
  end if;

  if( (XTp(3)='1' AND XBp(1)='1') OR (XTp(3)='1' AND XBp(2)='1') )then
   T3_L1(17) <= '1';
  else
   T3_L1(17) <= '0';
  end if;

  if( (XTp(3)='1' AND XBp(3)='1') OR (XTp(3)='1' AND XBp(4)='1') )then
   T3_L1(18) <= '1';
  else
   T3_L1(18) <= '0';
  end if;

  if( (XTp(3)='1' AND XBp(5)='1') OR (XTp(3)='1' AND XBp(6)='1') )then
   T3_L1(19) <= '1';
  else
   T3_L1(19) <= '0';
  end if;

  if( (XTp(3)='1' AND XBp(7)='1') OR (XTp(3)='1' AND XBp(8)='1') )then
   T3_L1(20) <= '1';
  else
   T3_L1(20) <= '0';
  end if;

  if( (XTp(3)='1' AND XBp(9)='1') OR (XTp(3)='1' AND XBp(10)='1') )then
   T3_L1(21) <= '1';
  else
   T3_L1(21) <= '0';
  end if;

  if( (XTp(3)='1' AND XBp(11)='1') OR (XTp(4)='1' AND XBp(0)='1') )then
   T3_L1(22) <= '1';
  else
   T3_L1(22) <= '0';
  end if;

  if( (XTp(4)='1' AND XBp(1)='1') OR (XTp(4)='1' AND XBp(2)='1') )then
   T3_L1(23) <= '1';
  else
   T3_L1(23) <= '0';
  end if;

  if( (XTp(4)='1' AND XBp(3)='1') OR (XTp(4)='1' AND XBp(4)='1') )then
   T3_L1(24) <= '1';
  else
   T3_L1(24) <= '0';
  end if;

  if( (XTp(4)='1' AND XBp(5)='1') OR (XTp(4)='1' AND XBp(6)='1') )then
   T3_L1(25) <= '1';
  else
   T3_L1(25) <= '0';
  end if;

  if( (XTp(4)='1' AND XBp(7)='1') OR (XTp(4)='1' AND XBp(8)='1') )then
   T3_L1(26) <= '1';
  else
   T3_L1(26) <= '0';
  end if;

  if( (XTp(4)='1' AND XBp(9)='1') OR (XTp(4)='1' AND XBp(10)='1') )then
   T3_L1(27) <= '1';
  else
   T3_L1(27) <= '0';
  end if;

  if( (XTp(4)='1' AND XBp(11)='1') OR (XTp(5)='1' AND XBp(0)='1') )then
   T3_L1(28) <= '1';
  else
   T3_L1(28) <= '0';
  end if;

  if( (XTp(5)='1' AND XBp(1)='1') OR (XTp(5)='1' AND XBp(2)='1') )then
   T3_L1(29) <= '1';
  else
   T3_L1(29) <= '0';
  end if;

  if( (XTp(5)='1' AND XBp(3)='1') OR (XTp(5)='1' AND XBp(4)='1') )then
   T3_L1(30) <= '1';
  else
   T3_L1(30) <= '0';
  end if;

  if( (XTp(5)='1' AND XBp(5)='1') OR (XTp(5)='1' AND XBp(6)='1') )then
   T3_L1(31) <= '1';
  else
   T3_L1(31) <= '0';
  end if;

  if( (XTp(5)='1' AND XBp(7)='1') OR (XTp(5)='1' AND XBp(8)='1') )then
   T3_L1(32) <= '1';
  else
   T3_L1(32) <= '0';
  end if;

  if( (XTp(5)='1' AND XBp(9)='1') OR (XTp(5)='1' AND XBp(10)='1') )then
   T3_L1(33) <= '1';
  else
   T3_L1(33) <= '0';
  end if;

  if( (XTp(5)='1' AND XBp(11)='1') OR (XTp(6)='1' AND XBp(0)='1') )then
   T3_L1(34) <= '1';
  else
   T3_L1(34) <= '0';
  end if;

  if( (XTp(6)='1' AND XBp(1)='1') OR (XTp(6)='1' AND XBp(2)='1') )then
   T3_L1(35) <= '1';
  else
   T3_L1(35) <= '0';
  end if;

  if( (XTp(6)='1' AND XBp(3)='1') OR (XTp(6)='1' AND XBp(4)='1') )then
   T3_L1(36) <= '1';
  else
   T3_L1(36) <= '0';
  end if;

  if( (XTp(6)='1' AND XBp(5)='1') OR (XTp(6)='1' AND XBp(6)='1') )then
   T3_L1(37) <= '1';
  else
   T3_L1(37) <= '0';
  end if;

  if( (XTp(6)='1' AND XBp(7)='1') OR (XTp(6)='1' AND XBp(8)='1') )then
   T3_L1(38) <= '1';
  else
   T3_L1(38) <= '0';
  end if;

  if( (XTp(6)='1' AND XBp(9)='1') OR (XTp(6)='1' AND XBp(10)='1') )then
   T3_L1(39) <= '1';
  else
   T3_L1(39) <= '0';
  end if;

  if( (XTp(6)='1' AND XBp(11)='1') OR (XTp(7)='1' AND XBp(0)='1') )then
   T3_L1(40) <= '1';
  else
   T3_L1(40) <= '0';
  end if;

  if( (XTp(7)='1' AND XBp(1)='1') OR (XTp(7)='1' AND XBp(2)='1') )then
   T3_L1(41) <= '1';
  else
   T3_L1(41) <= '0';
  end if;

  if( (XTp(7)='1' AND XBp(3)='1') OR (XTp(7)='1' AND XBp(4)='1') )then
   T3_L1(42) <= '1';
  else
   T3_L1(42) <= '0';
  end if;

  if( (XTp(7)='1' AND XBp(5)='1') OR (XTp(7)='1' AND XBp(6)='1') )then
   T3_L1(43) <= '1';
  else
   T3_L1(43) <= '0';
  end if;

  if( (XTp(7)='1' AND XBp(7)='1') OR (XTp(7)='1' AND XBp(8)='1') )then
   T3_L1(44) <= '1';
  else
   T3_L1(44) <= '0';
  end if;

  if( (XTp(7)='1' AND XBp(9)='1') OR (XTp(7)='1' AND XBp(10)='1') )then
   T3_L1(45) <= '1';
  else
   T3_L1(45) <= '0';
  end if;

  if( (XTp(7)='1' AND XBp(11)='1') OR (XTp(8)='1' AND XBp(0)='1') )then
   T3_L1(46) <= '1';
  else
   T3_L1(46) <= '0';
  end if;

  if( (XTp(8)='1' AND XBp(1)='1') OR (XTp(8)='1' AND XBp(2)='1') )then
   T3_L1(47) <= '1';
  else
   T3_L1(47) <= '0';
  end if;

  if( (XTp(8)='1' AND XBp(3)='1') OR (XTp(8)='1' AND XBp(4)='1') )then
   T3_L1(48) <= '1';
  else
   T3_L1(48) <= '0';
  end if;

  if( (XTp(8)='1' AND XBp(5)='1') OR (XTp(8)='1' AND XBp(6)='1') )then
   T3_L1(49) <= '1';
  else
   T3_L1(49) <= '0';
  end if;

  if( (XTp(8)='1' AND XBp(7)='1') OR (XTp(8)='1' AND XBp(8)='1') )then
   T3_L1(50) <= '1';
  else
   T3_L1(50) <= '0';
  end if;

  if( (XTp(8)='1' AND XBp(9)='1') OR (XTp(8)='1' AND XBp(10)='1') )then
   T3_L1(51) <= '1';
  else
   T3_L1(51) <= '0';
  end if;

  if( (XTp(8)='1' AND XBp(11)='1') OR (XTp(9)='1' AND XBp(0)='1') )then
   T3_L1(52) <= '1';
  else
   T3_L1(52) <= '0';
  end if;

  if( (XTp(9)='1' AND XBp(1)='1') OR (XTp(9)='1' AND XBp(2)='1') )then
   T3_L1(53) <= '1';
  else
   T3_L1(53) <= '0';
  end if;

  if( (XTp(9)='1' AND XBp(3)='1') OR (XTp(9)='1' AND XBp(4)='1') )then
   T3_L1(54) <= '1';
  else
   T3_L1(54) <= '0';
  end if;

  if( (XTp(9)='1' AND XBp(5)='1') OR (XTp(9)='1' AND XBp(6)='1') )then
   T3_L1(55) <= '1';
  else
   T3_L1(55) <= '0';
  end if;

  if( (XTp(9)='1' AND XBp(7)='1') OR (XTp(9)='1' AND XBp(8)='1') )then
   T3_L1(56) <= '1';
  else
   T3_L1(56) <= '0';
  end if;

  if( (XTp(9)='1' AND XBp(9)='1') OR (XTp(9)='1' AND XBp(10)='1') )then
   T3_L1(57) <= '1';
  else
   T3_L1(57) <= '0';
  end if;

  if( (XTp(9)='1' AND XBp(11)='1') OR (XTp(10)='1' AND XBp(0)='1') )then
   T3_L1(58) <= '1';
  else
   T3_L1(58) <= '0';
  end if;

  if( (XTp(10)='1' AND XBp(1)='1') OR (XTp(10)='1' AND XBp(2)='1') )then
   T3_L1(59) <= '1';
  else
   T3_L1(59) <= '0';
  end if;

  if( (XTp(10)='1' AND XBp(3)='1') OR (XTp(10)='1' AND XBp(4)='1') )then
   T3_L1(60) <= '1';
  else
   T3_L1(60) <= '0';
  end if;

  if( (XTp(10)='1' AND XBp(5)='1') OR (XTp(10)='1' AND XBp(6)='1') )then
   T3_L1(61) <= '1';
  else
   T3_L1(61) <= '0';
  end if;

  if( (XTp(10)='1' AND XBp(7)='1') OR (XTp(10)='1' AND XBp(8)='1') )then
   T3_L1(62) <= '1';
  else
   T3_L1(62) <= '0';
  end if;

  if( (XTp(10)='1' AND XBp(9)='1') OR (XTp(10)='1' AND XBp(10)='1') )then
   T3_L1(63) <= '1';
  else
   T3_L1(63) <= '0';
  end if;

  if( (XTp(10)='1' AND XBp(11)='1') OR (XTp(11)='1' AND XBp(0)='1') )then
   T3_L1(64) <= '1';
  else
   T3_L1(64) <= '0';
  end if;

  if( (XTp(11)='1' AND XBp(1)='1') OR (XTp(11)='1' AND XBp(2)='1') )then
   T3_L1(65) <= '1';
  else
   T3_L1(65) <= '0';
  end if;

  if( (XTp(11)='1' AND XBp(3)='1') OR (XTp(11)='1' AND XBp(4)='1') )then
   T3_L1(66) <= '1';
  else
   T3_L1(66) <= '0';
  end if;

  if( (XTp(11)='1' AND XBp(5)='1') OR (XTp(11)='1' AND XBp(6)='1') )then
   T3_L1(67) <= '1';
  else
   T3_L1(67) <= '0';
  end if;

  if( (XTp(11)='1' AND XBp(7)='1') OR (XTp(11)='1' AND XBp(8)='1') )then
   T3_L1(68) <= '1';
  else
   T3_L1(68) <= '0';
  end if;

  if( (XTp(11)='1' AND XBp(9)='1') OR (XTp(11)='1' AND XBp(10)='1') )then
   T3_L1(69) <= '1';
  else
   T3_L1(69) <= '0';
  end if;

  if( (XTp(11)='1' AND XBp(11)='1') OR (XTm(0)='1' AND XBm(2)='1') )then
   T3_L1(70) <= '1';
  else
   T3_L1(70) <= '0';
  end if;

  if( (XTm(0)='1' AND XBm(3)='1') OR (XTm(0)='1' AND XBm(4)='1') )then
   T3_L1(71) <= '1';
  else
   T3_L1(71) <= '0';
  end if;

  if( (XTm(0)='1' AND XBm(5)='1') OR (XTm(0)='1' AND XBm(6)='1') )then
   T3_L1(72) <= '1';
  else
   T3_L1(72) <= '0';
  end if;

  if( (XTm(0)='1' AND XBm(7)='1') OR (XTm(0)='1' AND XBm(8)='1') )then
   T3_L1(73) <= '1';
  else
   T3_L1(73) <= '0';
  end if;

  if( (XTm(0)='1' AND XBm(9)='1') OR (XTm(0)='1' AND XBm(10)='1') )then
   T3_L1(74) <= '1';
  else
   T3_L1(74) <= '0';
  end if;

  if( (XTm(0)='1' AND XBm(11)='1') OR (XTm(1)='1' AND XBm(1)='1') )then
   T3_L1(75) <= '1';
  else
   T3_L1(75) <= '0';
  end if;

  if( (XTm(1)='1' AND XBm(2)='1') OR (XTm(1)='1' AND XBm(3)='1') )then
   T3_L1(76) <= '1';
  else
   T3_L1(76) <= '0';
  end if;

  if( (XTm(1)='1' AND XBm(4)='1') OR (XTm(1)='1' AND XBm(5)='1') )then
   T3_L1(77) <= '1';
  else
   T3_L1(77) <= '0';
  end if;

  if( (XTm(1)='1' AND XBm(6)='1') OR (XTm(1)='1' AND XBm(7)='1') )then
   T3_L1(78) <= '1';
  else
   T3_L1(78) <= '0';
  end if;

  if( (XTm(1)='1' AND XBm(8)='1') OR (XTm(1)='1' AND XBm(9)='1') )then
   T3_L1(79) <= '1';
  else
   T3_L1(79) <= '0';
  end if;

  if( (XTm(1)='1' AND XBm(10)='1') OR (XTm(1)='1' AND XBm(11)='1') )then
   T3_L1(80) <= '1';
  else
   T3_L1(80) <= '0';
  end if;

  if( (XTm(2)='1' AND XBm(0)='1') OR (XTm(2)='1' AND XBm(1)='1') )then
   T3_L1(81) <= '1';
  else
   T3_L1(81) <= '0';
  end if;

  if( (XTm(2)='1' AND XBm(2)='1') OR (XTm(2)='1' AND XBm(3)='1') )then
   T3_L1(82) <= '1';
  else
   T3_L1(82) <= '0';
  end if;

  if( (XTm(2)='1' AND XBm(4)='1') OR (XTm(2)='1' AND XBm(5)='1') )then
   T3_L1(83) <= '1';
  else
   T3_L1(83) <= '0';
  end if;

  if( (XTm(2)='1' AND XBm(6)='1') OR (XTm(2)='1' AND XBm(7)='1') )then
   T3_L1(84) <= '1';
  else
   T3_L1(84) <= '0';
  end if;

  if( (XTm(2)='1' AND XBm(8)='1') OR (XTm(2)='1' AND XBm(9)='1') )then
   T3_L1(85) <= '1';
  else
   T3_L1(85) <= '0';
  end if;

  if( (XTm(2)='1' AND XBm(10)='1') OR (XTm(2)='1' AND XBm(11)='1') )then
   T3_L1(86) <= '1';
  else
   T3_L1(86) <= '0';
  end if;

  if( (XTm(3)='1' AND XBm(0)='1') OR (XTm(3)='1' AND XBm(1)='1') )then
   T3_L1(87) <= '1';
  else
   T3_L1(87) <= '0';
  end if;

  if( (XTm(3)='1' AND XBm(2)='1') OR (XTm(3)='1' AND XBm(3)='1') )then
   T3_L1(88) <= '1';
  else
   T3_L1(88) <= '0';
  end if;

  if( (XTm(3)='1' AND XBm(4)='1') OR (XTm(3)='1' AND XBm(5)='1') )then
   T3_L1(89) <= '1';
  else
   T3_L1(89) <= '0';
  end if;

  if( (XTm(3)='1' AND XBm(6)='1') OR (XTm(3)='1' AND XBm(7)='1') )then
   T3_L1(90) <= '1';
  else
   T3_L1(90) <= '0';
  end if;

  if( (XTm(3)='1' AND XBm(8)='1') OR (XTm(3)='1' AND XBm(9)='1') )then
   T3_L1(91) <= '1';
  else
   T3_L1(91) <= '0';
  end if;

  if( (XTm(3)='1' AND XBm(10)='1') OR (XTm(3)='1' AND XBm(11)='1') )then
   T3_L1(92) <= '1';
  else
   T3_L1(92) <= '0';
  end if;

  if( (XTm(4)='1' AND XBm(0)='1') OR (XTm(4)='1' AND XBm(1)='1') )then
   T3_L1(93) <= '1';
  else
   T3_L1(93) <= '0';
  end if;

  if( (XTm(4)='1' AND XBm(2)='1') OR (XTm(4)='1' AND XBm(3)='1') )then
   T3_L1(94) <= '1';
  else
   T3_L1(94) <= '0';
  end if;

  if( (XTm(4)='1' AND XBm(4)='1') OR (XTm(4)='1' AND XBm(5)='1') )then
   T3_L1(95) <= '1';
  else
   T3_L1(95) <= '0';
  end if;

  if( (XTm(4)='1' AND XBm(6)='1') OR (XTm(4)='1' AND XBm(7)='1') )then
   T3_L1(96) <= '1';
  else
   T3_L1(96) <= '0';
  end if;

  if( (XTm(4)='1' AND XBm(8)='1') OR (XTm(4)='1' AND XBm(9)='1') )then
   T3_L1(97) <= '1';
  else
   T3_L1(97) <= '0';
  end if;

  if( (XTm(4)='1' AND XBm(10)='1') OR (XTm(4)='1' AND XBm(11)='1') )then
   T3_L1(98) <= '1';
  else
   T3_L1(98) <= '0';
  end if;

  if( (XTm(5)='1' AND XBm(0)='1') OR (XTm(5)='1' AND XBm(1)='1') )then
   T3_L1(99) <= '1';
  else
   T3_L1(99) <= '0';
  end if;

  if( (XTm(5)='1' AND XBm(2)='1') OR (XTm(5)='1' AND XBm(3)='1') )then
   T3_L1(100) <= '1';
  else
   T3_L1(100) <= '0';
  end if;

  if( (XTm(5)='1' AND XBm(4)='1') OR (XTm(5)='1' AND XBm(5)='1') )then
   T3_L1(101) <= '1';
  else
   T3_L1(101) <= '0';
  end if;

  if( (XTm(5)='1' AND XBm(6)='1') OR (XTm(5)='1' AND XBm(7)='1') )then
   T3_L1(102) <= '1';
  else
   T3_L1(102) <= '0';
  end if;

  if( (XTm(5)='1' AND XBm(8)='1') OR (XTm(5)='1' AND XBm(9)='1') )then
   T3_L1(103) <= '1';
  else
   T3_L1(103) <= '0';
  end if;

  if( (XTm(5)='1' AND XBm(10)='1') OR (XTm(5)='1' AND XBm(11)='1') )then
   T3_L1(104) <= '1';
  else
   T3_L1(104) <= '0';
  end if;

  if( (XTm(6)='1' AND XBm(0)='1') OR (XTm(6)='1' AND XBm(1)='1') )then
   T3_L1(105) <= '1';
  else
   T3_L1(105) <= '0';
  end if;

  if( (XTm(6)='1' AND XBm(2)='1') OR (XTm(6)='1' AND XBm(3)='1') )then
   T3_L1(106) <= '1';
  else
   T3_L1(106) <= '0';
  end if;

  if( (XTm(6)='1' AND XBm(4)='1') OR (XTm(6)='1' AND XBm(5)='1') )then
   T3_L1(107) <= '1';
  else
   T3_L1(107) <= '0';
  end if;

  if( (XTm(6)='1' AND XBm(6)='1') OR (XTm(6)='1' AND XBm(7)='1') )then
   T3_L1(108) <= '1';
  else
   T3_L1(108) <= '0';
  end if;

  if( (XTm(6)='1' AND XBm(8)='1') OR (XTm(6)='1' AND XBm(9)='1') )then
   T3_L1(109) <= '1';
  else
   T3_L1(109) <= '0';
  end if;

  if( (XTm(6)='1' AND XBm(10)='1') OR (XTm(6)='1' AND XBm(11)='1') )then
   T3_L1(110) <= '1';
  else
   T3_L1(110) <= '0';
  end if;

  if( (XTm(7)='1' AND XBm(0)='1') OR (XTm(7)='1' AND XBm(1)='1') )then
   T3_L1(111) <= '1';
  else
   T3_L1(111) <= '0';
  end if;

  if( (XTm(7)='1' AND XBm(2)='1') OR (XTm(7)='1' AND XBm(3)='1') )then
   T3_L1(112) <= '1';
  else
   T3_L1(112) <= '0';
  end if;

  if( (XTm(7)='1' AND XBm(4)='1') OR (XTm(7)='1' AND XBm(5)='1') )then
   T3_L1(113) <= '1';
  else
   T3_L1(113) <= '0';
  end if;

  if( (XTm(7)='1' AND XBm(6)='1') OR (XTm(7)='1' AND XBm(7)='1') )then
   T3_L1(114) <= '1';
  else
   T3_L1(114) <= '0';
  end if;

  if( (XTm(7)='1' AND XBm(8)='1') OR (XTm(7)='1' AND XBm(9)='1') )then
   T3_L1(115) <= '1';
  else
   T3_L1(115) <= '0';
  end if;

  if( (XTm(7)='1' AND XBm(10)='1') OR (XTm(7)='1' AND XBm(11)='1') )then
   T3_L1(116) <= '1';
  else
   T3_L1(116) <= '0';
  end if;

  if( (XTm(8)='1' AND XBm(0)='1') OR (XTm(8)='1' AND XBm(1)='1') )then
   T3_L1(117) <= '1';
  else
   T3_L1(117) <= '0';
  end if;

  if( (XTm(8)='1' AND XBm(2)='1') OR (XTm(8)='1' AND XBm(3)='1') )then
   T3_L1(118) <= '1';
  else
   T3_L1(118) <= '0';
  end if;

  if( (XTm(8)='1' AND XBm(4)='1') OR (XTm(8)='1' AND XBm(5)='1') )then
   T3_L1(119) <= '1';
  else
   T3_L1(119) <= '0';
  end if;

  if( (XTm(8)='1' AND XBm(6)='1') OR (XTm(8)='1' AND XBm(7)='1') )then
   T3_L1(120) <= '1';
  else
   T3_L1(120) <= '0';
  end if;

  if( (XTm(8)='1' AND XBm(8)='1') OR (XTm(8)='1' AND XBm(9)='1') )then
   T3_L1(121) <= '1';
  else
   T3_L1(121) <= '0';
  end if;

  if( (XTm(8)='1' AND XBm(10)='1') OR (XTm(8)='1' AND XBm(11)='1') )then
   T3_L1(122) <= '1';
  else
   T3_L1(122) <= '0';
  end if;

  if( (XTm(9)='1' AND XBm(0)='1') OR (XTm(9)='1' AND XBm(1)='1') )then
   T3_L1(123) <= '1';
  else
   T3_L1(123) <= '0';
  end if;

  if( (XTm(9)='1' AND XBm(2)='1') OR (XTm(9)='1' AND XBm(3)='1') )then
   T3_L1(124) <= '1';
  else
   T3_L1(124) <= '0';
  end if;

  if( (XTm(9)='1' AND XBm(4)='1') OR (XTm(9)='1' AND XBm(5)='1') )then
   T3_L1(125) <= '1';
  else
   T3_L1(125) <= '0';
  end if;

  if( (XTm(9)='1' AND XBm(6)='1') OR (XTm(9)='1' AND XBm(7)='1') )then
   T3_L1(126) <= '1';
  else
   T3_L1(126) <= '0';
  end if;

  if( (XTm(9)='1' AND XBm(8)='1') OR (XTm(9)='1' AND XBm(9)='1') )then
   T3_L1(127) <= '1';
  else
   T3_L1(127) <= '0';
  end if;

  if( (XTm(9)='1' AND XBm(10)='1') OR (XTm(9)='1' AND XBm(11)='1') )then
   T3_L1(128) <= '1';
  else
   T3_L1(128) <= '0';
  end if;

  if( (XTm(10)='1' AND XBm(0)='1') OR (XTm(10)='1' AND XBm(1)='1') )then
   T3_L1(129) <= '1';
  else
   T3_L1(129) <= '0';
  end if;

  if( (XTm(10)='1' AND XBm(2)='1') OR (XTm(10)='1' AND XBm(3)='1') )then
   T3_L1(130) <= '1';
  else
   T3_L1(130) <= '0';
  end if;

  if( (XTm(10)='1' AND XBm(4)='1') OR (XTm(10)='1' AND XBm(5)='1') )then
   T3_L1(131) <= '1';
  else
   T3_L1(131) <= '0';
  end if;

  if( (XTm(10)='1' AND XBm(6)='1') OR (XTm(10)='1' AND XBm(7)='1') )then
   T3_L1(132) <= '1';
  else
   T3_L1(132) <= '0';
  end if;

  if( (XTm(10)='1' AND XBm(8)='1') OR (XTm(10)='1' AND XBm(9)='1') )then
   T3_L1(133) <= '1';
  else
   T3_L1(133) <= '0';
  end if;

  if( (XTm(10)='1' AND XBm(10)='1') OR (XTm(10)='1' AND XBm(11)='1') )then
   T3_L1(134) <= '1';
  else
   T3_L1(134) <= '0';
  end if;

  if( (XTm(11)='1' AND XBm(0)='1') OR (XTm(11)='1' AND XBm(1)='1') )then
   T3_L1(135) <= '1';
  else
   T3_L1(135) <= '0';
  end if;

  if( (XTm(11)='1' AND XBm(2)='1') OR (XTm(11)='1' AND XBm(3)='1') )then
   T3_L1(136) <= '1';
  else
   T3_L1(136) <= '0';
  end if;

  if( (XTm(11)='1' AND XBm(4)='1') OR (XTm(11)='1' AND XBm(5)='1') )then
   T3_L1(137) <= '1';
  else
   T3_L1(137) <= '0';
  end if;

  if( (XTm(11)='1' AND XBm(6)='1') OR (XTm(11)='1' AND XBm(7)='1') )then
   T3_L1(138) <= '1';
  else
   T3_L1(138) <= '0';
  end if;

  if( (XTm(11)='1' AND XBm(8)='1') OR (XTm(11)='1' AND XBm(9)='1') )then
   T3_L1(139) <= '1';
  else
   T3_L1(139) <= '0';
  end if;

  if( (XTm(11)='1' AND XBm(10)='1') OR (XTm(11)='1' AND XBm(11)='1') )then
   T3_L1(140) <= '1';
  else
   T3_L1(140) <= '0';
  end if;

-------------------------END Trigger 3 Level 1--------------------------------

-------------------------BEGIN Trigger 4 Level 1--------------------------------
  if( XTp(0)='1' OR XTp(1)='1' OR XTp(2)='1' OR XTp(3)='1' )then
   T4_L1(0) <= '1';
  else
   T4_L1(0) <= '0';
  end if;

  if( XTp(4)='1' OR XTp(5)='1' OR XTp(6)='1' OR XTp(7)='1' )then
   T4_L1(1) <= '1';
  else
   T4_L1(1) <= '0';
  end if;

  if( XTp(8)='1' OR XTp(9)='1' OR XTp(10)='1' OR XTp(11)='1' )then
   T4_L1(2) <= '1';
  else
   T4_L1(2) <= '0';
  end if;

  if( XTm(0)='1' OR XTm(1)='1' OR XTm(2)='1' OR XTm(3)='1' )then
   T4_L1(3) <= '1';
  else
   T4_L1(3) <= '0';
  end if;

  if( XTm(4)='1' OR XTm(5)='1' OR XTm(6)='1' OR XTm(7)='1' )then
   T4_L1(4) <= '1';
  else
   T4_L1(4) <= '0';
  end if;

  if( XTm(8)='1' OR XTm(9)='1' OR XTm(10)='1' OR XTm(11)='1' )then
   T4_L1(5) <= '1';
  else
   T4_L1(5) <= '0';
  end if;

  if( XBp(0)='1' OR XBp(1)='1' OR XBp(2)='1' OR XBp(3)='1' )then
   T4_L1(6) <= '1';
  else
   T4_L1(6) <= '0';
  end if;

  if( XBp(4)='1' OR XBp(5)='1' OR XBp(6)='1' OR XBp(7)='1' )then
   T4_L1(7) <= '1';
  else
   T4_L1(7) <= '0';
  end if;

  if( XBp(8)='1' OR XBp(9)='1' OR XBp(10)='1' OR XBp(11)='1' )then
   T4_L1(8) <= '1';
  else
   T4_L1(8) <= '0';
  end if;

  if( XBm(0)='1' OR XBm(1)='1' OR XBm(2)='1' OR XBm(3)='1' )then
   T4_L1(9) <= '1';
  else
   T4_L1(9) <= '0';
  end if;

  if( XBm(4)='1' OR XBm(5)='1' OR XBm(6)='1' OR XBm(7)='1' )then
   T4_L1(10) <= '1';
  else
   T4_L1(10) <= '0';
  end if;

  if( XBm(8)='1' OR XBm(9)='1' OR XBm(10)='1' OR XBm(11)='1' )then
   T4_L1(11) <= '1';
  else
   T4_L1(11) <= '0';
  end if;

-------------------------END Trigger 4 Level 1--------------------------------

-------------------------BEGIN Trigger 5 Level 1--------------------------------
  if( XTp(6)='1' OR XTp(7)='1' OR XTp(8)='1' OR XTp(9)='1' )then
   T5_L1(0) <= '1';
  else
   T5_L1(0) <= '0';
  end if;

  if( XTp(10)='1' OR XTp(11)='1' OR XTm(6)='1' OR XTm(7)='1' )then
   T5_L1(1) <= '1';
  else
   T5_L1(1) <= '0';
  end if;

  if( XTm(8)='1' OR XTm(9)='1' OR XTm(10)='1' OR XTm(11)='1' )then
   T5_L1(2) <= '1';
  else
   T5_L1(2) <= '0';
  end if;

  if( XBp(6)='1' OR XBp(7)='1' OR XBp(8)='1' OR XBp(9)='1' )then
   T5_L1(3) <= '1';
  else
   T5_L1(3) <= '0';
  end if;

  if( XBp(10)='1' OR XBp(11)='1' OR XBm(6)='1' OR XBm(7)='1' )then
   T5_L1(4) <= '1';
  else
   T5_L1(4) <= '0';
  end if;

  if( XBm(8)='1' OR XBm(9)='1' OR XBm(10)='1' OR XBm(11)='1' )then
   T5_L1(5) <= '1';
  else
   T5_L1(5) <= '0';
  end if;

-------------------------END Trigger 5 Level 1--------------------------------

 end if;
end process;

lookuptablelv2 : process(c1)
begin
 if c1'event and c1 = '1' then

-------------------------BEGIN Trigger 1 Level 2--------------------------------
  if( T1_L1(0)='1' OR T1_L1(1)='1' OR T1_L1(2)='1' OR T1_L1(3)='1' )then
   T1_L2(0) <= '1';
  else
   T1_L2(0) <= '0';
  end if;

  if( T1_L1(4)='1' OR T1_L1(5)='1' OR T1_L1(6)='1' OR T1_L1(7)='1' )then
   T1_L2(1) <= '1';
  else
   T1_L2(1) <= '0';
  end if;

  if( T1_L1(8)='1' OR T1_L1(9)='1' OR T1_L1(10)='1' OR T1_L1(11)='1' )then
   T1_L2(2) <= '1';
  else
   T1_L2(2) <= '0';
  end if;

  if( T1_L1(12)='1' OR T1_L1(13)='1' OR T1_L1(14)='1' OR T1_L1(15)='1' )then
   T1_L2(3) <= '1';
  else
   T1_L2(3) <= '0';
  end if;

  if( T1_L1(16)='1' OR T1_L1(17)='1' OR T1_L1(18)='1' OR T1_L1(19)='1' )then
   T1_L2(4) <= '1';
  else
   T1_L2(4) <= '0';
  end if;

  if( T1_L1(20)='1' OR T1_L1(21)='1' OR T1_L1(22)='1' OR T1_L1(23)='1' )then
   T1_L2(5) <= '1';
  else
   T1_L2(5) <= '0';
  end if;

  if( T1_L1(24)='1' OR T1_L1(25)='1' OR T1_L1(26)='1' OR T1_L1(27)='1' )then
   T1_L2(6) <= '1';
  else
   T1_L2(6) <= '0';
  end if;

  if( T1_L1(28)='1' OR T1_L1(29)='1' OR T1_L1(30)='1' OR T1_L1(31)='1' )then
   T1_L2(7) <= '1';
  else
   T1_L2(7) <= '0';
  end if;

  if( T1_L1(32)='1' OR T1_L1(33)='1' OR T1_L1(34)='1' OR T1_L1(35)='1' )then
   T1_L2(8) <= '1';
  else
   T1_L2(8) <= '0';
  end if;

  if( T1_L1(36)='1' OR T1_L1(37)='1' OR T1_L1(38)='1' OR T1_L1(39)='1' )then
   T1_L2(9) <= '1';
  else
   T1_L2(9) <= '0';
  end if;

  if( T1_L1(40)='1' OR T1_L1(41)='1' OR T1_L1(42)='1' OR T1_L1(43)='1' )then
   T1_L2(10) <= '1';
  else
   T1_L2(10) <= '0';
  end if;

  if( T1_L1(44)='1' OR T1_L1(45)='1' OR T1_L1(46)='1' OR T1_L1(47)='1' )then
   T1_L2(11) <= '1';
  else
   T1_L2(11) <= '0';
  end if;

  if( T1_L1(48)='1' OR T1_L1(49)='1' OR T1_L1(50)='1' OR T1_L1(51)='1' )then
   T1_L2(12) <= '1';
  else
   T1_L2(12) <= '0';
  end if;

  if( T1_L1(52)='1' OR T1_L1(53)='1' OR T1_L1(54)='1' OR T1_L1(55)='1' )then
   T1_L2(13) <= '1';
  else
   T1_L2(13) <= '0';
  end if;

  if( T1_L1(56)='1' OR T1_L1(57)='1' OR T1_L1(58)='1' OR T1_L1(59)='1' )then
   T1_L2(14) <= '1';
  else
   T1_L2(14) <= '0';
  end if;

  if( T1_L1(60)='1' OR T1_L1(61)='1' OR T1_L1(62)='1' OR T1_L1(63)='1' )then
   T1_L2(15) <= '1';
  else
   T1_L2(15) <= '0';
  end if;

  if( T1_L1(64)='1' OR T1_L1(65)='1' OR T1_L1(66)='1' OR T1_L1(67)='1' )then
   T1_L2(16) <= '1';
  else
   T1_L2(16) <= '0';
  end if;

  if( T1_L1(68)='1' OR T1_L1(69)='1' OR T1_L1(70)='1' OR T1_L1(71)='1' )then
   T1_L2(17) <= '1';
  else
   T1_L2(17) <= '0';
  end if;

  if( T1_L1(72)='1' OR T1_L1(73)='1' OR T1_L1(74)='1' OR T1_L1(75)='1' )then
   T1_L2(18) <= '1';
  else
   T1_L2(18) <= '0';
  end if;

  if( T1_L1(76)='1' OR T1_L1(77)='1' OR T1_L1(78)='1' OR T1_L1(79)='1' )then
   T1_L2(19) <= '1';
  else
   T1_L2(19) <= '0';
  end if;

  if( T1_L1(80)='1' OR T1_L1(81)='1' OR T1_L1(82)='1' OR T1_L1(83)='1' )then
   T1_L2(20) <= '1';
  else
   T1_L2(20) <= '0';
  end if;

  if( T1_L1(84)='1' OR T1_L1(85)='1' OR T1_L1(86)='1' OR T1_L1(87)='1' )then
   T1_L2(21) <= '1';
  else
   T1_L2(21) <= '0';
  end if;

  if( T1_L1(88)='1' OR T1_L1(89)='1' OR T1_L1(90)='1' OR T1_L1(91)='1' )then
   T1_L2(22) <= '1';
  else
   T1_L2(22) <= '0';
  end if;

  if( T1_L1(92)='1' OR T1_L1(93)='1' OR T1_L1(94)='1' OR T1_L1(95)='1' )then
   T1_L2(23) <= '1';
  else
   T1_L2(23) <= '0';
  end if;

  if( T1_L1(96)='1' OR T1_L1(97)='1' OR T1_L1(98)='1' OR T1_L1(99)='1' )then
   T1_L2(24) <= '1';
  else
   T1_L2(24) <= '0';
  end if;

  if( T1_L1(100)='1' OR T1_L1(101)='1' OR T1_L1(102)='1' OR T1_L1(103)='1' )then
   T1_L2(25) <= '1';
  else
   T1_L2(25) <= '0';
  end if;

  if( T1_L1(104)='1' OR T1_L1(105)='1' OR T1_L1(106)='1' OR T1_L1(107)='1' )then
   T1_L2(26) <= '1';
  else
   T1_L2(26) <= '0';
  end if;

  if( T1_L1(108)='1' OR T1_L1(109)='1' OR T1_L1(110)='1' OR T1_L1(111)='1' )then
   T1_L2(27) <= '1';
  else
   T1_L2(27) <= '0';
  end if;

  if( T1_L1(112)='1' OR T1_L1(113)='1' OR T1_L1(114)='1' OR T1_L1(115)='1' )then
   T1_L2(28) <= '1';
  else
   T1_L2(28) <= '0';
  end if;

  if( T1_L1(116)='1' OR T1_L1(117)='1' OR T1_L1(118)='1' OR T1_L1(119)='1' )then
   T1_L2(29) <= '1';
  else
   T1_L2(29) <= '0';
  end if;

  if( T1_L1(120)='1' OR T1_L1(121)='1' OR T1_L1(122)='1' OR T1_L1(123)='1' )then
   T1_L2(30) <= '1';
  else
   T1_L2(30) <= '0';
  end if;

  if( T1_L1(124)='1' OR T1_L1(125)='1' OR T1_L1(126)='1' OR T1_L1(127)='1' )then
   T1_L2(31) <= '1';
  else
   T1_L2(31) <= '0';
  end if;

  if( T1_L1(128)='1' OR T1_L1(129)='1' OR T1_L1(130)='1' OR T1_L1(131)='1' )then
   T1_L2(32) <= '1';
  else
   T1_L2(32) <= '0';
  end if;

  if( T1_L1(132)='1' OR T1_L1(133)='1' OR T1_L1(134)='1' OR T1_L1(135)='1' )then
   T1_L2(33) <= '1';
  else
   T1_L2(33) <= '0';
  end if;

  if( T1_L1(136)='1' OR T1_L1(137)='1' OR T1_L1(138)='1' OR T1_L1(139)='1' )then
   T1_L2(34) <= '1';
  else
   T1_L2(34) <= '0';
  end if;

  if( T1_L1(140)='1' )then
   T1_L2(35) <= '1';
  else
   T1_L2(35) <= '0';
  end if;

-------------------------END Trigger 1 Level 2--------------------------------

-------------------------BEGIN Trigger 2 Level 2--------------------------------
  if( T2_L1(0)='1' OR T2_L1(1)='1' OR T2_L1(2)='1' OR T2_L1(3)='1' )then
   T2_L2(0) <= '1';
  else
   T2_L2(0) <= '0';
  end if;

  if( T2_L1(4)='1' OR T2_L1(5)='1' OR T2_L1(6)='1' OR T2_L1(7)='1' )then
   T2_L2(1) <= '1';
  else
   T2_L2(1) <= '0';
  end if;

  if( T2_L1(8)='1' OR T2_L1(9)='1' OR T2_L1(10)='1' OR T2_L1(11)='1' )then
   T2_L2(2) <= '1';
  else
   T2_L2(2) <= '0';
  end if;

  if( T2_L1(12)='1' OR T2_L1(13)='1' OR T2_L1(14)='1' OR T2_L1(15)='1' )then
   T2_L2(3) <= '1';
  else
   T2_L2(3) <= '0';
  end if;

  if( T2_L1(16)='1' OR T2_L1(17)='1' OR T2_L1(18)='1' OR T2_L1(19)='1' )then
   T2_L2(4) <= '1';
  else
   T2_L2(4) <= '0';
  end if;

  if( T2_L1(20)='1' OR T2_L1(21)='1' OR T2_L1(22)='1' OR T2_L1(23)='1' )then
   T2_L2(5) <= '1';
  else
   T2_L2(5) <= '0';
  end if;

  if( T2_L1(24)='1' OR T2_L1(25)='1' OR T2_L1(26)='1' OR T2_L1(27)='1' )then
   T2_L2(6) <= '1';
  else
   T2_L2(6) <= '0';
  end if;

  if( T2_L1(28)='1' OR T2_L1(29)='1' OR T2_L1(30)='1' OR T2_L1(31)='1' )then
   T2_L2(7) <= '1';
  else
   T2_L2(7) <= '0';
  end if;

  if( T2_L1(32)='1' OR T2_L1(33)='1' OR T2_L1(34)='1' OR T2_L1(35)='1' )then
   T2_L2(8) <= '1';
  else
   T2_L2(8) <= '0';
  end if;

  if( T2_L1(36)='1' OR T2_L1(37)='1' OR T2_L1(38)='1' OR T2_L1(39)='1' )then
   T2_L2(9) <= '1';
  else
   T2_L2(9) <= '0';
  end if;

  if( T2_L1(40)='1' OR T2_L1(41)='1' OR T2_L1(42)='1' OR T2_L1(43)='1' )then
   T2_L2(10) <= '1';
  else
   T2_L2(10) <= '0';
  end if;

  if( T2_L1(44)='1' OR T2_L1(45)='1' OR T2_L1(46)='1' OR T2_L1(47)='1' )then
   T2_L2(11) <= '1';
  else
   T2_L2(11) <= '0';
  end if;

  if( T2_L1(48)='1' OR T2_L1(49)='1' OR T2_L1(50)='1' OR T2_L1(51)='1' )then
   T2_L2(12) <= '1';
  else
   T2_L2(12) <= '0';
  end if;

  if( T2_L1(52)='1' OR T2_L1(53)='1' OR T2_L1(54)='1' OR T2_L1(55)='1' )then
   T2_L2(13) <= '1';
  else
   T2_L2(13) <= '0';
  end if;

  if( T2_L1(56)='1' OR T2_L1(57)='1' OR T2_L1(58)='1' OR T2_L1(59)='1' )then
   T2_L2(14) <= '1';
  else
   T2_L2(14) <= '0';
  end if;

  if( T2_L1(60)='1' OR T2_L1(61)='1' OR T2_L1(62)='1' OR T2_L1(63)='1' )then
   T2_L2(15) <= '1';
  else
   T2_L2(15) <= '0';
  end if;

  if( T2_L1(64)='1' OR T2_L1(65)='1' OR T2_L1(66)='1' OR T2_L1(67)='1' )then
   T2_L2(16) <= '1';
  else
   T2_L2(16) <= '0';
  end if;

  if( T2_L1(68)='1' OR T2_L1(69)='1' OR T2_L1(70)='1' OR T2_L1(71)='1' )then
   T2_L2(17) <= '1';
  else
   T2_L2(17) <= '0';
  end if;

  if( T2_L1(72)='1' OR T2_L1(73)='1' OR T2_L1(74)='1' OR T2_L1(75)='1' )then
   T2_L2(18) <= '1';
  else
   T2_L2(18) <= '0';
  end if;

  if( T2_L1(76)='1' OR T2_L1(77)='1' OR T2_L1(78)='1' OR T2_L1(79)='1' )then
   T2_L2(19) <= '1';
  else
   T2_L2(19) <= '0';
  end if;

  if( T2_L1(80)='1' OR T2_L1(81)='1' OR T2_L1(82)='1' OR T2_L1(83)='1' )then
   T2_L2(20) <= '1';
  else
   T2_L2(20) <= '0';
  end if;

  if( T2_L1(84)='1' OR T2_L1(85)='1' OR T2_L1(86)='1' OR T2_L1(87)='1' )then
   T2_L2(21) <= '1';
  else
   T2_L2(21) <= '0';
  end if;

  if( T2_L1(88)='1' OR T2_L1(89)='1' OR T2_L1(90)='1' OR T2_L1(91)='1' )then
   T2_L2(22) <= '1';
  else
   T2_L2(22) <= '0';
  end if;

  if( T2_L1(92)='1' OR T2_L1(93)='1' OR T2_L1(94)='1' OR T2_L1(95)='1' )then
   T2_L2(23) <= '1';
  else
   T2_L2(23) <= '0';
  end if;

  if( T2_L1(96)='1' OR T2_L1(97)='1' OR T2_L1(98)='1' OR T2_L1(99)='1' )then
   T2_L2(24) <= '1';
  else
   T2_L2(24) <= '0';
  end if;

  if( T2_L1(100)='1' OR T2_L1(101)='1' OR T2_L1(102)='1' OR T2_L1(103)='1' )then
   T2_L2(25) <= '1';
  else
   T2_L2(25) <= '0';
  end if;

  if( T2_L1(104)='1' OR T2_L1(105)='1' OR T2_L1(106)='1' OR T2_L1(107)='1' )then
   T2_L2(26) <= '1';
  else
   T2_L2(26) <= '0';
  end if;

  if( T2_L1(108)='1' OR T2_L1(109)='1' OR T2_L1(110)='1' OR T2_L1(111)='1' )then
   T2_L2(27) <= '1';
  else
   T2_L2(27) <= '0';
  end if;

  if( T2_L1(112)='1' OR T2_L1(113)='1' OR T2_L1(114)='1' OR T2_L1(115)='1' )then
   T2_L2(28) <= '1';
  else
   T2_L2(28) <= '0';
  end if;

  if( T2_L1(116)='1' OR T2_L1(117)='1' OR T2_L1(118)='1' OR T2_L1(119)='1' )then
   T2_L2(29) <= '1';
  else
   T2_L2(29) <= '0';
  end if;

  if( T2_L1(120)='1' OR T2_L1(121)='1' OR T2_L1(122)='1' OR T2_L1(123)='1' )then
   T2_L2(30) <= '1';
  else
   T2_L2(30) <= '0';
  end if;

  if( T2_L1(124)='1' OR T2_L1(125)='1' OR T2_L1(126)='1' OR T2_L1(127)='1' )then
   T2_L2(31) <= '1';
  else
   T2_L2(31) <= '0';
  end if;

  if( T2_L1(128)='1' OR T2_L1(129)='1' OR T2_L1(130)='1' OR T2_L1(131)='1' )then
   T2_L2(32) <= '1';
  else
   T2_L2(32) <= '0';
  end if;

  if( T2_L1(132)='1' OR T2_L1(133)='1' OR T2_L1(134)='1' OR T2_L1(135)='1' )then
   T2_L2(33) <= '1';
  else
   T2_L2(33) <= '0';
  end if;

  if( T2_L1(136)='1' OR T2_L1(137)='1' OR T2_L1(138)='1' OR T2_L1(139)='1' )then
   T2_L2(34) <= '1';
  else
   T2_L2(34) <= '0';
  end if;

  if( T2_L1(140)='1' )then
   T2_L2(35) <= '1';
  else
   T2_L2(35) <= '0';
  end if;

-------------------------END Trigger 2 Level 2--------------------------------

-------------------------BEGIN Trigger 3 Level 2--------------------------------
  if( T3_L1(0)='1' OR T3_L1(1)='1' OR T3_L1(2)='1' OR T3_L1(3)='1' )then
   T3_L2(0) <= '1';
  else
   T3_L2(0) <= '0';
  end if;

  if( T3_L1(4)='1' OR T3_L1(5)='1' OR T3_L1(6)='1' OR T3_L1(7)='1' )then
   T3_L2(1) <= '1';
  else
   T3_L2(1) <= '0';
  end if;

  if( T3_L1(8)='1' OR T3_L1(9)='1' OR T3_L1(10)='1' OR T3_L1(11)='1' )then
   T3_L2(2) <= '1';
  else
   T3_L2(2) <= '0';
  end if;

  if( T3_L1(12)='1' OR T3_L1(13)='1' OR T3_L1(14)='1' OR T3_L1(15)='1' )then
   T3_L2(3) <= '1';
  else
   T3_L2(3) <= '0';
  end if;

  if( T3_L1(16)='1' OR T3_L1(17)='1' OR T3_L1(18)='1' OR T3_L1(19)='1' )then
   T3_L2(4) <= '1';
  else
   T3_L2(4) <= '0';
  end if;

  if( T3_L1(20)='1' OR T3_L1(21)='1' OR T3_L1(22)='1' OR T3_L1(23)='1' )then
   T3_L2(5) <= '1';
  else
   T3_L2(5) <= '0';
  end if;

  if( T3_L1(24)='1' OR T3_L1(25)='1' OR T3_L1(26)='1' OR T3_L1(27)='1' )then
   T3_L2(6) <= '1';
  else
   T3_L2(6) <= '0';
  end if;

  if( T3_L1(28)='1' OR T3_L1(29)='1' OR T3_L1(30)='1' OR T3_L1(31)='1' )then
   T3_L2(7) <= '1';
  else
   T3_L2(7) <= '0';
  end if;

  if( T3_L1(32)='1' OR T3_L1(33)='1' OR T3_L1(34)='1' OR T3_L1(35)='1' )then
   T3_L2(8) <= '1';
  else
   T3_L2(8) <= '0';
  end if;

  if( T3_L1(36)='1' OR T3_L1(37)='1' OR T3_L1(38)='1' OR T3_L1(39)='1' )then
   T3_L2(9) <= '1';
  else
   T3_L2(9) <= '0';
  end if;

  if( T3_L1(40)='1' OR T3_L1(41)='1' OR T3_L1(42)='1' OR T3_L1(43)='1' )then
   T3_L2(10) <= '1';
  else
   T3_L2(10) <= '0';
  end if;

  if( T3_L1(44)='1' OR T3_L1(45)='1' OR T3_L1(46)='1' OR T3_L1(47)='1' )then
   T3_L2(11) <= '1';
  else
   T3_L2(11) <= '0';
  end if;

  if( T3_L1(48)='1' OR T3_L1(49)='1' OR T3_L1(50)='1' OR T3_L1(51)='1' )then
   T3_L2(12) <= '1';
  else
   T3_L2(12) <= '0';
  end if;

  if( T3_L1(52)='1' OR T3_L1(53)='1' OR T3_L1(54)='1' OR T3_L1(55)='1' )then
   T3_L2(13) <= '1';
  else
   T3_L2(13) <= '0';
  end if;

  if( T3_L1(56)='1' OR T3_L1(57)='1' OR T3_L1(58)='1' OR T3_L1(59)='1' )then
   T3_L2(14) <= '1';
  else
   T3_L2(14) <= '0';
  end if;

  if( T3_L1(60)='1' OR T3_L1(61)='1' OR T3_L1(62)='1' OR T3_L1(63)='1' )then
   T3_L2(15) <= '1';
  else
   T3_L2(15) <= '0';
  end if;

  if( T3_L1(64)='1' OR T3_L1(65)='1' OR T3_L1(66)='1' OR T3_L1(67)='1' )then
   T3_L2(16) <= '1';
  else
   T3_L2(16) <= '0';
  end if;

  if( T3_L1(68)='1' OR T3_L1(69)='1' OR T3_L1(70)='1' OR T3_L1(71)='1' )then
   T3_L2(17) <= '1';
  else
   T3_L2(17) <= '0';
  end if;

  if( T3_L1(72)='1' OR T3_L1(73)='1' OR T3_L1(74)='1' OR T3_L1(75)='1' )then
   T3_L2(18) <= '1';
  else
   T3_L2(18) <= '0';
  end if;

  if( T3_L1(76)='1' OR T3_L1(77)='1' OR T3_L1(78)='1' OR T3_L1(79)='1' )then
   T3_L2(19) <= '1';
  else
   T3_L2(19) <= '0';
  end if;

  if( T3_L1(80)='1' OR T3_L1(81)='1' OR T3_L1(82)='1' OR T3_L1(83)='1' )then
   T3_L2(20) <= '1';
  else
   T3_L2(20) <= '0';
  end if;

  if( T3_L1(84)='1' OR T3_L1(85)='1' OR T3_L1(86)='1' OR T3_L1(87)='1' )then
   T3_L2(21) <= '1';
  else
   T3_L2(21) <= '0';
  end if;

  if( T3_L1(88)='1' OR T3_L1(89)='1' OR T3_L1(90)='1' OR T3_L1(91)='1' )then
   T3_L2(22) <= '1';
  else
   T3_L2(22) <= '0';
  end if;

  if( T3_L1(92)='1' OR T3_L1(93)='1' OR T3_L1(94)='1' OR T3_L1(95)='1' )then
   T3_L2(23) <= '1';
  else
   T3_L2(23) <= '0';
  end if;

  if( T3_L1(96)='1' OR T3_L1(97)='1' OR T3_L1(98)='1' OR T3_L1(99)='1' )then
   T3_L2(24) <= '1';
  else
   T3_L2(24) <= '0';
  end if;

  if( T3_L1(100)='1' OR T3_L1(101)='1' OR T3_L1(102)='1' OR T3_L1(103)='1' )then
   T3_L2(25) <= '1';
  else
   T3_L2(25) <= '0';
  end if;

  if( T3_L1(104)='1' OR T3_L1(105)='1' OR T3_L1(106)='1' OR T3_L1(107)='1' )then
   T3_L2(26) <= '1';
  else
   T3_L2(26) <= '0';
  end if;

  if( T3_L1(108)='1' OR T3_L1(109)='1' OR T3_L1(110)='1' OR T3_L1(111)='1' )then
   T3_L2(27) <= '1';
  else
   T3_L2(27) <= '0';
  end if;

  if( T3_L1(112)='1' OR T3_L1(113)='1' OR T3_L1(114)='1' OR T3_L1(115)='1' )then
   T3_L2(28) <= '1';
  else
   T3_L2(28) <= '0';
  end if;

  if( T3_L1(116)='1' OR T3_L1(117)='1' OR T3_L1(118)='1' OR T3_L1(119)='1' )then
   T3_L2(29) <= '1';
  else
   T3_L2(29) <= '0';
  end if;

  if( T3_L1(120)='1' OR T3_L1(121)='1' OR T3_L1(122)='1' OR T3_L1(123)='1' )then
   T3_L2(30) <= '1';
  else
   T3_L2(30) <= '0';
  end if;

  if( T3_L1(124)='1' OR T3_L1(125)='1' OR T3_L1(126)='1' OR T3_L1(127)='1' )then
   T3_L2(31) <= '1';
  else
   T3_L2(31) <= '0';
  end if;

  if( T3_L1(128)='1' OR T3_L1(129)='1' OR T3_L1(130)='1' OR T3_L1(131)='1' )then
   T3_L2(32) <= '1';
  else
   T3_L2(32) <= '0';
  end if;

  if( T3_L1(132)='1' OR T3_L1(133)='1' OR T3_L1(134)='1' OR T3_L1(135)='1' )then
   T3_L2(33) <= '1';
  else
   T3_L2(33) <= '0';
  end if;

  if( T3_L1(136)='1' OR T3_L1(137)='1' OR T3_L1(138)='1' OR T3_L1(139)='1' )then
   T3_L2(34) <= '1';
  else
   T3_L2(34) <= '0';
  end if;

  if( T3_L1(140)='1' )then
   T3_L2(35) <= '1';
  else
   T3_L2(35) <= '0';
  end if;

-------------------------END Trigger 3 Level 2--------------------------------

-------------------------BEGIN Trigger 4 Level 2--------------------------------
  if( T4_L1(0)='1' OR T4_L1(1)='1' OR T4_L1(2)='1' OR T4_L1(3)='1' )then
   T4_L2(0) <= '1';
  else
   T4_L2(0) <= '0';
  end if;

  if( T4_L1(4)='1' OR T4_L1(5)='1' OR T4_L1(6)='1' OR T4_L1(7)='1' )then
   T4_L2(1) <= '1';
  else
   T4_L2(1) <= '0';
  end if;

  if( T4_L1(8)='1' OR T4_L1(9)='1' OR T4_L1(10)='1' OR T4_L1(11)='1' )then
   T4_L2(2) <= '1';
  else
   T4_L2(2) <= '0';
  end if;

-------------------------END Trigger 4 Level 2--------------------------------

-------------------------BEGIN Trigger 5 Level 2--------------------------------
  if( T5_L1(0)='1' OR T5_L1(1)='1' OR T5_L1(2)='1' OR T5_L1(3)='1' )then
   T5_L2(0) <= '1';
  else
   T5_L2(0) <= '0';
  end if;

  if( T5_L1(4)='1' OR T5_L1(5)='1' )then
   T5_L2(1) <= '1';
  else
   T5_L2(1) <= '0';
  end if;

-------------------------END Trigger 5 Level 2--------------------------------

 end if;
end process;

lookuptablelv3 : process(c1)
begin
 if c1'event and c1 = '1' then

-------------------------BEGIN Trigger 1 Level 3--------------------------------
  if( T1_L2(0)='1' OR T1_L2(1)='1' OR T1_L2(2)='1' OR T1_L2(3)='1' )then
   T1_L3(0) <= '1';
  else
   T1_L3(0) <= '0';
  end if;

  if( T1_L2(4)='1' OR T1_L2(5)='1' OR T1_L2(6)='1' OR T1_L2(7)='1' )then
   T1_L3(1) <= '1';
  else
   T1_L3(1) <= '0';
  end if;

  if( T1_L2(8)='1' OR T1_L2(9)='1' OR T1_L2(10)='1' OR T1_L2(11)='1' )then
   T1_L3(2) <= '1';
  else
   T1_L3(2) <= '0';
  end if;

  if( T1_L2(12)='1' OR T1_L2(13)='1' OR T1_L2(14)='1' OR T1_L2(15)='1' )then
   T1_L3(3) <= '1';
  else
   T1_L3(3) <= '0';
  end if;

  if( T1_L2(16)='1' OR T1_L2(17)='1' OR T1_L2(18)='1' OR T1_L2(19)='1' )then
   T1_L3(4) <= '1';
  else
   T1_L3(4) <= '0';
  end if;

  if( T1_L2(20)='1' OR T1_L2(21)='1' OR T1_L2(22)='1' OR T1_L2(23)='1' )then
   T1_L3(5) <= '1';
  else
   T1_L3(5) <= '0';
  end if;

  if( T1_L2(24)='1' OR T1_L2(25)='1' OR T1_L2(26)='1' OR T1_L2(27)='1' )then
   T1_L3(6) <= '1';
  else
   T1_L3(6) <= '0';
  end if;

  if( T1_L2(28)='1' OR T1_L2(29)='1' OR T1_L2(30)='1' OR T1_L2(31)='1' )then
   T1_L3(7) <= '1';
  else
   T1_L3(7) <= '0';
  end if;

  if( T1_L2(32)='1' OR T1_L2(33)='1' OR T1_L2(34)='1' OR T1_L2(35)='1' )then
   T1_L3(8) <= '1';
  else
   T1_L3(8) <= '0';
  end if;

-------------------------END Trigger 1 Level 3--------------------------------

-------------------------BEGIN Trigger 2 Level 3--------------------------------
  if( T2_L2(0)='1' OR T2_L2(1)='1' OR T2_L2(2)='1' OR T2_L2(3)='1' )then
   T2_L3(0) <= '1';
  else
   T2_L3(0) <= '0';
  end if;

  if( T2_L2(4)='1' OR T2_L2(5)='1' OR T2_L2(6)='1' OR T2_L2(7)='1' )then
   T2_L3(1) <= '1';
  else
   T2_L3(1) <= '0';
  end if;

  if( T2_L2(8)='1' OR T2_L2(9)='1' OR T2_L2(10)='1' OR T2_L2(11)='1' )then
   T2_L3(2) <= '1';
  else
   T2_L3(2) <= '0';
  end if;

  if( T2_L2(12)='1' OR T2_L2(13)='1' OR T2_L2(14)='1' OR T2_L2(15)='1' )then
   T2_L3(3) <= '1';
  else
   T2_L3(3) <= '0';
  end if;

  if( T2_L2(16)='1' OR T2_L2(17)='1' OR T2_L2(18)='1' OR T2_L2(19)='1' )then
   T2_L3(4) <= '1';
  else
   T2_L3(4) <= '0';
  end if;

  if( T2_L2(20)='1' OR T2_L2(21)='1' OR T2_L2(22)='1' OR T2_L2(23)='1' )then
   T2_L3(5) <= '1';
  else
   T2_L3(5) <= '0';
  end if;

  if( T2_L2(24)='1' OR T2_L2(25)='1' OR T2_L2(26)='1' OR T2_L2(27)='1' )then
   T2_L3(6) <= '1';
  else
   T2_L3(6) <= '0';
  end if;

  if( T2_L2(28)='1' OR T2_L2(29)='1' OR T2_L2(30)='1' OR T2_L2(31)='1' )then
   T2_L3(7) <= '1';
  else
   T2_L3(7) <= '0';
  end if;

  if( T2_L2(32)='1' OR T2_L2(33)='1' OR T2_L2(34)='1' OR T2_L2(35)='1' )then
   T2_L3(8) <= '1';
  else
   T2_L3(8) <= '0';
  end if;

-------------------------END Trigger 2 Level 3--------------------------------

-------------------------BEGIN Trigger 3 Level 3--------------------------------
  if( T3_L2(0)='1' OR T3_L2(1)='1' OR T3_L2(2)='1' OR T3_L2(3)='1' )then
   T3_L3(0) <= '1';
  else
   T3_L3(0) <= '0';
  end if;

  if( T3_L2(4)='1' OR T3_L2(5)='1' OR T3_L2(6)='1' OR T3_L2(7)='1' )then
   T3_L3(1) <= '1';
  else
   T3_L3(1) <= '0';
  end if;

  if( T3_L2(8)='1' OR T3_L2(9)='1' OR T3_L2(10)='1' OR T3_L2(11)='1' )then
   T3_L3(2) <= '1';
  else
   T3_L3(2) <= '0';
  end if;

  if( T3_L2(12)='1' OR T3_L2(13)='1' OR T3_L2(14)='1' OR T3_L2(15)='1' )then
   T3_L3(3) <= '1';
  else
   T3_L3(3) <= '0';
  end if;

  if( T3_L2(16)='1' OR T3_L2(17)='1' OR T3_L2(18)='1' OR T3_L2(19)='1' )then
   T3_L3(4) <= '1';
  else
   T3_L3(4) <= '0';
  end if;

  if( T3_L2(20)='1' OR T3_L2(21)='1' OR T3_L2(22)='1' OR T3_L2(23)='1' )then
   T3_L3(5) <= '1';
  else
   T3_L3(5) <= '0';
  end if;

  if( T3_L2(24)='1' OR T3_L2(25)='1' OR T3_L2(26)='1' OR T3_L2(27)='1' )then
   T3_L3(6) <= '1';
  else
   T3_L3(6) <= '0';
  end if;

  if( T3_L2(28)='1' OR T3_L2(29)='1' OR T3_L2(30)='1' OR T3_L2(31)='1' )then
   T3_L3(7) <= '1';
  else
   T3_L3(7) <= '0';
  end if;

  if( T3_L2(32)='1' OR T3_L2(33)='1' OR T3_L2(34)='1' OR T3_L2(35)='1' )then
   T3_L3(8) <= '1';
  else
   T3_L3(8) <= '0';
  end if;

-------------------------END Trigger 3 Level 3--------------------------------

-------------------------BEGIN Trigger 4 Level 3--------------------------------
  if( T4_L2(0)='1' OR T4_L2(1)='1' OR T4_L2(2)='1' )then
   T4_L3(0) <= '1';
  else
   T4_L3(0) <= '0';
  end if;

-------------------------END Trigger 4 Level 3--------------------------------

-------------------------BEGIN Trigger 5 Level 3--------------------------------
  if( T5_L2(0)='1' OR T5_L2(1)='1' )then
   T5_L3(0) <= '1';
  else
   T5_L3(0) <= '0';
  end if;

-------------------------END Trigger 5 Level 3--------------------------------

 end if;
end process;

lookuptablelv4 : process(c1)
begin
 if c1'event and c1 = '1' then

-------------------------BEGIN Trigger 1 Level 4--------------------------------
  if( T1_L3(0)='1' OR T1_L3(1)='1' OR T1_L3(2)='1' OR T1_L3(3)='1' )then
   T1_L4(0) <= '1';
  else
   T1_L4(0) <= '0';
  end if;

  if( T1_L3(4)='1' OR T1_L3(5)='1' OR T1_L3(6)='1' OR T1_L3(7)='1' )then
   T1_L4(1) <= '1';
  else
   T1_L4(1) <= '0';
  end if;

  if( T1_L3(8)='1' )then
   T1_L4(2) <= '1';
  else
   T1_L4(2) <= '0';
  end if;

-------------------------END Trigger 1 Level 4--------------------------------

-------------------------BEGIN Trigger 2 Level 4--------------------------------
  if( T2_L3(0)='1' OR T2_L3(1)='1' OR T2_L3(2)='1' OR T2_L3(3)='1' )then
   T2_L4(0) <= '1';
  else
   T2_L4(0) <= '0';
  end if;

  if( T2_L3(4)='1' OR T2_L3(5)='1' OR T2_L3(6)='1' OR T2_L3(7)='1' )then
   T2_L4(1) <= '1';
  else
   T2_L4(1) <= '0';
  end if;

  if( T2_L3(8)='1' )then
   T2_L4(2) <= '1';
  else
   T2_L4(2) <= '0';
  end if;

-------------------------END Trigger 2 Level 4--------------------------------

-------------------------BEGIN Trigger 3 Level 4--------------------------------
  if( T3_L3(0)='1' OR T3_L3(1)='1' OR T3_L3(2)='1' OR T3_L3(3)='1' )then
   T3_L4(0) <= '1';
  else
   T3_L4(0) <= '0';
  end if;

  if( T3_L3(4)='1' OR T3_L3(5)='1' OR T3_L3(6)='1' OR T3_L3(7)='1' )then
   T3_L4(1) <= '1';
  else
   T3_L4(1) <= '0';
  end if;

  if( T3_L3(8)='1' )then
   T3_L4(2) <= '1';
  else
   T3_L4(2) <= '0';
  end if;

-------------------------END Trigger 3 Level 4--------------------------------

-------------------------BEGIN Trigger 4 Level 4--------------------------------
  if( T4_L3(0)='1' )then
   T4_L4(0) <= '1';
  else
   T4_L4(0) <= '0';
  end if;

-------------------------END Trigger 4 Level 4--------------------------------

-------------------------BEGIN Trigger 5 Level 4--------------------------------
  if( T5_L3(0)='1' )then
   T5_L4(0) <= '1';
  else
   T5_L4(0) <= '0';
  end if;

-------------------------END Trigger 5 Level 4--------------------------------

 end if;
end process;

lookuptablelv5 : process(c1)
begin
 if c1'event and c1 = '1' then

  if( T1_L4(0)='1' OR T1_L4(1)='1' OR T1_L4(2)='1' )then
   F_lvl_5(0) <= '1';
  else
   F_lvl_5(0) <= '0';
  end if;

  if( T2_L4(0)='1' OR T2_L4(1)='1' OR T2_L4(2)='1' )then
   F_lvl_5(1) <= '1';
  else
   F_lvl_5(1) <= '0';
  end if;

  if( T3_L4(0)='1' OR T3_L4(1)='1' OR T3_L4(2)='1' )then
   F_lvl_5(2) <= '1';
  else
   F_lvl_5(2) <= '0';
  end if;

  if( T4_L4(0)='1' )then
   F_lvl_5(3) <= '1';
  else
   F_lvl_5(3) <= '0';
  end if;

  if( T5_L4(0)='1' )then
   F_lvl_5(4) <= '1';
  else
   F_lvl_5(4) <= '0';
  end if;

 end if;
end process;

END rtl;
