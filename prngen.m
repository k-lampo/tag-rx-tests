function [beacon_prn_bb, tag_prn_bb] = prngen()

    beacon_seq = comm.GoldSequence('FirstPolynomial',[10 3 0],... %taps on the first register, note that 0 specifies constant term in the polynomial
                  'FirstInitialConditions', 1,... %all cells in the register start at 1
                  'SecondPolynomial',[10 8 3 2 0],... %taps on second register
                  'SecondInitialConditions', 1,... %all cells start at 1
                  'Index', 0, 'Shift', 12, 'SamplesPerFrame', 1023); 
                    %Index specifies XOR of the two polynomials, Shift
                    %specifies an offset of 12 samples from the starting
                    %point, SamplesPerFrame specifies how many samples are
                    %output in every iteration, which here is all 1023
    
    %repeat to generate tag sequence
    tag_seq = comm.GoldSequence('FirstPolynomial',[10 3 0],...
                  'FirstInitialConditions', 1,...
                  'SecondPolynomial', [10 8 3 2 0],...
                  'SecondInitialConditions', 1,...
                  'Index', 1, 'Shift', 9, 'SamplesPerFrame', 1023);         
              
    %runs the algorithim defined above to generate the pseudo-random code          
    beacon_prn = step(beacon_seq); 
    tag_prn = step(tag_seq);
    
    %changes the code from 0s and 1s to -1s and 1s
    beacon_prn = 2*beacon_prn - 1;
    tag_prn = 2*tag_prn - 1;
    
    %upsamples to 2.8 samples/chip
    %ie there are now 2.8 sample values for every 1 there was before, since
    %the reciever data takes samples at 2.8x the rate that the prn code
    %changes
    beacon_prn_bb = prnresample(beacon_prn, 14, 5);
    tag_prn_bb = prnresample(tag_prn, 14, 5);
    
    %normalize the signals
    beacon_prn_bb = beacon_prn_bb/norm(beacon_prn_bb);
    tag_prn_bb = tag_prn_bb/norm(tag_prn_bb);

end