function [ Fimg ] = bwFix( img )
  [row col]=size(img);
  Fimg = img;
  for i = 2:row-1
    for j = 2:col-1
      co = uint8(img(i-1,j))+uint8(img(i+1,j))+...
           uint8(img(i,j-1))+uint8(img(i,j+1));
      if img(i,j) == 1 && co < 2
        Fimg(i,j)=0;
      end
    end
  end
  
end
