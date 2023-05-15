fname_astro = '/Users/zac/Library/CloudStorage/Dropbox/Mac/Desktop/CUquad_OTA_20230512/tag_position_1/astro/1683941771_astro.dat';
fname_elroy = '/Users/zac/Library/CloudStorage/Dropbox/Mac/Desktop/CUquad_OTA_20230512/tag_position_1/elroy/1683941771_elroy.dat';
fname_jane = '/Users/zac/Library/CloudStorage/Dropbox/Mac/Desktop/CUquad_OTA_20230512/tag_position_1/jane/1683941770_jane.dat';
fname_judy = '/Users/zac/Library/CloudStorage/Dropbox/Mac/Desktop/CUquad_OTA_20230512/tag_position_1/judy/1683941769_judy.dat';

prngen();

[data_astro, header_astro] = usrp_data_parser(fname_astro);
cor_tag_astro = xcnorm_mex(data_astro, tag_prn_bb);
cor_beacon_astro = xcnorm_mex(data_astro, beacon_prn_bb);

save('cor_astro.mat','header_astro', 'cor_tag_astro', 'cor_beacon_astro');

%subplot(2,1,1)
%plot(abs(cor_beacon_astro))
%ylabel('Beacon')
%subplot(2,1,2)
%plot(abs(cor_tag_astro))
%ylabel('Tag')

[data_elroy, header_elroy] = usrp_data_parser(fname_elroy);
cor_tag_elroy = xcnorm_mex(data_elroy, tag_prn_bb);
cor_beacon_elroy = xcnorm_mex(data_elroy, beacon_prn_bb);
save('cor_elroy.mat','header_elroy', 'cor_tag_elroy', 'cor_beacon_elroy');

[data_jane, header_jane] = usrp_data_parser(fname_jane);
cor_tag_jane = xcnorm_mex(data_jane, tag_prn_bb);
cor_beacon_jane = xcnorm_mex(data_jane, beacon_prn_bb);
save('cor_jane.mat','header_jane', 'cor_tag_jane', 'cor_beacon_jane');

[data_judy, header_judy] = usrp_data_parser(fname_judy);
cor_tag_judy = xcnorm_mex(data_judy, tag_prn_bb);
cor_beacon_judy = xcnorm_mex(data_judy, beacon_prn_bb);
save('cor_judy.mat','header_judy', 'cor_tag_judy', 'cor_beacon_judy');