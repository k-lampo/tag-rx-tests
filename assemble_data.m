main_dir_b = dir("D:\correlated_data\elroy_beacon");
main_dir_b = main_dir_b(~[main_dir_b.isdir]);

main_dir_t = dir("D:\correlated_data\elroy_tag");
main_dir_t = main_dir_t(~[main_dir_t.isdir]);

time_dir = dir("D:\20230516\elroy");
time_dir = time_dir(~[time_dir.isdir]);

path_b = "D:\correlated_data\elroy_beacon\";
path_t = "D:\correlated_data\elroy_tag\";
peaks_b = 0;
peaks_t = 0;

disp("iterations to complete: " + length(main_dir_b));


for i=1:length(main_dir_b)
    [~,time_ints,inds] = grab_files_v2(time_dir,i);

    elroy_b_data = importdata(strcat(path_b,main_dir_b(i).name));
    elroy_b_data = elroy_b_data(:,1);
    peaks_b = [peaks_b;find_peak_times(elroy_b_data,0.1,time_ints,inds)];

    elroy_t_data = importdata(strcat(path_t,main_dir_t(i).name));
    elroy_t_data = elroy_t_data(:,1);
    peaks_t = [peaks_t;find_peak_times(elroy_t_data,0.1,time_ints,inds)];

    disp("done with iteration " + i);

    if rem(i,10) == 0
        peaks_b_temp = peaks_b(2+10*(i/10-1):length(peaks_b),1);
        save(strcat("D:\peaks\elroy_beacon_peaks_",string(i)),"peaks_b_temp");
        
        peaks_t_temp = peaks_t(2+10*(i/10-1):length(peaks_t),1);
        save(strcat("D:\peaks\elroy_tag_peaks_",string(i)),"peaks_t_temp");
    end
end



peaks_b = peaks_b(2:length(peaks_b),1);
save("D:\peaks\elroy_beacon_peaks","peaks_b");

peaks_t = peaks_t(2:length(peaks_t),1);
save("D:\peaks\elroy_tag_peaks","peaks_t");


%astro
main_dir_b = dir("D:\correlated_data\astro_beacon");
main_dir_b = main_dir_b(~[main_dir_b.isdir]);

main_dir_t = dir("D:\correlated_data\astro_tag");
main_dir_t = main_dir_t(~[main_dir_t.isdir]);

time_dir = dir("D:\20230516\astro");
time_dir = time_dir(~[time_dir.isdir]);

path_b = "D:\correlated_data\astro_beacon\";
path_t = "D:\correlated_data\astro_tag\";
peaks_b = 0;
peaks_t = 0;

disp("iterations to complete: " + length(main_dir_b));

for i=1:length(main_dir_b)
    [~,time_ints,inds] = grab_files_v2(time_dir,i);

    astro_b_data = importdata(strcat(path_b,main_dir_b(i).name));
    astro_b_data = astro_b_data(:,1);
    peaks_b = [peaks_b;find_peak_times(astro_b_data,0.1,time_ints,inds)];

    astro_t_data = importdata(strcat(path_t,main_dir_t(i).name));
    astro_t_data = astro_t_data(:,1);
    peaks_t = [peaks_t;find_peak_times(astro_t_data,0.1,time_ints,inds)];

    disp("done with iteration " + i);

    if rem(i,10) == 0
        peaks_b_temp = peaks_b(2+10*(i/10-1):length(peaks_b),1);
        save(strcat("D:\peaks\astro_beacon_peaks_",string(i)),"peaks_b_temp");
        
        peaks_t_temp = peaks_t(2+10*(i/10-1):length(peaks_t),1);
        save(strcat("D:\peaks\astro_tag_peaks_",string(i)),"peaks_t_temp");
    end
end

peaks_b = peaks_b(2:length(peaks_b),1);
save("D:\peaks\astro_beacon_peaks","peaks_b");

peaks_t = peaks_t(2:length(peaks_t),1);
save("D:\peaks\astro_tag_peaks","peaks_t");



%%jane
main_dir_b = dir("D:\correlated_data\jane_beacon");
main_dir_b = main_dir_b(~[main_dir_b.isdir]);

main_dir_t = dir("D:\correlated_data\jane_tag");
main_dir_t = main_dir_t(~[main_dir_t.isdir]);

time_dir = dir("D:\20230516\jane");
time_dir = time_dir(~[time_dir.isdir]);

path_b = "D:\correlated_data\jane_beacon\";
path_t = "D:\correlated_data\jane_tag\";
peaks_b = 0;
peaks_t = 0;

disp("iterations to complete: " + length(main_dir_b));

for i=1:length(main_dir_b)
    [~,time_ints,inds] = grab_files_v2(time_dir,i);

    jane_b_data = importdata(strcat(path_b,main_dir_b(i).name));
    jane_b_data = jane_b_data(:,1);
    peaks_b = [peaks_b;find_peak_times(jane_b_data,0.1,time_ints,inds)];

    jane_t_data = importdata(strcat(path_t,main_dir_t(i).name));
    jane_t_data = jane_t_data(:,1);
    peaks_t = [peaks_t;find_peak_times(jane_t_data,0.1,time_ints,inds)];

    disp("done with iteration " + i);

    if rem(i,10) == 0
        peaks_b_temp = peaks_b(2+10*(i/10-1):length(peaks_b),1);
        save(strcat("D:\peaks\jane_beacon_peaks_",string(i)),"peaks_b_temp");
        
        peaks_t_temp = peaks_t(2+10*(i/10-1):length(peaks_t),1);
        save(strcat("D:\peaks\jane_tag_peaks_",string(i)),"peaks_t_temp");
    end
end

peaks_b = peaks_b(2:length(peaks_b),1);
save("D:\peaks\jane_beacon_peaks","peaks_b");

peaks_t = peaks_t(2:length(peaks_t),1);
save("D:\peaks\jane_tag_peaks","peaks_t");




%%judy
main_dir_b = dir("D:\correlated_data\judy_beacon");
main_dir_b = main_dir_b(~[main_dir_b.isdir]);

main_dir_t = dir("D:\correlated_data\judy_tag");
main_dir_t = main_dir_t(~[main_dir_t.isdir]);

time_dir = dir("D:\20230516\judy");
time_dir = time_dir(~[time_dir.isdir]);

path_b = "D:\correlated_data\judy_beacon\";
path_t = "D:\correlated_data\judy_tag\";
peaks_b = 0;
peaks_t = 0;

disp("iterations to complete: " + length(main_dir_b));

for i=1:length(main_dir_b)
    [~,time_ints,inds] = grab_files_v2(time_dir,i);

    judy_b_data = importdata(strcat(path_b,main_dir_b(i).name));
    judy_b_data = judy_b_data(:,1);
    peaks_b = [peaks_b;find_peak_times(judy_b_data,0.2,time_ints,inds)];

    judy_t_data = importdata(strcat(path_t,main_dir_t(i).name));
    judy_t_data = judy_t_data(:,1);
    peaks_t = [peaks_t;find_peak_times(judy_t_data,0.2,time_ints,inds)];

    disp("done with iteration " + i);

    if rem(i,10) == 0
        peaks_b_temp = peaks_b(2+10*(i/10-1):length(peaks_b),1);
        save(strcat("D:\peaks\judy_beacon_peaks_",string(i)),"peaks_b_temp");
        
        peaks_t_temp = peaks_t(2+10*(i/10-1):length(peaks_t),1);
        save(strcat("D:\peaks\judy_tag_peaks_",string(i)),"peaks_t_temp");
    end
end

peaks_b = peaks_b(2:length(peaks_b),1);
save("D:\peaks\judy_beacon_peaks","peaks_b");

peaks_t = peaks_t(2:length(peaks_t),1);
save("D:\peaks\judy_tag_peaks","peaks_t");