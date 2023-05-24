library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity en_gen is
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic
    );
end entity en_gen;

architecture Behavioral of en_gen is
    signal   cpt       : integer := 0;
    signal   s_clk_out : std_logic := '0';

begin

    process(clk_in)
    begin
        if(rising_edge(clk_in)) then           
            if(cpt >= 4) then
                cpt       <= 0;
                s_clk_out <= not(s_clk_out);
            else
		cpt <= cpt + 1;
            end if;
        end if;
    end process;

clk_out   <= s_clk_out;

end architecture Behavioral;
