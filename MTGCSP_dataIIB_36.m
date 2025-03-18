[s, HDR] = sload('BCICIV_2b_gdf/B0203T.gdf');
bandcount=17;
dataset_information=HDR;
dataset_signal=s;
N=size(dataset_information.TRIG,1);
data_x=cell(N,1);
multiscale_x=cell(N,bandcount);
data_y=dataset_information.Classlabel;
i=1;

%������ȡ
    for j=1:size(dataset_information.EVENT.POS,1)
        if dataset_information.EVENT.TYP(j)==768
            temp=dataset_signal(dataset_information.EVENT.POS(j)+751:dataset_information.EVENT.POS(j)+1750,1:3)';
            me=mean(temp(1,:));
            temp(isnan(temp)) = me;
            data_x{i}=temp;
            i=i+1;
        end
    end

%decenter
fc = 250;          %����Ƶ��250Hz
point = 1000;           %��������500
n = 0:point-1;          
f = n*fc/point; 
band_number=1;
for band=2:18       
%��һ���˲�

Wn = [band*2*2 (band*2+4)*2]/fc;%����ͨ��Ϊ0.5-50Hz
[k,l] = butter(2,Wn);%4��IIR�˲���
%decenter

for i=1:N
    for j=1:3
multiscale_x{i,band_number}(j,:) = filtfilt(k,l,data_x{i}(j,:));
    end
end
band_number=band_number+1;
end



ind1=(data_y==1);
ind2=(data_y==2);
ind=logical(ind1+ind2);
multiscale_x=multiscale_x(ind,:);
data_y=data_y(ind);
for i=1:size(data_y,1)
if data_y(i)==1
    data_y(i)=1;
elseif data_y(i)==2
    data_y(i)=-1;
end

end

N=size(data_y,1);


number_of_all_timewindow=36;

group_data_x=cell(number_of_all_timewindow,N,bandcount);

now_window=1;
   for j=1:N
        for k=1:bandcount
            group_data_x{1,j,k}=multiscale_x{j,k}(:,1:125);
            group_data_x{2,j,k}=multiscale_x{j,k}(:,126:250);
            group_data_x{3,j,k}=multiscale_x{j,k}(:,251:375);
            group_data_x{4,j,k}=multiscale_x{j,k}(:,376:500);
            group_data_x{5,j,k}=multiscale_x{j,k}(:,501:625);
            group_data_x{6,j,k}=multiscale_x{j,k}(:,626:750);
            group_data_x{7,j,k}=multiscale_x{j,k}(:,751:875);
            group_data_x{8,j,k}=multiscale_x{j,k}(:,875:1000);
        end
   end


    for j=1:N
        for k=1:bandcount
            group_data_x{9,j,k}=multiscale_x{j,k}(:,1:250);
            group_data_x{10,j,k}=multiscale_x{j,k}(:,126:375);
            group_data_x{11,j,k}=multiscale_x{j,k}(:,251:500);
             group_data_x{12,j,k}=multiscale_x{j,k}(:,376:625);
            group_data_x{13,j,k}=multiscale_x{j,k}(:,501:750);
            group_data_x{14,j,k}=multiscale_x{j,k}(:,626:875);
            group_data_x{15,j,k}=multiscale_x{j,k}(:,751:1000);
        end
    end
    for j=1:N
        for k=1:bandcount
            group_data_x{16,j,k}=multiscale_x{j,k}(:,1:375);
            group_data_x{17,j,k}=multiscale_x{j,k}(:,126:500);
            group_data_x{18,j,k}=multiscale_x{j,k}(:,251:625);
            group_data_x{19,j,k}=multiscale_x{j,k}(:,376:750);
            group_data_x{20,j,k}=multiscale_x{j,k}(:,501:875);
            group_data_x{21,j,k}=multiscale_x{j,k}(:,626:1000);
         
        end
    end
    for j=1:N
        for k=1:bandcount
            group_data_x{22,j,k}=multiscale_x{j,k}(:,1:500);
            group_data_x{23,j,k}=multiscale_x{j,k}(:,126:625);
            group_data_x{24,j,k}=multiscale_x{j,k}(:,251:750);
             group_data_x{25,j,k}=multiscale_x{j,k}(:,376:875);
            group_data_x{26,j,k}=multiscale_x{j,k}(:,501:1000);
    
        end
    end
    for j=1:N
        for k=1:bandcount
             group_data_x{27,j,k}=multiscale_x{j,k}(:,1:625);
            group_data_x{28,j,k}=multiscale_x{j,k}(:,126:750);
            group_data_x{29,j,k}=multiscale_x{j,k}(:,251:875);
             group_data_x{30,j,k}=multiscale_x{j,k}(:,376:1000);
            
            
    
        end
    end
    for j=1:N
        for k=1:bandcount
               group_data_x{31,j,k}=multiscale_x{j,k}(:,1:750);
            group_data_x{32,j,k}=multiscale_x{j,k}(:,126:875);
            group_data_x{33,j,k}=multiscale_x{j,k}(:,251:1000);

    
        end
    end
     for j=1:N
        for k=1:bandcount
               group_data_x{34,j,k}=multiscale_x{j,k}(:,1:875);
            group_data_x{35,j,k}=multiscale_x{j,k}(:,126:1000);
           

    
        end
     end
     for j=1:N
        for k=1:bandcount
               group_data_x{36,j,k}=multiscale_x{j,k}(:,1:1000);
          

    
        end
    end



N=size(data_y,1);

for window=1:number_of_all_timewindow
for k=1:bandcount
for i=1:N
    for j=1:3
    group_data_x{window,i,k}(j,:)= group_data_x{window,i,k}(j,:) - mean(group_data_x{window,i,k}(j,:));
    end
end
end
end
