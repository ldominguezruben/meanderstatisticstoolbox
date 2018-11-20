%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Caclculo de tranporte de fondo (dune tracking)
%Dominguez Ruben L. UNL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% F=importdata('\\Hfluvial-08\d\HF_docs\Dominguez\Files\Rivers\Colastine\Campana 2016\Dunetracking\files\fromWinRiver\lat_lon_dist_prof_032_ASC.txt');
% 
% 
% F1=importdata('\\Hfluvial-08\d\HF_docs\Dominguez\Files\Rivers\Colastine\Campana 2016\Dunetracking\files\fromWinRiver\lat_lon_dist_prof_040_ASC.txt');
% 

%filtro los datos malos
n=1;

while 1
    if F(n,4)==-32768
       F(n,:)=[];
    end
    n=n+1;
    if n>size(F,1)
        break;
    end
end

n=1;

while 1
    if F1(n,4)==-32768
       F1(n,:)=[];
    end
    n=n+1;
    if n>size(F1,1)
        break;
    end
end

%Transforma deg2UTM
[x1,y1,~] = deg2utm(F(:,1),F(:,2));

%Transforma deg2UTM
[x2,y2,~] = deg2utm(F1(:,1),F1(:,2));


%limites
xliminf=x2(1,1);
xlimsup=x2(end-1,1);

%%
%calculate
%acomodo los puntos en una matriz
depth1=F(:,4);
depth2=F1(:,4);

MD1=[x1 y1 depth1];%cell2mat(dbfData);
MD2=[x2 y2 depth2];%cell2mat(dbfData1);

%Elimina puntos que estan fuera de las lineas entre puntos
MD1(MD1(:,1)<xliminf,:)=[];
MD2(MD2(:,1)<xliminf,:)=[];
MD1(MD1(:,1)>xlimsup,:)=[];
MD2(MD2(:,1)>xlimsup,:)=[];

%linea de ajuste 1
m=150;%size(MD1,1)+1;%numerode puntos
xx1=linspace(xliminf,xlimsup,m);

%Unimos los puntos y ajustamos a la nube de puntos a una funcion cuadratica
xx=vertcat(MD1(:,1),MD2(:,1));
yy=vertcat(MD1(:,2),MD2(:,2));
p = polyfit(xx,yy,4);
yy1 = polyval(p,xx1);

%linea de ajuste 2
m=150;%size(MD2,1);%numerode puntos
xx2=linspace(xliminf,xlimsup,m);

%Unimos los puntos y ajustamos a la nube de puntos a una funcion cuadratica
xx=vertcat(MD1(:,1),MD2(:,1));
yy=vertcat(MD1(:,2),MD2(:,2));
p = polyfit(xx,yy,4);
yy2 = polyval(p,xx2);

clear MD1
MD1(:,1)=xx1';
MD1(:,2)=yy1';


%%
%Define normal lines
%line1
for i=1:size(MD1,1)-1
    startpoint(i,:)=[MD1(i,1) MD1(i,2)];
    endpoint(i,:)=[MD1(i+1,1) MD1(i+1,2)];
    v(i,:)=endpoint(i,:)-startpoint(i,:);
    v(i,:)=100*v(i,:)/norm(v(i,:));
    xstart_line1(i,1)=MD1(i,1)+v(i,2);
    xend_line1(i,1)=MD1(i+1,1)-v(i,2);
    ystart_line1(i,1)=MD1(i,2)-v(i,1);
    yend_line1(i,1)=MD1(i+1,2)+v(i,1);
end

clear startpoint endpoint v MD2

MD2(:,1)=xx2';
MD2(:,2)=yy2';

%line2
for i=1:size(MD2,1)-1
    startpoint(i,:)=[MD2(i,1) MD2(i,2)];
    endpoint(i,:)=[MD2(i+1,1) MD2(i+1,2)];
    v(i,:)=endpoint(i,:)-startpoint(i,:);
    v(i,:)=100*v(i,:)/norm(v(i,:));
    xstart_line2(i,1)=MD2(i,1)+v(i,2);
    xend_line2(i,1)=MD2(i+1,1)-v(i,2);
    ystart_line2(i,1)=MD2(i,2)-v(i,1);
    yend_line2(i,1)=MD2(i+1,2)+v(i,1);
end



robust=0;
%Calcula la iterseccion

 xx1=x1;
 yy1=y1;
%interseccion con linea 1
for i=1:size(MD1,1)-2
    if isnan(xstart_line1(i,1)) | isnan(xend_line1(i,1)) | isnan(ystart_line1(i,1)) | isnan(yend_line1(i,1)) 
        xline1_int(:,i)=nan;
        yline1_int(:,i)=nan;
    else
        X11(:,i)=[xstart_line1(i,1);xend_line1(i,1)];
        Y22(:,i)=[ystart_line1(i,1);yend_line1(i,1)];
    [xline1_int(1,i),yline1_int(1,i),~,~] = intersections(X11(:,i),Y22(:,i),xx1,yy1,robust);
    %hold on
    %plot(xline1_int(1,i),yline1_int(1,i),'or')
    end
end

clear X11 Y22
xx2=x2;
yy2=y2;

% % %comprueba la normalidad e interseccion
% figure(2)
% for i=1:size(MD1,1)-1
%   line([xstart_line1(i), xend_line1(i)],[ystart_line1(i), yend_line1(i)]);
% end
% hold on
% plot(xx1,yy1,'-k','Linewidth',1)
% plot(xx2,yy2,'-m','Linewidth',1)
% plot(xline1_int,yline1_int,'or')
% plot(MD1(:,1),MD1(:,2),'-r')
% axis equal



%interseccion con linea 2
xx2=x2;
yy2=y2;
 
%[xline2_int,yline2_int,~,~] = intersections(line2(:,1),line2(:,2),xx2,yy2,robust);
for i=1:size(MD2,1)-2
    if isnan(xstart_line2(i,1)) | isnan(xend_line2(i,1)) | isnan(ystart_line2(i,1)) | isnan(yend_line2(i,1)) 
        xline2_int(:,i)=nan;
        yline2_int(:,i)=nan;
    else
        X11(:,i)=[xstart_line2(i,1);xend_line2(i,1)];%crea las lineas una por una. Puntos X
        Y22(:,i)=[ystart_line2(i,1);yend_line2(i,1)];%crea las lineas una por una. Puntos Y
%         line(X11,Y22)
%         hold on
%         plot(x1,y1,'-r')
%         plot(x2,y2,'-k')
%         axis equal
    [xline2_int(1,i),yline2_int(1,i),~,~] = intersections(X11(:,i),Y22(:,i),xx2,yy2,robust);
%     if isempty(xline2_int(1,i))
%         xline2_int(1,i)=nan;
%         yline2_int(1,i)=nan;
%     end
    %hold on
    end
end


%comprueba la normalidad e interseccion
figure(2)
for i=1:size(MD2,1)-1
  line([xstart_line2(i), xend_line2(i)],[ystart_line2(i), yend_line2(i)]);
end
hold on
plot(x1,y1,'-k','Linewidth',1)
plot(x2,y2,'-m','Linewidth',1)
plot(xline1_int,yline1_int,'or')
plot(xline2_int,yline2_int,'or')
plot(MD2(:,1),MD2(:,2),'-r')
axis equal


%%
%calculo de distancia
%linea 1

for i=1:size(MD1,1)-3
     distline1(1,i)=((xline1_int(1,i+1)-xline1_int(1,i+1))^2+(yline1_int(1,i+1)-yline1_int(1,i))^2)^0.5;
end


q = isnan(distline1) ; % find all NaNs
distline1(q) = 0 ; % treat NaNs as zero
DistanciaAcul1= cumsum(distline1) ;
DistanciaAcul1(q) = NaN ; % set NaN entries in x to NaN in the result

%linea 2
% 

for i=1:size(MD2,1)-3
    distline2(1,i)=((xline2_int(1,i)-xx2(1,1))^2+(yline2_int(1,i+1)-yy2(1,1))^2)^0.5;
end


%eliminan los nan
q = isnan(distline2) ; % find all NaNs
distline2(q) = 0 ; % treat NaNs as zero
DistanciaAcul2= cumsum(distline2) ;
DistanciaAcul2(q) = NaN ; % set NaN entries in x to NaN in the result


%%
%Calculo de profundidad
%distancia lineas 1
s=DistanciaAcul2'-DistanciaAcul1';
meadi=nanmean([distline1 distline2]);

%%
%vector final
 Proy_lin1=[DistanciaAcul1' MD1(1:end-3,3)];
 Proy_lin2=[DistanciaAcul2' MD2(1:end-2,3)];
 
 
% 
 figure(1)
 plot(Proy_lin1(:,1),Proy_lin1(:,2),'-r')
 %plot(F(:,3),F(:,4),'-r')
  hold on
 plot(Proy_lin2(:,1),Proy_lin2(:,2),'-b')
 %plot(F1(:,3),F1(:,4),'-k')
 set(gca,'yDir','reverse')
 legend('Recorrida 1','Recorrido 2')
 xlabel('Distancia [m]');ylabel('Altura [m]')
