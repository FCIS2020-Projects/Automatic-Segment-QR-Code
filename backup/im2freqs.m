function [ freq ] = im2freqs( img)
    col = numel(img);
    freq = [];
    co = [1 1 img(1)]; % [center counter color]
    for j = 2:col
        if co(3) ~= img(j)
            co(1) = co(1)+ uint32(co(2))/2;
            freq = [freq ; co];
            co = [j 1 img(j)];
        else
            co(2) = co(2) + 1;
        end
    end
    co(1) = co(1)+ uint32(co(2))/2;
    freq = [freq;co];
end


