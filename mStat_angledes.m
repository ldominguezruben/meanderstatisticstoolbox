function [angle]= mStat_angledes(equallySpacedX,equallySpacedY)

%This function found the angle variations of the resampled line 


for i=2:length(equallySpacedX)
angle(i)=atand((equallySpacedX(i)-equallySpacedX(i-1))/(equallySpacedY(i-1)-equallySpacedY(i)));
end

