%takes the correlated data and saves off a set of peaks for each file

%locate the correlated beacon data sets
astro_b_dir = dir("D:\recorrelated_data\astro_beacon");
astro_b_dir = astro_b_dir(~[astro_b_dir.isdir]); %removes the first few entires in the directory because they point to current & parent folder in the file structure

elroy_b_dir = dir("D:\recorrelated_data\elroy_beacon");
elroy_b_dir = elroy_b_dir(~[elroy_b_dir.isdir]); 

jane_b_dir = dir("D:\recorrelated_data\jane_beacon");
jane_b_dir = jane_b_dir(~[jane_b_dir.isdir]); 

judy_b_dir = dir("D:\recorrelated_data\judy_beacon");
judy_b_dir = judy_b_dir(~[judy_b_dir.isdir]);

%locate the correlated tag data sets
astro_t_dir = dir("D:\recorrelated_data\astro_tag");
astro_t_dir = astro_t_dir(~[astro_t_dir.isdir]);

elroy_t_dir = dir("D:\recorrelated_data\elroy_tag");
elroy_t_dir = elroy_t_dir(~[elroy_t_dir.isdir]);

jane_t_dir = dir("D:\recorrelated_data\jane_tag");
jane_t_dir = jane_t_dir(~[jane_t_dir.isdir]);

judy_t_dir = dir("D:\recorrelated_data\judy_tag");
judy_t_dir = judy_t_dir(~[judy_t_dir.isdir]);


%initialize the time between each reading & empty arrays to hold peaks
dt = 1/2.8; %in us; 2.8 MHz
astro_beacon_peaks = []; elroy_beacon_peaks = []; jane_beacon_peaks = []; judy_beacon_peaks = [];
astro_tag_peaks = []; elroy_tag_peaks = []; jane_tag_peaks = []; judy_tag_peaks = [];

%find the peaks for all of the data files
for i=1:length(astro_b_dir)
    %import the correlated data for each file in the directories
    as_bea_dat = importdata(strcat("D:\recorrelated_data\astro_beacon\",astro_b_dir(i).name));
    as_bea = as_bea_dat.corr();

    as_tag_dat = importdata(strcat("D:\recorrelated_data\astro_tag\",astro_t_dir(i).name));
    as_tag = as_tag_dat.corr();

    %create a time array for the correlated data
    as_times = zeros(length(as_bea),1);
    for j=1:length(as_bea)
        as_times(j) = as_bea_dat.time() + (j-1)*dt;
    end

    %calculate the peaks
    astro_beacon_peaks = find_peak_times(as_bea,0.1,as_times);
    astro_tag_peaks = find_peak_times(as_tag,0.1,as_times);
    disp(i + "/" + length(astro_t_dir));

    %save off the results
    if isempty(astro_beacon_peaks) == 0
        save(strcat("D:\recorrelated_peaks\astro_beacon\",astro_b_dir(i).name(1:23),"_peaks"),"astro_beacon_peaks");
    end
    if isempty(astro_tag_peaks) == 0
        save(strcat("D:\recorrelated_peaks\astro_tag\",astro_t_dir(i).name(1:20),"_peaks"),"astro_tag_peaks");
    end
end

for i=1:length(elroy_b_dir)
    el_bea_dat = importdata(strcat("D:\recorrelated_data\elroy_beacon\",elroy_b_dir(i).name));
    el_bea = el_bea_dat.corr();

    el_tag_dat = importdata(strcat("D:\recorrelated_data\elroy_tag\",elroy_t_dir(i).name));
    el_tag = el_tag_dat.corr();

    el_times = zeros(length(el_bea),1);
    for j=1:length(el_bea)
        el_times(j) = el_bea_dat.time() + (j-1)*dt;
    end

    elroy_beacon_peaks = find_peak_times(el_bea,0.1,el_times);
    elroy_tag_peaks = find_peak_times(el_tag,0.1,el_times);
    disp(i + "/" + length(elroy_t_dir));

    if isempty(elroy_beacon_peaks) == 0
        save(strcat("D:\recorrelated_peaks\elroy_beacon\",elroy_b_dir(i).name(1:23),"_peaks"),"elroy_beacon_peaks");
    end
    if isempty(elroy_tag_peaks) == 0
        save(strcat("D:\recorrelated_peaks\elroy_tag\",elroy_t_dir(i).name(1:20),"_peaks"),"elroy_tag_peaks");
    end
end


for i=1:length(jane_b_dir)
    ja_bea_dat = importdata(strcat("D:\recorrelated_data\jane_beacon\",jane_b_dir(i).name));
    ja_bea = ja_bea_dat.corr();

    ja_tag_dat = importdata(strcat("D:\recorrelated_data\jane_tag\",jane_t_dir(i).name));
    ja_tag = ja_tag_dat.corr();

    ja_times = zeros(length(ja_bea),1);
    for j=1:length(ja_bea)
        ja_times(j) = ja_bea_dat.time() + (j-1)*dt;
    end

    jane_beacon_peaks = find_peak_times(ja_bea,0.1,ja_times);
    jane_tag_peaks = find_peak_times(ja_tag,0.1,ja_times);
    disp(i + "/" + length(jane_t_dir));

    if isempty(jane_beacon_peaks) == 0
        save(strcat("D:\recorrelated_peaks\jane_beacon\",jane_b_dir(i).name(1:22),"_peaks"),"jane_beacon_peaks");
    end
    if isempty(jane_tag_peaks) == 0
        save(strcat("D:\recorrelated_peaks\jane_tag\",jane_t_dir(i).name(1:19),"_peaks"),"jane_tag_peaks");
    end
end

for i=1:length(judy_b_dir)
    ju_bea_dat = importdata(strcat("D:\recorrelated_data\judy_beacon\",judy_b_dir(i).name));
    ju_bea = ju_bea_dat.corr();

    ju_tag_dat = importdata(strcat("D:\recorrelated_data\judy_tag\",judy_t_dir(i).name));
    ju_tag = ju_tag_dat.corr();

    ju_times = zeros(length(ju_bea),1);
    for j=1:length(ju_bea)
        ju_times(j) = ju_bea_dat.time() + (j-1)*dt;
    end

    judy_beacon_peaks = find_peak_times(ju_bea,0.3,ju_times);
    judy_tag_peaks = find_peak_times(ju_tag,0.1,ju_times);
    disp(i + "/" + length(judy_t_dir));

    if isempty(judy_beacon_peaks) == 0
        save(strcat("D:\recorrelated_peaks\judy_beacon\",judy_b_dir(i).name(1:22),"_peaks"),"judy_beacon_peaks");
    end
    if isempty(judy_tag_peaks) == 0
        save(strcat("D:\recorrelated_peaks\judy_tag\",judy_t_dir(i).name(1:19),"_peaks"),"judy_tag_peaks");
    end
end