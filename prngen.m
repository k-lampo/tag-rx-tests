beacon_seq = comm.GoldSequence('FirstPolynomial',[10 3 0],...
              'FirstInitialConditions', 1,...
              'SecondPolynomial',[10 8 3 2 0],...
              'SecondInitialConditions', 1,...
              'Index', 0, 'Shift', 12, 'SamplesPerFrame', 1023);

tag_seq = comm.GoldSequence('FirstPolynomial',[10 3 0],...
              'FirstInitialConditions', 1,...
              'SecondPolynomial', [10 8 3 2 0],...
              'SecondInitialConditions', 1,...
              'Index', 1, 'Shift', 9, 'SamplesPerFrame', 1023);         
          
          
beacon_prn = step(beacon_seq);
tag_prn = step(tag_seq);

beacon_prn = 2*beacon_prn - 1;
tag_prn = 2*tag_prn - 1;

%Upsample to 2.817 samples/chip
beacon_prn_bb = prnresample(beacon_prn, 14, 5);
tag_prn_bb = prnresample(tag_prn, 14, 5);

%normalize
beacon_prn_bb = beacon_prn_bb/norm(beacon_prn_bb);
tag_prn_bb = tag_prn_bb/norm(tag_prn_bb);

