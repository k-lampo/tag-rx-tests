%Hand-picked beacon times:
t_beacon = 1e3*[astro_beacon_peaks(3);
            elroy_beacon_peaks(2);
            jane_beacon_peaks(3);
            judy_beacon_peaks(2)]; %microseconds

%Grab coordinates for receivers:
[rx_positions, tag_position] = test_coordinates();
rx_positions = rx_positions/100; %100m

%Calculate timing offsets between receivers:
offsets = find_offsets_good_units(t_beacon,rx_positions,zeros(3,1));

%Hand-picked tag times:
t_tag1 = [astro_tag_peaks(6);
          elroy_tag_peaks(9);
          jane_tag_peaks(29);
          judy_tag_peaks(36)]-astro_tag_peaks(6);
t_tag1 = 1e3*t_tag1-offsets; %microseconds

t_tag2 = [astro_tag_peaks(9);
          elroy_tag_peaks(10);
          jane_tag_peaks(34);
          judy_tag_peaks(41)]-astro_tag_peaks(9);
t_tag2 = 1e3*t_tag2-offsets;%microseconds


r_tag1 = find_position_good_units(t_tag1,rx_positions);
r_tag2 = find_position_good_units(t_tag2,rx_positions);
