%% calculate offsets

%locate the beacon peak data sets
astro_b_pdir = dir("D:\recorrelated_peaks\astro_beacon");
astro_b_pdir = astro_b_pdir(~[astro_b_pdir.isdir]); %removes the first few entires in the directory because they point to current & parent folder in the file structure
elroy_b_pdir = dir("D:\recorrelated_peaks\elroy_beacon");
elroy_b_pdir = elroy_b_pdir(~[elroy_b_pdir.isdir]); 
jane_b_pdir = dir("D:\recorrelated_peaks\jane_beacon");
jane_b_pdir = jane_b_pdir(~[jane_b_pdir.isdir]); 
judy_b_pdir = dir("D:\recorrelated_peaks\judy_beacon");
judy_b_pdir = judy_b_pdir(~[judy_b_pdir.isdir]);

%create beacon peak arrays by concatenating all data files to determine offsets
astro_beacon_peaks = []; elroy_beacon_peaks = []; jane_beacon_peaks = []; judy_beacon_peaks = [];
for i=1:length(astro_b_pdir)
    astro_beacon_peaks = [astro_beacon_peaks;importdata(strcat("D:\recorrelated_peaks\astro_beacon","\",astro_b_pdir(i).name))];
end
for i=1:length(elroy_b_pdir)
    elroy_beacon_peaks = [elroy_beacon_peaks;importdata(strcat("D:\recorrelated_peaks\elroy_beacon","\",elroy_b_pdir(i).name))];
end
for i=1:length(jane_b_pdir)
    jane_beacon_peaks = [jane_beacon_peaks;importdata(strcat("D:\recorrelated_peaks\jane_beacon","\",jane_b_pdir(i).name))];
end
for i=1:length(judy_b_pdir)
    judy_beacon_peaks = [judy_beacon_peaks;importdata(strcat("D:\recorrelated_peaks\judy_beacon","\",judy_b_pdir(i).name))];
end

%plot peaks to find aligned start and end times, which must be manually inputted into beacon_sorter
%{
scatter(astro_beacon_peaks(1:2),ones(2,1)+3);
hold on
scatter(elroy_beacon_peaks(1:2),ones(2,1)+2);
scatter(jane_beacon_peaks(1:2),ones(2,1)+1);
scatter(judy_beacon_peaks(1:2),ones(2,1));
hold off

scatter(astro_beacon_peaks(length(astro_beacon_peaks)-9:length(astro_beacon_peaks)),ones(10,1)+3);
hold on
scatter(elroy_beacon_peaks(length(elroy_beacon_peaks)-9:length(elroy_beacon_peaks)),ones(10,1)+2);
scatter(jane_beacon_peaks(length(jane_beacon_peaks)-9:length(jane_beacon_peaks)),ones(10,1)+1);
scatter(judy_beacon_peaks(length(judy_beacon_peaks)-9:length(judy_beacon_peaks)),ones(10,1));
hold off
%}

%clean up peaks so that each entry in each row of the clean_beacon_peaks array
%represents the same beacon pulse
clean_beacon_peaks = beacon_sorter(astro_beacon_peaks,elroy_beacon_peaks,jane_beacon_peaks,judy_beacon_peaks,10000000); %units are microseconds

%truncate the peaks for consistency across calculations
clean_beacon_peaks = rem(clean_beacon_peaks,70000000000);

%grab coordinates for receivers in the local coordinate system w/ origin at
%the beacon
[rx_positions,~] = test_coordinates();
rx_positions = rx_positions./100; %scale of 100m

%calculate timing offsets between receivers at each timestep in the clean
%beacon peak set
offsets = zeros(size(clean_beacon_peaks,1),4);
for i=1:size(clean_beacon_peaks,1)
    t_beacon = [clean_beacon_peaks(i,:)]';
    offsets(i,:) = find_offsets_good_units(t_beacon,rx_positions,zeros(3,1))'; %beacon position is set to zero because it's the origin of the new coord system
end

%add offsets to beacon peaks for use in aligning tag peaks
clean_beacon_peaks = clean_beacon_peaks - offsets; 
for i=1:size(clean_beacon_peaks,1)
    avg_peak_times(i,1) = mean(clean_beacon_peaks(i,:));
end

%plot the clean beacon peaks to ensure alignment
%{
figure();
scatter(clean_beacon_peaks(1:2,1),ones(2,1)+3);
hold on
scatter(clean_beacon_peaks(1:2,2),ones(2,1)+2);
scatter(clean_beacon_peaks(1:2,3),ones(2,1)+1);
scatter(clean_beacon_peaks(1:2,4),ones(2,1));
hold off
%}

%create an array with the offsets and their respective times
offsets_times = [avg_peak_times,offsets];


%% calculate positions

%locate the tag peak sets
astro_t_pdir = dir("D:\recorrelated_peaks\astro_tag");
astro_t_pdir = astro_t_pdir(~[astro_t_pdir.isdir]);
elroy_t_pdir = dir("D:\recorrelated_peaks\elroy_tag");
elroy_t_pdir = elroy_t_pdir(~[elroy_t_pdir.isdir]);
jane_t_pdir = dir("D:\recorrelated_peaks\jane_tag");
jane_t_pdir = jane_t_pdir(~[jane_t_pdir.isdir]);
judy_t_pdir = dir("D:\recorrelated_peaks\judy_tag");
judy_t_pdir = judy_t_pdir(~[judy_t_pdir.isdir]);

%create tag peak arrays by concatenating all tag files for each reciever
%add the closest offset value from the arrays above to each peak
astro_tag_peaks = []; elroy_tag_peaks = []; jane_tag_peaks = []; judy_tag_peaks = [];
for i=1:length(astro_t_pdir)
    as_addition = importdata(strcat("D:\recorrelated_peaks\astro_tag","\",astro_t_pdir(i).name));
    as_addition = rem(as_addition,70000000000);
    for j=1:length(as_addition)
        [~,peak] = min(abs(offsets_times(:,1) - as_addition(j)));
        as_addition(j) = as_addition(j) - offsets_times(peak,2);
    end
    astro_tag_peaks = [astro_tag_peaks;as_addition];
end
for i=1:length(elroy_t_pdir)
    el_addition = importdata(strcat("D:\recorrelated_peaks\elroy_tag","\",elroy_t_pdir(i).name));
    el_addition = rem(el_addition,70000000000);
    for j=1:length(el_addition)
        [~,peak] = min(abs(offsets_times(:,1) - el_addition(j)));
        el_addition(j) = el_addition(j) - offsets_times(peak,3);
    end
    elroy_tag_peaks = [elroy_tag_peaks;el_addition];
end
for i=1:length(jane_t_pdir)
    ja_addition = importdata(strcat("D:\recorrelated_peaks\jane_tag","\",jane_t_pdir(i).name));
    ja_addition = rem(ja_addition,70000000000);
    for j=1:length(ja_addition)
        [~,peak] = min(abs(offsets_times(:,1) - ja_addition(j)));
        ja_addition(j) = ja_addition(j) - offsets_times(peak,4);
    end
    jane_tag_peaks = [jane_tag_peaks;ja_addition];
end
for i=1:length(judy_t_pdir)
    ju_addition = importdata(strcat("D:\recorrelated_peaks\judy_tag","\",judy_t_pdir(i).name));
    ju_addition = rem(ju_addition,70000000000);
    for j=1:length(ju_addition)
        [~,peak] = min(abs(offsets_times(:,1) - ju_addition(j)));
        ju_addition(j) = ju_addition(j) - offsets_times(peak,5);
    end
    judy_tag_peaks = [judy_tag_peaks;ju_addition];
end

%plot peaks to find aligned start and end times, which must be manually
%inputted into tag_sorter
%{
scatter(astro_tag_peaks(1:2),ones(2,1)+3);
hold on
scatter(elroy_tag_peaks(1:2),ones(2,1)+2);
scatter(jane_tag_peaks(1:2),ones(2,1)+1);
scatter(judy_tag_peaks(1:2),ones(2,1));
hold off

figure();
scatter(astro_tag_peaks(length(astro_tag_peaks)-1:length(astro_tag_peaks)),ones(2,1)+3);
hold on
scatter(elroy_tag_peaks(length(elroy_tag_peaks)-1:length(elroy_tag_peaks)),ones(2,1)+2);
scatter(jane_tag_peaks(length(jane_tag_peaks)-4:length(jane_tag_peaks)-3),ones(1,1)+1);
scatter(judy_tag_peaks(length(judy_tag_peaks)-2:length(judy_tag_peaks)-2),ones(1,1));
hold off
%}

%clean up the tag set so that each row in the resulting matrix represents
%the same tag pulse
clean_tag_peaks = tag_sorter(astro_tag_peaks,elroy_tag_peaks,jane_tag_peaks,judy_tag_peaks,1000000);

%plot a random section of data to ensure alignment
%{
scatter(clean_tag_peaks(976:980,1),ones(5,1)+3);
hold on
scatter(clean_tag_peaks(976:980,2),ones(5,1)+2);
scatter(clean_tag_peaks(976:980,3),ones(5,1)+1);
scatter(clean_tag_peaks(976:980,4),ones(5,1));
hold off
%}

%grab coordinates for receivers in the local coordinate system w/ origin at
%the beacon
[rx_positions] = test_coordinates();
rx_positions = rx_positions./100; %scale of 100m

%calculate the positions
r_tag = zeros(1,2);
for i=1:length(clean_tag_peaks)  
    %caculate the position of the tag
    t_tag = [clean_tag_peaks(i,:)]';
    r_tag(i,1) = mean([clean_tag_peaks(i,:)]);
    r_tag(i,2:3) = find_position_good_units(t_tag,rx_positions)';
    disp(i);
end

r_tag_scaled = [r_tag(:,1),r_tag(:,2).*100,r_tag(:,3).*100]; %reset to meters instead of 100m
save("D:\location_predictions_final","r_tag_scaled"); %save off the final location prediction matrix

