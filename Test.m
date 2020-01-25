function [  ] = Test( Rimg )

    Rimg = imread('5.1.bmp');
    %Rimg = imrotate(Rimg,-32);
    img = rgb2gray(Rimg);
    img = ~im2bw(img);
    
    %Rotation loop
    
    %Dilation and erode part
    %se = [0 1 0; 1 1 1; 0 1 0];
    %img = imerode(img,se);
    %img = imdilate(img,ones(3,3));
    
    %labeling & prop.
    [L num] = bwlabel(img);
    RP = regionprops(L,'all');
    figure,imshow( L );
    
    for i = 1:num
        Ari = RP(i).Area;
        Boxi = RP(i).BoundingBox;
        Ceni = RP(i).Centroid;
        if Ari<0 || abs(Boxi(3)-Boxi(4))>4 || (Ari /((Boxi(3)-2)*(Boxi(4)-2))) < 0.99  ...
                 %|| Boxi(3)<10 || Boxi(4)<10
            L(L==i)=0;
            continue;
        end
        R = [ ];
        D = [ ];
        for j = 1:num
            Arj = RP(j).Area;
            Boxj = RP(j).BoundingBox;
            Cenj = RP(j).Centroid;
            if i==j || Arj<0 || abs(Boxj(3)-Boxj(4))>4 || (Arj /((Boxj(3)-2)*(Boxj(4)-2))) < 0.99  ...
                 %|| Boxj(3)<10 || Boxj(4)<10
                continue;
            end
            % on the Right
            if Cenj(1)-Ceni(1) > Boxi(3)*4 && abs(Cenj(2)-Ceni(2)) < Boxi(4)/2
                R = [R; j];
            end
            % down side
            if Cenj(2)-Ceni(2) > Boxi(4)*4 && abs(Cenj(1)-Ceni(1)) < Boxi(3)/2
                D = [D; j];
            end
            
        end
        [t1 x]=size(R);
        [t2 x]=size(D);
        if t1>0 && t2 >0
            a = pdist([Ceni ; RP(R(1)).Centroid],'euclidean');
            b = pdist([Ceni ; RP(D(1)).Centroid],'euclidean');
            c = pdist([RP(R(1)).Centroid ; RP(D(1)).Centroid],'euclidean');
            zz = abs((a*a + b*b)-(c*c))/(c*c)
            if zz < 0.02 
                [i t1 t2]
                %figure,imshow(Rimg); 
                hold on;
                rectangle('Position', RP(i).BoundingBox, ...
                'Linewidth', 3, 'EdgeColor', 'r');
                rectangle('Position', RP(R(1)).BoundingBox, ...
                    'Linewidth', 3, 'EdgeColor', 'r');
                rectangle('Position', RP(D(1)).BoundingBox, ...
                    'Linewidth', 3, 'EdgeColor', 'r');
            end
        end
    end
    
        
    
end

