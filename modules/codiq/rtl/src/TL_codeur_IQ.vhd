library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.ALL;
    use ieee.std_logic_unsigned.ALL;

entity TL_codeur_IQ is
  port 
  (
   resetn       : in   std_logic; 				     -- reset general
   clk	        : in   std_logic;					 -- signal de clk 50 MHz 
   en_2MHz      : in   std_logic; 				     -- signal enable 2 MHz reçu depuis le bloc FIFO a chaque envoi de bit de data b_in
   b_in         : in   std_logic;                    -- data reçue bit a bit via la FIFO
   mem_state    : in   std_logic; 		-- signal 2 bits provenant de la FIFO indiquant si leur memoire est vide ou pas ("00" memoire vide)
   dac_ready    : in   std_logic;					 -- signal d'etat ready du DAC (ready a '1')
   IBB          : out  std_logic_vector(3 downto 0); -- sortie IBB
   QBB          : out  std_logic_vector(3 downto 0); -- sortie QBB
   en_dac		: out  std_logic;
   ready        : out  std_logic					 -- signal ready a envoyer a la fifo
   );
end TL_codeur_IQ;

architecture TL_codeur_IQ_arch of TL_codeur_IQ is

  signal en_10MHz : std_logic := '0';

component zigbee_fsm is
    port
    (
	 clk	      : in   std_logic;					   -- signal de clk 50 MHz 
     en_10MHz     : in   std_logic; 			       -- signal enable 10 MHz servant de clk genere par la clk 50 MHz dans le bloc en_gen.vhd
	 en           : in   std_logic; 				   -- signal enable 2 MHz reçu depuis le bloc FIFO a chaque envoi de bit de data b_in
	 b_in         : in   std_logic;                    -- data reçue bit a bit via la FIFO
     resetn       : in   std_logic; 				   -- reset actif a 0
	 mem_state    : in   std_logic; 				   -- signal 2 bits provenant de la FIFO indiquant si leur memoire est vide ou pas ("01" memoire vide)
	 dac_ready    : in   std_logic;		 	  		   -- signal d'etat ready du DAC (ready a '1')
	 ready		  : out  std_logic;
	 en_dac		  : out  std_logic;		  
     IBB          : out  std_logic_vector(3 downto 0); -- sortie I
	 QBB          : out  std_logic_vector(3 downto 0)  -- sortie Q
    );
end component;

component en_gen is
    port (
		resetn  : in  std_logic;
        clk_in  : in  std_logic;
        clk_out : out std_logic
    );
end component en_gen;  
  
begin



-- ******** affectation signaux ********


-- *************************************
fsm_mapping : zigbee_fsm -- port map du bloc fsm
    port map 
    (
	 clk	    => clk,
     en_10MHz   => en_10MHz,
	 en         => en_2MHz,
	 b_in       => b_in,
     resetn     => resetn,
	 mem_state  => mem_state,
	 dac_ready  => dac_ready,
     IBB        => IBB,
	 QBB        => QBB,
	 en_dac		=> en_dac,
	 ready		=> ready
    );
	
en_gen_map : en_gen -- port map du bloc gen_enable
	port map
	(
	 resetn   => resetn,
	 clk_in	  => clk,
	 clk_out  => en_10MHz
	 );
	   
end TL_codeur_IQ_arch;
	 
