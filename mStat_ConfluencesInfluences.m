function [Conf]=mStat_ConfluencesInfluences(geovar)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Function to define influences of tributaries
%by Dominguez Ruben UNL, Argentina.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%Determinate el punto mas cercano entre el tributario y el principal

x=geovar{1}.equallySpacedX;%
y=geovar{1}.equallySpacedY;%


for t=2:length(geovar)

    %%Find interesection
    robust=0;
    [Conf.XINT{t},Conf.YINT{t},Conf.IOUT{t},Conf.JOUT{t}] =...
        intersections(geovar{1}.equallySpacedX,geovar{1}.equallySpacedY,geovar{t}.equallySpacedX,geovar{t}.equallySpacedY,robust);
    
    if isnan(Conf.XINT{t})%Find the point closest
        
        Aini{t}=[geovar{t}.equallySpacedX(1) geovar{t}.equallySpacedY(1)];
        Aend{t}=[geovar{t}.equallySpacedX(end) geovar{t}.equallySpacedY(end)];

        B=[x y];
                
%         T=10;
        
%         k = dsearchn(B,T,A{t})
        
        %compute Euclidean distances:
        distancesini{t} = sqrt(sum(bsxfun(@minus, B, Aini{t}).^2,2));
        %find the smallest distance and use that as an index into B:
        closestini{t} = find(distancesini{t}==min(distancesini{t}));
        
        %compute Euclidean distances:
        distancesend{t} = sqrt(sum(bsxfun(@minus, B, Aend{t}).^2,2));
        %find the smallest distance and use that as an index into B:
        closestend{t} = find(distancesend{t}==min(distancesend{t}));


        if min(distancesini{t})<min(distancesend{t})
           Conf.indexinter{t}=closestini{t};
        else
             Conf.indexinter{t}=closestend{t};
        end


        Conf.XINT{t}=geovar{1}.equallySpacedX(Conf.indexinter{t},1);
        Conf.YINT{t}=geovar{1}.equallySpacedY(Conf.indexinter{t},1);
    else
       [~,Conf.indexinter{t}]=min(abs(x-Conf.XINT{t}));
    end 

end


%%
% Evaluate arc-wavelength
% Define limits
FileBed_dataMX = geovar{1}.sResample(:,1); 
FileBed_dataMZ = geovar{1}.cResample(:,1); 
xmin=min(FileBed_dataMX);     
DeltaCentS=FileBed_dataMX(2,1)-FileBed_dataMX(1,1);  %units. 
dt=1;
sst=transpose(FileBed_dataMZ);
variance = nanstd(sst)^2;
sst = (sst - nanmean(sst))/sqrt(variance) ;

% Computation of the Lag1 coefficient for the Red Noise Power Spectrum Eq. 16        
Abscise = [1:length(sst)]*dt + xmin ;  % construct Abscise array

%Intersection
for t=2:length(geovar)
Conf.Xgraph(t)=Abscise(1,Conf.indexinter{t})*DeltaCentS;
end
    
%%
%Read data of WaveletCenterline
T3 = getappdata(0, 'T3');

%Sort areas ascendet line
for w=1:length(T3.Ar)
    [Tw(w)]=nanmin(T3.X_Y{w}(1,:));
end

E=sort(Tw,2);

for w=1:length(T3.Ar)
    for q=1:length(T3.Ar)
        if E(w)==nanmin(T3.X_Y{q}(1,:));
            T3.X_Yorder{w}=T3.X_Y{q}(:,:);
            T3.Arorder(w)=T3.Ar(q);
            break
        end
    end
%     figure(3)
%     hold on
%     plot(T3.X_Yorder{w}(1,:),T3.X_Yorder{w}(2,:),'-k')
end


%Find close number
for t=2:length(geovar)
for u=1:length(T3.Ar)
    [~,T.pos(t)]=min(abs(Conf.Xgraph(t)-T3.X_Yorder{u}(1,:)));
    T.u(t)=u;
    break
end
end

T.pos(t+1)=length(T3.Ar);

%%
%Average the rest of areas
e=1;
l=1;
for t=2:length(geovar)+1
    if t==2
    for u=1:2: T.pos(t)-1
        Conf.BeforeAveArea{t}(e)=nanmean(T3.Arorder(u:u+1));
        e=e+1;
    end
    clear u
    else
    for u= T.pos(t-1):2: T.pos(t)
        Conf.AfterAveArea{t}(l)=nanmean(T3.Arorder(u:u+1));
        l=l+1;
    end
    clear u
    end
end

% %Average areas
% m=1;
% for t=3:length(T.pos)
%     if t==3
%         Conf.Aveareas(1)=nanmean(T3.Arorder(1:T.pos(t)-1));
%     else
%         Conf.Aveareas(m)=nanmean(Conf.AfterAveArea{t});
%     end
% end

%%
%Compare both areas if the differences is more than 20% detect
%difference and determinate the R (Parameter of time to adecuation of River)
%Only with areas after the confluences

coef=1.2;%20%

%re-validate this code
for t=3:length(T.pos)
    for q=2:length(Conf.AfterAveArea{t})
        if Conf.AfterAveArea{t}(q)<coef*(Conf.AfterAveArea{t}(q-1)) | Conf.AfterAveArea{t}(q)>coef*(Conf.AfterAveArea{t}(q-1))
            break 
        end
    end
    Break(t)=e*2+q+1;
end

%%
%Define distance that change the bifurcation downstream

for t=3:length(T.pos)
    X_Y_Change(t)=nanmin(T3.X_Yorder{Break(t)}(1,:));
end

XIntrinsec=Abscise*DeltaCentS;

m=1;
for t=3:length(T.pos)
    [~,positionIntrinsec(t)]=min(abs(X_Y_Change(t)-XIntrinsec));
    
    Conf.Rintrinsec(m)=Abscise(positionIntrinsec(t))*DeltaCentS;  
    
    Conf.X_Ypoint(t,:)=[geovar{1}.equallySpacedX(positionIntrinsec(t),1) geovar{1}.equallySpacedY(positionIntrinsec(t),1)];
    
    Conf.R(m)=((geovar{1}.equallySpacedX(positionIntrinsec(t),1)-Conf.XINT{t-1})^2+(geovar{1}.equallySpacedY(positionIntrinsec(t),1)-Conf.YINT{t-1})^2)^0.5;
    m=m+1;
end

