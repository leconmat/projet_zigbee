library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
--    use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;


entity zigbee_fsm is
    port
(
        clk	      : in   std_logic;					   -- signal de clk 50 MHz 
        en_10MHz     : in   std_logic; 			       -- signal enable 10 MHz servant de clk genere par la clk 50 MHz dans le bloc en_gen.vhd
        en           : in   std_logic; 				   -- signal enable 2 MHz re�u depuis le bloc FIFO a chaque envoi de bit de data b_in
        b_in         : in   std_logic;                    -- data recue bit a bit via la FIFO
        resetn       : in   std_logic; 				   -- reset actif a 0
        mem_state    : in   std_logic; 			-- signal 2 bits provenant de la FIFO indiquant si leur memoire est vide ou pas ("01" memoire vide)
        dac_ready    : in   std_logic;					   -- signal d etat ready du DAC (ready a  1 )
        IBB          : out  std_logic_vector(3 downto 0); -- sortie I
        QBB          : out  std_logic_vector(3 downto 0)  -- sortie Q
    );
end zigbee_fsm;

architecture Behavioral of zigbee_fsm is

    type StateType is (RST_STATE, INIT, I, Q);
    type mem_t_I is array(4 downto 0) of std_logic_vector(3 downto 0);
    type mem_t_Q is array(4 downto 0) of std_logic_vector(3 downto 0);

    signal C_STATE     : StateType;        	 -- etat actuel (current state)
    signal N_STATE     : StateType;          -- etat suivant (next state)

    signal cpt_old  : integer;
    signal cpt      : integer;                      -- variable d increment compteur
    signal cpt_next : integer;                      -- variable suivante d increment compteur

    signal S_IBB       : std_logic_vector(3 downto 0); -- variable temporaire pour IBB
    signal S_QBB       : std_logic_vector(3 downto 0); -- variable temporaire pour QBB
	signal temp_IBB    : std_logic_vector(3 downto 0); -- variable temporaire pour IBB
    signal temp_QBB    : std_logic_vector(3 downto 0); -- variable temporaire pour QBB
    signal S_AI        : std_logic;  	           -- signal temporaire Ai
    signal S_AQ        : std_logic;  	           -- signal temporaire Aq

    signal b_in_prev   : std_logic;	           -- stockage signal b_in
    --signal B           : std_logic :='0';  	           -- parametre principal de la FSM dependant de b_in	


    signal S_AI_next   : std_logic :='0';  	           -- signal temporaire Ai suivant
    signal S_AQ_next   : std_logic :='1';  	           -- signal temporaire Aq suivant



    signal mem_array_I : mem_t_I;
    signal mem_array_Q : mem_t_Q;

    signal en_prev     : std_logic;
    signal en_10MHz_prev     : std_logic;

    signal s_b_in_prev : std_logic;


begin

    -- ******** affectation signaux ********

    mem_array_I(0) <= "0111";
    mem_array_I(1) <= "0110";
    mem_array_I(2) <= "0101";
    mem_array_I(3) <= "0011";
    mem_array_I(4) <= "0001";

    mem_array_Q(0) <= "0001";
    mem_array_Q(1) <= "0011";
    mem_array_Q(2) <= "0101";
    mem_array_Q(3) <= "0110";
    mem_array_Q(4) <= "0111";

    --************************************************************************************************************************************************
    assign : process (clk, resetn) -- permet le passage du current state au next state et la reception de l etat reset
    begin
        if(resetn = '0') then -- reset actif a 0
            en_10MHz_prev 	<= '0';
            en_prev   		<= '0';
            cpt 			<= 0;
            S_AI      		<= '0';
            S_AQ      		<= '1';
            IBB 			<= (others => '0');
            QBB 			<= (others => '0');
			temp_IBB 		<= (others => '0');
            temp_QBB 		<= (others => '0');		
            b_in_prev       <= '0';
            s_b_in_prev		<= '0';
            cpt_old 		<= 0;

        else
            if(rising_edge(clk)) then
                en_10MHz_prev	<= en_10MHz;
                en_prev 		<= en;
				temp_IBB	<= S_IBB;
				temp_QBB	<= S_QBB;

                if(en_10MHz = '1' and en_10MHz_prev = '0') then                    
					
					IBB    		<= temp_IBB;
                    QBB    		<= temp_QBB;
                    
                    cpt 		<= cpt_next;
                    cpt_old 	<= cpt;
					b_in_prev 	<= s_b_in_prev;
                end if;

                if(en = '1' and en_prev = '0') then
                    s_b_in_prev <= b_in;
                    
		    		S_AI    	<= S_AI_next;
                    S_AQ    	<= S_AQ_next;
                end if;	
            end if;
        end if;
    end process assign;

    --************************************************************************************************************************************************

    FSM : process (resetn, clk, N_STATE)
    begin
        if(resetn = '0') then -- reset actif a 0
            C_STATE <= RST_STATE;
        else
            if(rising_edge(clk)) then
                C_STATE <= N_STATE;
            end if;
        end if;
    end process FSM;

    --************************************************************************************************************************************************

    FSM_STATES : process(C_STATE, mem_state, dac_ready, cpt, en, cpt_old, en_prev) -- contient les conditions de passage aux etats suivants 

    begin
        N_STATE <= C_STATE;

        case C_STATE is
            --*********************************************************************************
            when RST_STATE =>
                if(mem_state = '1' and dac_ready = '1' and en = '0' and en_prev = '1') then
                    N_STATE <= INIT;
                else
                    N_STATE <= RST_STATE;
                end if;

            --*********************************************************************************
            when INIT =>
                if(cpt = 4 and cpt_old = 4 and en = '0' and en_prev = '1') then
                    if(dac_ready = '0' or mem_state = '0') then
                        N_STATE <= RST_STATE;
                    else
                        N_STATE <= I;
                    end if;
                else
                    N_STATE <= INIT;
                end if;

            --*********************************************************************************
            when I =>
                if(cpt = 0 and cpt_old = 0 and en= '0' and en_prev = '1') then
                    if(dac_ready = '0' or mem_state = '0') then
                        N_STATE <= RST_STATE;
                    else
                        N_STATE <= Q;
                    end if;
                else
                    N_STATE <= I;
                end if;

            --*********************************************************************************
            when Q =>
                if(cpt = 4 and cpt_old = 4 and en = '0' and en_prev = '1') then
                    if(dac_ready = '0' or mem_state = '0') then
                        N_STATE <= RST_STATE;
                    else
                        N_STATE <= I;
                    end if;
                else
                    N_STATE <= Q;
                end if;

            --*********************************************************************************              
            when others =>
                N_STATE <= RST_STATE;

        end case;

    end process FSM_STATES;

    --************************************************************************************************************************************************
    FSM_OUTPUTS : process (C_STATE, S_AI, S_AQ, en, cpt, cpt_old, b_in, mem_array_I, b_in_prev, mem_array_Q, mem_state, dac_ready, temp_IBB, temp_QBB) -- contient les sorties des etats
    begin

        case C_STATE is

            when RST_STATE => -- etat reset -- prochain etat : wait_state

                if(mem_state = '1' and dac_ready = '1' and en = '1') then
                    S_AI_next 	<= b_in;
                    S_AQ_next 	<= S_AQ;
					S_IBB		<= temp_IBB;
					S_QBB		<= temp_QBB;
					cpt_next	<= cpt;
                end if;

                cpt_next 		<= 0;
                S_QBB 			<= (others => '0');
                S_IBB 			<= (others => '0');
				S_AI_next		<= '0';
				S_AQ_next		<= '1';

            --*********************************************************************************
            when INIT =>
				cpt_next 		<= cpt;
                S_QBB 			<= temp_QBB;
                S_IBB 			<= temp_IBB;
				S_AI_next		<= S_AI;
				S_AQ_next		<= '1';

                if(cpt < 4) then
					S_AI_next	<= S_AI;
					S_AQ_next	<= S_AQ;
					cpt_next	<= (cpt + 1);

                    S_QBB <= mem_array_Q(cpt);
					
                    if(S_AI = '0') then
                        S_IBB	<= std_logic_vector(-(signed(mem_array_I(cpt))));
                    else
                        S_IBB	<= mem_array_I(cpt);
                    end if;
                else

                    if (cpt = 4 and cpt_old = 3) then
						cpt_next 	<= cpt;
						S_AI_next	<= S_AI;
						S_AQ_next	<= S_AQ;
						
                        if(S_AI = '0') then
                            S_IBB	<= std_logic_vector(-(signed(mem_array_I(cpt))));
                        else
                            S_IBB	<= mem_array_I(cpt);
                        end if;
                    	S_QBB 		<= mem_array_Q(cpt);
					end if;

					if(cpt = 4 and en = '1') then
                    	S_AQ_next	<= S_AQ;
                        S_AI_next	<= (b_in xor b_in_prev) xnor S_AI;
						cpt_next 	<= cpt;
						S_IBB		<= temp_IBB;
						S_QBB		<= temp_QBB;
                    end if;
                end if;
            --*********************************************************************************
            when I =>
				cpt_next 		<= cpt;
                S_QBB 			<= temp_QBB;
                S_IBB 			<= temp_IBB;
				S_AI_next		<= S_AI;
				S_AQ_next		<= S_AQ;

                if(cpt > 0) then
					S_AI_next	<= S_AI;
					S_AQ_next	<= S_AQ;
					cpt_next   	<= (cpt - 1);

                    if(S_AI = '0') then
                        S_IBB	<= std_logic_vector(-(signed(mem_array_I(cpt))));
                    else
                        S_IBB	<= mem_array_I(cpt);
                    end if;

                    if(S_AQ = '0') then
                        S_QBB	<= std_logic_vector(-(signed(mem_array_Q(cpt))));
                    else
                        S_QBB	<= mem_array_Q(cpt);
                    end if;
                else
                    if (cpt = 0 and cpt_old = 1) then
						cpt_next 	<= cpt;
						S_AI_next	<= S_AI;
						S_AQ_next	<= S_AQ;

                        if(S_AI = '0') then
                            S_IBB    <= std_logic_vector(-(signed(mem_array_I(cpt))));
                        else
                            S_IBB    <= mem_array_I(cpt);
                        end if;

                        if(S_AQ = '0') then
                            S_QBB    <= std_logic_vector(-(signed(mem_array_Q(cpt))));
                        else
                            S_QBB    <= mem_array_Q(cpt);
                        end if;   
                    end if;
					if(cpt = 0 and en = '1') then
						S_AQ_next	<= (b_in xor b_in_prev) xnor S_AQ;
                        S_AI_next	<= S_AI;
						cpt_next 	<= cpt;
						S_IBB		<= temp_IBB;
						S_QBB		<= temp_QBB;
					end if;
                end if;
            --*********************************************************************************
            when Q =>
				cpt_next 		<= cpt;
                S_QBB 			<= temp_QBB;
                S_IBB 			<= temp_IBB;
				S_AI_next		<= S_AI;
				S_AQ_next		<= S_AQ;

                if(cpt < 4) then
					S_AI_next	<= S_AI;
					S_AQ_next	<= S_AQ;
					cpt_next	<= (cpt + 1);

                    if(S_AI = '0') then
                        S_IBB    <= std_logic_vector(-(signed(mem_array_I(cpt))));
                    else
                        S_IBB    <= mem_array_I(cpt);
                    end if;

                    if(S_AQ = '0') then
                        S_QBB    <= std_logic_vector(-(signed(mem_array_Q(cpt))));
                    else
                        S_QBB    <= mem_array_Q(cpt);
                    end if;
                else
                    if(cpt = 4 and cpt_old = 3) then
						cpt_next 	<= cpt;
						S_AI_next	<= S_AI;
						S_AQ_next	<= S_AQ;

                        if(S_AI = '0') then
                            S_IBB    <= std_logic_vector(-(signed(mem_array_I(cpt))));
                        else
                            S_IBB    <= mem_array_I(cpt);
                        end if;

                        if(S_AQ = '0') then
                            S_QBB    <= std_logic_vector(-(signed(mem_array_Q(cpt))));
                        else
                            S_QBB    <= mem_array_Q(cpt);
                        end if;
                    end if;

					if (cpt = 4 and en = '1') then
						S_AQ_next	<= S_AQ;
                        S_AI_next	<= (b_in xor b_in_prev) xnor S_AI;
						cpt_next 	<= cpt;
						S_IBB		<= temp_IBB;
						S_QBB		<= temp_QBB;
					end if;
                end if;

            --*********************************************************************************              
            when others => 	S_AQ_next	<= S_AQ;
                        	S_AI_next	<= S_AI;
							cpt_next 	<= cpt;
							S_IBB		<= temp_IBB;
							S_QBB		<= temp_QBB;

                --********************************************************************************* 
        end case;

    end process FSM_OUTPUTS;

    --************************************************************************************************************************************************ 

end Behavioral;