function [  ] = SquareCounter( Rimg )
    Rimg = imread('4.1.bmp');
    Rimg = imrotate(Rimg,-35);
    img = rgb2gray(Rimg);
    img = ~im2bw(img);
    %figure,imshow(img)
    %Dilation and erode part
    se = [0 1 0; 1 1 1; 0 1 0];
    img = imerode(img,se);
    img = imdilate(img,ones(3,3));
    figure,imshow(img);
    
    
    [L num] = bwlabel(img);
    figure,imshow(label2rgb(L))
    RP = regionprops(L,'all');
    [Sx Sy] = size(RP);
    error = zeros(Sx,4);
    error(:,1:2)=100000000;
    AnsList = [];
    for i = 1:num
        Ar = RP(i).Area;
        Box = RP(i).BoundingBox;
        if Ar<25 || abs(Box(3)-Box(4))>2 || (Ar /((Box(3)-2)*(Box(4)-2))) < 0.99 || ((Box(3)-2)*(Box(4)-2))<4
            L(L==i)=0;
            continue;
        end
        %figure,imshow(label2rgb(L));
        %figure,imshow((L==i).*i);
        for j = 1:num
            if i==j || RP(j).Area<25 || abs(RP(j).BoundingBox(3)-RP(i).BoundingBox(3))>2
                continue
            end
            BoxJ = RP(i).BoundingBox;
            temp = abs(RP(i).Area-RP(j).Area);
            if temp <= error(i,1)
                %if Rp(i).cent - Rp(j).cent  == Rp(i).cent - error(
                error(i,2)=error(i,1);
                error(i,4)=error(i,3);
                error(i,1)=temp;
                error(i,3)=j;
            elseif temp <= error(i,2)
                error(i,2)=temp;
                error(i,4)=j;
            end
        end
        
        if i==0 || error(i,3)==0|| error(i,4)==0
            continue;
        end
        AnsList = [AnsList; [error(i,1)+error(i,2) i error(i,3) error(i,4)]];
        temp = uint32((i + error(i,3) + error(i,4))/3);
        %L(L==i)=temp;
        L(L==error(i,3))=i;
        L(L==error(i,4))=i;
    end
    SS = AnsList(1);
    [siz x] = size(AnsList);
    for i = 1:siz
        if SS(1)>AnsList(i,1)
            SS = AnsList(i,:);
        end
    end
    SS
    RP(1)
    figure,imshow(label2rgb(L)); 
    hold on;
    for i = 1:numel(RP)
        Ar = RP(i).Area;
        Box = RP(i).BoundingBox;
        if Ar<25 || abs(Box(3)-Box(4))>2 || (Ar /((Box(3)-2)*(Box(4)-2))) < 0.99 || ((Box(3)-2)*(Box(4)-2))<4
            L(L==i)=0;
            continue;
        end
        rectangle('Position', RP(i).BoundingBox, ...
        'Linewidth', 3, 'EdgeColor', 'r');
    end
    
%     L(L==SS(3))=SS(2);
%     L(L==SS(4))=SS(2);
%     L = (L==SS(2)).*1;
%     figure,imshow(L); 
    
end
