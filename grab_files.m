function [data,times] = grab_files(dir,iter)
%pulls files from the given directory starting at file "iter" and retrieving
%25 files in total; 25 files x 4 recievers ~= 8 GB of data at a time

    min = 25*(iter-1) + 1; %adjusts the inputted iteration to fit 25-file chunks
    max = size(dir,1); %sets the maximum file to use based on the number of files in the directory

    files = strings(1,1); %creates a string array to be filled with file names

    %iterates through up to 25 files and records the file name for each
    for i=min:max %ensures that the loop will stop once the last file in the directory has been reached, regardless of whether 25 files have been pulled
        files(i-min+1,1) = {strcat(dir(i).folder,"\",dir(i).name)};
        if i-min == 24
            break; %ensures that only 25 files are pulled at a time
        end
    end

    [data,times,~] = file_concat(files); %sends the array of file names to file_concat to extract the data within

end