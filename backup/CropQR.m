function QR = CropQR (img, points)
   %u = [points(2,:)-points(4,:) 0];
   %v = [1 0 0];
   %c = cross(u,v);
   %angle = sign(c(3))*180/pi*atan2(norm(c),dot(u,v));
   %angle = -(mod(angle +360,360)-135);
   angle = atand((points(2,2)-points(4,2))/(points(2,1)-points(4,1)));
   angle = angle - 45;
   if points(4,1) < points(2,1)
     angle = angle + 180;
   end
   
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