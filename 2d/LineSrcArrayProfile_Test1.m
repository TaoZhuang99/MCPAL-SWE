clear all
xc = (-4:4).' * 17.15/1e3;
a = 0.05;

p.name = 'steerable';
p.steer_angle = 70/180*pi;

prf = LineSrcArrayProfile('xc', xc, 'a', a);
prf.CreateProfile(wav, p)
