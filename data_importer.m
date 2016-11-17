clear; clc;

Fs = 16e6;
L = 30e6;

file = fopen('B1- 2.42 GHz.bin', 'r');
IQdata = fread(file,[2,L],'int16');
fclose(file);
IQdata = IQdata(1,:) + 1i*IQdata(2,:);

figure(1);
subplot(2,2,1)
plot((0:L-1)/Fs,real(IQdata),'b',(0:L-1)/Fs,imag(IQdata),'r');
grid on;

% figure(2)
% plot3((0:L-1)/Fs,real(IQdata),imag(IQdata),'b.')
% grid on
% axis('square')

subplot(2,2,2)
plot((0:L-1)/Fs,20*log10(abs(IQdata)));

ff = 1e3;
a = IQdata(1:floor(length(IQdata)/ff)*ff);
a2 = abs(a).^2;
a2 = reshape(a2,ff, ceil(length(a2)/ff));
pwr = sqrt(mean(a2));
pwr = 20*log10(pwr);
maxp = max(pwr);
mp = mean(pwr);
thr = (maxp+mp)/2;


if (pwr(1)>thr)
   det = find(pwr<thr);
   det = det(1);
   pwr = pwr(det:end);
   a = a((det*ff):end);
end
    
subplot(2,2,3)
plot(1:length(pwr),pwr)

sp = find(pwr>thr);
sp = sp(1);
ep = find(pwr(sp:end) < thr);
ep = ep(1)+sp;

sp = sp*ff;
ep = ep*ff;

%Add a few extra samples:
sp = sp - 20e3;
ep = ep + 10e3;
if (sp < 1)
    sp = 1;
end
if (ep > length(a))
    ep = length(a);
end
pkt = a(sp:ep);

subplot(2,2,4)
plot(abs(pkt))
