function [  ] = QRextraction( Rimg )
    Rimg = imread('4.4.bmp');
    img = rgb2gray(Rimg);
    
    %sharppining the image
    
    img = imsharpen(img,'Radius',10,'Amount',1);    
    img = ~im2bw(img,0.5);
    
    [L num] = bwlabel(img);
    RP = regionprops(L,'all');
    hit = QRkey(img,L,RP);
    hit = [unique(hit) histc(hit,unique(hit))]
     
    figure,imshow(L ); 
    
    flag = zeros((numel(hit)/2));
    for i = 1:(numel(hit)/2)-1
        if flag(i)==1
            continue;
        end
        ci = RP(hit(i,1)).Centroid;
        j = i+1;
        if flag(j)==1
            continue;
        end
        cj = RP(hit(j,1)).Centroid;
        for k = 1:(numel(hit)/2)
            if i == k || j == k || flag(k)==1 
                continue;
            end
            ck = RP(hit(k,1)).Centroid;
            %start
            a = pdist([ci ; cj],'euclidean');
            b = pdist([ci ; ck],'euclidean');
            c = pdist([cj ; ck],'euclidean');
            diff = cj - ci;
            if c<a || c<b
                continue;
            end
            d = ck+diff;
            zz = abs((a*a + b*b)-(c*c))/(c*c)
            center = ((cj+ci+ck+d)/4);
            if zz < 0.1 
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
        
        
    %x = [113;226;66;12;113]
    %y = [104;80;17;22;104]
    
    %plot(x,y,'Linewidth', 3,'Color','r');
    
            
           
        
end

