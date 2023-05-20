global_constants;

beacon_rel = [astro_local elroy_local jane_local judy_local];

t0 = 100*rand(1);
b0 = 100*rand(1);
d2 = 100*rand(1);
d3 = 100*rand(1);
d4 = 100*rand(1);

beacon_range = zeros(4,1);
for k = 1:4
    beacon_range(k) = norm(beacon_rel(1:2,k));
end
beacon_tof = beacon_range/c + b0;


tag1_rel = [astro_local elroy_local jane_local judy_local] - tag1_local;
tag1_range = zeros(4,1);
for k = 1:4
    tag1_range(k) = norm(tag1_rel(1:2,k));
end
tag1_tof = tag1_range/c + t0;

beacon_tof = beacon_tof + [0; d2; d3; d4];
tag1_tof = tag1_tof + [0; d2; d3; d4];

%tag1_ls = find_position2(tag1_tof, beacon_tof, beacon_rel, zeros(3,1));

time_offsets = find_offsets(beacon_tof, beacon_rel, zeros(3,1));
time_offsets - [d2; d3; d4]

tag1_ls = find_position(tag1_tof, time_offsets, beacon_rel);
tag1_ls - tag1_local(1:2)

