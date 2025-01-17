function [clean_peaks] = beacon_sorter(astro_peaks,elroy_peaks,jane_peaks,judy_peaks,real_dt)

    tol = 300000; %tolerable variation from expected value in us
    
    %handpicked maximum and minimum times based on the fact that the files
    %are in curated groups, and the start and end times are aligned
    astro_start = 1;
    elroy_start = 1;
    jane_start = 1;
    judy_start = 1;
    abs_min = min([astro_peaks(astro_start),elroy_peaks(elroy_start),jane_peaks(jane_start),judy_peaks(judy_start)]);

    astro_end = length(astro_peaks);
    elroy_end = length(elroy_peaks);
    jane_end = length(jane_peaks);
    judy_end = length(judy_peaks);
    abs_max = max([astro_peaks(astro_end),elroy_peaks(elroy_end),jane_peaks(jane_end),judy_peaks(judy_end)]);

    %determine the maximum possible number of steps in the clean set based on
    %the real step size
    total_steps = round((abs_max - abs_min)/real_dt) + 1;
    
    %initialize an array to save the clean peak structure
    clean_peaks = zeros(total_steps,4);
    clean_peaks(1,:) = [astro_peaks(astro_start),elroy_peaks(elroy_start),jane_peaks(jane_start),judy_peaks(judy_start)];
    
    %populate the clean peaks matrix with beacon peaks that all represent
    %the same pulse
    [targets] = clean_peaks(1,:)'; %what the method is searching for; we expect a pulse every ~10s
    indices = [astro_start;elroy_start;jane_start;judy_start] + 1; %index for each reciever based on the determined starting indices above
    for i=2:length(clean_peaks) %for the length of the clean peaks
        subindices = indices; %method searches through the subindices, but always returns to the main index set if there's no subindex match (ensures one bad value doesn't run the entire method)
        targets = targets + real_dt; %add the expected dt to the target array

        while subindices(1) <= length(astro_peaks) && astro_peaks(subindices(1)) < targets(1) + tol %300ms
            if astro_peaks(subindices(1)) > targets(1) - tol %check to see if it's a legitamate match
                clean_peaks(i,1) = astro_peaks(subindices(1));
                indices(1) = subindices(1) + 1; %updates the index so that the next search starts from the point after this saved one
                break
            end
            subindices(1) = subindices(1) + 1;
        end

        while subindices(2) <= length(elroy_peaks) && elroy_peaks(subindices(2)) < targets(2) + tol
            if elroy_peaks(subindices(2)) > targets(2) - tol
                clean_peaks(i,2) = elroy_peaks(subindices(2));
                indices(2) = subindices(2) + 1;
                break
            end
            subindices(2) = subindices(2) + 1;
        end


        while subindices(3) <= length(jane_peaks) && jane_peaks(subindices(3)) < targets(3) + tol
            if jane_peaks(subindices(3)) > targets(3) - tol
                clean_peaks(i,3) = jane_peaks(subindices(3));
                indices(3) = subindices(3) + 1;
                break
            end
            subindices(3) = subindices(3) + 1;
        end

        while subindices(4) <= length(judy_peaks) && judy_peaks(subindices(4)) < targets(4) + tol
            if judy_peaks(subindices(4)) > targets(4) - tol
                clean_peaks(i,4) = judy_peaks(subindices(4));
                indices(4) = subindices(4) + 1;
                break
            end
            subindices(4) = subindices(4) + 1;
        end

    end

    %removes all rows for which at least one reciever didn't have a match
    i=1;
    while i <= size(clean_peaks,1)
        if clean_peaks(i,1) == 0 || clean_peaks(i,2) == 0 || clean_peaks(i,3) == 0 || clean_peaks(i,4) == 0
            clean_peaks(i,:) = [];
        else
            i = i+1;
        end
    end

end