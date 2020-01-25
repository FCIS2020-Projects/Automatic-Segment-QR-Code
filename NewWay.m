function [  ] = NewWay( Rimg )
    Rimg = imread('7.1.bmp');
    img = rgb2gray(Rimg);
    
    %sharppining the image
    img = imsharpen(img,'Radius',10,'Amount',1);    
    img = ~im2bw(img,0.7);
    
    [row col] = size(img);
    [L num] = bwlabel(img);
    RP = regionprops(L,'all');
    hit = [];
    for i = 1:row
        freq = [];
        co = [1 1 img(i,1)]; % [center counter color]
        for j = 2:col
            if co(3) ~= img(i,j)
                co(1) = co(1)+ uint32(co(2))/2;
                freq = [freq ; co];
                co = [j 1 img(i,j)];
            else
                co(2) = co(2) + 1;
            end
        end
        co(1) = co(1)+ uint32(co(2))/2;
        freq = [freq;co];
        %
        [num x] = size(freq);
        for j = 3:num-2
            Error = 0.5;
            if freq(j,3)==0
                continue;
            elseif abs((freq(j,2)/3)-freq(j-2,2)) > (freq(j,2)/3)*Error || ...
                   abs((freq(j,2)/3)-freq(j-1,2)) > (freq(j,2)/3)*Error || ...
                   abs((freq(j,2)/3)-freq(j+1,2)) > (freq(j,2)/3)*Error || ...
                   abs((freq(j,2)/3)-freq(j+2,2)) > (freq(j,2)/3)*Error
               continue;
            end
            %x = freq(j,1) , y = i
            % cheack before adding the same width
            Box = RP( L(i,freq(j,1)) ).BoundingBox;
            Ar = RP( L(i,freq(j,1)) ).Area;
            if abs(Box(3)-Box(4))<15 && (Ar >15) && ...
                    (Ar /min(1,(Box(3)-2)*(Box(4)-2))) > 0.99
                hit = [hit; L(i,freq(j,1))];
                j = j+2;
            end
        end
    end
    
    
    hit = [unique(hit) histc(hit,unique(hit))]
    figure,imshow(Rimg ); 
    hold on;
%     for i = 1:(numel(hit)/2)
%         if hit(i,2) >1 
%         
%         rectangle('Position', RP(hit(i,1)).BoundingBox, ...
%         'Linewidth', 3, 'EdgeColor', 'r');
%         end
%     end
    flag = zeros((numel(hit)/2));
    for i = 1:(numel(hit)/2)
        if flag(i)==1
            continue;
        end
        ci = RP(hit(i,1)).Centroid;
         for j = 1:(numel(hit)/2)
             cj = RP(hit(j,1)).Centroid;
             if flag(j)==1 || i==j 
                continue;
             end
             
             for k = 1:(numel(hit)/2)
                ck = RP(hit(k,1)).Centroid;
                if i == k || j == k || flag(k)==1 
                     continue;
                end
                
                a = pdist([ci ; cj],'euclidean');
                b = pdist([ci ; ck],'euclidean');
                c = pdist([cj ; ck],'euclidean');
                diff = cj - ci;
                d = ck+diff;
                zz = abs((a*a + b*b)-(c*c))/(c*c);
                center = ((cj+ci+ck+d)/4);
                if zz < 0.05 && (abs(a-b)/max(a,b))<0.1
                    x = [cj(1);ci(1);ck(1);d(1)];
                    y = [cj(2);ci(2);ck(2);d(2)];
                    
                    x = x+(x-center(1))*0.5;
                    y = y+(y-center(2))*0.5;
                    flag(i)=1;flag(j)=1;flag(k)=1;
                    figure,imshow(CropQR( Rimg , [x y]));
                    break;              
                end
        
             end
         end
    end
        
     
        
        
        
    %x = [113;226;66;12;113]
    %y = [104;80;17;22;104]
    
    %plot(x,y,'Linewidth', 3,'Color','r');
    
            
           
        
end

