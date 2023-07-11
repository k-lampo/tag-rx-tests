%% determine the residuals for the position predictions

%import the GPS location set in the local frame and the predicted positions
tag_gps_local = importdata("D:\locations.mat");
tag_gps_local(:,1) = rem(tag_gps_local(:,1),1684270000000000);
predictions = importdata("D:\location_predictions_final.mat");
predictions(:,1) = rem(predictions(:,1),1684270000000000);

%calculate continuous residuals
x_c_res = [];
y_c_res = [];
j = 1;
k = 1;

for i=1:length(predictions)
    %only calculates residuals for positions within the time range of the
    %GPS data (& skips a large gap in data in the middle)
    if predictions(i,1) >= tag_gps_local(1,1) && predictions(i,1) <= tag_gps_local(973,1) || predictions(i,1) >= tag_gps_local(974,1) && predictions(i,1) <= tag_gps_local(length(tag_gps_local),1)
        %find the GPS points just before and just after the predicted value
        above_list = find(tag_gps_local(:,1) >= predictions(i,1));
        below_list = find(tag_gps_local(:,1) <= predictions(i,1));
        above = above_list(1);
        below = below_list(length(below_list));
        amt_above = tag_gps_local(above,1) - predictions(i,1);
        amt_below = predictions(i,1) - tag_gps_local(below,1);
        
        %approximate the GPS value at the exact predicted time by making a
        %linear model between the two points
        approx_x = tag_gps_local(below,2) + (tag_gps_local(above,2) - tag_gps_local(below,2))*(amt_below/(amt_above + amt_below));
        approx_y = tag_gps_local(below,3) + (tag_gps_local(above,3) - tag_gps_local(below,3))*(amt_below/(amt_above + amt_below));
        
        %calculate and store the residuals
        if abs(approx_x - predictions(i,2)) < 200 && abs(approx_y - predictions(i,3)) < 200 %removes large outliers immediately (~2-4 pts per plot)
            x_c_res(j) = approx_x - predictions(i,2); %for histogram
            x_c_res_plot(j,:) = [predictions(i,1:2),x_c_res(j)]; %for scatter plot

            y_c_res(j) = approx_y - predictions(i,3);
            y_c_res_plot(j,:) = [predictions(i,1),predictions(i,3),y_c_res(j)];

            c_res(j) = norm([x_c_res(j), y_c_res(j)]);
            c_res_plot(j,:) = [predictions(i,1:3),c_res(j)];
            j = j + 1;
        end
    end
end

%calculate the standard deviations
x_c_std = std(x_c_res);
y_c_std = std(y_c_res);
c_std = std(c_res);

%% create residual histograms

%create bins in the range of -200 to 200 for use in the histograms
num_bins = 80;
for i=1:num_bins
    his_bins(1,i) = -200 + 400/num_bins*(i-1);
end

figure();
histogram(x_c_res,his_bins);
xlabel("Residual (m)");
ylabel("Frequency");
title("X Coordinate Residuals");
txt = {strcat("\sigma = ",string(x_c_std))};
text(50,50,txt,'FontSize',14);
xlim([-200 200]);

figure();
histogram(y_c_res,his_bins,'FaceColor','r');
xlabel("Residual (m)");
ylabel("Frequency");
title("Y Coordinate Residuals");
txt = {strcat("\sigma = ",string(y_c_std))};
text(50,50,txt,'FontSize',14);
xlim([-200 200]);

figure();
histogram(c_res,his_bins,'FaceColor',[0.4660 0.6740 0.1880]);
xlabel("Residual (m)");
ylabel("Frequency");
title("Residuals: Distance from Local Origin");
txt = {strcat("\sigma = ",string(c_std))};
text(50,50,txt,'FontSize',14);
xlim([0 200]);


%% plot offsets

plot((offsets_times(:,1) + 1684270000000000)./1e6,offsets_times(:,2)./1e6,'LineWidth',2);
hold on
plot((offsets_times(:,1) + 1684270000000000)./1e6,offsets_times(:,3)./1e6,'LineWidth',2);
plot((offsets_times(:,1) + 1684270000000000)./1e6,offsets_times(:,4)./1e6,'LineWidth',2);
plot((offsets_times(:,1) + 1684270000000000)./1e6,offsets_times(:,5)./1e6,'LineWidth',2);
hold off

legend("astro","elroy","jane","judy");
xlabel("GPS Time (s)");
ylabel("Offset (s)");
title("Reciever Offset vs GPS Time");

%% plot actual vs predicted locations in scatter plots

%x coordinate
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,2),[],"black",".");
hold on
scatter((predictions(:,1) + 1684270000000000)./1e6,predictions(:,2),[],"blue","."); %[0.32 0.5333333333333 0.6745098039]
hold off

ylim([-400 300]);
legend("Tag GPS Data","Predicted Locations");
ylabel("X Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("X Coordinate: Predicted vs Actual Locations");

%y coordinate
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,3),[],"black",".");
hold on
scatter((predictions(:,1) + 1684270000000000)./1e6,predictions(:,3),[],"red","."); %[0.8 0.32 0.32]
hold off

ylim([-500 500]);
legend("Tag GPS Data","Predicted Locations");
ylabel("Y Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("Y Coordinate: Predicted vs Actual Locations");

%both
for i=1:length(tag_gps_local)
    norm_tag_gps(i,1) = norm([tag_gps_local(i,3),tag_gps_local(i,2)]);
end
for i=1:length(predictions)
    norm_predictions(i,1) = norm([predictions(i,3),predictions(i,2)]);
end

figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,norm_tag_gps(:,1),[],"black",".");
hold on
scatter((predictions(:,1) + 1684270000000000)./1e6,norm_predictions(:,1),[],[0.4660 0.6740 0.1880],".");
hold off

ylim([0 600]);
legend("Tag GPS Data","Predicted Locations");
ylabel("Distance from Local Origin (m)");
xlabel("GPS Time (s)");
title("Predicted vs Actual Locations");

%% plot actual vs predicted locations with mean & std in scatter plots

%calculate the mean of the position error
x_mean_pos_error = mean(x_c_res);
x_std_pos_error = std(x_c_res);

x_mean_line = predictions(:,2) + x_mean_pos_error;
x_std2_line = x_mean_line + x_std_pos_error + x_std_pos_error;
x_stdm2_line = x_mean_line - x_std_pos_error - x_std_pos_error;
x_cut_pred = predictions;
i = 1;

while i < length(x_mean_line)
    if x_mean_line(i) >= 150 || x_mean_line(i) <= -300 || x_std2_line(i) >= 150 || x_std2_line(i) <= -300 || x_stdm2_line(i) >= 150 || x_stdm2_line(i) <= -300
        x_mean_line(i) = [];
        x_std2_line(i) = [];
        x_stdm2_line(i) = [];
        x_cut_pred(i,:) = [];
    else
        i = i + 1;
    end
end

%calculate the mean of the position error
y_mean_pos_error = mean(y_c_res);
y_std_pos_error = std(y_c_res);

y_mean_line = predictions(:,3) + y_mean_pos_error;
y_std2_line = y_mean_line + y_std_pos_error + y_std_pos_error;
y_stdm2_line = y_mean_line - y_std_pos_error - y_std_pos_error;
y_cut_pred = predictions;
i = 1;

while i < length(y_mean_line)
    if y_mean_line(i) >= 350 || y_mean_line(i) <= -500 || y_std2_line(i) >= 350 || y_std2_line(i) <= -500 || y_stdm2_line(i) >= 350 || y_stdm2_line(i) <= -500
        y_mean_line(i) = [];
        y_std2_line(i) = [];
        y_stdm2_line(i) = [];
        y_cut_pred(i,:) = [];
    else
        i = i + 1;
    end
end

%calculate the mean of the position error
mean_pos_error = mean(c_res);
std_pos_error = std(c_res);

mean_line = norm_predictions(:,1) + mean_pos_error;
std2_line = mean_line + std_pos_error + std_pos_error;
stdm2_line = mean_line - std_pos_error - std_pos_error;
cut_pred = predictions(:,1);
i = 1;

while i < length(mean_line)
    if mean_line(i) >= 600 || mean_line(i) <= 0 || std2_line(i) >= 600 || std2_line(i) <= 0 || stdm2_line(i) >= 600 || stdm2_line(i) <= 0
        mean_line(i) = [];
        std2_line(i) = [];
        stdm2_line(i) = [];
        cut_pred(i,:) = [];
    else
        i = i + 1;
    end
end

%x coordinate
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,2),[],"black",".");
hold on
scatter((predictions(:,1) + 1684270000000000)./1e6,predictions(:,2),[],"blue",".");
plot((x_cut_pred(:,1) + 1684270000000000)./1e6,x_std2_line,'color',[0.5 0.5 0.5]); %[0.32 0.5333333333333 0.6745098039]
plot((x_cut_pred(:,1) + 1684270000000000)./1e6,x_stdm2_line,'color',[0.5 0.5 0.5]); %[0.32 0.5333333333333 0.6745098039]
hold off

ylim([-300 150]);
legend("Tag GPS Data","Predicted Locations","2\sigma","-2\sigma");
ylabel("X Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("X Coordinate: Predicted vs Actual Locations");

%y coordinate
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,3),[],"black",".");
hold on
scatter((predictions(:,1) + 1684270000000000)./1e6,predictions(:,3),[],"red","."); %[0.8 0.32 0.32]
plot((y_cut_pred(:,1) + 1684270000000000)./1e6,y_std2_line,'color',[0.5 0.5 0.5]); %[0.32 0.5333333333333 0.6745098039]
plot((y_cut_pred(:,1) + 1684270000000000)./1e6,y_stdm2_line,'color',[0.5 0.5 0.5]); %[0.32 0.5333333333333 0.6745098039]
hold off

ylim([-500 350]);
legend("Tag GPS Data","Predicted Locations","2\sigma","-2\sigma");
ylabel("Y Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("Y Coordinate: Predicted vs Actual Locations");

%both
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,norm_tag_gps(:,1),[],"black",".");
hold on
scatter((predictions(:,1) + 1684270000000000)./1e6,norm_predictions(:,1),[],[0.4660 0.6740 0.1880],"."); %[0.8 0.32 0.32]
plot((cut_pred(:,1) + 1684270000000000)./1e6,std2_line(:,1),'color',[0.5 0.5 0.5]); %[0.32 0.5333333333333 0.6745098039]
plot((cut_pred(:,1) + 1684270000000000)./1e6,stdm2_line(:,1),'color',[0.5 0.5 0.5]); %[0.32 0.5333333333333 0.6745098039]
hold off

ylim([0 600]);
xlim([1.684273e9 1.684276e9]);
legend("Tag GPS Data","Predicted Locations","2\sigma","-2\sigma");
ylabel("Distance from Local Origin (m)");
xlabel("GPS Time (s)");
title("Predicted vs Actual Locations");

%% plot actual vs predicted positions within 1-2 standard deviations

%create arrays with data that falls in the 1-2 std ranges
y_res_1std = []; y_res_2std = []; x_res_1std = []; x_res_2std = [];
for i=1:length(x_c_res_plot)
    if abs(x_c_res_plot(i,3)) <= x_c_std
        x_res_1std = [x_res_1std;x_c_res_plot(i,:)];
        x_res_2std = [x_res_2std;x_c_res_plot(i,:)];
    elseif abs(x_c_res_plot(i,3)) <= 2*x_c_std
        x_res_2std = [x_res_2std;x_c_res_plot(i,:)];
    end
end

for i=1:length(y_res_plot)
    if abs(y_res_plot(i,3)) < y_c_std
        y_res_1std = [y_res_1std;y_res_plot(i,:)];
        y_res_2std = [y_res_2std;y_res_plot(i,:)];
    elseif abs(y_res_plot(i,3)) < 2*y_c_std
        y_res_2std = [y_res_2std;y_res_plot(i,:)];
        k = k + 1;
    end
end

%plot 1 std, y coord
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,3),[],"black",".");
hold on
scatter((y_res_1std(:,1) + 1684270000000000)./1e6,y_res_1std(:,2),[],"red",".");
hold off

ylim([-500 500]);
xlim([1.684273e9 1.684276e9]);
legend("Tag GPS Data","Predicted Locations");
ylabel("Y Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("Y Coordinate: Predicted vs Actual Locations (residual < \sigma)");

%plot 2 std, y coord
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,3),[],"black",".");
hold on
scatter((y_res_2std(:,1) + 1684270000000000)./1e6,y_res_2std(:,2),[],"red",".");
hold off

ylim([-500 500]);
xlim([1.684273e9 1.684276e9]);
legend("Tag GPS Data","Predicted Locations");
ylabel("Y Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("Y Coordinate: Predicted vs Actual Locations (residual < 2\sigma)");

%plot 1 std, x coord
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,2),[],"black",".");
hold on
scatter((x_res_1std(:,1) + 1684270000000000)./1e6,x_res_1std(:,2),[],"blue","."); %[0.8 0.32 0.32]
hold off

ylim([-400 300]);
xlim([1.684273e9 1.684276e9]);
legend("Tag GPS Data","Predicted Locations");
ylabel("X Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("X Coordinate: Predicted vs Actual Locations (residual < \sigma)");

%plot 2 std, x coord
figure();
scatter((tag_gps_local(:,1) + 1684270000000000)./1e6,tag_gps_local(:,2),[],"black",".");
hold on
scatter((x_res_2std(:,1) + 1684270000000000)./1e6,x_res_2std(:,2),[],"blue","."); %[0.8 0.32 0.32]
hold off

ylim([-400 300]);
xlim([1.684273e9 1.684276e9]);
legend("Tag GPS Data","Predicted Locations");
ylabel("X Coordinate, Local Reference Frame (m)");
xlabel("GPS Time (s)");
title("X Coordinate: Predicted vs Actual Locations (residual < 2\sigma)");

%% plot 3d position vs residual
z = eye(length(c_res));
z = z .* c_res';

surf(c_res_plot(:,2),c_res_plot(:,3),z);
xlabel("X Coordinate");
ylabel("Y Coordinate");
zlabel("Residual");


