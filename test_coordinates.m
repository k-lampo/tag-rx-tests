function rx_local = test_coordinates()

    astro_lla =	[39.975011666666667	-105.2256183333333 1637];
    elroy_lla =	[39.975208333333335	-105.2359216666667 1661];
    jane_lla =  [39.978681666666667	-105.2285650000000 1635];
    judy_lla =	[39.979219999999998	-105.2320800000000 1631];
    
    beacon_lla = [39.977652580690 -105.230643475862 1633];
    
    astro_ecef = lla2ecef(astro_lla)';
    elroy_ecef = lla2ecef(elroy_lla)';
    jane_ecef = lla2ecef(jane_lla)';
    judy_ecef = lla2ecef(judy_lla)';
    
    beacon_ecef = lla2ecef(beacon_lla)';
    
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
    
    %tag1_local = R*(tag1_ecef - beacon_ecef);
    %tag2_local = R*(tag2_ecef - beacon_ecef);
    
    
    %plot(astro_local(1), astro_local(2), 'bo')
    %hold on
    %plot(elroy_local(1), elroy_local(2), 'bo');
    %plot(jane_local(1), jane_local(2), 'bo');
    %plot(judy_local(1), judy_local(2), 'bo');
    
    rx_local = [astro_local, elroy_local, jane_local, judy_local];

end