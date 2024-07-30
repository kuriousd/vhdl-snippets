


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- VHDL snippet base on Tales from Beyond the Register Map Blog by Olof Kindgren
-- url : https://blog.award-winning.me/2017/11/resetting-reset-handling.html?m=1
-- Tested with Vivado 2022.1 Synthesizer
-- This blog entry is just gold, it blowed my mind! I've also suffered the heart attack!

entity reset is
    generic (
        RESET_CASE : positive := 3 -- Best solution
    );
    port (
        rst     : in std_logic;
        clk     : in std_logic;
        i_valid : in std_logic;
        i_data  : in std_logic_vector(3 downto 0);
        o_valid : out std_logic;
        o_data  : out std_logic_vector(3 downto 0)      
);
end entity;

architecture rtl of reset is
    signal count : unsigned(2 downto 0);
    signal r_data : unsigned(3 downto 0);
    
begin
    case_1 : if RESET_CASE = 1 generate
        process(clk)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    o_data <= (others => '0');
                    r_data <= (others => '0');
                    o_valid <= '0';
                    count <= (others => '0');
                else
                    if (i_valid = '1') then
                        count <= count +1;
                    end if;
                    r_data <= unsigned(i_data);
                    o_data <= std_logic_vector(r_data + count);
                    o_valid <= i_valid;
                end if;
            end if;
        end process;    
    end generate;
    
    case_2 : if RESET_CASE = 2 generate
        process(clk)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
--                    o_data <= (others => '0');
--                    r_data <= (others => '0');
                    o_valid <= '0';
                    count <= (others => '0');
                else
                    if (i_valid = '1') then
                        count <= count +1;
                    end if;
                    r_data <= unsigned(i_data);
                    o_data <= std_logic_vector(r_data + count);
                    o_valid <= i_valid;
                end if;
            end if;
        end process;    
    end generate;
      
    case_3 : if RESET_CASE = 3 generate
        process(clk)
        begin
            if (rising_edge(clk)) then
                if (i_valid = '1') then
                    count <= count +1;
                end if;
                r_data <= unsigned(i_data);
                o_data <= std_logic_vector(r_data + count);
                o_valid <= i_valid;
                if (rst = '1') then
--                    o_data <= (others => '0');
--                    r_data <= (others => '0');
                    o_valid <= '0';
                    count <= (others => '0');
                end if;
            end if;
        end process;    
    end generate;
    
    -- case not present in blog entry but mentioned by Olof
    -- "What should we do then? 
    -- One way is to replicate the assignments to data_r and 
    -- data_o also in the reset section, but that's pretty awkward. 
    -- The real solution is much simpler, 
    -- but will probably cause heart attacks among conservative RTL designers"
    -- This heart attacking solution is case 3!
    case_4 : if RESET_CASE = 4 generate
        process(clk)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    r_data <= unsigned(i_data);
                    o_data <= std_logic_vector(r_data + count);
                    o_valid <= '0';
                    count <= (others => '0');
                else
                    if (i_valid = '1') then
                        count <= count +1;
                    end if;
                    r_data <= unsigned(i_data);
                    o_data <= std_logic_vector(r_data + count);
                    o_valid <= i_valid;
                end if;
            end if;
        end process;    
    end generate;
end architecture;
