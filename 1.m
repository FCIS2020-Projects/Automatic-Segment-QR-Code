function [ AnsList ] = SquareCounter( img )
    img = imread('6.2.bmp');
    img = rgb2gray(img);
    img = ~im2bw(img);
    
    %figure,imshow(img)
    [L num] = bwlabel(img);
    %figure,imshow(label2rgb(L))
    RP = regionprops(L,'all');
    [Sx Sy] = size(RP);
    error = zeros(Sx,4);
    error(:,1:2)=100000000
    AnsList = [];
    for i = 1:num
        if RP(i).Area<25 || abs(RP(i).BoundingBox(3)-RP(i).BoundingBox(4))>2
            L(L==i)=0;
            continue;
        end
        %figure,imshow(label2rgb(L));
        %figure,imshow((L==i).*i);
        for j = 1:num
            if i==j || RP(j).Area<25 || abs(RP(j).BoundingBox(3)-RP(i).BoundingBox(3))>2
                continue
            end
            temp = abs(RP(i).Area-RP(j).Area);
            if temp <= error(i,1)
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
    size(AnsList)
    
%     for i = 1:num
%         if i == AnsList(i,2) || i == AnsList(i,3) || i == AnsList(i,4)
%             xColor = (AnsList(i,2)+AnsList(i,3)+AnsList(i,4))/3;
%             L(L==xColor)=-i;
%             L(L==i) =xColor;
%             L(L==xColor)=i;
%         end
%     end
%     figure,imshow(label2rgb(L));
%     L = (L==50).*50;
%     RP(Ans(2))
%     RP(Ans(3))
%     RP(Ans(4))
%     RP( Ans(2) ).Centroid(1:2)
    figure,imshow(label2rgb(L));
    
    
end
