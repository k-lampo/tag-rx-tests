function [r_tag_scaled] = clean_peaks(as_b_peaks,el_b_peaks,ja_b_peaks,ju_b_peaks,as_t_peaks,el_t_peaks,ja_t_peaks,ju_t_peaks)

    clean_beacon_peaks = beacon_sorter(as_b_peaks,el_b_peaks,ja_b_peaks,ju_b_peaks,10000000); %units are microseconds

    %plot cleaned beacon peaks as a sanity check
    %{
    scatter(clean_beacon_peaks(:,1),ones(size(clean_beacon_peaks,1),1)+3);
    hold on
    scatter(clean_beacon_peaks(:,2),ones(size(clean_beacon_peaks,1),1)+2);
    scatter(clean_beacon_peaks(:,3),ones(size(clean_beacon_peaks,1),1)+1);
    scatter(clean_beacon_peaks(:,4),ones(size(clean_beacon_peaks,1),1));
    hold off
    %}

    %truncate the peaks
    clean_beacon_peaks = rem(clean_beacon_peaks,70000000000);
    
    %grab coordinates for receivers in the local coordinate system w/ origin at
    %the beacon
    [rx_positions] = test_coordinates();
    rx_positions = rx_positions./100; %scale of 100m
    
    %calculate timing offsets between receivers at each timestep in the clean
    %beacon peak set
    offsets = zeros(size(clean_beacon_peaks,1),4);
    for i=1:size(clean_beacon_peaks,1)
        t_beacon = [clean_beacon_peaks(i,:)]';
        offsets(i,:) = find_offsets_good_units(t_beacon,rx_positions,zeros(3,1))'; %beacon position is set to zero because it's the origin of the new coord system
    end

    %save("D:\offsets","offsets");

    %calculate offset jumps (for graphing/analysis)
    %{
    offset_jumps = [];
    as = 1; el = 1; ja = 1; ju = 1;
    for i=1:length(offsets) - 1
        if abs(offsets(i+1,1) - offsets(i,1))/1e6 > 0.01
            offset_jumps(as,1) = mean(clean_beacon_peaks(i:i+1,1));
            as = as + 1;
        end
        if abs(offsets(i+1,2) - offsets(i,2))/1e6 > 0.01
            offset_jumps(el,2) = mean(clean_beacon_peaks(i:i+1,2));
            el = el + 1;
        end
        if abs(offsets(i+1,3) - offsets(i,3))/1e6 > 0.01
            offset_jumps(ja,3) = mean(clean_beacon_peaks(i:i+1,3));
            ja = ja + 1;
        end
        if abs(offsets(i+1,4) - offsets(i,4))/1e6 > 0.01
            offset_jumps(ju,4) = mean(clean_beacon_peaks(i:i+1,4));
            ju = ju + 1;
        end
    end
    %}

    %plot of peaks to make sure they are properly aligned
    %{
    scatter(clean_beacon_peaks(:,1),ones(length(clean_beacon_peaks),1)+3);
    hold on
    scatter(clean_beacon_peaks(:,2),ones(length(clean_beacon_peaks),1)+2);
    scatter(clean_beacon_peaks(:,3),ones(length(clean_beacon_peaks),1)+1);
    scatter(clean_beacon_peaks(:,4),ones(length(clean_beacon_peaks),1));
    hold off
    %}

    %plot of offsets  
    %{
    plot(clean_beacon_peaks(:,1)./1000000+1684270000,offsets(:,1)./1000000,'LineWidth',2);
    hold on
    plot(clean_beacon_peaks(:,1)./1000000+1684270000,offsets(:,2)./1000000,'LineWidth',2);
    plot(clean_beacon_peaks(:,1)./1000000+1684270000,offsets(:,3)./1000000,'LineWidth',2);
    plot(clean_beacon_peaks(:,1)./1000000+1684270000,offsets(:,4)./1000000,'LineWidth',2);
    hold off

    legend("Astro","Elroy","Jane","Judy");
    xlabel("Unix Timestamp (s)");
    ylabel("Offset (s)");
    title("Receiver Offset vs Time");
    %}

    %save("D:\offset_jumps","offset_jumps");

    %add offsets to beacon peaks for use in aligning tag peaks
    clean_beacon_peaks = clean_beacon_peaks - offsets; 
    
    %truncate the tag peaks for matrix conditioning purposes
    as_t_peaks = rem(as_t_peaks,70000000000);
    el_t_peaks = rem(el_t_peaks,70000000000);
    ja_t_peaks = rem(ja_t_peaks,70000000000);
    ju_t_peaks = rem(ju_t_peaks,70000000000);
    
    %{
    %add offsets to the peaks
    [as_t_peaks,astro_start] = add_offsets(as_t_peaks,1,clean_beacon_peaks,offsets);
    [el_t_peaks,elroy_start] = add_offsets(el_t_peaks,2,clean_beacon_peaks,offsets);
    [ja_t_peaks,jane_start] = add_offsets(ja_t_peaks,3,clean_beacon_peaks,offsets);
    [ju_t_peaks,judy_start] = add_offsets(ju_t_peaks,4,clean_beacon_peaks,offsets);
    
    %remove the unadjusted peaks (those before the first beacon peak)
    offset_astro_tag_peaks = as_t_peaks(astro_start:end);
    offset_elroy_tag_peaks = el_t_peaks(elroy_start:end);
    offset_jane_tag_peaks = ja_t_peaks(jane_start:end);
    offset_judy_tag_peaks = ju_t_peaks(judy_start:end);
    %}

    offset_astro_tag_peaks = as_t_peaks - offsets(1,1);
    offset_elroy_tag_peaks = el_t_peaks - offsets(1,2);
    offset_jane_tag_peaks = ja_t_peaks - offsets(1,3);
    offset_judy_tag_peaks = ju_t_peaks - offsets(1,4);

    scatter(offset_astro_tag_peaks,ones(length(offset_astro_tag_peaks),1)+3);
    hold on
    scatter(offset_elroy_tag_peaks,ones(length(offset_elroy_tag_peaks),1)+2);
    scatter(offset_jane_tag_peaks,ones(length(offset_jane_tag_peaks),1)+1);
    scatter(offset_judy_tag_peaks,ones(length(offset_judy_tag_peaks),1));
    hold off
    
    %clean up the peak set so that each reciever's data represents the same
    %beacon pulses
    clean_tag_peaks = tag_sorter(offset_astro_tag_peaks,offset_elroy_tag_peaks,offset_jane_tag_peaks,offset_judy_tag_peaks,1000000);
    %clean_tag_peaks = [offset_astro_tag_peaks(2),offset_elroy_tag_peaks(2),offset_jane_tag_peaks(3),offset_judy_tag_peaks(1)];

    %plot clean peaks for each reciever to check for agreement
    scatter(clean_tag_peaks(:,1),ones(1,size(clean_tag_peaks,1))+2);
    hold on
    scatter(clean_tag_peaks(:,2),ones(1,size(clean_tag_peaks,1))+1);
    scatter(clean_tag_peaks(:,3),ones(1,size(clean_tag_peaks,1)));
    scatter(clean_tag_peaks(:,4),ones(1,size(clean_tag_peaks,1))-1);
    hold off
    
    %calculate the tag position at each time in the clean tag data set
    r_tag = zeros(1,2);
    for i=1:size(clean_tag_peaks,1)    
        %caculate the position of the tag
        t_tag = [clean_tag_peaks(i,:)]';
        r_tag(i,1) = mean([offset_astro_tag_peaks(i),offset_elroy_tag_peaks(i),offset_jane_tag_peaks(i),offset_judy_tag_peaks(i)]);
        r_tag(i,2:3) = find_position_good_units(t_tag,rx_positions)';
        disp(i);
    end
    
    r_tag_scaled = [r_tag(:,1),r_tag(:,2).*100,r_tag(:,3).*100]; %reset to meters instead of 100m
    %save("D:\location_predictions_realignment","r_tag_scaled")
end
