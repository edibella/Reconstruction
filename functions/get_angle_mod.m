function theta_all = get_angle_mod(para)

sy = para.Recon.sy;
sz = para.Recon.sz;
data_angle  = para.dataAngle/180*pi;
golden_angle = ((sqrt(5)-1)/2)*pi;
theta_all = mod((0:sy*sz-1)*golden_angle,data_angle);

end