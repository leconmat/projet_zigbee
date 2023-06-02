
module TL_codeur_IQ ( resetn, clk, en_2MHz, b_in, mem_state, dac_ready, IBB, 
        QBB, en_dac, ready );
  output [3:0] IBB;
  output [3:0] QBB;
  input resetn, clk, en_2MHz, b_in, mem_state, dac_ready;
  output en_dac, ready;
  wire   en_10MHz, \fsm_mapping/n232 , \fsm_mapping/n231 , \fsm_mapping/n230 ,
         \fsm_mapping/n229 , \fsm_mapping/n228 , \fsm_mapping/n227 ,
         \fsm_mapping/n226 , \fsm_mapping/n225 , \fsm_mapping/n224 ,
         \fsm_mapping/n223 , \fsm_mapping/n222 , \fsm_mapping/n221 ,
         \fsm_mapping/n220 , \fsm_mapping/n218 , \fsm_mapping/n217 ,
         \fsm_mapping/n216 , \fsm_mapping/n215 , \fsm_mapping/n214 ,
         \fsm_mapping/n213 , \fsm_mapping/n212 , \fsm_mapping/n211 ,
         \fsm_mapping/n210 , \fsm_mapping/n209 , \fsm_mapping/n208 ,
         \fsm_mapping/n207 , \fsm_mapping/n206 , \fsm_mapping/n205 ,
         \fsm_mapping/n204 , \fsm_mapping/n203 , \fsm_mapping/n202 ,
         \fsm_mapping/n201 , \fsm_mapping/n200 , \fsm_mapping/n199 ,
         \fsm_mapping/n198 , \fsm_mapping/n197 , \fsm_mapping/n196 ,
         \fsm_mapping/n195 , \fsm_mapping/n194 , \fsm_mapping/n193 ,
         \fsm_mapping/n192 , \fsm_mapping/n191 , \fsm_mapping/n190 ,
         \fsm_mapping/n189 , \fsm_mapping/n188 , \fsm_mapping/n187 ,
         \fsm_mapping/n185 , \fsm_mapping/n184 , \fsm_mapping/n183 ,
         \fsm_mapping/n182 , \fsm_mapping/n181 , \fsm_mapping/n180 ,
         \fsm_mapping/n179 , \fsm_mapping/n178 , \fsm_mapping/n177 ,
         \fsm_mapping/n176 , \fsm_mapping/n175 , \fsm_mapping/n174 ,
         \fsm_mapping/n173 , \fsm_mapping/n172 , \fsm_mapping/n171 ,
         \fsm_mapping/n170 , \fsm_mapping/n169 , \fsm_mapping/n168 ,
         \fsm_mapping/n167 , \fsm_mapping/n166 , \fsm_mapping/n165 ,
         \fsm_mapping/n164 , \fsm_mapping/n163 , \fsm_mapping/n161 ,
         \fsm_mapping/n160 , \fsm_mapping/n159 , \fsm_mapping/n158 ,
         \fsm_mapping/n157 , \fsm_mapping/n156 , \fsm_mapping/n155 ,
         \fsm_mapping/n154 , \fsm_mapping/n153 , \fsm_mapping/n152 ,
         \fsm_mapping/n151 , \fsm_mapping/n150 , \fsm_mapping/n149 ,
         \fsm_mapping/n148 , \fsm_mapping/n147 , \fsm_mapping/n146 ,
         \fsm_mapping/n145 , \fsm_mapping/n143 , \fsm_mapping/n140 ,
         \fsm_mapping/n139 , \fsm_mapping/n138 , \fsm_mapping/n137 ,
         \fsm_mapping/n136 , \fsm_mapping/n135 , \fsm_mapping/n134 ,
         \fsm_mapping/n133 , \fsm_mapping/n132 , \fsm_mapping/n131 ,
         \fsm_mapping/n130 , \fsm_mapping/n129 , \fsm_mapping/n128 ,
         \fsm_mapping/n127 , \fsm_mapping/n126 , \fsm_mapping/n125 ,
         \fsm_mapping/n124 , \fsm_mapping/n123 , \fsm_mapping/n122 ,
         \fsm_mapping/n120 , \fsm_mapping/n119 , \fsm_mapping/n118 ,
         \fsm_mapping/n117 , \fsm_mapping/n116 , \fsm_mapping/n115 ,
         \fsm_mapping/n114 , \fsm_mapping/n113 , \fsm_mapping/n112 ,
         \fsm_mapping/n111 , \fsm_mapping/n110 , \fsm_mapping/n109 ,
         \fsm_mapping/n108 , \fsm_mapping/n107 , \fsm_mapping/n106 ,
         \fsm_mapping/n105 , \fsm_mapping/n104 , \fsm_mapping/n103 ,
         \fsm_mapping/n102 , \fsm_mapping/n101 , \fsm_mapping/n100 ,
         \fsm_mapping/n99 , \fsm_mapping/n98 , \fsm_mapping/n97 ,
         \fsm_mapping/n96 , \fsm_mapping/n95 , \fsm_mapping/n94 ,
         \fsm_mapping/n93 , \fsm_mapping/n92 , \fsm_mapping/n90 ,
         \fsm_mapping/n89 , \fsm_mapping/n88 , \fsm_mapping/n87 ,
         \fsm_mapping/n86 , \fsm_mapping/n85 , \fsm_mapping/n84 ,
         \fsm_mapping/n83 , \fsm_mapping/n82 , \fsm_mapping/n81 ,
         \fsm_mapping/n80 , \fsm_mapping/n79 , \fsm_mapping/n77 ,
         \fsm_mapping/n76 , \fsm_mapping/n75 , \fsm_mapping/n74 ,
         \fsm_mapping/n73 , \fsm_mapping/n72 , \fsm_mapping/n71 ,
         \fsm_mapping/n70 , \fsm_mapping/n69 , \fsm_mapping/n68 ,
         \fsm_mapping/n67 , \fsm_mapping/n66 , \fsm_mapping/n65 ,
         \fsm_mapping/n64 , \fsm_mapping/n63 , \fsm_mapping/n62 ,
         \fsm_mapping/n61 , \fsm_mapping/n60 , \fsm_mapping/n59 ,
         \fsm_mapping/n58 , \fsm_mapping/n57 , \fsm_mapping/n56 ,
         \fsm_mapping/n55 , \fsm_mapping/n54 , \fsm_mapping/n53 ,
         \fsm_mapping/n52 , \fsm_mapping/n51 , \fsm_mapping/n50 ,
         \fsm_mapping/n49 , \fsm_mapping/n48 , \fsm_mapping/n47 ,
         \fsm_mapping/n46 , \fsm_mapping/n45 , \fsm_mapping/n44 ,
         \fsm_mapping/n43 , \fsm_mapping/n42 , \fsm_mapping/n41 ,
         \fsm_mapping/n40 , \fsm_mapping/n39 , \fsm_mapping/n38 ,
         \fsm_mapping/n37 , \fsm_mapping/n36 , \fsm_mapping/n35 ,
         \fsm_mapping/n34 , \fsm_mapping/n33 , \fsm_mapping/n32 ,
         \fsm_mapping/n31 , \fsm_mapping/n30 , \fsm_mapping/n29 ,
         \fsm_mapping/n28 , \fsm_mapping/N261 , \fsm_mapping/N260 ,
         \fsm_mapping/N259 , \fsm_mapping/dac_ready_prev ,
         \fsm_mapping/s_b_in_prev , \fsm_mapping/b_in_prev ,
         \fsm_mapping/S_AQ , \fsm_mapping/S_AI , \fsm_mapping/en_prev ,
         \fsm_mapping/f_temp_dac , \fsm_mapping/N233 ,
         \fsm_mapping/f_dac_down , \fsm_mapping/en_10MHz_prev ,
         \en_gen_map/n4 , \en_gen_map/n3 , \en_gen_map/n1 , \en_gen_map/N13 ,
         \en_gen_map/N6 , n1, n2, n3, n4;
  wire   [1:0] \fsm_mapping/N_STATE ;
  wire   [1:0] \fsm_mapping/C_STATE ;
  wire   [3:0] \fsm_mapping/temp_QBB ;
  wire   [3:0] \fsm_mapping/temp_IBB ;
  wire   [2:0] \fsm_mapping/cpt_old ;
  wire   [2:0] \fsm_mapping/cpt ;
  wire   [2:0] \en_gen_map/cpt ;

  CLKIN0 \fsm_mapping/U194  ( .A(dac_ready), .Q(\fsm_mapping/n176 ) );
  NOR20 \fsm_mapping/U193  ( .A(\fsm_mapping/f_dac_down ), .B(
        \fsm_mapping/n176 ), .Q(\fsm_mapping/N233 ) );
  CLKIN0 \fsm_mapping/U192  ( .A(en_2MHz), .Q(\fsm_mapping/n214 ) );
  NOR20 \fsm_mapping/U191  ( .A(\fsm_mapping/n214 ), .B(\fsm_mapping/en_prev ), 
        .Q(\fsm_mapping/N260 ) );
  NOR20 \fsm_mapping/U190  ( .A(\fsm_mapping/C_STATE [1]), .B(
        \fsm_mapping/C_STATE [0]), .Q(\fsm_mapping/n127 ) );
  CLKIN0 \fsm_mapping/U189  ( .A(\fsm_mapping/n127 ), .Q(\fsm_mapping/n116 )
         );
  NAND30 \fsm_mapping/U188  ( .A(\fsm_mapping/n116 ), .B(resetn), .C(dac_ready), .Q(\fsm_mapping/N261 ) );
  CLKIN0 \fsm_mapping/U187  ( .A(mem_state), .Q(\fsm_mapping/n215 ) );
  NOR30 \fsm_mapping/U186  ( .A(\fsm_mapping/n214 ), .B(\fsm_mapping/n176 ), 
        .C(\fsm_mapping/n215 ), .Q(\fsm_mapping/n173 ) );
  CLKIN0 \fsm_mapping/U185  ( .A(\fsm_mapping/n173 ), .Q(\fsm_mapping/n115 )
         );
  NOR30 \fsm_mapping/U184  ( .A(\fsm_mapping/cpt [0]), .B(\fsm_mapping/cpt [1]), .C(\fsm_mapping/n69 ), .Q(\fsm_mapping/n217 ) );
  NOR30 \fsm_mapping/U183  ( .A(\fsm_mapping/cpt_old [0]), .B(
        \fsm_mapping/cpt_old [1]), .C(\fsm_mapping/n218 ), .Q(
        \fsm_mapping/n216 ) );
  NAND30 \fsm_mapping/U182  ( .A(\fsm_mapping/n217 ), .B(\fsm_mapping/n215 ), 
        .C(\fsm_mapping/n216 ), .Q(\fsm_mapping/n208 ) );
  CLKIN0 \fsm_mapping/U177  ( .A(\fsm_mapping/n217 ), .Q(\fsm_mapping/n180 )
         );
  NOR20 \fsm_mapping/U176  ( .A(\fsm_mapping/n214 ), .B(\fsm_mapping/n180 ), 
        .Q(\fsm_mapping/n120 ) );
  NAND20 \fsm_mapping/U175  ( .A(\fsm_mapping/n216 ), .B(\fsm_mapping/n120 ), 
        .Q(\fsm_mapping/n210 ) );
  NAND20 \fsm_mapping/U172  ( .A(\fsm_mapping/n69 ), .B(\fsm_mapping/n98 ), 
        .Q(\fsm_mapping/n83 ) );
  CLKIN0 \fsm_mapping/U171  ( .A(\fsm_mapping/n83 ), .Q(\fsm_mapping/n195 ) );
  NOR30 \fsm_mapping/U169  ( .A(\fsm_mapping/cpt_old [1]), .B(
        \fsm_mapping/cpt_old [2]), .C(\fsm_mapping/n80 ), .Q(
        \fsm_mapping/n161 ) );
  NAND30 \fsm_mapping/U168  ( .A(\fsm_mapping/n179 ), .B(\fsm_mapping/n215 ), 
        .C(\fsm_mapping/n161 ), .Q(\fsm_mapping/n207 ) );
  NOR20 \fsm_mapping/U167  ( .A(\fsm_mapping/n80 ), .B(\fsm_mapping/n214 ), 
        .Q(\fsm_mapping/n143 ) );
  NAND30 \fsm_mapping/U166  ( .A(\fsm_mapping/n119 ), .B(\fsm_mapping/n207 ), 
        .C(\fsm_mapping/n143 ), .Q(\fsm_mapping/n213 ) );
  NOR40 \fsm_mapping/U165  ( .A(\fsm_mapping/n213 ), .B(
        \fsm_mapping/cpt_old [0]), .C(\fsm_mapping/cpt_old [2]), .D(
        \fsm_mapping/cpt_old [1]), .Q(\fsm_mapping/n212 ) );
  AOI310 \fsm_mapping/U164  ( .A(\fsm_mapping/n208 ), .B(\fsm_mapping/n188 ), 
        .C(\fsm_mapping/n210 ), .D(\fsm_mapping/n212 ), .Q(\fsm_mapping/n211 )
         );
  OAI310 \fsm_mapping/U163  ( .A(\fsm_mapping/n116 ), .B(\fsm_mapping/en_prev ), .C(\fsm_mapping/n115 ), .D(\fsm_mapping/n211 ), .Q(\fsm_mapping/N_STATE [0])
         );
  AOI220 \fsm_mapping/U161  ( .A(\fsm_mapping/n207 ), .B(\fsm_mapping/n119 ), 
        .C(\fsm_mapping/n208 ), .D(\fsm_mapping/n209 ), .Q(\fsm_mapping/n206 )
         );
  CLKIN0 \fsm_mapping/U160  ( .A(\fsm_mapping/n206 ), .Q(
        \fsm_mapping/N_STATE [1]) );
  NOR20 \fsm_mapping/U159  ( .A(\fsm_mapping/n98 ), .B(\fsm_mapping/n163 ), 
        .Q(\fsm_mapping/n205 ) );
  CLKIN0 \fsm_mapping/U158  ( .A(\fsm_mapping/n188 ), .Q(\fsm_mapping/n204 )
         );
  NAND30 \fsm_mapping/U157  ( .A(\fsm_mapping/f_temp_dac ), .B(
        \fsm_mapping/n180 ), .C(\fsm_mapping/f_dac_down ), .Q(
        \fsm_mapping/n190 ) );
  AOI210 \fsm_mapping/U155  ( .A(\fsm_mapping/n190 ), .B(\fsm_mapping/n47 ), 
        .C(\fsm_mapping/n68 ), .Q(\fsm_mapping/n193 ) );
  OAI210 \fsm_mapping/U154  ( .A(\fsm_mapping/n205 ), .B(\fsm_mapping/n204 ), 
        .C(\fsm_mapping/n193 ), .Q(\fsm_mapping/n201 ) );
  NAND20 \fsm_mapping/U153  ( .A(\fsm_mapping/n205 ), .B(\fsm_mapping/n69 ), 
        .Q(\fsm_mapping/n154 ) );
  NOR20 \fsm_mapping/U152  ( .A(\fsm_mapping/n204 ), .B(\fsm_mapping/n154 ), 
        .Q(\fsm_mapping/n202 ) );
  XNR20 \fsm_mapping/U151  ( .A(\fsm_mapping/cpt [1]), .B(\fsm_mapping/cpt [0]), .Q(\fsm_mapping/n82 ) );
  AOI2110 \fsm_mapping/U150  ( .A(\fsm_mapping/n82 ), .B(\fsm_mapping/n98 ), 
        .C(\fsm_mapping/n53 ), .D(\fsm_mapping/n69 ), .Q(\fsm_mapping/n203 )
         );
  AOI2110 \fsm_mapping/U149  ( .A(\fsm_mapping/cpt [2]), .B(\fsm_mapping/n201 ), .C(\fsm_mapping/n202 ), .D(\fsm_mapping/n203 ), .Q(\fsm_mapping/n196 ) );
  NAND20 \fsm_mapping/U148  ( .A(\fsm_mapping/dac_ready_prev ), .B(dac_ready), 
        .Q(\fsm_mapping/n122 ) );
  NOR20 \fsm_mapping/U147  ( .A(\fsm_mapping/n122 ), .B(\fsm_mapping/n164 ), 
        .Q(\fsm_mapping/n197 ) );
  NOR20 \fsm_mapping/U146  ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n119 ), 
        .Q(\fsm_mapping/n174 ) );
  OAI210 \fsm_mapping/U145  ( .A(\fsm_mapping/C_STATE [0]), .B(
        \fsm_mapping/n173 ), .C(\fsm_mapping/n174 ), .Q(\fsm_mapping/n199 ) );
  NOR20 \fsm_mapping/U144  ( .A(dac_ready), .B(\fsm_mapping/n174 ), .Q(
        \fsm_mapping/n200 ) );
  CLKIN0 \fsm_mapping/U143  ( .A(\fsm_mapping/n200 ), .Q(\fsm_mapping/n172 )
         );
  NAND20 \fsm_mapping/U142  ( .A(\fsm_mapping/n199 ), .B(\fsm_mapping/n172 ), 
        .Q(\fsm_mapping/n165 ) );
  CLKIN0 \fsm_mapping/U141  ( .A(\fsm_mapping/n165 ), .Q(\fsm_mapping/n198 )
         );
  OAI210 \fsm_mapping/U140  ( .A(\fsm_mapping/n197 ), .B(\fsm_mapping/n198 ), 
        .C(\fsm_mapping/N259 ), .Q(\fsm_mapping/n182 ) );
  CLKIN0 \fsm_mapping/U139  ( .A(\fsm_mapping/n182 ), .Q(\fsm_mapping/n183 )
         );
  NAND20 \fsm_mapping/U138  ( .A(\fsm_mapping/n119 ), .B(\fsm_mapping/n80 ), 
        .Q(\fsm_mapping/n65 ) );
  OAI210 \fsm_mapping/U137  ( .A(\fsm_mapping/n90 ), .B(\fsm_mapping/n190 ), 
        .C(\fsm_mapping/n65 ), .Q(\fsm_mapping/n194 ) );
  AOI220 \fsm_mapping/U136  ( .A(\fsm_mapping/n194 ), .B(\fsm_mapping/n98 ), 
        .C(\fsm_mapping/n195 ), .D(\fsm_mapping/n188 ), .Q(\fsm_mapping/n191 )
         );
  NOR20 \fsm_mapping/U135  ( .A(\fsm_mapping/n69 ), .B(\fsm_mapping/n193 ), 
        .Q(\fsm_mapping/n184 ) );
  OAI210 \fsm_mapping/U134  ( .A(\fsm_mapping/n184 ), .B(\fsm_mapping/n182 ), 
        .C(\fsm_mapping/cpt [0]), .Q(\fsm_mapping/n192 ) );
  OAI210 \fsm_mapping/U133  ( .A(\fsm_mapping/n191 ), .B(\fsm_mapping/n182 ), 
        .C(\fsm_mapping/n192 ), .Q(\fsm_mapping/n232 ) );
  CLKIN0 \fsm_mapping/U131  ( .A(\fsm_mapping/n190 ), .Q(\fsm_mapping/n189 )
         );
  AOI220 \fsm_mapping/U130  ( .A(\fsm_mapping/n188 ), .B(\fsm_mapping/n69 ), 
        .C(\fsm_mapping/n189 ), .D(\fsm_mapping/n47 ), .Q(\fsm_mapping/n187 )
         );
  AOI210 \fsm_mapping/U128  ( .A(\fsm_mapping/n184 ), .B(\fsm_mapping/cpt [1]), 
        .C(\fsm_mapping/n185 ), .Q(\fsm_mapping/n181 ) );
  NOR40 \fsm_mapping/U127  ( .A(\fsm_mapping/n178 ), .B(\fsm_mapping/n179 ), 
        .C(\fsm_mapping/n180 ), .D(\fsm_mapping/cpt_old [2]), .Q(
        \fsm_mapping/n166 ) );
  OAI310 \fsm_mapping/U126  ( .A(\fsm_mapping/n177 ), .B(\fsm_mapping/n166 ), 
        .C(\fsm_mapping/n161 ), .D(dac_ready), .Q(\fsm_mapping/n231 ) );
  XNR20 \fsm_mapping/U125  ( .A(\fsm_mapping/b_in_prev ), .B(b_in), .Q(
        \fsm_mapping/n114 ) );
  NAND20 \fsm_mapping/U124  ( .A(\fsm_mapping/n143 ), .B(\fsm_mapping/n114 ), 
        .Q(\fsm_mapping/n170 ) );
  CLKIN0 \fsm_mapping/U123  ( .A(\fsm_mapping/n170 ), .Q(\fsm_mapping/n175 )
         );
  OAI210 \fsm_mapping/U121  ( .A(\fsm_mapping/C_STATE [1]), .B(
        \fsm_mapping/n173 ), .C(\fsm_mapping/n174 ), .Q(\fsm_mapping/n171 ) );
  NAND30 \fsm_mapping/U120  ( .A(\fsm_mapping/n171 ), .B(\fsm_mapping/n172 ), 
        .C(\fsm_mapping/N260 ), .Q(\fsm_mapping/n168 ) );
  NOR20 \fsm_mapping/U119  ( .A(\fsm_mapping/n170 ), .B(\fsm_mapping/n168 ), 
        .Q(\fsm_mapping/n169 ) );
  OAI220 \fsm_mapping/U118  ( .A(\fsm_mapping/n167 ), .B(\fsm_mapping/n168 ), 
        .C(\fsm_mapping/n169 ), .D(\fsm_mapping/n131 ), .Q(\fsm_mapping/n230 )
         );
  CLKIN0 \fsm_mapping/U117  ( .A(\fsm_mapping/n120 ), .Q(\fsm_mapping/n113 )
         );
  NAND20 \fsm_mapping/U116  ( .A(\fsm_mapping/n166 ), .B(\fsm_mapping/n113 ), 
        .Q(\fsm_mapping/n75 ) );
  NAND20 \fsm_mapping/U115  ( .A(\fsm_mapping/cpt [2]), .B(\fsm_mapping/n75 ), 
        .Q(\fsm_mapping/n58 ) );
  CLKIN0 \fsm_mapping/U114  ( .A(\fsm_mapping/n58 ), .Q(\fsm_mapping/n59 ) );
  CLKIN0 \fsm_mapping/U112  ( .A(\fsm_mapping/n44 ), .Q(\fsm_mapping/n45 ) );
  NAND20 \fsm_mapping/U111  ( .A(\fsm_mapping/n69 ), .B(\fsm_mapping/n163 ), 
        .Q(\fsm_mapping/n99 ) );
  OAI2110 \fsm_mapping/U108  ( .A(\fsm_mapping/n69 ), .B(\fsm_mapping/n156 ), 
        .C(\fsm_mapping/n75 ), .D(\fsm_mapping/n81 ), .Q(\fsm_mapping/n157 )
         );
  CLKIN0 \fsm_mapping/U107  ( .A(\fsm_mapping/n80 ), .Q(\fsm_mapping/n56 ) );
  NAND20 \fsm_mapping/U106  ( .A(\fsm_mapping/n161 ), .B(
        \fsm_mapping/cpt_old [0]), .Q(\fsm_mapping/n145 ) );
  CLKIN0 \fsm_mapping/U101  ( .A(\fsm_mapping/n92 ), .Q(\fsm_mapping/n54 ) );
  CLKIN0 \fsm_mapping/U99  ( .A(\fsm_mapping/n154 ), .Q(\fsm_mapping/n160 ) );
  AOI210 \fsm_mapping/U97  ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n157 ), 
        .C(\fsm_mapping/n158 ), .Q(\fsm_mapping/n155 ) );
  NAND20 \fsm_mapping/U96  ( .A(\fsm_mapping/n154 ), .B(\fsm_mapping/n83 ), 
        .Q(\fsm_mapping/n153 ) );
  AOI220 \fsm_mapping/U95  ( .A(\fsm_mapping/n153 ), .B(\fsm_mapping/n131 ), 
        .C(\fsm_mapping/S_AQ ), .D(\fsm_mapping/n83 ), .Q(\fsm_mapping/n151 )
         );
  NOR20 \fsm_mapping/U93  ( .A(\fsm_mapping/n69 ), .B(\fsm_mapping/n147 ), .Q(
        \fsm_mapping/n152 ) );
  CLKIN0 \fsm_mapping/U92  ( .A(\fsm_mapping/n75 ), .Q(\fsm_mapping/n138 ) );
  AOI2110 \fsm_mapping/U91  ( .A(\fsm_mapping/cpt [0]), .B(\fsm_mapping/n69 ), 
        .C(\fsm_mapping/n152 ), .D(\fsm_mapping/n138 ), .Q(\fsm_mapping/n150 )
         );
  AOI210 \fsm_mapping/U89  ( .A(\fsm_mapping/n119 ), .B(\fsm_mapping/n148 ), 
        .C(\fsm_mapping/n149 ), .Q(\fsm_mapping/n146 ) );
  XNR20 \fsm_mapping/U88  ( .A(\fsm_mapping/n131 ), .B(\fsm_mapping/n99 ), .Q(
        \fsm_mapping/n139 ) );
  AOI210 \fsm_mapping/U82  ( .A(\fsm_mapping/n69 ), .B(\fsm_mapping/cpt [1]), 
        .C(\fsm_mapping/n138 ), .Q(\fsm_mapping/n106 ) );
  NOR20 \fsm_mapping/U81  ( .A(\fsm_mapping/n106 ), .B(\fsm_mapping/n51 ), .Q(
        \fsm_mapping/n137 ) );
  AOI2110 \fsm_mapping/U80  ( .A(\fsm_mapping/n119 ), .B(\fsm_mapping/n135 ), 
        .C(\fsm_mapping/n136 ), .D(\fsm_mapping/n137 ), .Q(\fsm_mapping/n133 )
         );
  AOI210 \fsm_mapping/U79  ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n59 ), .C(
        \fsm_mapping/n45 ), .Q(\fsm_mapping/n128 ) );
  AOI220 \fsm_mapping/U77  ( .A(\fsm_mapping/n47 ), .B(\fsm_mapping/n131 ), 
        .C(\fsm_mapping/n119 ), .D(\fsm_mapping/n132 ), .Q(\fsm_mapping/n130 )
         );
  OAI220 \fsm_mapping/U76  ( .A(\fsm_mapping/n128 ), .B(\fsm_mapping/n129 ), 
        .C(\fsm_mapping/n45 ), .D(\fsm_mapping/n130 ), .Q(\fsm_mapping/n229 )
         );
  AOI220 \fsm_mapping/U73  ( .A(\fsm_mapping/temp_QBB [0]), .B(
        \fsm_mapping/n39 ), .C(QBB[0]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n126 ) );
  CLKIN0 \fsm_mapping/U72  ( .A(\fsm_mapping/n126 ), .Q(\fsm_mapping/n228 ) );
  AOI220 \fsm_mapping/U71  ( .A(\fsm_mapping/temp_QBB [1]), .B(
        \fsm_mapping/n39 ), .C(QBB[1]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n125 ) );
  CLKIN0 \fsm_mapping/U70  ( .A(\fsm_mapping/n125 ), .Q(\fsm_mapping/n227 ) );
  AOI220 \fsm_mapping/U69  ( .A(\fsm_mapping/temp_QBB [2]), .B(
        \fsm_mapping/n39 ), .C(QBB[2]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n124 ) );
  CLKIN0 \fsm_mapping/U68  ( .A(\fsm_mapping/n124 ), .Q(\fsm_mapping/n226 ) );
  AOI220 \fsm_mapping/U67  ( .A(\fsm_mapping/temp_QBB [3]), .B(
        \fsm_mapping/n39 ), .C(QBB[3]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n123 ) );
  CLKIN0 \fsm_mapping/U66  ( .A(\fsm_mapping/n123 ), .Q(\fsm_mapping/n225 ) );
  AOI210 \fsm_mapping/U63  ( .A(\fsm_mapping/n47 ), .B(\fsm_mapping/n118 ), 
        .C(\fsm_mapping/n119 ), .Q(\fsm_mapping/n117 ) );
  OAI2110 \fsm_mapping/U62  ( .A(dac_ready), .B(\fsm_mapping/n51 ), .C(
        \fsm_mapping/N260 ), .D(\fsm_mapping/n117 ), .Q(\fsm_mapping/n109 ) );
  AOI210 \fsm_mapping/U61  ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n113 ), 
        .C(\fsm_mapping/n109 ), .Q(\fsm_mapping/n107 ) );
  NOR20 \fsm_mapping/U60  ( .A(\fsm_mapping/n115 ), .B(\fsm_mapping/n116 ), 
        .Q(\fsm_mapping/n110 ) );
  XNR20 \fsm_mapping/U59  ( .A(\fsm_mapping/n48 ), .B(\fsm_mapping/n114 ), .Q(
        \fsm_mapping/n111 ) );
  AOI220 \fsm_mapping/U57  ( .A(\fsm_mapping/n110 ), .B(b_in), .C(
        \fsm_mapping/n111 ), .D(\fsm_mapping/n112 ), .Q(\fsm_mapping/n108 ) );
  OAI220 \fsm_mapping/U56  ( .A(\fsm_mapping/n107 ), .B(\fsm_mapping/n48 ), 
        .C(\fsm_mapping/n108 ), .D(\fsm_mapping/n109 ), .Q(\fsm_mapping/n224 )
         );
  OAI2110 \fsm_mapping/U55  ( .A(\fsm_mapping/n100 ), .B(\fsm_mapping/n58 ), 
        .C(\fsm_mapping/n83 ), .D(\fsm_mapping/n106 ), .Q(\fsm_mapping/n102 )
         );
  NOR20 \fsm_mapping/U54  ( .A(\fsm_mapping/n99 ), .B(\fsm_mapping/n98 ), .Q(
        \fsm_mapping/n105 ) );
  CLKIN0 \fsm_mapping/U53  ( .A(\fsm_mapping/n105 ), .Q(\fsm_mapping/n97 ) );
  AOI220 \fsm_mapping/U52  ( .A(\fsm_mapping/n54 ), .B(
        \fsm_mapping/temp_IBB [0]), .C(\fsm_mapping/n92 ), .D(
        \fsm_mapping/n97 ), .Q(\fsm_mapping/n104 ) );
  OAI220 \fsm_mapping/U51  ( .A(\fsm_mapping/n104 ), .B(\fsm_mapping/n53 ), 
        .C(\fsm_mapping/n105 ), .D(\fsm_mapping/n90 ), .Q(\fsm_mapping/n103 )
         );
  AOI210 \fsm_mapping/U50  ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n102 ), 
        .C(\fsm_mapping/n103 ), .Q(\fsm_mapping/n101 ) );
  OAI210 \fsm_mapping/U49  ( .A(\fsm_mapping/n59 ), .B(\fsm_mapping/n98 ), .C(
        \fsm_mapping/n99 ), .Q(\fsm_mapping/n96 ) );
  NAND20 \fsm_mapping/U48  ( .A(\fsm_mapping/n98 ), .B(\fsm_mapping/n99 ), .Q(
        \fsm_mapping/n93 ) );
  AOI210 \fsm_mapping/U47  ( .A(\fsm_mapping/n93 ), .B(\fsm_mapping/n97 ), .C(
        \fsm_mapping/S_AI ), .Q(\fsm_mapping/n94 ) );
  AOI220 \fsm_mapping/U46  ( .A(\fsm_mapping/S_AI ), .B(\fsm_mapping/n96 ), 
        .C(\fsm_mapping/n94 ), .D(\fsm_mapping/n58 ), .Q(\fsm_mapping/n95 ) );
  OAI210 \fsm_mapping/U45  ( .A(\fsm_mapping/n84 ), .B(\fsm_mapping/n58 ), .C(
        \fsm_mapping/n95 ), .Q(\fsm_mapping/n86 ) );
  AOI210 \fsm_mapping/U44  ( .A(\fsm_mapping/S_AI ), .B(\fsm_mapping/n93 ), 
        .C(\fsm_mapping/n94 ), .Q(\fsm_mapping/n89 ) );
  OAI220 \fsm_mapping/U41  ( .A(\fsm_mapping/n88 ), .B(\fsm_mapping/n53 ), .C(
        \fsm_mapping/n89 ), .D(\fsm_mapping/n90 ), .Q(\fsm_mapping/n87 ) );
  AOI210 \fsm_mapping/U40  ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n86 ), .C(
        \fsm_mapping/n87 ), .Q(\fsm_mapping/n85 ) );
  NAND20 \fsm_mapping/U39  ( .A(\fsm_mapping/n82 ), .B(\fsm_mapping/n83 ), .Q(
        \fsm_mapping/n67 ) );
  CLKIN0 \fsm_mapping/U38  ( .A(\fsm_mapping/n67 ), .Q(\fsm_mapping/n77 ) );
  NOR20 \fsm_mapping/U35  ( .A(\fsm_mapping/n53 ), .B(\fsm_mapping/n80 ), .Q(
        \fsm_mapping/n73 ) );
  NOR20 \fsm_mapping/U34  ( .A(\fsm_mapping/n76 ), .B(\fsm_mapping/n75 ), .Q(
        \fsm_mapping/n79 ) );
  AOI2110 \fsm_mapping/U33  ( .A(n4), .B(\fsm_mapping/n73 ), .C(
        \fsm_mapping/n79 ), .D(\fsm_mapping/n47 ), .Q(\fsm_mapping/n70 ) );
  XNR20 \fsm_mapping/U32  ( .A(\fsm_mapping/S_AI ), .B(\fsm_mapping/n77 ), .Q(
        \fsm_mapping/n71 ) );
  CLKIN0 \fsm_mapping/U31  ( .A(\fsm_mapping/n76 ), .Q(\fsm_mapping/n74 ) );
  AOI220 \fsm_mapping/U30  ( .A(\fsm_mapping/n73 ), .B(\fsm_mapping/n57 ), .C(
        \fsm_mapping/n74 ), .D(\fsm_mapping/n75 ), .Q(\fsm_mapping/n72 ) );
  OAI220 \fsm_mapping/U29  ( .A(\fsm_mapping/n70 ), .B(\fsm_mapping/n71 ), .C(
        \fsm_mapping/n72 ), .D(\fsm_mapping/n60 ), .Q(\fsm_mapping/n63 ) );
  AOI2110 \fsm_mapping/U27  ( .A(\fsm_mapping/n65 ), .B(\fsm_mapping/n66 ), 
        .C(\fsm_mapping/n67 ), .D(\fsm_mapping/S_AI ), .Q(\fsm_mapping/n64 )
         );
  AOI2110 \fsm_mapping/U26  ( .A(\fsm_mapping/S_AI ), .B(\fsm_mapping/n62 ), 
        .C(\fsm_mapping/n63 ), .D(\fsm_mapping/n64 ), .Q(\fsm_mapping/n61 ) );
  AOI210 \fsm_mapping/U24  ( .A(\fsm_mapping/n56 ), .B(\fsm_mapping/n57 ), .C(
        \fsm_mapping/S_AI ), .Q(\fsm_mapping/n55 ) );
  AOI210 \fsm_mapping/U23  ( .A(\fsm_mapping/n54 ), .B(
        \fsm_mapping/temp_IBB [3]), .C(\fsm_mapping/n55 ), .Q(
        \fsm_mapping/n52 ) );
  OAI220 \fsm_mapping/U22  ( .A(\fsm_mapping/n50 ), .B(\fsm_mapping/n51 ), .C(
        \fsm_mapping/n52 ), .D(\fsm_mapping/n53 ), .Q(\fsm_mapping/n49 ) );
  AOI210 \fsm_mapping/U21  ( .A(\fsm_mapping/n47 ), .B(\fsm_mapping/n48 ), .C(
        \fsm_mapping/n49 ), .Q(\fsm_mapping/n46 ) );
  AOI220 \fsm_mapping/U20  ( .A(\fsm_mapping/temp_IBB [0]), .B(
        \fsm_mapping/n39 ), .C(IBB[0]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n43 ) );
  CLKIN0 \fsm_mapping/U19  ( .A(\fsm_mapping/n43 ), .Q(\fsm_mapping/n223 ) );
  AOI220 \fsm_mapping/U18  ( .A(\fsm_mapping/temp_IBB [1]), .B(
        \fsm_mapping/n39 ), .C(IBB[1]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n42 ) );
  CLKIN0 \fsm_mapping/U17  ( .A(\fsm_mapping/n42 ), .Q(\fsm_mapping/n222 ) );
  AOI220 \fsm_mapping/U16  ( .A(\fsm_mapping/temp_IBB [2]), .B(
        \fsm_mapping/n39 ), .C(IBB[2]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n41 ) );
  CLKIN0 \fsm_mapping/U15  ( .A(\fsm_mapping/n41 ), .Q(\fsm_mapping/n221 ) );
  AOI220 \fsm_mapping/U14  ( .A(\fsm_mapping/temp_IBB [3]), .B(
        \fsm_mapping/n39 ), .C(IBB[3]), .D(\fsm_mapping/n40 ), .Q(
        \fsm_mapping/n38 ) );
  CLKIN0 \fsm_mapping/U13  ( .A(\fsm_mapping/n38 ), .Q(\fsm_mapping/n220 ) );
  INV2 \fsm_mapping/U12  ( .A(\fsm_mapping/n196 ), .Q(\fsm_mapping/n37 ) );
  INV2 \fsm_mapping/U11  ( .A(\fsm_mapping/N261 ), .Q(\fsm_mapping/n36 ) );
  INV2 \fsm_mapping/U10  ( .A(\fsm_mapping/n181 ), .Q(\fsm_mapping/n35 ) );
  INV2 \fsm_mapping/U9  ( .A(\fsm_mapping/n101 ), .Q(\fsm_mapping/n34 ) );
  INV2 \fsm_mapping/U8  ( .A(\fsm_mapping/n146 ), .Q(\fsm_mapping/n33 ) );
  INV2 \fsm_mapping/U7  ( .A(\fsm_mapping/n155 ), .Q(\fsm_mapping/n32 ) );
  INV2 \fsm_mapping/U6  ( .A(\fsm_mapping/n85 ), .Q(\fsm_mapping/n31 ) );
  INV2 \fsm_mapping/U5  ( .A(\fsm_mapping/n61 ), .Q(\fsm_mapping/n30 ) );
  INV2 \fsm_mapping/U4  ( .A(\fsm_mapping/n46 ), .Q(\fsm_mapping/n29 ) );
  INV2 \fsm_mapping/U3  ( .A(\fsm_mapping/n133 ), .Q(\fsm_mapping/n28 ) );
  DFC1 \fsm_mapping/QBB_reg[2]  ( .D(\fsm_mapping/n226 ), .C(clk), .RN(resetn), 
        .Q(QBB[2]) );
  DFEC1 \fsm_mapping/temp_QBB_reg[2]  ( .D(\fsm_mapping/n28 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_QBB [2]), .QN(\fsm_mapping/n134 ) );
  DFC1 \fsm_mapping/IBB_reg[3]  ( .D(\fsm_mapping/n220 ), .C(clk), .RN(resetn), 
        .Q(IBB[3]) );
  DFEC1 \fsm_mapping/temp_IBB_reg[3]  ( .D(\fsm_mapping/n29 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_IBB [3]) );
  DFC1 \fsm_mapping/IBB_reg[2]  ( .D(\fsm_mapping/n221 ), .C(clk), .RN(resetn), 
        .Q(IBB[2]) );
  DFEC1 \fsm_mapping/temp_IBB_reg[2]  ( .D(\fsm_mapping/n30 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_IBB [2]), .QN(\fsm_mapping/n60 ) );
  DFC1 \fsm_mapping/IBB_reg[1]  ( .D(\fsm_mapping/n222 ), .C(clk), .RN(resetn), 
        .Q(IBB[1]) );
  DFEC1 \fsm_mapping/temp_IBB_reg[1]  ( .D(\fsm_mapping/n31 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_IBB [1]), .QN(\fsm_mapping/n84 ) );
  DFC1 \fsm_mapping/S_AI_reg  ( .D(\fsm_mapping/n224 ), .C(clk), .RN(resetn), 
        .Q(\fsm_mapping/S_AI ), .QN(\fsm_mapping/n48 ) );
  DFC1 \fsm_mapping/QBB_reg[0]  ( .D(\fsm_mapping/n228 ), .C(clk), .RN(resetn), 
        .Q(QBB[0]) );
  DFEC1 \fsm_mapping/temp_QBB_reg[0]  ( .D(\fsm_mapping/n32 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_QBB [0]), .QN(\fsm_mapping/n156 ) );
  DFC1 \fsm_mapping/QBB_reg[1]  ( .D(\fsm_mapping/n227 ), .C(clk), .RN(resetn), 
        .Q(QBB[1]) );
  DFEC1 \fsm_mapping/temp_QBB_reg[1]  ( .D(\fsm_mapping/n33 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_QBB [1]), .QN(\fsm_mapping/n147 ) );
  DFC1 \fsm_mapping/QBB_reg[3]  ( .D(\fsm_mapping/n225 ), .C(clk), .RN(resetn), 
        .Q(QBB[3]) );
  DFC1 \fsm_mapping/temp_QBB_reg[3]  ( .D(\fsm_mapping/n229 ), .C(clk), .RN(
        resetn), .Q(\fsm_mapping/temp_QBB [3]), .QN(\fsm_mapping/n129 ) );
  DFC1 \fsm_mapping/IBB_reg[0]  ( .D(\fsm_mapping/n223 ), .C(clk), .RN(resetn), 
        .Q(IBB[0]) );
  DFEC1 \fsm_mapping/temp_IBB_reg[0]  ( .D(\fsm_mapping/n34 ), .E(
        \fsm_mapping/n44 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/temp_IBB [0]), .QN(\fsm_mapping/n100 ) );
  DFP1 \fsm_mapping/S_AQ_reg  ( .D(\fsm_mapping/n230 ), .C(clk), .SN(resetn), 
        .Q(\fsm_mapping/S_AQ ), .QN(\fsm_mapping/n131 ) );
  DFEC1 \fsm_mapping/ready_reg  ( .D(\fsm_mapping/N233 ), .E(
        \fsm_mapping/N259 ), .C(clk), .RN(resetn), .Q(ready) );
  DFP1 \fsm_mapping/f_dac_down_reg  ( .D(\fsm_mapping/n231 ), .C(clk), .SN(
        resetn), .Q(\fsm_mapping/f_dac_down ), .QN(\fsm_mapping/n177 ) );
  DFEC1 \fsm_mapping/cpt_reg[1]  ( .D(\fsm_mapping/n35 ), .E(
        \fsm_mapping/n183 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/cpt [1]), 
        .QN(\fsm_mapping/n163 ) );
  DFEC1 \fsm_mapping/cpt_old_reg[0]  ( .D(\fsm_mapping/cpt [0]), .E(
        \fsm_mapping/N259 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/cpt_old [0]), .QN(\fsm_mapping/n179 ) );
  DFC1 \fsm_mapping/cpt_reg[0]  ( .D(\fsm_mapping/n232 ), .C(clk), .RN(resetn), 
        .Q(\fsm_mapping/cpt [0]), .QN(\fsm_mapping/n98 ) );
  DFC1 \fsm_mapping/en_dac_reg  ( .D(en_10MHz), .C(clk), .RN(\fsm_mapping/n36 ), .Q(en_dac) );
  DFC1 \fsm_mapping/C_STATE_reg[1]  ( .D(\fsm_mapping/N_STATE [1]), .C(clk), 
        .RN(resetn), .Q(\fsm_mapping/C_STATE [1]) );
  DFEC1 \fsm_mapping/cpt_old_reg[2]  ( .D(\fsm_mapping/cpt [2]), .E(
        \fsm_mapping/N259 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/cpt_old [2]), .QN(\fsm_mapping/n218 ) );
  DFC1 \fsm_mapping/C_STATE_reg[0]  ( .D(\fsm_mapping/N_STATE [0]), .C(clk), 
        .RN(resetn), .Q(\fsm_mapping/C_STATE [0]), .QN(\fsm_mapping/n164 ) );
  DFEC1 \fsm_mapping/b_in_prev_reg  ( .D(\fsm_mapping/s_b_in_prev ), .E(
        \fsm_mapping/N259 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/b_in_prev )
         );
  DFEC1 \fsm_mapping/s_b_in_prev_reg  ( .D(b_in), .E(\fsm_mapping/N260 ), .C(
        clk), .RN(resetn), .Q(\fsm_mapping/s_b_in_prev ) );
  DFC1 \fsm_mapping/en_prev_reg  ( .D(en_2MHz), .C(clk), .RN(resetn), .Q(
        \fsm_mapping/en_prev ) );
  DFC1 \fsm_mapping/en_10MHz_prev_reg  ( .D(en_10MHz), .C(clk), .RN(resetn), 
        .Q(\fsm_mapping/en_10MHz_prev ) );
  DFC1 \fsm_mapping/dac_ready_prev_reg  ( .D(dac_ready), .C(clk), .RN(resetn), 
        .Q(\fsm_mapping/dac_ready_prev ) );
  NOR30 \en_gen_map/U7  ( .A(\en_gen_map/cpt [0]), .B(\en_gen_map/cpt [1]), 
        .C(\en_gen_map/n3 ), .Q(\en_gen_map/N13 ) );
  NOR20 \en_gen_map/U6  ( .A(\en_gen_map/cpt [0]), .B(\en_gen_map/N13 ), .Q(
        \en_gen_map/N6 ) );
  XNR20 \en_gen_map/U5  ( .A(\en_gen_map/cpt [1]), .B(\en_gen_map/cpt [0]), 
        .Q(\en_gen_map/n4 ) );
  DFC1 \en_gen_map/clk_out_reg  ( .D(\en_gen_map/N13 ), .C(clk), .RN(resetn), 
        .Q(en_10MHz), .QN(n3) );
  JKC1 \en_gen_map/cpt_reg[2]  ( .J(\en_gen_map/n1 ), .K(\en_gen_map/n4 ), .C(
        clk), .RN(resetn), .QN(\en_gen_map/n3 ) );
  TFEC1 \en_gen_map/cpt_reg[1]  ( .T(\en_gen_map/cpt [0]), .C(clk), .RN(resetn), .Q(\en_gen_map/cpt [1]), .QN(n1) );
  DFC1 \en_gen_map/cpt_reg[0]  ( .D(\en_gen_map/N6 ), .C(clk), .RN(resetn), 
        .Q(\en_gen_map/cpt [0]), .QN(n2) );
  DFEC1 \fsm_mapping/f_temp_dac_reg  ( .D(\fsm_mapping/n177 ), .E(
        \fsm_mapping/n176 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/f_temp_dac ) );
  DFEC1 \fsm_mapping/cpt_old_reg[1]  ( .D(\fsm_mapping/cpt [1]), .E(
        \fsm_mapping/N259 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/cpt_old [1]), .QN(\fsm_mapping/n178 ) );
  IMUX21 U1 ( .A(\fsm_mapping/n129 ), .B(\fsm_mapping/S_AQ ), .S(
        \fsm_mapping/n92 ), .Q(\fsm_mapping/n132 ) );
  NAND31 U2 ( .A(\fsm_mapping/n120 ), .B(\fsm_mapping/dac_ready_prev ), .C(
        dac_ready), .Q(\fsm_mapping/n118 ) );
  OAI212 U3 ( .A(\fsm_mapping/n98 ), .B(\fsm_mapping/n163 ), .C(
        \fsm_mapping/n69 ), .Q(\fsm_mapping/n81 ) );
  MUX31 U4 ( .A(\fsm_mapping/n139 ), .B(\fsm_mapping/n134 ), .C(
        \fsm_mapping/n134 ), .S0(\fsm_mapping/n145 ), .S1(\fsm_mapping/n143 ), 
        .Q(\fsm_mapping/n140 ) );
  MUX22 U5 ( .A(\fsm_mapping/n84 ), .B(\fsm_mapping/n89 ), .S(
        \fsm_mapping/n92 ), .Q(\fsm_mapping/n88 ) );
  IMUX21 U6 ( .A(\fsm_mapping/n187 ), .B(\fsm_mapping/n65 ), .S(
        \fsm_mapping/n82 ), .Q(\fsm_mapping/n185 ) );
  IMUX21 U7 ( .A(\fsm_mapping/n147 ), .B(\fsm_mapping/n151 ), .S(
        \fsm_mapping/n92 ), .Q(\fsm_mapping/n148 ) );
  NOR21 U8 ( .A(n1), .B(n2), .Q(\en_gen_map/n1 ) );
  NAND20 U10 ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/n69 ), .Q(
        \fsm_mapping/n66 ) );
  NOR21 U11 ( .A(\fsm_mapping/n145 ), .B(\fsm_mapping/n143 ), .Q(n4) );
  IMUX21 U13 ( .A(\fsm_mapping/n140 ), .B(\fsm_mapping/n139 ), .S(
        \fsm_mapping/n80 ), .Q(\fsm_mapping/n135 ) );
  OAI220 U14 ( .A(\fsm_mapping/n160 ), .B(\fsm_mapping/n90 ), .C(
        \fsm_mapping/n159 ), .D(\fsm_mapping/n53 ), .Q(\fsm_mapping/n158 ) );
  OAI222 U15 ( .A(\fsm_mapping/n51 ), .B(\fsm_mapping/n81 ), .C(
        \fsm_mapping/n77 ), .D(\fsm_mapping/n65 ), .Q(\fsm_mapping/n62 ) );
  DFEC3 \fsm_mapping/cpt_reg[2]  ( .D(\fsm_mapping/n37 ), .E(
        \fsm_mapping/n183 ), .C(clk), .RN(resetn), .Q(\fsm_mapping/cpt [2]), 
        .QN(\fsm_mapping/n69 ) );
  IMUX21 U9 ( .A(\fsm_mapping/temp_QBB [0]), .B(\fsm_mapping/n154 ), .S(
        \fsm_mapping/n92 ), .Q(\fsm_mapping/n159 ) );
  OAI221 U12 ( .A(\fsm_mapping/n51 ), .B(\fsm_mapping/n150 ), .C(
        \fsm_mapping/n151 ), .D(\fsm_mapping/n90 ), .Q(\fsm_mapping/n149 ) );
  IMUX20 U16 ( .A(\fsm_mapping/temp_IBB [3]), .B(\fsm_mapping/n48 ), .S(
        \fsm_mapping/n58 ), .Q(\fsm_mapping/n50 ) );
  NAND22 U17 ( .A(\fsm_mapping/n195 ), .B(\fsm_mapping/n163 ), .Q(
        \fsm_mapping/n80 ) );
  OAI311 U18 ( .A(\fsm_mapping/n164 ), .B(\fsm_mapping/n59 ), .C(
        \fsm_mapping/n122 ), .D(\fsm_mapping/n165 ), .Q(\fsm_mapping/n44 ) );
  NOR21 U19 ( .A(n3), .B(\fsm_mapping/en_10MHz_prev ), .Q(\fsm_mapping/N259 )
         );
  INV3 U20 ( .A(\fsm_mapping/n53 ), .Q(\fsm_mapping/n119 ) );
  NAND21 U21 ( .A(\fsm_mapping/C_STATE [1]), .B(\fsm_mapping/n164 ), .Q(
        \fsm_mapping/n53 ) );
  CLKIN1 U22 ( .A(\fsm_mapping/n90 ), .Q(\fsm_mapping/n47 ) );
  NAND21 U23 ( .A(\fsm_mapping/n51 ), .B(\fsm_mapping/n90 ), .Q(
        \fsm_mapping/n188 ) );
  OAI221 U24 ( .A(\fsm_mapping/n76 ), .B(\fsm_mapping/n134 ), .C(
        \fsm_mapping/n139 ), .D(\fsm_mapping/n90 ), .Q(\fsm_mapping/n136 ) );
  OAI212 U25 ( .A(\fsm_mapping/n210 ), .B(\fsm_mapping/n51 ), .C(
        \fsm_mapping/n90 ), .Q(\fsm_mapping/n209 ) );
  OAI212 U26 ( .A(\fsm_mapping/n76 ), .B(\fsm_mapping/n113 ), .C(
        \fsm_mapping/n90 ), .Q(\fsm_mapping/n112 ) );
  NAND21 U27 ( .A(\fsm_mapping/C_STATE [1]), .B(\fsm_mapping/C_STATE [0]), .Q(
        \fsm_mapping/n90 ) );
  NAND22 U28 ( .A(\fsm_mapping/n56 ), .B(\fsm_mapping/n57 ), .Q(
        \fsm_mapping/n92 ) );
  CLKIN0 U29 ( .A(n4), .Q(\fsm_mapping/n57 ) );
  NOR21 U30 ( .A(\fsm_mapping/n40 ), .B(\fsm_mapping/n127 ), .Q(
        \fsm_mapping/n39 ) );
  NOR21 U31 ( .A(\fsm_mapping/N259 ), .B(\fsm_mapping/n127 ), .Q(
        \fsm_mapping/n40 ) );
  INV2 U32 ( .A(\fsm_mapping/n68 ), .Q(\fsm_mapping/n51 ) );
  NAND22 U33 ( .A(\fsm_mapping/n68 ), .B(\fsm_mapping/cpt [2]), .Q(
        \fsm_mapping/n76 ) );
  AOI2111 U34 ( .A(\fsm_mapping/n175 ), .B(\fsm_mapping/n131 ), .C(
        \fsm_mapping/n127 ), .D(\fsm_mapping/n68 ), .Q(\fsm_mapping/n167 ) );
  NOR21 U35 ( .A(\fsm_mapping/n164 ), .B(\fsm_mapping/C_STATE [1]), .Q(
        \fsm_mapping/n68 ) );
endmodule

