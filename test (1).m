img = imread('5.3.bmp');
img = rgb2gray(img);
img = imsharpen(img,'Radius',20,'Amount',1);    
img = ~im2bw(img);
bwo = img;
%% ??????????????????
bw = imclearborder(bwo);
%% QR??????(Bounding Box)???
bw2 = imopen(bw, ones(5));
bw2 = imclose(bw2, ones(25));
bbox = regionprops(bw2, 'BoundingBox');
%% EulerNumber????????
bw = bwpropfilt(bw, 'EulerNumber', [0, 0]);
figure,imshow(bw);
%% ???
bwa = imfill(bw, 'holes');
%% ????????
stats = regionprops(bwa, 'Centroid');
Centroid = cat(1, stats.Centroid);
%% ???1:1:3:1:1???????(?????????)???
sz = size(Centroid,1);
flag = zeros(sz(1),1);
bwl = bwlabel(bwa);
bw2 = bw;
wsum = 0;
for i = 1:sz(1)
    roi = bwl == i;
    area = bwo;
    area(~roi) = 0;
    xy = round(Centroid(i,:));
    x = area(:, xy(1));
    
    pw = pulsewidth(double(x)); %????(??)
    ps = pulsesep(double(x)); %?????(??)
    
    % ??3,??2??????????????????Break
    flagout = ~(size(ps, 1) == 2 && size(pw, 1) == 3);
    if flagout == 1
        bw2(bwl == i) = 0;
    else
        % 1???????????????1:1:3:1:1??????????
        width = sum([pw;ps]) / 7;
        pat = [pw(1), ps(2), pw(2), ps(2), pw(3)] / width;
        if pdist2(pat, [1 1 3 1 1]) < 0.6
            flag(i) = 1;
        else
            bw2(bwl == i) = 0;
        end
        wsum = wsum + width;
    end
end
wsum = wsum/sz(1);