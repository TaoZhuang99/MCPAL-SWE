p1 = Point3D(0,0,0);
p1.Print;
p2 = Point3D(1,2,3);
p1.Translate(p2);
p1.Print;
p1.Translate(p2);
p1.Print;

R = [0, -1, 0; 1, 0, 0; 0, 0, 1];
p1 = Point3D(1,0,0);
p1.Print;
p1.Rotate(R);
p1.Print;