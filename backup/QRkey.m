function [ hit ] = QRkey( img,L,RP )
    hit=[];
    [row ~] = size(img);
    for i = 1:row
        freq = im2freqs(img(i,:));
        [num ~] = size(freq);
        for j = 3:num-3
            Error = 0.5;
            if abs((freq(j,2)/3)-freq(j-2,2)) > ceil((freq(j,2)/3)*Error)+1 || ...
                   abs((freq(j,2)/3)-freq(j-1,2)) > ceil((freq(j,2)/3)*Error)+1 || ...
                   abs((freq(j,2)/3)-freq(j+1,2)) > ceil((freq(j,2)/3)*Error)+1 || ...
                   abs((freq(j,2)/3)-freq(j+2,2)) > ceil((freq(j,2)/3)*Error)+1 || ...
                   freq(j,3)==0 || L(i,freq(j,1))==0 || L(i,freq(j+2,1))==0 || L(i,freq(j-2,1))==0
               continue;
            end
            %x = freq(j,1) , y = i
            Box = RP( L(i,freq(j,1)) ).BoundingBox;
            Cdif = uint32(sum(abs(RP(L(i,freq(j+2,1))).Centroid - RP(L(i,freq(j,1))).Centroid)));
            Ar = RP( L(i,freq(j,1)) ).Area;
            
            if  Cdif <= 5 && ...
            (Ar /min(1,(Box(3)-2)*(Box(4)-2))) > 0.99 && ...
            L(i,freq(j-2,1))==L(i,freq(j+2,1)) && L(i,freq(j-2,1))~=L(i,freq(j,1))
                hit = [hit; L(i,freq(j,1))];
                j = j+2;
            end
        end
    end

end

