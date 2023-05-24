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
        en           : in   std_logic; 				   -- signal enable 2 MHz reçu depuis le bloc FIFO a chaque envoi de bit de data b_in
        b_in         : in   std_logic;                    -- data recue bit a bit via la FIFO
        resetn       : in   std_logic; 				   -- reset actif a 0
        mem_state    : in   std_logic; 			-- signal 2 bits provenant de la FIFO indiquant si leur memoire est vide ou pas ("01" memoire vide)
        dac_ready    : in   std_logic;					   -- signal d etat ready du DAC (ready a  1 )
        IBB          : out  std_logic_vector(3 downto 0); -- sortie I
        QBB          : out  std_logic_vector(3 downto 0)  -- sortie Q
    );
end zigbee_fsm;

architecture Behavioral of zigbee_fsm is

    type StateType is (rst_state, wait_state, init, flag_reinit_I, flag_reinit_Q, I, Q);
    type mem_t_I is array(4 downto 0) of std_logic_vector(3 downto 0);
    type mem_t_Q is array(4 downto 0) of std_logic_vector(3 downto 0);

    signal c_state     : StateType;        	 -- etat actuel (current state)
    signal n_state     : StateType;          -- etat suivant (next state)

    signal inc_I1      : integer;                      -- variable d increment pour I etat I ou init
    signal inc_Q1      : integer;                      -- variable d increment pour Q etat I ou init
    signal inc_I2      : integer;                      -- variable d increment pour I etat Q
    signal inc_Q2      : integer;                      -- variable d increment pour Q etat Q
    signal s_IBB       : std_logic_vector(3 downto 0); -- variable temporaire pour IBB
    signal s_QBB       : std_logic_vector(3 downto 0); -- variable temporaire pour QBB
    signal S_AI        : std_logic :='0';  	           -- signal temporaire Ai
    signal S_AQ        : std_logic :='0';  	           -- signal temporaire Aq
    signal S_AI_prev   : std_logic :='0';  	           -- signal temporaire Ai precedent
    signal S_AQ_prev   : std_logic :='0';  	           -- signal temporaire Aq precedent
    signal b_in_prev   : std_logic :='0';	           -- stockage signal b_in
    signal B           : std_logic :='0';  	           -- parametre principal de la FSM dependant de b_in	
    signal f_inc_I1    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
    signal f_inc_Q1    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
    signal f_inc_I2    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
    signal f_inc_Q2    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
	
	signal next_f_inc_I1    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
    signal next_f_inc_Q1    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
    signal next_f_inc_I2    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
    signal next_f_inc_Q2    : std_logic :='0'; 	           -- flag signalant l overflow de inc_I permettant de passer a l etat suivant
	
    signal S_AI_next   : std_logic :='0';  	           -- signal temporaire Ai suivant
    signal S_AQ_next   : std_logic :='0';  	           -- signal temporaire Aq suivant

    signal inc_I1_next : integer;                      -- variable d increment pour I etat I ou init
    signal inc_Q1_next : integer;                      -- variable d increment pour Q etat I ou init
    signal inc_I2_next : integer;                      -- variable d increment pour I etat Q
    signal inc_Q2_next : integer;                      -- variable d increment pour Q etat Q

    signal mem_array_I : mem_t_I;
    signal mem_array_Q : mem_t_Q;

    signal en_prev     : std_logic;
	signal en_10MHz_prev     : std_logic;
	
	signal s_b_in_prev : std_logic;

begin

    -- ******** affectation signaux ********

    mem_array_I(0) <= "0000";
    mem_array_I(1) <= "0010";
    mem_array_I(2) <= "0100";
    mem_array_I(3) <= "0110";
    mem_array_I(4) <= "0111";

    mem_array_Q(0) <= "0000";
    mem_array_Q(1) <= "0010";
    mem_array_Q(2) <= "0100";
    mem_array_Q(3) <= "0110";
    mem_array_Q(4) <= "0111";

    --************************************************************************************************************************************************
    assign : process (clk, resetn) -- permet le passage du current state au next state et la reception de l etat reset
    begin
	if(resetn = '0') then -- reset actif a 0
		en_10MHz_prev <= '0';
		en_prev   <= '1';	
		f_inc_I1  <= '0';
		f_inc_Q1  <= '0';
		f_inc_I2  <= '0';
		f_inc_Q2  <= '0';	
		inc_I1    <= 0;
		inc_Q1    <= 4;
		inc_I2    <= 4;
		inc_Q2    <= 0;
		S_AI      <= '0';
		S_AQ      <= '0';
		IBB <= (others => '0');
		QBB <= (others => '0');
		b_in_prev       <= '0';
		s_b_in_prev       <= '0';

        else
		if(rising_edge(clk)) then
                	en_10MHz_prev   <= en_10MHz;
			en_prev <= en;
			f_inc_I1 <= next_f_inc_I1;
                	f_inc_I2 <= next_f_inc_I2;
                	f_inc_Q1 <= next_f_inc_Q1;
                	f_inc_Q2 <= next_f_inc_Q2;
			S_AI    <= S_AI_next;
			S_AQ    <= S_AQ_next;
			
			if(en_10MHz = '1' and en_10MHz_prev = '0') then
				inc_I1 <= inc_I1_next;
				inc_Q1 <= inc_Q1_next;
				inc_I2 <= inc_I2_next;
				inc_Q2 <= inc_Q2_next;
				IBB    <= s_IBB;
				QBB    <= s_QBB;
			end if;
			
			if(en = '1' and en_prev = '0') then
				B <= b_in xor b_in_prev;
				s_b_in_prev <= b_in;
                		b_in_prev <= s_b_in_prev;
			end if;
		end if;
	end if;
    end process assign;

    --************************************************************************************************************************************************
    
    FSM : process (resetn, clk, n_state)
    begin
        if(resetn = '0') then -- reset actif a 0
            c_state <= rst_state;		
        else
            if(rising_edge(clk)) then
                c_state <= n_state;
            end if;
        end if;
    end process FSM;

    --************************************************************************************************************************************************

    FSM_STATES : process(c_state, mem_state, dac_ready, en, f_inc_I1, f_inc_Q1, f_inc_I2, f_inc_Q2) -- contient les conditions de passage aux etats suivants 

    begin
        n_state <= c_state;

        case c_state is
            --*********************************************************************************
            when rst_state =>
                n_state <= wait_state;


            --*********************************************************************************
            when wait_state =>
                if(mem_state = '1' and dac_ready = '1' and en = '1') then
                    n_state <= init;
                else
                    n_state <= wait_state;
                end if;

            --*********************************************************************************
            when init =>
                if(dac_ready = '0' or mem_state = '0') then
                    n_state <= wait_state;
                else
                    if(en = '1' and f_inc_I1 = '1' and f_inc_Q1 = '1') then
                        n_state <= flag_reinit_I;
                    end if;
                end if;

            --*********************************************************************************
            when flag_reinit_I =>
                n_state <= I;

            --*********************************************************************************
            when I =>
                if(dac_ready = '0' or mem_state = '0') then
                    n_state <= wait_state;
                end if;

                if(f_inc_I1 = '1' and f_inc_Q1 = '1' and en = '1') then
                    n_state <= flag_reinit_Q;
                else
                    n_state <= I;
                end if;

            --*********************************************************************************
            when flag_reinit_Q =>
                n_state <= Q;

            --*********************************************************************************
            when Q =>
                if(dac_ready = '0' or mem_state = '0') then
                    n_state <= wait_state;
                end if;

                if(f_inc_I2 = '1' and f_inc_Q2 = '1' and en = '1') then
                    n_state <= flag_reinit_I;
                else
                    n_state <= Q;
                end if;

            --*********************************************************************************              
            when others =>
                n_state <= rst_state;

        end case;

    end process FSM_STATES;

    --************************************************************************************************************************************************
    FSM_OUTPUTS : process (c_state, S_AI, S_AQ, en, inc_I1, inc_Q1, inc_I2, inc_Q2, b_in, mem_array_I, b_in_prev, B, S_AI_prev, S_AQ_prev, mem_array_Q) -- contient les sorties des etats
    begin

        case c_state is

            when rst_state => -- etat reset -- prochain etat : wait_state
                next_f_inc_I1  <= '0';
                next_f_inc_Q1  <= '0';
                next_f_inc_I2  <= '0';
                next_f_inc_Q2  <= '0';
                
                S_AI_next      <= '0';
                S_AQ_next      <= '0';

                S_AI_prev <= '0';
                S_AQ_prev <= '0';

                inc_I1_next    <= 0;
                inc_Q1_next    <= 4;
                inc_I2_next    <= 4;
                inc_Q2_next    <= 0;


            --*********************************************************************************
            when wait_state =>
                next_f_inc_I1  <= '0';
                next_f_inc_Q1  <= '0';
                next_f_inc_I2  <= '0';
                next_f_inc_Q2  <= '0';

                inc_I1_next    <= 0;
                inc_Q1_next    <= 4;
                inc_I2_next    <= 4;
                inc_Q2_next    <= 0;

                S_AI_next 		<= b_in;
                S_AQ_next 		<= '1';

                S_AI_prev <= S_AI;
                S_AQ_prev <= S_AQ;

            --*********************************************************************************
            when init =>

                S_AI_prev  <= S_AI;
                S_AQ_prev  <= S_AQ;
				
		
                if(inc_I1 = 4) then -- compteur rom I state Init
                    next_f_inc_I1 <= '1';
                else
                    inc_I1_next   <= inc_I1 + 1;
                end if;

                if(inc_Q1 = 0) then -- compteur rom Q state Init
                    next_f_inc_Q1 <= '1';
                else
                    inc_Q1_next   <= inc_Q1 - 1;
                end if;

                if(S_AI = '0') then
                    s_IBB    <= std_logic_vector(-(signed(mem_array_I(inc_I1))));
                else
                    s_IBB    <= mem_array_I(inc_I1);
                end if;

                s_QBB(3 downto 0) <= mem_array_I(inc_Q1);



            --*********************************************************************************
            when flag_reinit_I =>
                next_f_inc_I1  <= '0';
                next_f_inc_Q1  <= '0';
                next_f_inc_I2  <= '0';
                next_f_inc_Q2  <= '0';

                inc_I1_next	   <= 0;
                inc_Q1_next	   <= 4;
                inc_I2_next	   <= 4;
                inc_Q2_next	   <= 0;

                S_AI_next       <= B xnor S_AI;
                S_AQ_next       <= S_AQ;

                S_AI_prev  <= S_AI;
                S_AQ_prev  <= S_AQ;
                

            --*********************************************************************************
            when I =>

                if(inc_I1 = 4) then -- compteur rom I state I
                    next_f_inc_I1 <= '1';
                else
                    inc_I1_next   <= inc_I1 + 1;
                end if;

                if(inc_Q1 = 0) then -- compteur rom Q state I
                    next_f_inc_Q1 <= '1';
                else
                    inc_Q1_next   <= (inc_Q1 - 1);
                end if;


                if(S_AI = '0' and f_inc_I1 = '0') then
                    s_IBB    <= std_logic_vector(-(signed(mem_array_I(inc_I1))));
                else
                    s_IBB    <= mem_array_I(inc_I1);
                end if;

                if(S_AQ = '0' and f_inc_Q1 = '0') then
                    s_QBB    <= std_logic_vector(-(signed(mem_array_Q(inc_Q1))));
                else
                    s_QBB    <= mem_array_Q(inc_Q1);
                end if;

            --*********************************************************************************
            when flag_reinit_Q =>
                next_f_inc_I1  <= '0';
                next_f_inc_Q1  <= '0';
                next_f_inc_I2  <= '0';
                next_f_inc_Q2  <= '0';

                inc_I1_next    <= 0;
                inc_Q1_next    <= 4;
                inc_I2_next    <= 4;
                inc_Q2_next    <= 0;

                S_AQ_next     <= B    xnor S_AQ;
                S_AI_next     <= S_AI;

                S_AI_prev  <= S_AI;
                S_AQ_prev  <= S_AQ;
            --*********************************************************************************
            when Q =>

                if(inc_I2 = 0) then -- compteur rom I state Q
                    next_f_inc_I2      <= '1';
                else
                    inc_I2_next   <= (inc_I2 - 1);
                end if;

                if(inc_Q2 = 4) then -- compteur rom Q state Q
                    next_f_inc_Q2 <= '1';
                else
                    inc_Q2_next   <= (inc_Q2 + 1);
                end if;


                if(S_AI = '0' and f_inc_I2 = '0') then
                    s_IBB    <= std_logic_vector(-(signed(mem_array_I(inc_I2))));
                else
                    s_IBB    <= mem_array_I(inc_I2);
                end if;

                if(S_AQ = '0' and f_inc_Q2 = '0') then
                    s_QBB    <= std_logic_vector(-(signed(mem_array_Q(inc_Q2))));
                else
                    s_QBB    <= mem_array_Q(inc_Q2);
                end if;

            --*********************************************************************************              
            when others => NULL;

                --********************************************************************************* 
        end case;

    end process FSM_OUTPUTS;

    --************************************************************************************************************************************************ 

end Behavioral;
