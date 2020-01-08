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
        signal ST2T: std_logic_vector(0 downto 0);
        signal ST4T: std_logic_vector(0 downto 0);
        signal ST2B: std_logic_vector(0 downto 0);
        signal ST4B: std_logic_vector(0 downto 0);
        signal T1_L1: std_logic_vector(0 downto 0);
        signal T1_L2: std_logic_vector(0 downto 0);
        signal T1_L3: std_logic_vector(0 downto 0);
        signal T1_L4: std_logic_vector(0 downto 0);
        signal T2_L1: std_logic_vector(0 downto 0);
        signal T2_L2: std_logic_vector(0 downto 0);
        signal T2_L3: std_logic_vector(0 downto 0);
        signal T2_L4: std_logic_vector(0 downto 0);
        signal T3_L1: std_logic_vector(0 downto 0);
        signal T3_L2: std_logic_vector(0 downto 0);
        signal T3_L3: std_logic_vector(0 downto 0);
        signal T3_L4: std_logic_vector(0 downto 0);
        signal T4_L1: std_logic_vector(0 downto 0);
        signal T4_L2: std_logic_vector(0 downto 0);
        signal T4_L3: std_logic_vector(0 downto 0);
        signal T4_L4: std_logic_vector(0 downto 0);
        signal T5_L1: std_logic_vector(0 downto 0);
        signal T5_L2: std_logic_vector(0 downto 0);
        signal T5_L3: std_logic_vector(0 downto 0);
        signal T5_L4: std_logic_vector(0 downto 0);
        signal F_lvl_5: std_logic_vector(31 downto 0);
BEGIN
        -- ST2 is in L1Out(0) and ST4 in L1Out(1)
        ST2T (0) <= A_DIN_L (0);
        ST4T (0) <= A_DIN_L (1);
        ST2B (0) <= B_DIN_L (0);
        ST4B (0) <= B_DIN_L (1);
        F_DOUT_L (31 downto 0) <= F_lvl_5 (31 downto 0);
        C_DOUT_L (31 downto 0) <= F_lvl_5 (31 downto 0);

-- L1 generates a yes no bit for ST2 and ST4 for each half....

--    OUTPUT TRIGGERS
--  1- ALL NIM: as long as ST2 and ST4 have any hit, we fire
--  2- TT: hits in ST2 and ST4 top halves
--  3- TB: hits in ST2 and ST4 top then bottom
--  4- BT: hits in ST2 and ST4 bottom then top
--  5- BB: hits in ST2 and ST4 bottom then bottom

lookuptablelv1 : process(c1)
begin
 if c1'event and c1 = '1' then
    -- Trig 1
    if( (ST2T(0)='1' OR ST2B(0)='1') AND (ST4T(0)='1' OR ST4B(0)='1') )then
        T1_L1(0) <= '1';
    else
        T1_L1(0) <= '0';
    end if;
    -- Trig 2 
    if( ST2T(0)='1' AND ST4T(0)='1')then
        T2_L1(0) <= '1';
    else
        T2_L1(0) <= '0';
    end if;
    -- Trig 3
    if( ST2T(0)='1' AND ST4B(0)='1')then
        T3_L1(0) <= '1';
    else
        T3_L1(0) <= '0';
    end if;
    -- Trig 4
    if( ST2B(0)='1' AND ST4T(0)='1')then
        T4_L1(0) <= '1';
    else
        T4_L1(0) <= '0';
    end if;
    -- Trig 5
    if( ST2B(0)='1' AND ST4B(0)='1')then
        T5_L1(0) <= '1';
    else
        T5_L1(0) <= '0';
    end if;
 end if;
end process;

lookuptablelv2 : process(c1)
begin
 if c1'event and c1 = '1' then
    -- Trig 1
    if( T1_L1(0) = '1' )then
        T1_L2(0) <= '1';
    else
        T1_L2(0) <= '0';
    end if;
    -- Trig 2
    if( T2_L1(0) = '1' )then
        T2_L2(0) <= '1';
    else
        T2_L2(0) <= '0';
    end if;
    -- Trig 3
    if( T3_L1(0) = '1' )then
        T3_L2(0) <= '1';
    else
        T3_L2(0) <= '0';
    end if;
    -- Trig 4
    if( T4_L1(0) = '1' )then
        T4_L2(0) <= '1';
    else
        T4_L2(0) <= '0';
    end if;
    -- Trig 5
    if( T5_L1(0) = '1' )then
        T5_L2(0) <= '1';
    else
        T5_L2(0) <= '0';
    end if;
 end if;
end process;

lookuptablelv3 : process(c1)
begin
 if c1'event and c1 = '1' then
    -- Trig 1
    if( T1_L2(0) = '1' )then
        T1_L3(0) <= '1';
    else
        T1_L3(0) <= '0';
    end if;
    -- Trig 2
    if( T2_L2(0) = '1' )then
        T2_L3(0) <= '1';
    else
        T2_L3(0) <= '0';
    end if;
    -- Trig 3
    if( T3_L2(0) = '1' )then
        T3_L3(0) <= '1';
    else
        T3_L3(0) <= '0';
    end if;
    -- Trig 4
    if( T4_L2(0) = '1' )then
        T4_L3(0) <= '1';
    else
        T4_L3(0) <= '0';
    end if;
    -- Trig 5
    if( T5_L2(0) = '1' )then
        T5_L3(0) <= '1';
    else
        T5_L3(0) <= '0';
    end if;
 end if;
end process;

lookuptablelv4 : process(c1)
begin
 if c1'event and c1 = '1' then
    -- Trig 1
    if( T1_L3(0) = '1' )then
        T1_L4(0) <= '1';
    else
        T1_L4(0) <= '0';
    end if;
    -- Trig 2
    if( T2_L3(0) = '1' )then
        T2_L4(0) <= '1';
    else
        T2_L4(0) <= '0';
    end if;
    -- Trig 3
    if( T3_L3(0) = '1' )then
        T3_L4(0) <= '1';
    else
        T3_L4(0) <= '0';
    end if;
    -- Trig 4
    if( T4_L3(0) = '1' )then
        T4_L4(0) <= '1';
    else
        T4_L4(0) <= '0';
    end if;
    -- Trig 5
    if( T5_L3(0) = '1' )then
        T5_L4(0) <= '1';
    else
        T5_L4(0) <= '0';
    end if;
 end if;
end process;

lookuptablelv5 : process(c1)
begin
 if c1'event and c1 = '1' then
    -- Trig 1
    if( T1_L4(0) = '1' )then
        F_lvl_5(0) <= '1';
    else
        F_lvl_5(0) <= '0';
    end if;
    -- Trig 2
    if( T2_L4(0) = '1' )then
        F_lvl_5(1) <= '1';
    else
        F_lvl_5(1) <= '0';
    end if;
    -- Trig 3
    if( T3_L4(0) = '1' )then
        F_lvl_5(2) <= '1';
    else
        F_lvl_5(2) <= '0';
    end if;
    -- Trig 4
    if( T4_L4(0) = '1' )then
        F_lvl_5(3) <= '1';
    else
        F_lvl_5(3) <= '0';
    end if;
    -- Trig 5
    if( T5_L4(0) = '1' )then
        F_lvl_5(4) <= '1';
    else
        F_lvl_5(4) <= '0';
    end if;
 end if;
end process;
END rtl;
