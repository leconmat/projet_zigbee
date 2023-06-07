library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
--    use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;


entity zigbee_fsm is
    port
(
        clk         : in   std_logic;					 -- signal de clk 50 MHz 
        en_10MHz    : in   std_logic; 			         -- signal enable 10 MHz servant de clk genere par la clk 50 MHz dans le bloc en_gen.vhd
        en          : in   std_logic; 				     -- signal enable 2 MHz reçu depuis le bloc FIFO a chaque envoi de bit de data b_in
        b_in        : in   std_logic;                    -- data recue bit a bit via la FIFO
        resetn      : in   std_logic; 				     -- reset actif a 0
        mem_state   : in   std_logic; 					 -- signal 2 bits provenant de la FIFO indiquant si leur memoire est vide ou pas ("01" memoire vide)
        dac_ready   : in   std_logic;					 -- signal d etat ready du DAC
		ready       : out  std_logic;					 -- signal ready envoye a la fifo lorsque le dac est ready
		en_dac		: out  std_logic;					 -- signal en envoye au dac en synchronisation avec chaque valeur IBB/QBB envoyees
        IBB         : out  std_logic_vector(3 downto 0); -- sortie I
        QBB         : out  std_logic_vector(3 downto 0)  -- sortie Q
    );
end zigbee_fsm;

architecture Behavioral of zigbee_fsm is

    type StateType is (RST_STATE, INIT, I, Q); -- etats de la fsm
    type mem_t_I is array(4 downto 0) of std_logic_vector(3 downto 0); -- rom I
    type mem_t_Q is array(4 downto 0) of std_logic_vector(3 downto 0); -- rom Q

    signal C_STATE     : StateType;        	 	-- etat actuel (current state)
    signal N_STATE     : StateType;          		-- etat suivant (next state)

    signal cpt_old  		: std_logic_vector(2 downto 0);		-- variable precedente compteur
    signal cpt      		: std_logic_vector(2 downto 0);		-- variable d increment compteur
    signal cpt_next 		: std_logic_vector(2 downto 0);		-- variable suivante d increment compteur

    signal S_IBB       		: std_logic_vector(3 downto 0); 	-- variable temporaire pour IBB
    signal S_QBB       		: std_logic_vector(3 downto 0); 	-- variable temporaire pour QBB
	signal temp_IBB    		: std_logic_vector(3 downto 0); 	-- variable temporaire pour IBB
    signal temp_QBB    		: std_logic_vector(3 downto 0); 	-- variable temporaire pour QBB
    signal S_AI        		: std_logic;  	           			-- signal temporaire Ai
    signal S_AQ        		: std_logic;  	           			-- signal temporaire Aq

    signal b_in_prev   		: std_logic;	           			-- stockage signal b_in	

    signal S_AI_next   		: std_logic;  	           			-- signal temporaire Ai suivant
    signal S_AQ_next   		: std_logic;  	           			-- signal temporaire Aq suivant

	signal f_dac_down		: std_logic;						-- flag d etat bas du dac
	signal f_temp_dac  		: std_logic;

    signal mem_array_I 		: mem_t_I;							-- rom memoire I
    signal mem_array_Q 		: mem_t_Q;							-- rom memoire Q

    signal en_prev			: std_logic;						-- valeur precedente enable
    signal en_10MHz_prev    : std_logic;						-- valeur precedente enable 10 MHz
	signal dac_ready_prev	: std_logic;						-- valeur precedente dac_ready

    signal s_b_in_prev 		: std_logic;						-- signal d assignation de b_in_prev


begin

    -- ******** affectation signaux ********

    mem_array_I(0) <= "0111"; -- 7
    mem_array_I(1) <= "0110"; -- 6
    mem_array_I(2) <= "0101"; -- 5
    mem_array_I(3) <= "0011"; -- 3
    mem_array_I(4) <= "0001"; -- 1

    mem_array_Q(0) <= "0001"; -- 1
    mem_array_Q(1) <= "0011"; -- 3
    mem_array_Q(2) <= "0101"; -- 5
    mem_array_Q(3) <= "0110"; -- 6
    mem_array_Q(4) <= "0111"; -- 7

    --************************************************************************************************************************************************

	assign_ready : process(resetn, clk)
	begin
		if(resetn = '0') then
			ready <= '0';
		else
			if(rising_edge(clk)) then
				if(en_10MHz = '1' and en_10MHz_prev = '0') then
					if(dac_ready = '1' and f_dac_down = '0') then
						ready   <= '1';
					else
						ready   <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	assign_dac_down : process(resetn, clk)
	begin
		if(resetn = '0') then
			f_dac_down <= '1';
			f_temp_dac <= '0';
		else
			if(rising_edge(clk)) then
				
				if(dac_ready = '0') then
					f_dac_down <= '1';
					if(f_dac_down = '0') then
						f_temp_dac <= '1';
					end if;
					if(f_dac_down = '1') then
						f_temp_dac <= '0';
					end if;
				else
				    if(dac_ready = '1' and ((cpt = x"4" and cpt_old = x"3") or (cpt = x"0" and cpt_old = x"1") or (cpt = x"0" and cpt_old = x"0"))) then
						f_dac_down <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;

    assign : process (clk, resetn) -- permet le passage du current state au next state et la reception de l etat reset
    begin
        if(resetn = '0') then -- reset actif a 0
            en_10MHz_prev 		<= '0';
            en_prev   			<= '0';
            cpt 				<= (others => '0');
            S_AI      			<= '0';
            S_AQ      			<= '1';
			temp_IBB 			<= (others => '0');
            temp_QBB 			<= (others => '0');		
            b_in_prev       	<= '0';
            s_b_in_prev			<= '0';
            cpt_old 			<= (others => '0');
			dac_ready_prev		<= '0';

        else
            if(rising_edge(clk)) then
                en_10MHz_prev		<= en_10MHz;
                en_prev 			<= en;
				temp_IBB			<= S_IBB;
				temp_QBB			<= S_QBB;
				dac_ready_prev		<= dac_ready;

                if(en_10MHz = '1' and en_10MHz_prev = '0') then       
			        cpt 			<= cpt_next;
                    cpt_old 		<= cpt;
					b_in_prev 		<= s_b_in_prev;
                end if;

                if(en = '1' and en_prev = '0') then
                    s_b_in_prev 	<= b_in;
		    		S_AI    		<= S_AI_next;
                    S_AQ    		<= S_AQ_next;
                end if;	
            end if;
        end if;
    end process assign;

	en_dac_assign : process (clk, resetn, dac_ready, c_state)
	begin
		if(resetn = '0' or dac_ready = '0' or c_state = RST_STATE) then -- reset actif a 0
            en_dac <= '0';
        else
            if(rising_edge(clk)) then
				if(en_10MHz = '1') then           
					en_dac <= '1';
				else
					en_dac <= '0';
				end if;
			end if;
		end if;
	end process en_dac_assign;
				
	--*********************************************************************************

	rst_IBB_QBB : process(resetn, clk)
	begin

		if(resetn = '0') then
			IBB <= (others => '0');
			QBB <= (others => '0');
		else
			if(rising_edge(clk)) then
				if(en_10MHz = '1' and en_10MHz_prev = '0') then
					IBB    		<= temp_IBB;
                	QBB    		<= temp_QBB;
				end if;
				if(c_state = rst_state) then
					IBB <= (others => '0');
					QBB <= (others => '0');
				end if;
			end if;
		end if;
	end process rst_IBB_QBB;

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
                if(mem_state = '1' and dac_ready = '1' and en = '1' and en_prev = '0') then
                    N_STATE <= INIT;
                else
                    N_STATE <= RST_STATE;
                end if;

	--*********************************************************************************
            when INIT =>
				if(dac_ready = '0') then
					N_STATE <= INIT;
				end if;
				
				if(cpt = x"4" and cpt_old = x"4" and mem_state = '0') then
					N_STATE <= RST_STATE;
				else

                	if(cpt = x"4" and cpt_old = x"4" and en = '1') then
                		N_STATE <= I;
                	else
                		N_STATE <= INIT;
                	end if;
				end if;

            --*********************************************************************************
            when I =>
				if(dac_ready = '0') then
					N_STATE <= I;
				end if;

				if(cpt = x"0" and cpt_old = x"0" and mem_state = '0') then
					N_STATE <= RST_STATE;
				else
				
                	if(cpt = x"0" and cpt_old = x"0" and en = '1') then
                    	N_STATE <= Q;
                	else
                		N_STATE <= I;
               		end if;
				end if;

	--*********************************************************************************
            when Q =>
				if(dac_ready = '0') then
					N_STATE <= Q;
				end if;

				if(cpt = x"4" and cpt_old = x"4" and mem_state = '0') then
					N_STATE <= RST_STATE;
				else

                	if(cpt = x"4" and cpt_old = x"4" and en = '1') then
                    	N_STATE <= I;
					else
                   		N_STATE <= Q;
					end if;
                end if;

	--*********************************************************************************              
            --when others =>
                --N_STATE <= RST_STATE;

        end case;

    end process FSM_STATES;

    --************************************************************************************************************************************************
    FSM_OUTPUTS : process (C_STATE, S_AI, S_AQ, en, cpt, cpt_old, b_in, mem_array_I, b_in_prev, mem_array_Q, mem_state, dac_ready, temp_IBB, temp_QBB, dac_ready_prev, f_dac_down, f_temp_dac) -- contient les sorties des etats
    begin

        case C_STATE is

            when RST_STATE => -- etat reset -- prochain etat : init
				cpt_next 		<= (others => '0');
                S_QBB 			<= (others => '0');
                S_IBB 			<= (others => '0');
				S_AI_next		<= '0';
				S_AQ_next		<= '1';

                if(mem_state = '1' and dac_ready = '1' and en = '1') then
                    S_AI_next 	<= b_in;
                    S_AQ_next 	<= S_AQ;
					S_IBB		<= temp_IBB;
					S_QBB		<= temp_QBB;
					cpt_next	<= cpt;
                end if;
		
	--*********************************************************************************
            when INIT =>
				cpt_next 		<= cpt;
                S_QBB 			<= temp_QBB;
                S_IBB 			<= temp_IBB;
				S_AI_next		<= S_AI;
				S_AQ_next		<= '1';

				if(dac_ready = '1') then
		            if(cpt < x"4") then
						S_AI_next	<= S_AI;
						S_AQ_next	<= '1';
						cpt_next	<= std_logic_vector(unsigned(cpt)+1);

		                S_QBB <= mem_array_Q(to_integer(unsigned(cpt)));
					
		                if(S_AI = '0') then
		                    S_IBB	<= std_logic_vector(-(signed(mem_array_I(to_integer(unsigned(cpt))))));
		                else
		                    S_IBB	<= mem_array_I(to_integer(unsigned(cpt)));
		                end if;
		            else

		                if (cpt = x"4" and cpt_old = x"3") then
							cpt_next 	<= cpt;
							S_AI_next	<= S_AI;
							S_AQ_next	<= '1';
						
		                    if(S_AI = '0') then
		                        S_IBB	<= std_logic_vector(-(signed(mem_array_I(to_integer(unsigned(cpt))))));
		                    else
		                        S_IBB	<= mem_array_I(to_integer(unsigned(cpt)));
		                    end if;
		                	S_QBB 		<= mem_array_Q(to_integer(unsigned(cpt)));
						end if;

						if(cpt = 4 and en = '1') then
		                	S_AQ_next	<= '1';
		                    S_AI_next	<= (b_in xor b_in_prev) xnor S_AI;
							cpt_next 	<= cpt;
							S_IBB		<= temp_IBB;
							S_QBB		<= temp_QBB;
		                end if;
		            end if;
				else
					S_AQ_next	<= S_AQ;
                    S_AI_next	<= S_AI;
					cpt_next 	<= cpt;
					S_IBB		<= temp_IBB;
					S_QBB		<= temp_QBB;
				end if;

	--*********************************************************************************
            when I =>
				cpt_next 		<= cpt;
                S_QBB 			<= temp_QBB;
                S_IBB 			<= temp_IBB;
				S_AI_next		<= S_AI;
				S_AQ_next		<= S_AQ;

				if(f_dac_down = '1' and f_temp_dac = '1' and cpt /= x"0") then
					cpt_next   	<= std_logic_vector(unsigned(cpt)-1);
				end if;

				if(dac_ready = '1') then
		            if(cpt > x"0") then
						S_AI_next	<= S_AI;
						S_AQ_next	<= S_AQ;
						cpt_next   	<= std_logic_vector(unsigned(cpt)-1);

		                if(S_AI = '0') then
		                    S_IBB	<= std_logic_vector(-(signed(mem_array_I(to_integer(unsigned(cpt))))));
		                else
		                    S_IBB	<= mem_array_I(to_integer(unsigned(cpt)));
		                end if;

		                if(S_AQ = '0') then
		                    S_QBB	<= std_logic_vector(-(signed(mem_array_Q(to_integer(unsigned(cpt))))));
		                else
		                    S_QBB	<= mem_array_Q(to_integer(unsigned(cpt)));
		                end if;
		            else
		                if (cpt = x"0" and cpt_old = x"1") then
							cpt_next 	<= cpt;
							S_AI_next	<= S_AI;
							S_AQ_next	<= S_AQ;

		                    if(S_AI = '0') then
		                        S_IBB    <= std_logic_vector(-(signed(mem_array_I(to_integer(unsigned(cpt))))));
		                    else
		                        S_IBB    <= mem_array_I(to_integer(unsigned(cpt)));
		                    end if;

		                    if(S_AQ = '0') then
		                        S_QBB    <= std_logic_vector(-(signed(mem_array_Q(to_integer(unsigned(cpt))))));
		                    else
		                        S_QBB    <= mem_array_Q(to_integer(unsigned(cpt)));
		                    end if;   
		                end if;

						if(cpt = x"0" and en = '1') then
							S_AQ_next	<= (b_in xor b_in_prev) xnor S_AQ;
		                    S_AI_next	<= S_AI;
							cpt_next 	<= cpt;
							S_IBB		<= temp_IBB;
							S_QBB		<= temp_QBB;
						end if;
		            end if;
				else
					S_AQ_next	<= S_AQ;
                    S_AI_next	<= S_AI;
					cpt_next 	<= cpt;
					S_IBB		<= temp_IBB;
					S_QBB		<= temp_QBB;
				end if;

	--*********************************************************************************
            when Q =>
				cpt_next 		<= cpt;
                S_QBB 			<= temp_QBB;
                S_IBB 			<= temp_IBB;
				S_AI_next		<= S_AI;
				S_AQ_next		<= S_AQ;

				if(f_dac_down = '1' and f_temp_dac = '1' and cpt /= x"4") then
					cpt_next   		<= std_logic_vector(unsigned(cpt)+1);
				end if;

				if(dac_ready_prev = '1' and dac_ready = '1') then
	            	if(cpt < x"4") then
						S_AI_next	<= S_AI;
						S_AQ_next	<= S_AQ;
						cpt_next	<= std_logic_vector(unsigned(cpt)+1);

	                	if(S_AI = '0') then
	                	    S_IBB    <= std_logic_vector(-(signed(mem_array_I(to_integer(unsigned(cpt))))));
	                	else
	                	    S_IBB    <= mem_array_I(to_integer(unsigned(cpt)));
	                	end if;

	                	if(S_AQ = '0') then
	                	    S_QBB    <= std_logic_vector(-(signed(mem_array_Q(to_integer(unsigned(cpt))))));
	                	else
	                	    S_QBB    <= mem_array_Q(to_integer(unsigned(cpt)));
	                	end if;
	            	else	
	                	if(cpt = x"4" and cpt_old = x"3") then
							cpt_next 	<= cpt;
							S_AI_next	<= S_AI;
							S_AQ_next	<= S_AQ;

	                	    if(S_AI = '0') then
	                	        S_IBB    <= std_logic_vector(-(signed(mem_array_I(to_integer(unsigned(cpt))))));
	                	    else
	                	        S_IBB    <= mem_array_I(to_integer(unsigned(cpt)));
	                	    end if;

	                	    if(S_AQ = '0') then
	                	        S_QBB    <= std_logic_vector(-(signed(mem_array_Q(to_integer(unsigned(cpt))))));
	                	    else
	                	        S_QBB    <= mem_array_Q(to_integer(unsigned(cpt)));
	                	    end if;
	                	end if;

						if (cpt = x"4" and en = '1') then
							S_AQ_next	<= S_AQ;
	                	    S_AI_next	<= (b_in xor b_in_prev) xnor S_AI;
							cpt_next 	<= cpt;
							S_IBB		<= temp_IBB;
							S_QBB		<= temp_QBB;
						end if;
	            	end if;
				else
					S_AQ_next	<= S_AQ;
                	S_AI_next	<= S_AI;
					cpt_next 	<= cpt;
					S_IBB		<= temp_IBB;
					S_QBB		<= temp_QBB;
				end if;

	--*********************************************************************************              
            --when others => 	
					--S_AQ_next	<= S_AQ;
                    --S_AI_next	<= S_AI;
					--cpt_next 	<= cpt;
					--S_IBB		<= temp_IBB;
					--S_QBB		<= temp_QBB;

	--********************************************************************************* 
        end case;

    end process FSM_OUTPUTS;

    --************************************************************************************************************************************************ 

end Behavioral;
