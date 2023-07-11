%record the directory of each of the four folders containing data to iterate through in managable chunks
%these are struct arrays with fields name, folder, date, bytes, isdir, datenum
jane_dir = dir("/media/rexlab/LaCie/20230516/jane");
jane_dir = jane_dir(~[jane_dir.isdir]); %removes the first few entires in the directory because they point to current & parent folder in the file structure
judy_dir = dir("/media/rexlab/LaCie/20230516/judy");
judy_dir = judy_dir(~[judy_dir.isdir]);

%generate the pseudo-random codes for the beacon and tag
[beacon_prn_bb,tag_prn_bb] = prngen();

%set the maximum number of iterations for each reciever based on the number of files in the directory
jane_max = length(jane_dir);
judy_max = length(judy_dir);

%note the total number of iterations based on the largest directory
fprintf("number of jane iterations to complete: " + jane_max + '\n \n')

for i=1:jane_max
    [jane_segment,jane_times,~] = file_concat(strcat(jane_dir(i).folder,"/",jane_dir(i).name));
    jane_beacon.time = jane_times(1);
    jane_tag.time = jane_times(1);

    jane_beacon.corr = xcnorm_p_mex(jane_segment,beacon_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/jane_beacon/",jane_dir(i).name(1:15),"_beacon.mat"),"jane_beacon","-v7.3");
    jane_beacon.corr = [];

    jane_tag.corr = xcnorm_p_mex(jane_segment,tag_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/jane_tag/",jane_dir(i).name(1:15),"_tag.mat"),"jane_tag","-v7.3");
    jane_tag.corr = [];

    disp("jane " + i + " done");
end

for i=1:judy_max
    [judy_segment,judy_times,~] = file_concat(strcat(judy_dir(i).folder,"/",judy_dir(i).name));
    judy_beacon.time = judy_times(1);
    judy_tag.time = judy_times(1);

    judy_beacon.corr = xcnorm_p_mex(judy_segment,beacon_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/judy_beacon/",judy_dir(i).name(1:15),"_beacon.mat"),"judy_beacon","-v7.3");
    judy_beacon.corr = [];

    judy_tag.corr = xcnorm_p_mex(judy_segment,tag_prn_bb);
    save(strcat("/media/rexlab/LaCie/recorrelated_data/judy_tag/",judy_dir(i).name(1:15),"_tag.mat"),"judy_tag","-v7.3");
    judy_tag.corr = [];

    disp("judy " + i + " done");
end
