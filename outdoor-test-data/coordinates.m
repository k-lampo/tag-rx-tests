astro_lla =	[40.005236	-105.262149 1631];
elroy_lla =	[40.005502	-105.2617 1631];
jane_lla =  [40.006179	-105.26275 1631];
judy_lla =	[40.006203	-105.262531 1631];

beacon_lla = [40.0057914 -105.2624098 1631];
tag1_lla = [40.0060588 -105.2624349 1631];
tag2_lla = [40.0056626 -105.2619942 1631];

astro_ecef = lla2ecef(astro_lla)';
elroy_ecef = lla2ecef(elroy_lla)';
jane_ecef = lla2ecef(jane_lla)';
judy_ecef = lla2ecef(judy_lla)';

beacon_ecef = lla2ecef(beacon_lla)';
tag1_ecef = lla2ecef(tag1_lla)';
tag2_ecef = lla2ecef(tag2_lla)';

%Arbitrarily pick the beacon as the origin of our local coordinate system
%This should correspond to a local East-North-Up frame

z_local = beacon_ecef/norm(beacon_ecef);
x_local = cross([0; 0; 1], z_local);
x_local = x_local/norm(x_local);
y_local = cross(z_local, x_local);
y_local = y_local/norm(y_local);

R = [x_local'; y_local'; z_local']; %ECEF-to-local rotation

astro_local = R*(astro_ecef - beacon_ecef);
elroy_local = R*(elroy_ecef - beacon_ecef);
jane_local = R*(jane_ecef - beacon_ecef);
judy_local = R*(judy_ecef - beacon_ecef);

tag1_local = R*(tag1_ecef - beacon_ecef);
tag2_local = R*(tag2_ecef - beacon_ecef);


plot(astro_local(1), astro_local(2), 'bo')
hold on
plot(elroy_local(1), elroy_local(2), 'bo');
plot(jane_local(1), jane_local(2), 'bo');
plot(judy_local(1), judy_local(2), 'bo');
plot(tag1_local(1), tag1_local(2), 'rx');
plot(tag2_local(1), tag2_local(2), 'rx');