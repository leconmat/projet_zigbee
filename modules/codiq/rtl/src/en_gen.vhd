library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity en_gen is
    port 
	(
	resetn  : in  std_logic;
    clk_in  : in  std_logic;
    clk_out : out std_logic
    );
end entity en_gen;

architecture Behavioral of en_gen is

   signal cpt : std_logic_vector(2 downto 0);

begin

    process(clk_in, resetn)
    begin
		if(resetn = '0') then
			clk_out 		<= '0';
			cpt				<= (others => '0');
    else
	  	if(rising_edge(clk_in)) then           
			  if(cpt = "100") then
		  	  cpt		<= (others => '0');
				  clk_out <= '1';
			  else
				  cpt 	<= cpt + '1';
				  clk_out <= '0';
			  end if;
		  end if;
    end if;
    end process;

 end Behavioral;

