function QR = CropQR (img, points)
   angle = atand((points(2,2)-points(4,2))/(points(2,1)-points(4,1)));
   if points(4,1) < points(2,1)
     angle = angle + 180;
   end
   angle = angle - 45;
   
   [h ,w ,~] = size(img);
   QR = imrotate(img, angle);
   [rh ,rw ,~] = size(QR);
   T=[w/2 h/2];
   RT=[rw/2 rh/2];
   R=[cosd(angle) -sind(angle); sind(angle) cosd(angle)];
   
   T = [T;T;T;T];
   RT = [RT;RT;RT;RT];
   rotpoints=(points-T)*R+RT ;
   
   rotpoints=uint32(rotpoints);
   xymax = max(rotpoints);
   xymin = min(rotpoints);
   QR = QR(xymin(2):xymax(2), xymin(1):xymax(1), :);
end