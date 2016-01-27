function [ A_out, t_out ] = HQR_blk_var1( A, t, nb_alg )

  [ ATL, ATR, ...
    ABL, ABR ] = FLA_Part_2x2( A, ...
                               0, 0, 'FLA_TL' );

  [ tT, ...
    tB ] = FLA_Part_2x1( t, ...
                         0, 'FLA_TOP' );

  while ( size( ATL, 2 ) < size( A, 2 ) )

    b = min( size( ABR, 2 ), nb_alg );

    [ A00, A01, A02, ...
      A10, A11, A12, ...
      A20, A21, A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                               ABL, ABR, ...
                                               b, b, 'FLA_BR' );

    [ t0, ...
      t1, ...
      t2 ] = FLA_Repart_2x1_to_3x1( tT, ...
                                    tB, ...
                                    b, 'FLA_BOTTOM' );

    %------------------------------------------------------------%

    [ A11_21, t1 ]  = HQR_unb_var1( [ A11 
                                      A21 ], t1 );
                             
    [ A11, ...
      A21 ] = FLA_Part_2x1( A11_21, ...
                            b, 'FLA_TOP' );
    
    T = HQR_Form_T( A11_21, t1 )
    
    [ A12, ...
      A22 ] = HQR_Apply( T, A11, A12, ...
                            A21, A22 );

    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00, A01, A02, ...
                                             A10, A11, A12, ...
                                             A20, A21, A22, ...
                                             'FLA_TL' );

    [ tT, ...
      tB ] = FLA_Cont_with_3x1_to_2x1( t0, ...
                                       t1, ...
                                       t2, ...
                                       'FLA_TOP' );

  end

  A_out = [ ATL, ATR
            ABL, ABR ];

  t_out = [ tT
            tB ];

return

