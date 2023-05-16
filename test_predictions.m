c = 299792458.0/1000.0; %meters/ms

beacon_rel = [astro_local elroy_local jane_local judy_local];
beacon_range = zeros(4,1);
for k = 1:4
    beacon_range(k) = norm(beacon_rel(:,k));
end
beacon_tof = beacon_range/c;


tag1_rel = [astro_local elroy_local jane_local judy_local] - tag1_local;
tag1_range = zeros(4,1);
for k = 1:4
    tag1_range(k) = norm(tag1_rel(:,k));
end
tag1_tof = tag1_range/c;

tag1_local
tag1_ls = find_position(tag1_tof, beacon_tof, beacon_rel)

