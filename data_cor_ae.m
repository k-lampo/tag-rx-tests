%record the directory of each of the four folders containing data to iterate through in managable chunks
%these are struct arrays with fields name, folder, date, bytes, isdir, datenum
astro_dir = dir("/media/rexlab/LaCie/20230516/astro");
astro_dir = astro_dir(~[astro_dir.isdir]); %removes the first few entires in the directory because they point to current & parent folder in the file structure
elroy_dir = dir("/media/rexlab/LaCie/20230516/elroy");
elroy_dir = elroy_dir(~[elroy_dir.isdir]);

%generate the pseudo-random codes for the beacon and tag
[beacon_prn_bb,tag_prn_bb] = prngen();

%set the maximum number of iterations for each reciever based on the number of files in the directory
astro_max = length(astro_dir);
elroy_max = length(elroy_dir);

%note the total number of iterations based on the largest directory
fprintf("number of astro iterations to complete: " + astro_max + '\n \n')

for i=1:astro_max
    [astro_segment,astro_times,~] = file_concat(strcat(astro_dir(i).folder,"/",astro_dir(i).name));
    astro_beacon.time = astro_times(1);
    astro_tag.time = astro_times(1);

    astro_beacon.corr = xcnorm_p_mex(astro_segment,beacon_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/astro_beacon/",astro_dir(i).name(1:16),"_beacon.mat"),"astro_beacon","-v7.3");
    astro_beacon.corr = [];

    astro_tag.corr = xcnorm_p_mex(astro_segment,tag_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/astro_tag/",astro_dir(i).name(1:16),"_tag.mat"),"astro_tag","-v7.3");
    astro_tag.corr = [];

    disp("astro " + i + " done");
end

for i=1:elroy_max
    [elroy_segment,elroy_times,~] = file_concat(strcat(elroy_dir(i).folder,"/",elroy_dir(i).name));
    elroy_beacon.time = elroy_times(1);
    elroy_tag.time = elroy_times(1);

    elroy_beacon.corr = xcnorm_p_mex(elroy_segment,beacon_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/elroy_beacon/",elroy_dir(i).name(1:16),"_beacon.mat"),"elroy_beacon","-v7.3");
    elroy_beacon.corr = [];

    elroy_tag.corr = xcnorm_p_mex(elroy_segment,tag_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/elroy_tag/",elroy_dir(i).name(1:16),"_tag.mat"),"elroy_tag","-v7.3");
    elroy_tag.corr = [];

    disp("elroy " + i + " done");
end