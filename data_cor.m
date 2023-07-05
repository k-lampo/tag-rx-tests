%record the directory of each of the four folders containing data to iterate through in managable chunks
%these are struct arrays with fields name, folder, date, bytes, isdir, datenum
astro_dir = dir("/media/rexlab/LaCie/20230516/astro");
astro_dir = astro_dir(~[astro_dir.isdir]); %removes the first few entires in the directory because they point to current & parent folder in the file structure
elroy_dir = dir("/media/rexlab/LaCie/20230516/elroy");
elroy_dir = elroy_dir(~[elroy_dir.isdir]);
jane_dir = dir("/media/rexlab/LaCie/20230516/jane");
jane_dir = jane_dir(~[jane_dir.isdir]);
judy_dir = dir("/media/rexlab/LaCie/20230516/judy");
judy_dir = judy_dir(~[judy_dir.isdir]);

%generate the pseudo-random codes for the beacon and tag
[beacon_prn_bb,tag_prn_bb] = prngen();

%set the maximum number of iterations for each reciever based on the number of files in the directory
astro_max = ceil(size(astro_dir,1)/25);
elroy_max = ceil(size(elroy_dir,1)/25);
jane_max = ceil(size(jane_dir,1)/25);
judy_max = ceil(size(judy_dir,1)/25);

%note the total number of iterations based on the largest directory
fprintf("number of iterations to complete: " + max([astro_max,elroy_max,jane_max,judy_max]) + '\n \n')

%main iterations; takes chunks of 25 files from each directory and
%correlates with both beacon and tag signals before saving the results off
%and restarting the loop
for i=1:max([astro_max,elroy_max,jane_max,judy_max])
    %pulls 25 files for each reciever
    disp("pulling data for iteration " + i);
    tic

    %pull segments of each data set
    if i <= astro_max
        [astro_segment,astro_times] = grab_files(astro_dir,i);
    end

    if i <= elroy_max
        [elroy_segment,elroy_times] = grab_files(elroy_dir,i);
    end

    if i <= jane_max
        [jane_segment,jane_times] = grab_files(jane_dir,i);
    end

    if i <= judy_max
        [judy_segment,judy_times] = grab_files(judy_dir,i);
    end

    toc

    %adds new time data for the output matrices in a second column so
    %matches can later be easily associated with their unix timestamp
    astro_beacon(:,2) = astro_times;
    astro_tag(:,2) = astro_times;
    elroy_beacon(:,2) = elroy_times;
    elroy_tag(:,2) = elroy_times;
    jane_beacon(:,2) = jane_times;
    jane_tag(:,2) = jane_times;
    judy_beacon(:,2) = judy_times;
    judy_tag(:,2) = judy_times;

    %calls the correlation function on each of the four recievers with both
    %beacon and tag outputs
    disp("running correlation on iteration " + i);
    tic

    %astro functions
    if i <= astro_max %adding max ensures the method doesn't try to operate on non-existent files
        astro_beacon = xcnorm_p_mex(astro_segment,beacon_prn_bb);
        %outputs are named based on the unix timestamp of the first file
        %pulled, and also include the iteration number (ie "3")
        save(strcat("/media/rexlab/LaCie/correlated_data/astro_beacon/beacon_",astro_dir(25*(i-1) + 1).name(1:16),"_",string(i),".mat"),"astro_beacon","-v7.3");
        %result matrix is immediately cleared to save memory space
        astro_beacon = [];
        disp("astro beacon done");

        astro_tag = xcnorm_p_mex(astro_segment,tag_prn_bb);
        save(strcat("/media/rexlab/LaCie/correlated_data/astro_tag/tag_",astro_dir(25*(i-1) + 1).name(1:16),"_",string(i),".mat"),"astro_tag","-v7.3");
        astro_tag = [];
        disp("astro tag done");
    end

    %elroy functions
    if i <= elroy_max 
        elroy_beacon = xcnorm_p_mex(elroy_segment,beacon_prn_bb);
        save(strcat("/media/rexlab/LaCie/correlated_data/elroy_beacon/beacon_",elroy_dir(25*(i-1) + 1).name(1:16),"_",string(i),".mat"),"elroy_beacon","-v7.3");
        elroy_beacon = [];
        disp("elroy beacon done");

        elroy_tag = xcnorm_p_mex(elroy_segment,tag_prn_bb);
        save(strcat("/media/rexlab/LaCie/correlated_data/elroy_tag/tag_",elroy_dir(25*(i-1) + 1).name(1:16),"_",string(i),".mat"),"elroy_tag","-v7.3");
        elroy_tag = [];
        disp("elroy tag done");
    end

    %jane functions
    if i <= jane_max 
        jane_beacon = xcnorm_p_mex(jane_segment,beacon_prn_bb);
        save(strcat("/media/rexlab/LaCie/correlated_data/jane_beacon/beacon_",jane_dir(25*(i-1) + 1).name(1:15),"_",string(i),".mat"),"jane_beacon","-v7.3");
        jane_beacon = [];
        disp("jane beacon done");

        jane_tag = xcnorm_p_mex(jane_segment,tag_prn_bb);
       save(strcat("/media/rexlab/LaCie/correlated_data/jane_tag/tag_",jane_dir(25*(i-1) + 1).name(1:15),"_",string(i),".mat"),"jane_tag","-v7.3");
        jane_tag = [];
        disp("jane tag done");
    end

    %judy functions
    if i <= judy_max
        judy_beacon = xcnorm_p_mex(judy_segment,beacon_prn_bb);
        save(strcat("/media/rexlab/LaCie/correlated_data/judy_beacon/beacon_",judy_dir(25*(i-1) + 1).name(1:15),"_",string(i),".mat"),"judy_beacon","-v7.3");
        judy_beacon = [];
        disp("judy beacon done");

        judy_tag = xcnorm_p_mex(judy_segment,tag_prn_bb);
        save(strcat("/media/rexlab/LaCie/correlated_data/judy_tag/tag_",judy_dir(25*(i-1) + 1).name(1:15),"_",string(i),".mat"),"judy_tag","-v7.3");
        judy_tag = [];
        disp("judy tag done");
    end

    toc
    fprintf("done with iteration " + i + '\n \n');

end

