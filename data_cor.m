[beacon_prn_bb,tag_prn_bb] = prngen();

%ToDo: Try this
%cor_astro_beacon = xcorr(astro_data, beacon_prn_bb, 'normalized');

disp("astro beacon...")
%f_astro_beacon = parfeval(@(dat)xcnorm_mex(dat, beacon_prn_bb),1,astro_data);
cor_astro_beacon = xcnorm_mex(astro_data, beacon_prn_bb);
disp("elroy beacon...")
%f_elroy_beacon = parfeval(@(dat)xcnorm_mex(dat, beacon_prn_bb),1,elroy_data);
cor_elroy_beacon = xcnorm_mex(elroy_data, beacon_prn_bb);
disp("jane beacon...")
%f_jane_beacon = parfeval(@(dat)xcnorm_mex(dat, beacon_prn_bb),1,jane_data);
cor_jane_beacon = xcnorm_mex(jane_data, beacon_prn_bb);
disp("judy beacon...")
%f_judy_beacon = parfeval(@(dat)xcnorm_mex(dat, beacon_prn_bb),1,judy_data);
cor_judy_beacon = xcnorm_mex(judy_data, beacon_prn_bb);

disp("astro tag...")
%f_astro_tag = parfeval(@(dat)xcnorm_mex(dat, tag_prn_bb),1,astro_data);
cor_astro_tag = xcnorm_mex(astro_data, tag_prn_bb);
disp("elroy tag...")
%f_elroy_tag = parfeval(@(dat)xcnorm_mex(dat, tag_prn_bb),1,elroy_data);
cor_elroy_tag = xcnorm_mex(elroy_data, tag_prn_bb);
disp("jane tag...")
%f_jane_tag = parfeval(@(dat)xcnorm_mex(dat, tag_prn_bb),1,jane_data);
cor_jane_tag = xcnorm_mex(jane_data, tag_prn_bb);
disp("judy tag...")
%f_judy_tag = parfeval(@(dat)xcnorm_mex(dat, tag_prn_bb),1,judy_data);
cor_judy_tag = xcnorm_mex(judy_data, tag_prn_bb);

disp("saving...")
save("data.mat", "-v7.3");
disp("done!")