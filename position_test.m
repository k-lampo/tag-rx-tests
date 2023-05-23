%Hand-picked beacon times:
t_beacon = [astro_beacon_peaks(3);
            elroy_beacon_peaks(2);
            jane_beacon_peaks(3);
            judy_beacon_peaks(2)];

%Grab coordinates for receivers:
rx_positions = test_coordinates();

%Calculate timing offsets between receivers:
offsets = find_offsets(t_beacon,rx_positions,zeros(3,1));

%Hand-picked tag times:
t_tag1 = [astro_tag_peaks(6);
          elroy_tag_peaks(9);
          jane_tag_peaks(29);
          judy_tag_peaks(36)]-offsets;

t_tag2 = [astro_tag_peaks(9);
          elroy_tag_peaks(10);
          jane_tag_peaks(34);
          judy_tag_peaks(41)]-offsets;

r_tag1 = find_position(t_tag1,rx_positions);
r_tag2 = find_position(t_tag2,rx_positions);
