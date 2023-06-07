
module zigbee_cordic_top ( reset_n, clk, ibb, qbb, iValid, wout, oValid );
  input [4:0] ibb;
  input [4:0] qbb;
  output [5:0] wout;
  input reset_n, clk, iValid;
  output oValid;
  wire   \cor_x_s0[2][5] , \cor_x_s0[2][4] , \cor_x_s0[2][3] ,
         \cor_x_s0[2][2] , \cor_x_s0[1][5] , \cor_x_s0[1][4] ,
         \cor_x_s0[1][3] , \cor_x_s0[1][2] , \cor_x_s0[1][1] ,
         \cor_x_s0[1][0] , \cor_x_s0[0][3] , \cor_x_s0[0][2] ,
         \cor_x_s0[0][1] , \cor_x_s0[0][0] , \cor_y_s0[2][5] ,
         \cor_y_s0[2][4] , \cor_y_s0[2][3] , \cor_y_s0[2][2] ,
         \cor_y_s0[2][1] , \cor_y_s0[2][0] , \cor_y_s0[1][5] ,
         \cor_y_s0[1][4] , \cor_y_s0[1][3] , \cor_y_s0[1][2] ,
         \cor_y_s0[1][1] , \cor_y_s0[1][0] , \cor_y_s0[0][5] ,
         \cor_y_s0[0][4] , \cor_y_s0[0][3] , \cor_y_s0[0][2] ,
         \cor_y_s0[0][1] , \cor_y_s0[0][0] , \cor_w_s0[2][5] ,
         \cor_w_s0[2][4] , \valid_s0[2] , \cor_x_s1[2][5] , \cor_x_s1[2][4] ,
         \cor_x_s1[2][3] , \cor_x_s1[2][2] , \cor_y_s1[2][5] ,
         \cor_y_s1[2][4] , \cor_y_s1[2][3] , \cor_y_s1[2][2] ,
         \cor_y_s1[2][1] , \cor_w_s1[4][5] , \cor_w_s1[4][4] ,
         \cor_w_s1[4][3] , \cor_w_s1[4][2] , \valid_s1[4] , N6, N7, N8, N9,
         N10, N13, N14, N15, N16, N20, n5, n14, n15, n16, n17, \S0/n39 ,
         \S0/n38 , \S0/n37 , \S0/n36 , \S0/n35 , \S0/n34 , \S0/n33 , \S0/n32 ,
         \S0/n29 , \S0/n28 , \S0/n27 , \S0/n26 , \S0/n25 , \S0/n24 , \S0/n23 ,
         \S0/n22 , \S0/N32 , \S0/N19 , \S0/N18 , \S0/N17 , \S0/N16 , \S0/N14 ,
         \S0/N13 , \S0/N12 , \S0/N11 , \S0/N10 , \S0/N9 , \S0/N7 , \S0/N6 ,
         \S0/N5 , \S0/N4 , \S1/n35 , \S1/n34 , \S1/n27 , \S1/N38 , \S1/N26 ,
         \S1/N25 , \S1/N24 , \S1/N23 , \S1/N22 , \S1/N21 , \S1/N20 , \S1/N19 ,
         \S1/N18 , \S1/N17 , \S1/N16 , \S1/N15 , \S1/N14 , \S1/N13 , \S1/N12 ,
         \S1/N11 , \S1/N8 , \S1/N7 , \S1/N6 , \S1/N5 , \S2/n37 , \S2/n36 ,
         \S2/n35 , \S2/n34 , \S2/n21 , \S2/N38 , \S2/N37 , \S2/N36 , \S2/N32 ,
         \S2/N31 , \S2/N30 , \S2/N29 , \S2/N26 , \S2/N20 , \S3/n30 , \S3/n28 ,
         \S3/n27 , \S3/n26 , \S3/N38 , \S3/N37 , \S3/N30 ,
         \S2/sub_53/carry[5] , \S2/add_53/carry[5] , \S2/sub_56/carry[5] , n25,
         n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40,
         n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54,
         n55, n56, n57, n59, n61, n62, n63, n64, n65, n66, n67, n68, n69, n72,
         n74, n75, n76, n77, n78, n81, n82, n86;
  wire   [4:0] ibb_ibuff;
  wire   [4:0] qbb_ibuff;
  wire   [5:1] \S1/add_50/carry ;
  wire   [5:0] \S1/sub_50/B_not ;
  wire   [6:0] \S1/sub_50/carry ;
  wire   [5:0] \S1/sub_53/B_not ;
  wire   [6:0] \S1/sub_53/carry ;
  wire   [5:1] \S1/add_53/carry ;
  wire   [5:1] \S0/r64/carry ;
  wire   [5:0] \S0/sub_50/B_not ;
  wire   [6:0] \S0/sub_50/carry ;
  wire   [6:0] \S0/sub_53/carry ;
  wire   [5:0] \sub_173/carry ;
  wire   [5:0] \sub_170/carry ;

  DFC1 iValid_ibuff_reg ( .D(iValid), .C(clk), .RN(reset_n), .Q(\valid_s0[2] )
         );
  DFC1 \ibb_ibuff_reg[3]  ( .D(ibb[3]), .C(clk), .RN(reset_n), .Q(ibb_ibuff[3]), .QN(n33) );
  DFC1 \ibb_ibuff_reg[2]  ( .D(ibb[2]), .C(clk), .RN(reset_n), .Q(ibb_ibuff[2]), .QN(n34) );
  DFC1 \ibb_ibuff_reg[1]  ( .D(ibb[1]), .C(clk), .RN(reset_n), .Q(ibb_ibuff[1]), .QN(n38) );
  DFC1 \ibb_ibuff_reg[0]  ( .D(ibb[0]), .C(clk), .RN(reset_n), .Q(N13), .QN(
        n35) );
  DFC1 \qbb_ibuff_reg[4]  ( .D(qbb[4]), .C(clk), .RN(reset_n), .Q(qbb_ibuff[4]), .QN(n41) );
  DFC1 \qbb_ibuff_reg[3]  ( .D(qbb[3]), .C(clk), .RN(reset_n), .Q(qbb_ibuff[3]), .QN(n36) );
  DFC1 \qbb_ibuff_reg[2]  ( .D(qbb[2]), .C(clk), .RN(reset_n), .Q(qbb_ibuff[2]), .QN(n44) );
  DFC1 \qbb_ibuff_reg[1]  ( .D(qbb[1]), .C(clk), .RN(reset_n), .Q(n32), .QN(
        n43) );
  DFC1 \qbb_ibuff_reg[0]  ( .D(qbb[0]), .C(clk), .RN(reset_n), .Q(N6), .QN(n42) );
  DFC1 \valid_s1_reg[2]  ( .D(\valid_s0[2] ), .C(clk), .RN(reset_n), .Q(
        \valid_s1[4] ) );
  DFC1 \cor_x_s1_reg[2][5]  ( .D(\cor_x_s0[2][5] ), .C(clk), .RN(reset_n), .Q(
        \cor_x_s1[2][5] ), .QN(n45) );
  DFC1 \cor_x_s1_reg[2][4]  ( .D(\cor_x_s0[2][4] ), .C(clk), .RN(reset_n), .Q(
        \cor_x_s1[2][4] ) );
  DFC1 \cor_x_s1_reg[2][3]  ( .D(\cor_x_s0[2][3] ), .C(clk), .RN(reset_n), .Q(
        \cor_x_s1[2][3] ), .QN(n39) );
  DFC1 \cor_x_s1_reg[2][2]  ( .D(\cor_x_s0[2][2] ), .C(clk), .RN(reset_n), .Q(
        \cor_x_s1[2][2] ), .QN(n29) );
  DFC1 \cor_y_s1_reg[2][5]  ( .D(\cor_y_s0[2][5] ), .C(clk), .RN(reset_n), .Q(
        \cor_y_s1[2][5] ), .QN(n37) );
  DFC1 \cor_y_s1_reg[2][4]  ( .D(\cor_y_s0[2][4] ), .C(clk), .RN(reset_n), .Q(
        \cor_y_s1[2][4] ), .QN(n47) );
  DFC1 \cor_y_s1_reg[2][3]  ( .D(\cor_y_s0[2][3] ), .C(clk), .RN(reset_n), .Q(
        \cor_y_s1[2][3] ) );
  DFC1 \cor_y_s1_reg[2][2]  ( .D(\cor_y_s0[2][2] ), .C(clk), .RN(reset_n), .Q(
        \cor_y_s1[2][2] ), .QN(n46) );
  DFC1 \cor_y_s1_reg[2][1]  ( .D(\cor_y_s0[2][1] ), .C(clk), .RN(reset_n), .Q(
        \cor_y_s1[2][1] ), .QN(n28) );
  DFC1 \cor_y_s1_reg[2][0]  ( .D(\cor_y_s0[2][0] ), .C(clk), .RN(reset_n), 
        .QN(n40) );
  DFC1 \cor_w_s1_reg[2][5]  ( .D(\cor_w_s0[2][5] ), .C(clk), .RN(reset_n), .Q(
        \S2/N32 ) );
  DFC1 \cor_w_s1_reg[2][4]  ( .D(\cor_w_s0[2][4] ), .C(clk), .RN(reset_n), .Q(
        \S2/N31 ), .QN(n30) );
  DFC1 \cor_w_s1_reg[2][3]  ( .D(\S1/sub_50/B_not [5]), .C(clk), .RN(reset_n), 
        .Q(\S2/N30 ) );
  DFC1 \cor_w_s1_reg[2][2]  ( .D(n25), .C(clk), .RN(reset_n), .Q(\S2/N29 ), 
        .QN(n31) );
  DFC1 oValid_obuff_reg ( .D(\valid_s1[4] ), .C(clk), .RN(reset_n), .Q(oValid)
         );
  DFC1 \wout_obuff_reg[0]  ( .D(n25), .C(clk), .RN(reset_n), .Q(wout[0]) );
  DFC1 \wout_obuff_reg[1]  ( .D(\S2/n21 ), .C(clk), .RN(reset_n), .Q(wout[1])
         );
  DFC1 \wout_obuff_reg[2]  ( .D(\cor_w_s1[4][2] ), .C(clk), .RN(reset_n), .Q(
        wout[2]) );
  DFC1 \wout_obuff_reg[3]  ( .D(\cor_w_s1[4][3] ), .C(clk), .RN(reset_n), .Q(
        wout[3]) );
  DFC1 \wout_obuff_reg[4]  ( .D(\cor_w_s1[4][4] ), .C(clk), .RN(reset_n), .Q(
        wout[4]) );
  DFC1 \wout_obuff_reg[5]  ( .D(\cor_w_s1[4][5] ), .C(clk), .RN(reset_n), .Q(
        wout[5]) );
  CLKIN0 U25 ( .A(n17), .Q(\cor_x_s0[0][0] ) );
  AOI220 \S0/U46  ( .A(\S0/N32 ), .B(\S0/n39 ), .C(n49), .D(n86), .Q(\S0/n38 )
         );
  CLKIN0 \S0/U45  ( .A(\S0/n38 ), .Q(\S1/N38 ) );
  NAND20 \S0/U43  ( .A(\S0/N9 ), .B(n86), .Q(\S0/n37 ) );
  OAI210 \S0/U42  ( .A(n86), .B(n50), .C(\S0/n37 ), .Q(\cor_x_s0[1][0] ) );
  CLKIN0 \S0/U41  ( .A(\S0/N4 ), .Q(\S0/n28 ) );
  NAND20 \S0/U40  ( .A(\S0/N10 ), .B(n86), .Q(\S0/n36 ) );
  OAI210 \S0/U39  ( .A(n86), .B(\S0/n28 ), .C(\S0/n36 ), .Q(\cor_x_s0[1][1] )
         );
  CLKIN0 \S0/U38  ( .A(\S0/N5 ), .Q(\S0/n26 ) );
  NAND20 \S0/U37  ( .A(\S0/N11 ), .B(n86), .Q(\S0/n35 ) );
  CLKIN0 \S0/U35  ( .A(\S0/N6 ), .Q(\S0/n24 ) );
  NAND20 \S0/U34  ( .A(\S0/N12 ), .B(n86), .Q(\S0/n34 ) );
  CLKIN0 \S0/U32  ( .A(\S0/N7 ), .Q(\S0/n22 ) );
  NAND20 \S0/U31  ( .A(\S0/N13 ), .B(n86), .Q(\S0/n33 ) );
  NAND20 \S0/U28  ( .A(\S0/N14 ), .B(n86), .Q(\S0/n32 ) );
  CLKIN0 \S0/U24  ( .A(\S0/N16 ), .Q(\S0/n29 ) );
  CLKIN0 \S0/U22  ( .A(\S0/N17 ), .Q(\S0/n27 ) );
  CLKIN0 \S0/U20  ( .A(\S0/N18 ), .Q(\S0/n25 ) );
  CLKIN0 \S0/U18  ( .A(\S0/N19 ), .Q(\S0/n23 ) );
  AOI220 \S1/U44  ( .A(\cor_y_s0[0][5] ), .B(\S1/sub_50/B_not [5]), .C(n86), 
        .D(\cor_y_s0[1][5] ), .Q(\S1/n35 ) );
  CLKIN0 \S1/U43  ( .A(\S1/n35 ), .Q(\cor_w_s0[2][4] ) );
  AOI220 \S1/U42  ( .A(\S1/N38 ), .B(\S1/sub_50/B_not [5]), .C(\S1/N38 ), .D(
        \cor_y_s0[1][5] ), .Q(\S1/n34 ) );
  CLKIN0 \S1/U41  ( .A(\S1/n34 ), .Q(\cor_w_s0[2][5] ) );
  AOI220 \S1/U28  ( .A(\S1/N15 ), .B(\S1/sub_50/B_not [5]), .C(\S1/N21 ), .D(
        \cor_y_s0[1][5] ), .Q(\S1/n27 ) );
  CLKIN0 \S1/U27  ( .A(\S1/n27 ), .Q(\cor_y_s0[2][0] ) );
  AOI220 \S2/U48  ( .A(\S2/N29 ), .B(n37), .C(n31), .D(\cor_y_s1[2][5] ), .Q(
        \S2/n37 ) );
  AOI220 \S2/U46  ( .A(\S2/N30 ), .B(n37), .C(\S2/N36 ), .D(\cor_y_s1[2][5] ), 
        .Q(\S2/n36 ) );
  CLKIN0 \S2/U45  ( .A(\S2/n36 ), .Q(\S3/N30 ) );
  AOI220 \S2/U44  ( .A(\S2/N31 ), .B(n37), .C(\S2/N37 ), .D(\cor_y_s1[2][5] ), 
        .Q(\S2/n35 ) );
  CLKIN0 \S2/U43  ( .A(\S2/n35 ), .Q(\S3/N37 ) );
  AOI220 \S2/U42  ( .A(\S2/N32 ), .B(n37), .C(\S2/N38 ), .D(\cor_y_s1[2][5] ), 
        .Q(\S2/n34 ) );
  CLKIN0 \S2/U41  ( .A(\S2/n34 ), .Q(\S3/N38 ) );
  CLKIN0 \S2/U17  ( .A(\S2/n21 ), .Q(\S3/n30 ) );
  AOI220 \S3/U40  ( .A(\S3/N30 ), .B(\S2/n21 ), .C(\S3/N30 ), .D(\S3/n30 ), 
        .Q(\S3/n28 ) );
  CLKIN0 \S3/U39  ( .A(\S3/n28 ), .Q(\cor_w_s1[4][3] ) );
  AOI220 \S3/U38  ( .A(\S3/N37 ), .B(\S2/n21 ), .C(\S3/N37 ), .D(\S3/n30 ), 
        .Q(\S3/n27 ) );
  CLKIN0 \S3/U37  ( .A(\S3/n27 ), .Q(\cor_w_s1[4][4] ) );
  AOI220 \S3/U36  ( .A(\S3/N38 ), .B(\S2/n21 ), .C(\S3/N38 ), .D(\S3/n30 ), 
        .Q(\S3/n26 ) );
  CLKIN0 \S3/U35  ( .A(\S3/n26 ), .Q(\cor_w_s1[4][5] ) );
  ADD32 \S1/sub_50/U2_2  ( .A(\cor_x_s0[1][2] ), .B(\S1/sub_50/B_not [2]), 
        .CI(\S1/sub_50/carry [2]), .CO(\S1/sub_50/carry [3]), .S(\S1/N11 ) );
  ADD32 \S1/sub_50/U2_3  ( .A(\cor_x_s0[1][3] ), .B(\S1/sub_50/B_not [3]), 
        .CI(\S1/sub_50/carry [3]), .CO(\S1/sub_50/carry [4]), .S(\S1/N12 ) );
  ADD32 \S1/sub_50/U2_4  ( .A(\cor_x_s0[1][4] ), .B(\S1/sub_50/B_not [5]), 
        .CI(\S1/sub_50/carry [4]), .CO(\S1/sub_50/carry [5]), .S(\S1/N13 ) );
  ADD32 \S1/sub_53/U2_1  ( .A(\cor_y_s0[1][1] ), .B(\S1/sub_53/B_not [1]), 
        .CI(\S1/sub_53/carry [1]), .CO(\S1/sub_53/carry [2]), .S(\S1/N16 ) );
  ADD32 \S1/sub_53/U2_2  ( .A(\cor_y_s0[1][2] ), .B(\S1/sub_53/B_not [2]), 
        .CI(\S1/sub_53/carry [2]), .CO(\S1/sub_53/carry [3]), .S(\S1/N17 ) );
  ADD32 \S1/sub_53/U2_3  ( .A(\cor_y_s0[1][3] ), .B(\S1/sub_53/B_not [3]), 
        .CI(\S1/sub_53/carry [3]), .CO(\S1/sub_53/carry [4]), .S(\S1/N18 ) );
  ADD32 \S1/sub_53/U2_4  ( .A(\cor_y_s0[1][4] ), .B(\S1/sub_53/B_not [5]), 
        .CI(\S1/sub_53/carry [4]), .CO(\S1/sub_53/carry [5]), .S(\S1/N19 ) );
  ADD32 \S1/add_53/U1_4  ( .A(\cor_y_s0[1][4] ), .B(\cor_x_s0[1][5] ), .CI(
        \S1/add_53/carry [4]), .CO(\S1/add_53/carry [5]), .S(\S1/N25 ) );
  ADD32 \S0/r64/U1_1  ( .A(\cor_x_s0[0][1] ), .B(\cor_y_s0[0][1] ), .CI(
        \S0/r64/carry [1]), .CO(\S0/r64/carry [2]), .S(\S0/N4 ) );
  ADD32 \S0/r64/U1_2  ( .A(\cor_x_s0[0][2] ), .B(\cor_y_s0[0][2] ), .CI(
        \S0/r64/carry [2]), .CO(\S0/r64/carry [3]), .S(\S0/N5 ) );
  ADD32 \S0/r64/U1_3  ( .A(\cor_x_s0[0][3] ), .B(\cor_y_s0[0][3] ), .CI(
        \S0/r64/carry [3]), .CO(\S0/r64/carry [4]), .S(\S0/N6 ) );
  ADD32 \S0/r64/U1_4  ( .A(n48), .B(\cor_y_s0[0][4] ), .CI(\S0/r64/carry [4]), 
        .CO(\S0/r64/carry [5]), .S(\S0/N7 ) );
  ADD32 \S0/sub_50/U2_1  ( .A(\cor_x_s0[0][1] ), .B(\S0/sub_50/B_not [1]), 
        .CI(\S0/sub_50/carry [1]), .CO(\S0/sub_50/carry [2]), .S(\S0/N10 ) );
  ADD32 \S0/sub_50/U2_2  ( .A(\cor_x_s0[0][2] ), .B(\S0/sub_50/B_not [2]), 
        .CI(\S0/sub_50/carry [2]), .CO(\S0/sub_50/carry [3]), .S(\S0/N11 ) );
  ADD32 \S0/sub_50/U2_3  ( .A(\cor_x_s0[0][3] ), .B(\S0/sub_50/B_not [3]), 
        .CI(\S0/sub_50/carry [3]), .CO(\S0/sub_50/carry [4]), .S(\S0/N12 ) );
  ADD32 \S0/sub_50/U2_4  ( .A(n48), .B(\S0/sub_50/B_not [4]), .CI(
        \S0/sub_50/carry [4]), .CO(\S0/sub_50/carry [5]), .S(\S0/N13 ) );
  ADD32 \S0/sub_53/U2_1  ( .A(\cor_y_s0[0][1] ), .B(n16), .CI(
        \S0/sub_53/carry [1]), .CO(\S0/sub_53/carry [2]), .S(\S0/N16 ) );
  ADD32 \S0/sub_53/U2_2  ( .A(\cor_y_s0[0][2] ), .B(n15), .CI(
        \S0/sub_53/carry [2]), .CO(\S0/sub_53/carry [3]), .S(\S0/N17 ) );
  ADD32 \S0/sub_53/U2_3  ( .A(\cor_y_s0[0][3] ), .B(n14), .CI(
        \S0/sub_53/carry [3]), .CO(\S0/sub_53/carry [4]), .S(\S0/N18 ) );
  ADD32 \S0/sub_53/U2_4  ( .A(\cor_y_s0[0][4] ), .B(n27), .CI(
        \S0/sub_53/carry [4]), .CO(\S0/sub_53/carry [5]), .S(\S0/N19 ) );
  XOR31 \S1/add_53/U1_5  ( .A(\cor_y_s0[1][5] ), .B(\cor_x_s0[1][5] ), .C(
        \S1/add_53/carry [5]), .Q(\S1/N26 ) );
  XOR31 \S1/sub_53/U2_5  ( .A(\cor_y_s0[1][5] ), .B(\S1/sub_53/B_not [5]), .C(
        \S1/sub_53/carry [5]), .Q(\S1/N20 ) );
  ADD31 \S1/add_50/U1_4  ( .A(\cor_x_s0[1][4] ), .B(\cor_y_s0[1][5] ), .CI(
        \S1/add_50/carry [4]), .CO(\S1/add_50/carry [5]), .S(\S1/N7 ) );
  XOR31 \S1/add_50/U1_5  ( .A(\cor_x_s0[1][5] ), .B(\cor_y_s0[1][5] ), .C(
        \S1/add_50/carry [5]), .Q(\S1/N8 ) );
  ADD31 \S1/add_53/U1_1  ( .A(\cor_y_s0[1][1] ), .B(\cor_x_s0[1][2] ), .CI(
        \S1/add_53/carry [1]), .CO(\S1/add_53/carry [2]), .S(\S1/N22 ) );
  ADD31 \S1/add_50/U1_2  ( .A(\cor_x_s0[1][2] ), .B(\cor_y_s0[1][3] ), .CI(
        \S1/add_50/carry [2]), .CO(\S1/add_50/carry [3]), .S(\S1/N5 ) );
  ADD31 \S1/add_53/U1_2  ( .A(\cor_y_s0[1][2] ), .B(\cor_x_s0[1][3] ), .CI(
        \S1/add_53/carry [2]), .CO(\S1/add_53/carry [3]), .S(\S1/N23 ) );
  ADD31 \S1/add_50/U1_3  ( .A(\cor_x_s0[1][3] ), .B(\cor_y_s0[1][4] ), .CI(
        \S1/add_50/carry [3]), .CO(\S1/add_50/carry [4]), .S(\S1/N6 ) );
  LOGIC1 U35 ( .Q(n25) );
  NOR31 U41 ( .A(qbb_ibuff[2]), .B(n32), .C(N6), .Q(\sub_170/carry [3]) );
  NAND31 U42 ( .A(\sub_173/carry [3]), .B(\S0/N32 ), .C(n33), .Q(n27) );
  INV3 U43 ( .A(n27), .Q(n48) );
  IMAJ31 U44 ( .A(n82), .B(n47), .C(\cor_x_s1[2][5] ), .Q(\S2/sub_53/carry[5] ) );
  MUX22 U46 ( .A(qbb_ibuff[4]), .B(N10), .S(\S0/N32 ), .Q(\cor_y_s0[0][4] ) );
  NAND31 U49 ( .A(n28), .B(\cor_x_s1[2][2] ), .C(n40), .Q(n76) );
  NAND22 U50 ( .A(\cor_y_s0[0][0] ), .B(n17), .Q(\S0/sub_50/carry [1]) );
  NOR31 U53 ( .A(ibb_ibuff[2]), .B(ibb_ibuff[1]), .C(N13), .Q(
        \sub_173/carry [3]) );
  AOI2111 U54 ( .A(n28), .B(n39), .C(n40), .D(n29), .Q(n66) );
  NAND22 U55 ( .A(n30), .B(n54), .Q(\S2/sub_56/carry[5] ) );
  IMAJ31 U58 ( .A(\cor_x_s1[2][4] ), .B(n46), .C(n78), .Q(n81) );
  NAND41 U59 ( .A(n43), .B(n44), .C(n36), .D(n41), .Q(N20) );
  OAI212 U60 ( .A(\S0/N32 ), .B(n49), .C(N13), .Q(n17) );
  XNR31 U61 ( .A(\cor_x_s0[1][5] ), .B(\cor_y_s0[1][5] ), .C(
        \S1/sub_50/carry [5]), .Q(\S1/N14 ) );
  OAI222 U64 ( .A(n51), .B(\S0/n39 ), .C(n86), .D(n53), .Q(\cor_y_s0[1][5] )
         );
  NOR21 U65 ( .A(ibb_ibuff[1]), .B(N13), .Q(\sub_173/carry [2]) );
  NOR21 U66 ( .A(n32), .B(N6), .Q(\sub_170/carry [2]) );
  XOR21 U67 ( .A(\sub_173/carry [2]), .B(n34), .Q(N15) );
  XOR21 U68 ( .A(\sub_170/carry [2]), .B(n44), .Q(N8) );
  XOR21 U71 ( .A(\sub_173/carry [3]), .B(n33), .Q(N16) );
  XOR21 U72 ( .A(\sub_170/carry [3]), .B(n36), .Q(N9) );
  XOR21 U73 ( .A(n35), .B(n38), .Q(N14) );
  XOR21 U74 ( .A(n42), .B(n43), .Q(N7) );
  NOR21 U75 ( .A(\S0/sub_50/B_not [0]), .B(n17), .Q(\S0/r64/carry [1]) );
  INV3 U76 ( .A(n56), .Q(\S0/sub_53/carry [1]) );
  NOR21 U77 ( .A(n17), .B(\cor_y_s0[0][0] ), .Q(n56) );
  XNR21 U78 ( .A(qbb_ibuff[4]), .B(\sub_170/carry [4]), .Q(N10) );
  NOR21 U80 ( .A(\S2/N29 ), .B(\S2/N30 ), .Q(n54) );
  XNR21 U81 ( .A(\cor_x_s0[0][0] ), .B(\cor_y_s0[0][0] ), .Q(n50) );
  XNR21 U82 ( .A(\cor_x_s0[0][0] ), .B(\S0/sub_50/B_not [0]), .Q(\S0/N9 ) );
  XNR21 U84 ( .A(\S2/sub_56/carry[5] ), .B(\S2/N32 ), .Q(\S2/N38 ) );
  XNR21 U86 ( .A(\S2/N30 ), .B(\S2/N29 ), .Q(\S2/N36 ) );
  XOR21 U90 ( .A(\cor_y_s0[0][0] ), .B(n17), .Q(n52) );
  INV3 U91 ( .A(n55), .Q(\S1/sub_53/carry [1]) );
  NOR21 U92 ( .A(n65), .B(\cor_y_s0[1][0] ), .Q(n55) );
  NOR21 U93 ( .A(n65), .B(n57), .Q(\S1/add_53/carry [1]) );
  INV3 U94 ( .A(\cor_y_s0[1][0] ), .Q(n57) );
  XOR21 U97 ( .A(\cor_y_s0[1][0] ), .B(\cor_x_s0[1][1] ), .Q(\S1/N21 ) );
  XNR21 U98 ( .A(\cor_y_s0[1][0] ), .B(n65), .Q(\S1/N15 ) );
  CLKIN0 U100 ( .A(\cor_y_s0[0][0] ), .Q(\S0/sub_50/B_not [0]) );
  CLKIN0 U101 ( .A(\cor_y_s0[0][1] ), .Q(\S0/sub_50/B_not [1]) );
  CLKIN0 U102 ( .A(\cor_y_s0[0][2] ), .Q(\S0/sub_50/B_not [2]) );
  CLKIN0 U103 ( .A(\cor_y_s0[0][3] ), .Q(\S0/sub_50/B_not [3]) );
  CLKIN0 U104 ( .A(\cor_y_s0[0][4] ), .Q(\S0/sub_50/B_not [4]) );
  CLKIN0 U105 ( .A(\cor_x_s0[1][2] ), .Q(\S1/sub_53/B_not [1]) );
  CLKIN0 U106 ( .A(\cor_x_s0[1][3] ), .Q(\S1/sub_53/B_not [2]) );
  CLKIN0 U107 ( .A(\cor_x_s0[1][4] ), .Q(\S1/sub_53/B_not [3]) );
  CLKIN0 U108 ( .A(\cor_x_s0[1][5] ), .Q(\S1/sub_53/B_not [5]) );
  CLKIN0 U109 ( .A(\cor_y_s0[1][3] ), .Q(\S1/sub_50/B_not [2]) );
  CLKIN0 U110 ( .A(\cor_y_s0[1][4] ), .Q(\S1/sub_50/B_not [3]) );
  CLKIN0 U111 ( .A(\cor_y_s0[1][1] ), .Q(n59) );
  NOR20 U112 ( .A(n59), .B(\cor_x_s0[1][0] ), .Q(n62) );
  OAI220 U115 ( .A(n62), .B(n65), .C(\cor_y_s0[1][2] ), .D(n61), .Q(
        \S1/sub_50/carry [2]) );
  CLKIN0 U117 ( .A(\cor_y_s0[1][2] ), .Q(n64) );
  OAI2110 U118 ( .A(\cor_x_s0[1][1] ), .B(\cor_y_s0[1][2] ), .C(
        \cor_x_s0[1][0] ), .D(\cor_y_s0[1][1] ), .Q(n63) );
  OAI210 U119 ( .A(n65), .B(n64), .C(n63), .Q(\S1/add_50/carry [2]) );
  AOI210 U120 ( .A(\cor_y_s1[2][1] ), .B(\cor_x_s1[2][3] ), .C(n66), .Q(n69)
         );
  CLKIN0 U121 ( .A(n69), .Q(n67) );
  OAI210 U122 ( .A(\cor_y_s1[2][2] ), .B(n67), .C(\cor_x_s1[2][4] ), .Q(n68)
         );
  OAI210 U123 ( .A(n69), .B(n46), .C(n68), .Q(n72) );
  OAI210 U129 ( .A(n75), .B(n47), .C(n74), .Q(\S2/add_53/carry[5] ) );
  NAND20 U130 ( .A(\cor_x_s1[2][2] ), .B(n40), .Q(n77) );
  AOI220 U131 ( .A(n77), .B(\cor_y_s1[2][1] ), .C(n39), .D(n76), .Q(n78) );
  ADD31 \S1/add_53/U1_3  ( .A(\cor_y_s0[1][3] ), .B(\cor_x_s0[1][4] ), .CI(
        \S1/add_53/carry [3]), .CO(\S1/add_53/carry [4]), .S(\S1/N24 ) );
  IMAJ31 U36 ( .A(n72), .B(\cor_y_s1[2][3] ), .C(\cor_x_s1[2][5] ), .Q(n75) );
  MUX22 U38 ( .A(qbb_ibuff[2]), .B(N8), .S(\S0/N32 ), .Q(\cor_y_s0[0][2] ) );
  XOR31 U39 ( .A(\cor_y_s1[2][5] ), .B(n45), .C(\S2/sub_53/carry[5] ), .Q(
        \S2/N20 ) );
  MUX22 U47 ( .A(qbb_ibuff[3]), .B(N9), .S(\S0/N32 ), .Q(\cor_y_s0[0][3] ) );
  IMAJ31 U70 ( .A(n81), .B(\cor_y_s1[2][3] ), .C(n45), .Q(n82) );
  NOR40 U85 ( .A(qbb_ibuff[3]), .B(qbb_ibuff[2]), .C(n32), .D(N6), .Q(
        \sub_170/carry [4]) );
  XOR21 U99 ( .A(\S2/N31 ), .B(n54), .Q(\S2/N37 ) );
  IMUX21 U132 ( .A(\S2/n37 ), .B(\S2/n37 ), .S(\S2/n21 ), .Q(\cor_w_s1[4][2] )
         );
  DFC3 \ibb_ibuff_reg[4]  ( .D(ibb[4]), .C(clk), .RN(reset_n), .Q(\S0/N32 ), 
        .QN(n49) );
  XOR31 \S2/add_53/U1_5  ( .A(\cor_y_s1[2][5] ), .B(\cor_x_s1[2][5] ), .C(
        \S2/add_53/carry[5] ), .Q(\S2/N26 ) );
  MUX22 U37 ( .A(N6), .B(N6), .S(\S0/N32 ), .Q(\cor_y_s0[0][0] ) );
  OAI212 U40 ( .A(N6), .B(N20), .C(n41), .Q(n5) );
  MUX22 U45 ( .A(n32), .B(N7), .S(\S0/N32 ), .Q(\cor_y_s0[0][1] ) );
  OAI311 U48 ( .A(\cor_y_s1[2][4] ), .B(n72), .C(\cor_y_s1[2][3] ), .D(
        \cor_x_s1[2][5] ), .Q(n74) );
  NOR30 U51 ( .A(\cor_x_s0[1][1] ), .B(n59), .C(\cor_x_s0[1][0] ), .Q(n61) );
  XNR20 U52 ( .A(\cor_y_s0[0][5] ), .B(\S0/sub_50/carry [5]), .Q(\S0/N14 ) );
  OAI220 U56 ( .A(n5), .B(n49), .C(\S0/N32 ), .D(n41), .Q(\cor_y_s0[0][5] ) );
  CLKBU2 U57 ( .A(\cor_y_s0[0][5] ), .Q(n86) );
  INV3 U62 ( .A(\cor_x_s0[1][1] ), .Q(n65) );
  MUX21 U63 ( .A(\S1/N7 ), .B(\S1/N13 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_x_s0[2][4] ) );
  MUX21 U69 ( .A(\S1/N6 ), .B(\S1/N12 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_x_s0[2][3] ) );
  MUX21 U79 ( .A(\S1/N5 ), .B(\S1/N11 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_x_s0[2][2] ) );
  MUX21 U83 ( .A(\S1/N20 ), .B(\S1/N26 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_y_s0[2][5] ) );
  MUX21 U87 ( .A(\S1/N8 ), .B(\S1/N14 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_x_s0[2][5] ) );
  MUX21 U88 ( .A(\S1/N19 ), .B(\S1/N25 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_y_s0[2][4] ) );
  MUX21 U89 ( .A(\S1/N18 ), .B(\S1/N24 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_y_s0[2][3] ) );
  MUX21 U95 ( .A(\S1/N17 ), .B(\S1/N23 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_y_s0[2][2] ) );
  MUX21 U96 ( .A(\S1/N16 ), .B(\S1/N22 ), .S(\cor_y_s0[1][5] ), .Q(
        \cor_y_s0[2][1] ) );
  INV2 U113 ( .A(\cor_y_s0[1][5] ), .Q(\S1/sub_50/B_not [5]) );
  OAI211 U114 ( .A(n86), .B(\S0/n22 ), .C(\S0/n33 ), .Q(\cor_x_s0[1][4] ) );
  OAI221 U116 ( .A(\S0/n39 ), .B(\S0/n22 ), .C(n86), .D(\S0/n23 ), .Q(
        \cor_y_s0[1][4] ) );
  XOR20 U124 ( .A(\S0/sub_53/carry [5]), .B(n86), .Q(n53) );
  OAI221 U125 ( .A(\S0/n39 ), .B(n50), .C(n86), .D(n52), .Q(\cor_y_s0[1][0] )
         );
  XNR20 U126 ( .A(n86), .B(\S0/r64/carry [5]), .Q(n51) );
  OAI211 U127 ( .A(n86), .B(\S0/n24 ), .C(\S0/n34 ), .Q(\cor_x_s0[1][3] ) );
  OAI221 U128 ( .A(\S0/n39 ), .B(\S0/n24 ), .C(n86), .D(\S0/n25 ), .Q(
        \cor_y_s0[1][3] ) );
  OAI211 U133 ( .A(n86), .B(\S0/n26 ), .C(\S0/n35 ), .Q(\cor_x_s0[1][2] ) );
  OAI221 U134 ( .A(\S0/n39 ), .B(\S0/n28 ), .C(n86), .D(\S0/n29 ), .Q(
        \cor_y_s0[1][1] ) );
  CLKIN1 U135 ( .A(\cor_y_s0[0][5] ), .Q(\S0/n39 ) );
  INV3 U136 ( .A(n14), .Q(\cor_x_s0[0][3] ) );
  AOI220 U137 ( .A(N16), .B(\S0/N32 ), .C(ibb_ibuff[3]), .D(n49), .Q(n14) );
  INV3 U138 ( .A(n15), .Q(\cor_x_s0[0][2] ) );
  AOI220 U139 ( .A(N15), .B(\S0/N32 ), .C(ibb_ibuff[2]), .D(n49), .Q(n15) );
  INV3 U140 ( .A(n16), .Q(\cor_x_s0[0][1] ) );
  AOI220 U141 ( .A(N14), .B(\S0/N32 ), .C(ibb_ibuff[1]), .D(n49), .Q(n16) );
  AOI221 U142 ( .A(\S2/N20 ), .B(n37), .C(\cor_y_s1[2][5] ), .D(\S2/N26 ), .Q(
        \S2/n21 ) );
  OAI211 U143 ( .A(\cor_y_s0[0][5] ), .B(n51), .C(\S0/n32 ), .Q(
        \cor_x_s0[1][5] ) );
  OAI221 U144 ( .A(\S0/n39 ), .B(\S0/n26 ), .C(n86), .D(\S0/n27 ), .Q(
        \cor_y_s0[1][2] ) );
endmodule

