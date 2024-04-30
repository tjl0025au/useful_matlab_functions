% geopolygon picker and interpolator
% Bryce Karlins: 2022-10-30
% Creates a blank geoplot at some bounds and allows user to create and
% tweak a closed polygon. From there it performs a smoothing step with
% cubic spline interpolation with end conditions (curve fitting toolbox
% required) and then upsamples the spline path to a final point count. Also
% includes some code to plot other relevant TMS lines. 
%% Blank Geoplot
clear
clf
figure(1)
geoaxes
geobasemap satellite
geolimits([33.553531,33.838131],[-106.725336,-106.445044])  %WSMR
% geolimits([36.268,36.2765],[-115.015,-115.0065]) %LVMS

% Old Bounds, black
% oldBounds();

% Polimove QJ bounds, green

% 2021 LiDAR bounds, red


% pitLine(26,926);

% RaceyBounds();

% runData();

% nodes();

geobasemap satellite
%% Draw/Load Polygon
% Uncomment blocks to either draw polygon or load a prev poly from mat
% Use ROI if you want a closed path, line if you want it discontinuous

%draw polygon from scratch
%%roi = drawpolygon('FaceAlpha',0,'FaceSelectable',false,'Color',"red");
line = drawpolyline('Color',"red");

%load polygon from file;
% [file,path] = uigetfile("*.mat");
% load([path,file])
% % roi = drawpolygon('FaceAlpha',0,'FaceSelectable',false,'Color',"red",'Position',roi.Position);
% % line = drawpolyline('Color',"red",'Position',line.Position);

input('press enter to continue with smoothing') % wait for polygon fine tuning
%% Interpolate Loop

% scale to match your application:
smoothing_points = 30;  % how many evenly spaced points to smooth with
upsample_points = 1000; % final number of points desired

rawLine = line.Position; % get array of points from drawn polygon
% rawLine(end+1,1:2) = rawLine(1,1:2); % copy first point to end to create closed shape


intermedLine = interparc(smoothing_points,rawLine(:,1),rawLine(:,2),'spline'); % do a coarse spline interp to smooth handdrawn path
smoothLine = interparc(upsample_points,intermedLine(:,1),intermedLine(:,2),'spline'); % upsample to final point count


hold on
geoplot(intermedLine(:,1),intermedLine(:,2),'LineStyle','none','Marker','.','Color','c','MarkerSize',12)
geoplot(smoothLine(:,1),smoothLine(:,2),'Marker','.','Color','b')
hold off

%% Interpolate Line

rawLine = line.Position; % get array of points from drawn polygon
% rawLine(end+1,1:2) = rawLine(1,1:2); % copy first point to end to create closed shape

intermedLine = interparc(50,rawLine(:,1),rawLine(:,2)); % do a coarse spline interp to smooth handdrawn path
smoothLine = interparc(1000,intermedLine(:,1),intermedLine(:,2)); % upsample to final point count

hold on
geoplot(intermedLine(:,1),intermedLine(:,2),'LineStyle','none','Marker','.','Color','c','MarkerSize',12)
geoplot(smoothLine(:,1),smoothLine(:,2),'Marker','.','Color','b')
hold off

%% Export Line to CSV
[file,path] = uiputfile({'*.mat'},"Save Your Path CSV");
writematrix(smoothLine,[path,file])

% [file,path] = uiputfile({'*.csv'},"Save Your Path CSV");
% writematrix(track_inside,[path,file])
% [file,path] = uiputfile({'*.csv'},"Save Your Path CSV");
% writematrix(track_outside,[path,file])







%% Comp with other lines :)

function oldBounds()
    % plot 2021 track bounds
    innerBound = readmatrix("..\..\VEGAS\old\2021_final\Track_Inside.csv");
    outerBound = readmatrix("..\..\VEGAS\old\2021_final\Track_Outside.csv");
    hold on
    geoplot(innerBound(2:end,1),innerBound(2:end,2),'Color',"black",'LineWidth',1.5)
    geoplot(outerBound(2:end,1),outerBound(2:end,2),'Color',"black",'LineWidth',1.5)
    hold off
end

% function poliMoveQJ()
%     % plot polimove's smartnet inner line survey
%     addpath("polimoveQuickjackInner\")
%     poli1 = importLLH("20220927_inner_line_1.LLH");
%     poli2 = importLLH("20220927_inner_line_2.LLH");
%     poli3 = importLLH("20220927_inner_line_3.LLH");
%     hold on
%     geoplot(poli1.lat,poli1.lon,'Color',"black",'LineWidth',1.5)
%     geoplot(poli2.lat,poli2.lon,'Color',"black",'LineWidth',1.5)
%     geoplot(poli3.lat,poli3.lon,'Color',"black",'LineWidth',1.5)
%     hold off
% end

% function chaseInner()
%     % pull and plot the oct. 29th chase car inner bound surveys
%     % addpath("track_test_chase1\rosbag2_2022_10_29-16_16_53\")
%     addpath("track_test_chase1\oct_29_2022_1622_smartnet\")
%     % load("rosbag2_2022_10_29-16_16_53.mat")
%     % load("oct_29_2022_1622_smartnet.mat")
%     chaseLL = [cellfun(@(m) double(m.lat),novatel_chase.bestgnsspos),cellfun(@(m) double(m.lon),novatel_chase.bestgnsspos)];
%     hold on
%     geoplot(chaseLL(:,1),chaseLL(:,2),'Color',"magenta" ,'LineWidth',1.5)
%     hold off
% end

% function chaseOuter()
%     % pull and plot the nov 11 chase car outer bound survey
%     addpath("track_test_chase2\rosbag2_2022_11_01-10_43_42\")
%     load track_test_chase2\rosbag2_2022_11_01-10_43_42\rosbag2_2022_11_01-10_43_42_topics.mat
%     crop = 0.14305;
%     hold on
%     geoplot(nov_chase_lat(1:floor(crop*length(nov_chase_lat))),nov_chase_lon(1:floor(crop*length(nov_chase_lat))),'Color',"black" ,'LineWidth',1.5)
%     hold off
% end

% function newWalls()
%     innerWall = readmatrix("innerTrackBound.csv");
%     outerWall = readmatrix("outerTrackBound.csv");
%     hold on
%     geoplot(innerWall(:,1),innerWall(:,2),'Color',"black" ,'LineWidth',1.5)
%     geoplot(outerWall(:,1),outerWall(:,2),'Color',"black" ,'LineWidth',1.5)
%     hold off
% end

% function newRaceyBounds()
%     hold on
%     raceInner = readmatrix("innerRaceBound-tight_smartnet.csv");
%     raceOuter = readmatrix("outerRaceBound-tight_smartnet.csv");
%     geoplot(raceInner(:,1),raceInner(:,2),'Color',"magenta" ,'LineWidth',1.5)
%     geoplot(raceOuter(:,1),raceOuter(:,2),'Color',"magenta" ,'LineWidth',1.5)
%     hold off
% end

% function newerRaceyBounds()
%     hold on
%     raceInner = readmatrix("innerRaceBound-tight_R2-1_smartnet.csv");
%     raceOuter = readmatrix("outerRaceBound-tight_smartnet.csv");
%     geoplot(raceInner(:,1),raceInner(:,2),'Color',"magenta" ,'LineWidth',1.5)
%     geoplot(raceOuter(:,1),raceOuter(:,2),'Color',"magenta" ,'LineWidth',1.5)
%     hold off
% end

% function raceLines()
%     raceLineInner = readmatrix("innerRaceLine.csv");
%     raceLineInnerN = readmatrix("ATR_proposed-race-lines\innerRaceLine.csv");
%     raceLineInnerR2 = readmatrix("ATR_proposed-race-lines\innerRaceLine_R2.csv");
%     hold on
%     geoplot(raceLineInner(:,1),raceLineInner(:,2),'Color',"red" ,'LineWidth',5);
%     geoplot(raceLineInnerN(:,1),raceLineInnerN(:,2),'Color',"blue" ,'LineWidth',3);
%     geoplot(raceLineInnerR2(:,1),raceLineInnerR2(:,2),'Color',"yellow" ,'LineWidth',.75);
%     hold off
% end

% function runData()
%     load("11-03_run1.mat");
%     hold on
%     geoplot(nov_bot_lat,nov_bot_lon,'Color',"green" ,'LineWidth',1.2)
%     geoplot(nov_top_lat,nov_top_lon,'Color',"white" ,'LineWidth',1.2)
%     hold off
% end

function pitLine()
    pitMid = readmatrix("../../VEGAS/final/Pit_Mid.csv");
    pitMid = [pitMid(26:385,:);pitMid(441:926,:)];
    hold on
    geoplot(pitMid(:,1),pitMid(:,2),'Color',"yellow",'LineWidth',3)
    hold off
end

function nodes()
    hold on;
    refLLA = [36.2754184647035,-115.007297748316,0];
    nodesNED = readmatrix("../../VEGAS/final/GraphPoints_vis");
    nodesLLA = ned2lla([nodesNED,zeros(height(nodesNED),1)],refLLA,'flat');

    geoplot(nodesLLA(:,1),nodesLLA(:,2),LineStyle="none",Marker=".",MarkerSize=4,MarkerFaceColor='b');
    hold off;
end
