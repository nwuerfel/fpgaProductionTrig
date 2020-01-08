LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY code_460 IS
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
END code_460 ;
ARCHITECTURE rtl OF code_460 IS
signal A     : std_logic_vector(31 downto 0);
signal Aa     : std_logic_vector(31 downto 0);
signal B     : std_logic_vector(31 downto 0);
signal Ba     : std_logic_vector(31 downto 0);
signal C     : std_logic_vector(31 downto 0);
signal D     : std_logic_vector(31 downto 0);
signal Da     : std_logic_vector(31 downto 0);
signal E     : std_logic_vector(31 downto 0);
signal Ea     : std_logic_vector(31 downto 0);
signal Eb     : std_logic_vector(31 downto 0);
signal F     : std_logic_vector(31 downto 0);
signal G     : std_logic_vector(1 downto 0);
        signal ST2temp_lv1: std_logic_vector(   3 downto 0);
        signal ST4temp_lv1: std_logic_vector(   3 downto 0);
        signal ST2temp_lv2: std_logic_vector(   0 downto 0);
        signal ST4temp_lv2: std_logic_vector(   0 downto 0);
        signal ST2temp_lv3: std_logic_vector(   0 downto 0);
        signal ST4temp_lv3: std_logic_vector(   0 downto 0);
        signal ST2temp_lv4: std_logic_vector(   0 downto 0);
        signal ST4temp_lv4: std_logic_vector(   0 downto 0);
        signal ST2temp_lv5: std_logic_vector(   0 downto 0);
        signal ST4temp_lv5: std_logic_vector(   0 downto 0);
        signal ST2temp_lv6: std_logic_vector(   0 downto 0);
        signal ST4temp_lv6: std_logic_vector(   0 downto 0);
        signal ST2temp_lv7: std_logic_vector(   0 downto 0);
        signal ST4temp_lv7: std_logic_vector(   0 downto 0);
        signal temp_lv8: std_logic_vector(  1 downto 0);
BEGIN
   Aa (11 downto 0) <= A_DIN_L (13 downto 2);
   Aa (22 downto 12) <= A_DIN_L (28 downto 18);
   Ba (15 downto 0) <= B_DIN_L (15 downto 0);
   Da (15 downto 0) <= B_DIN_L (31 downto 16);
   Ea (7 downto 0) <= D_DIN_L (23 downto 16);
   Ea (15 downto 8) <= D_DIN_L (7 downto 0);
   Eb (7 downto 0) <= D_DIN_L (31 downto 24);
   Eb (15 downto 8) <= D_DIN_L (15 downto 8);
   F_DOUT_L(1 downto 0) <= temp_lv8( 1 downto 0);
   C_DOUT_L(1 downto 0) <= temp_lv8( 1 downto 0);
lookuptable_LV0 : process(c1)
begin
 if c1'event and c1='1' then
        if(Ea( 0)='1' OR Eb( 0)='1' )then
          E( 0)<='1';
          else
          E( 0)<='0';
          end if;
        if(Ea( 1)='1' OR Eb( 1)='1' )then
          E( 1)<='1';
          else
          E( 1)<='0';
          end if;
        if(Ea( 2)='1' OR Eb( 2)='1' )then
          E( 2)<='1';
          else
          E( 2)<='0';
          end if;
        if(Ea( 3)='1' OR Eb( 3)='1' )then
          E( 3)<='1';
          else
          E( 3)<='0';
          end if;
        if(Ea( 4)='1' OR Eb( 4)='1' )then
          E( 4)<='1';
          else
          E( 4)<='0';
          end if;
        if(Ea( 5)='1' OR Eb( 5)='1' )then
          E( 5)<='1';
          else
          E( 5)<='0';
          end if;
        if(Ea( 6)='1' OR Eb( 6)='1' )then
          E( 6)<='1';
          else
          E( 6)<='0';
          end if;
        if(Ea( 7)='1' OR Eb( 7)='1' )then
          E( 7)<='1';
          else
          E( 7)<='0';
          end if;
        if(Ea( 8)='1' OR Eb( 8)='1' )then
          E( 8)<='1';
          else
          E( 8)<='0';
          end if;
        if(Ea( 9)='1' OR Eb( 9)='1' )then
          E( 9)<='1';
          else
          E( 9)<='0';
          end if;
        if(Ea(10)='1' OR Eb(10)='1' )then
          E(10)<='1';
          else
          E(10)<='0';
          end if;
        if(Ea(11)='1' OR Eb(11)='1' )then
          E(11)<='1';
          else
          E(11)<='0';
          end if;
        if(Ea(12)='1' OR Eb(12)='1' )then
          E(12)<='1';
          else
          E(12)<='0';
          end if;
        if(Ea(13)='1' OR Eb(13)='1' )then
          E(13)<='1';
          else
          E(13)<='0';
          end if;
        if(Ea(14)='1' OR Eb(14)='1' )then
          E(14)<='1';
          else
          E(14)<='0';
          end if;
        if(Ea(15)='1' OR Eb(15)='1' )then
          E(15)<='1';
          else
          E(15)<='0';
          end if;
        if(Da( 0)='1' )then
          D( 0)<='1';
          else
          D( 0)<='0';
          end if;
        if(Da( 1)='1' )then
          D( 1)<='1';
          else
          D( 1)<='0';
          end if;
        if(Da( 2)='1' )then
          D( 2)<='1';
          else
          D( 2)<='0';
          end if;
        if(Da( 3)='1' )then
          D( 3)<='1';
          else
          D( 3)<='0';
          end if;
        if(Da( 4)='1' )then
          D( 4)<='1';
          else
          D( 4)<='0';
          end if;
        if(Da( 5)='1' )then
          D( 5)<='1';
          else
          D( 5)<='0';
          end if;
        if(Da( 6)='1' )then
          D( 6)<='1';
          else
          D( 6)<='0';
          end if;
        if(Da( 7)='1' )then
          D( 7)<='1';
          else
          D( 7)<='0';
          end if;
        if(Da( 8)='1' )then
          D( 8)<='1';
          else
          D( 8)<='0';
          end if;
        if(Da( 9)='1' )then
          D( 9)<='1';
          else
          D( 9)<='0';
          end if;
        if(Da(10)='1' )then
          D(10)<='1';
          else
          D(10)<='0';
          end if;
        if(Da(11)='1' )then
          D(11)<='1';
          else
          D(11)<='0';
          end if;
        if(Da(12)='1' )then
          D(12)<='1';
          else
          D(12)<='0';
          end if;
        if(Da(13)='1' )then
          D(13)<='1';
          else
          D(13)<='0';
          end if;
        if(Da(14)='1' )then
          D(14)<='1';
          else
          D(14)<='0';
          end if;
        if(Da(15)='1' )then
          D(15)<='1';
          else
          D(15)<='0';
          end if;
        if(Ba( 0)='1' )then
          B( 0)<='1';
          else
          B( 0)<='0';
          end if;
        if(Ba( 1)='1' )then
          B( 1)<='1';
          else
          B( 1)<='0';
          end if;
        if(Ba( 2)='1' )then
          B( 2)<='1';
          else
          B( 2)<='0';
          end if;
        if(Ba( 3)='1' )then
          B( 3)<='1';
          else
          B( 3)<='0';
          end if;
        if(Ba( 4)='1' )then
          B( 4)<='1';
          else
          B( 4)<='0';
          end if;
        if(Ba( 5)='1' )then
          B( 5)<='1';
          else
          B( 5)<='0';
          end if;
        if(Ba( 6)='1' )then
          B( 6)<='1';
          else
          B( 6)<='0';
          end if;
        if(Ba( 7)='1' )then
          B( 7)<='1';
          else
          B( 7)<='0';
          end if;
        if(Ba( 8)='1' )then
          B( 8)<='1';
          else
          B( 8)<='0';
          end if;
        if(Ba( 9)='1' )then
          B( 9)<='1';
          else
          B( 9)<='0';
          end if;
        if(Ba(10)='1' )then
          B(10)<='1';
          else
          B(10)<='0';
          end if;
        if(Ba(11)='1' )then
          B(11)<='1';
          else
          B(11)<='0';
          end if;
        if(Ba(12)='1' )then
          B(12)<='1';
          else
          B(12)<='0';
          end if;
        if(Ba(13)='1' )then
          B(13)<='1';
          else
          B(13)<='0';
          end if;
        if(Ba(14)='1' )then
          B(14)<='1';
          else
          B(14)<='0';
          end if;
        if(Ba(15)='1' )then
          B(15)<='1';
          else
          B(15)<='0';
          end if;
        if(Aa( 0)='1' )then
          A( 0)<='1';
          else
          A( 0)<='0';
          end if;
        if(Aa( 1)='1' )then
          A( 1)<='1';
          else
          A( 1)<='0';
          end if;
        if(Aa( 2)='1' )then
          A( 2)<='1';
          else
          A( 2)<='0';
          end if;
        if(Aa( 3)='1' )then
          A( 3)<='1';
          else
          A( 3)<='0';
          end if;
        if(Aa( 4)='1' )then
          A( 4)<='1';
          else
          A( 4)<='0';
          end if;
        if(Aa( 5)='1' )then
          A( 5)<='1';
          else
          A( 5)<='0';
          end if;
        if(Aa( 6)='1' )then
          A( 6)<='1';
          else
          A( 6)<='0';
          end if;
        if(Aa( 7)='1' )then
          A( 7)<='1';
          else
          A( 7)<='0';
          end if;
        if(Aa( 8)='1' )then
          A( 8)<='1';
          else
          A( 8)<='0';
          end if;
        if(Aa( 9)='1' )then
          A( 9)<='1';
          else
          A( 9)<='0';
          end if;
        if(Aa(10)='1' )then
          A(10)<='1';
          else
          A(10)<='0';
          end if;
        if(Aa(11)='1' )then
          A(11)<='1';
          else
          A(11)<='0';
          end if;
        if(Aa(12)='1' )then
          A(12)<='1';
          else
          A(12)<='0';
          end if;
        if(Aa(13)='1' )then
          A(13)<='1';
          else
          A(13)<='0';
          end if;
        if(Aa(14)='1' )then
          A(14)<='1';
          else
          A(14)<='0';
          end if;
        if(Aa(15)='1' )then
          A(15)<='1';
          else
          A(15)<='0';
          end if;
        if(Aa(16)='1' )then
          A(16)<='1';
          else
          A(16)<='0';
          end if;
        if(Aa(17)='1' )then
          A(17)<='1';
          else
          A(17)<='0';
          end if;
        if(Aa(18)='1' )then
          A(18)<='1';
          else
          A(18)<='0';
          end if;
        if(Aa(19)='1' )then
          A(19)<='1';
          else
          A(19)<='0';
          end if;
        if(Aa(20)='1' )then
          A(20)<='1';
          else
          A(20)<='0';
          end if;
        if(Aa(21)='1' )then
          A(21)<='1';
          else
          A(21)<='0';
          end if;
        if(Aa(22)='1' )then
          A(22)<='1';
          else
          A(22)<='0';
          end if;
 end if;
end process;
lookuptable_LV1 : process(c1)
begin
 if c1'event and c1='1' then
        if(B(15)='1' OR B(14)='1' OR B(13)='1' OR B(12)='1' )then
          ST2temp_lv1(0)<='1';
          else
          ST2temp_lv1(0)<='0';
          end if;
        if(B(11)='1' OR B(10)='1' OR B( 9)='1' OR B( 8)='1' )then
          ST2temp_lv1(1)<='1';
          else
          ST2temp_lv1(1)<='0';
          end if;
        if(B( 7)='1' OR B( 6)='1' OR B( 5)='1' OR B( 4)='1' )then
          ST2temp_lv1(2)<='1';
          else
          ST2temp_lv1(2)<='0';
          end if;
        if(B( 3)='1' OR B( 2)='1' OR B( 1)='1' OR B( 0)='1' )then
          ST2temp_lv1(3)<='1';
          else
          ST2temp_lv1(3)<='0';
          end if;
        if(E(15)='1' OR E(14)='1' OR E(13)='1' OR E(12)='1' )then
          ST4temp_lv1(0)<='1';
          else
          ST4temp_lv1(0)<='0';
          end if;
        if(E(11)='1' OR E(10)='1' OR E( 9)='1' OR E( 8)='1' )then
          ST4temp_lv1(1)<='1';
          else
          ST4temp_lv1(1)<='0';
          end if;
        if(E( 7)='1' OR E( 6)='1' OR E( 5)='1' OR E( 4)='1' )then
          ST4temp_lv1(2)<='1';
          else
          ST4temp_lv1(2)<='0';
          end if;
        if(E( 3)='1' OR E( 2)='1' OR E( 1)='1' OR E( 0)='1' )then
          ST4temp_lv1(3)<='1';
          else
          ST4temp_lv1(3)<='0';
          end if;
 end if;
end process;
lookuptable_LV2 : process(c1)
begin
 if c1'event and c1='1' then
      if(ST2temp_lv1(   0)='1' OR ST2temp_lv1(   1)='1' OR ST2temp_lv1(   2)='1' OR ST2temp_lv1(   3)='1' )then
		  ST2temp_lv2(   0)<='1';
		  else
		  ST2temp_lv2(   0)<='0';
		  end if;
      if(ST4temp_lv1(   0)='1' OR ST4temp_lv1(   1)='1' OR ST4temp_lv1(   2)='1' OR ST4temp_lv1(   3)='1' )then
		  ST4temp_lv2(   0)<='1';
		  else
		  ST4temp_lv2(   0)<='0';
		  end if;
 end if;
end process;
lookuptable_LV3 : process(c1)
begin
 if c1'event and c1='1' then
      if(ST2temp_lv2(   0)='1' )then
		  ST2temp_lv3(   0)<='1';
		  else
		  ST2temp_lv3(   0)<='0';
		  end if;
      if(ST4temp_lv2(   0)='1' )then
		  ST4temp_lv3(   0)<='1';
		  else
		  ST4temp_lv3(   0)<='0';
		  end if;
 end if;
end process;
lookuptable_LV4 : process(c1)
begin
 if c1'event and c1='1' then
      if(ST2temp_lv3(   0)='1' )then
		  ST2temp_lv4(   0)<='1';
		  else
		  ST2temp_lv4(   0)<='0';
		  end if;
      if(ST4temp_lv3(   0)='1' )then
		  ST4temp_lv4(   0)<='1';
		  else
		  ST4temp_lv4(   0)<='0';
		  end if;
 end if;
end process;
lookuptable_LV5 : process(c1)
begin
 if c1'event and c1='1' then
      if(ST2temp_lv4(   0)='1' )then
		  ST2temp_lv5(   0)<='1';
		  else
		  ST2temp_lv5(   0)<='0';
		  end if;
      if(ST4temp_lv4(   0)='1' )then
		  ST4temp_lv5(   0)<='1';
		  else
		  ST4temp_lv5(   0)<='0';
		  end if;
 end if;
end process;
lookuptable_LV6 : process(c1)
begin
 if c1'event and c1='1' then
      if(ST2temp_lv5(   0)='1' )then
		  ST2temp_lv6(   0)<='1';
		  else
		  ST2temp_lv6(   0)<='0';
		  end if;
      if(ST4temp_lv5(   0)='1' )then
		  ST4temp_lv6(   0)<='1';
		  else
		  ST4temp_lv6(   0)<='0';
		  end if;
 end if;
end process;
lookuptable_LV7 : process(c1)
begin
 if c1'event and c1='1' then
      if(ST2temp_lv6(   0)='1' )then
		  ST2temp_lv7(   0)<='1';
		  else
		  ST2temp_lv7(   0)<='0';
		  end if;
      if(ST4temp_lv6(   0)='1' )then
		  ST4temp_lv7(   0)<='1';
		  else
		  ST4temp_lv7(   0)<='0';
		  end if;
 end if;
end process;
lookuptable_LV8 : process(c1)
begin
  if c1'event and c1='1' then
		  if(ST2temp_lv7(   0) = '1') then
		    temp_lv8( 0) <= '1';
		    else
		    temp_lv8( 0) <= '0';
		    end if;
		  if(ST4temp_lv7(   0) = '1') then
		    temp_lv8( 1) <= '1';
		    else
		    temp_lv8( 1) <= '0';
		    end if;
  end if;
end process;
end rtl;