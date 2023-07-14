function [rx_local, tag1_local] = local_to_gcs()

%grab final positions in local frame of ref
local_coords_import = importdata("D:\location_predictions_final.mat");
local_coords = local_coords_import(:,2:3);
local_coords(:,3) = 10;

%create and invert the rotation matrix previously used to convert to the local frame
beacon_lla = [39.977652580690 -105.230643475862 1633];
beacon_ecef = lla2ecef(beacon_lla)';

z_local = beacon_ecef/norm(beacon_ecef);
x_local = cross([0; 0; 1], z_local);
x_local = x_local/norm(x_local);
y_local = cross(z_local, x_local);
y_local = y_local/norm(y_local);

R = [x_local'; y_local'; z_local']; %ECEF-to-local rotation
R_inv = R.'; %reverse (local-to-ECEF rotation)

for i = 1:length(local_coords)
    ecef(i,:) = ( R_inv*local_coords(i,:)' + beacon_ecef )';
end

lla = ecef2lla(ecef);

%astro_local = R*(astro_ecef - beacon_ecef);
%elroy_local = R*(elroy_ecef - beacon_ecef);
%jane_local = R*(jane_ecef - beacon_ecef);
%judy_local = R*(judy_ecef - beacon_ecef);

%tag1_local = R*(tag1_ecef - beacon_ecef);
%tag2_local = R*(tag2_ecef - beacon_ecef);

%rx_local = [astro_local, elroy_local, jane_local, judy_local];

save("D:/location_predictions_lla","lla");

end