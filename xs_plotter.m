%nicely plots repeat cross section surveys. Must fit a plane to surveyed cross sections in Cloud Compare or
% fit a plane yourself prior to using this script.
% Works for XS that are really long and don't compare well if plotted where x axis is distance from point
%to point. For questions about input file format, contact danny white.
%danny.white@colostate.edu

clear all



planes = readmatrix('XS Planes Normal Origin Shift.xlsx');

yzplane = [0,1,0];

for i = 1
    
    myFiles = dir('**/*.txt');
    figure(i)
   
    for j = 1:length(myFiles)
        data = readmatrix(myFiles(j).name); 
        
        xprime = [];
        yprime = [];
        v = [];
        projpoints = [];
        angle = [];
        stakez = 2437.26;

        

        data(:,1) = data(:,1) + planes(7,i+1); %perform cloud compare shift
        data(:,2) = data(:,2) + planes(8,i+1); %perform cloud compare shift
        stakei = find(data(:,1)==min(data(:,1))); %returns index of farthest west survey point
        data(:,3) = data(:,3) + stakez - data(stakei,3); 
        v = [data(:,1)-planes(4,i+1),data(:,2)-planes(5,i+1),data(:,3)-planes(6,i+1)];
        dist = v(:,1)*planes(1,i+1)+v(:,2)*planes(2,i+1)+v(:,3)*planes(3,i+1);
        projpoints = [data(:,1)-dist.*planes(1,i+1),data(:,2)-dist.*planes(2,i+1),data(:,3)-dist.*planes(3,i+1)];
        angle = acosd(yzplane(1)*planes(1,i+1)+yzplane(2)*planes(2,i+1)+yzplane(3)*planes(3,i+1));
        projpoints(:,1) = projpoints(:,1) - min(projpoints(:,1));
        projpoints(:,2) = projpoints(:,2) - max(projpoints(:,2));
        xprime(:,1) = projpoints(:,1)*cosd(angle) - projpoints(:,2)*sind(angle);
        yprime(:,2) = projpoints(:,1)*sind(angle) + projpoints(:,2)*cosd(angle);
        cm = colormap(flipud(copper(size(myFiles,1))));
        plot(xprime,projpoints(:,3),'Color',cm(j,:))
        hold on




                
    end
legend('11/17/2020','05/14/2021','07/09/2021','08/05/2021','10/17/2021','Location','eastoutside')
xlabel('Station (m)')
ylabel('Elevation (m)')




end
