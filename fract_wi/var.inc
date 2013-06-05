; Variables for Fractal Winter 4kb
; Alexey Komarov <alexey@komarov.org.ru>, 2001

nshift   dw 0
_128     dw 128
_100     dw 100
_57_3    dd 57.3
_1_4     dd 1.4
_32      dw 32
_20      dw 20
_1       dw 1
_1_2     dd 1.2
_80      dw 80
_60      dw 60
_3500    dw 3500
zshift   dw 20
zeye     dw -200
_10666   dd 10666.666667
_2       dw 2
_7692    dd 7692.3076923
_1_3     dd 1.3
_0_1     dd 0.1
_256     dw 256
_0_02    dd 0.0200625
_40_7    dd 40.738383195
_0_0001  dd 0.0001
minus1   dw -1
_64      dw 64
_63      dw 64
_0_9     dd 0.9
tt       dw 0
fft      dd 0
t1       db 'O winter! bar thine adamantine doors: The north is thine; there hast thou built thy dark$'
t2       db 'Deep-founded habitation. Shake not thy roofs Nor bend thy pillars with thine iron car.$'
t3       db 'Greets:       level45     CEG      nooklear      Secular      NRG      Accept Corp      T-rex$'
error    db '480kb', 10, 13, '$'

m1       db 'Mortal Antibiotic$'
m2       db 'presents$'
m3       db 'Oldskool 4kb Intro$'
m4       db 'for funs$'
m41      db 'Fractal Winter$'
m5       db 'Calcing fractals...$'

mseg     dw ?
tseg     dw ?
nseg     dw ?
useg     dw ?
iseg     dw ?
rseg     dw ?
aseg     dw ?

start_var:

pixel    dw ?
bangle   dw ?
iter     dw ?
dll      dw ?
dxl      dw ?
dyl      dw ?
ail      dw ?
bil      dw ?
xil      dw ?
yil      dw ?
x1l      dw ?
y1l      dw ?
x2l      dw ?
y2l      dw ?
color    dw ?
vseg     dw ?
rok      dw ?
rom      dw ?
rox      dw ?
roy      dw ?
roz      dw ?
rox1     dw ?
roy1     dw ?
roz1     dw ?
rx       dw ?
ry       dw ?
rz       dw ?

lin1     dw 4357 dup(?)
lin2     dw 4357 dup(?)
sinus    dw 1440 dup(?)
cosinus  dw 1440 dup(?)

temp     dd ?
temp1    dw ?
mx       dw ?
my       dw ?
mradius  dw ?
pc       dw ?
px       dw ?
py       dw ?
c3x      dw ?
c3y      dw ?
c3z      dw ?
di_orig  dw ?
wgx      dw ?
wgy      dw ?
fes      dw ?
fbp      dw ?
ur       dw ?
fcx      dw ?
fcy      dw ?
fzx      dw ?
fzy      dw ?
ft       dw ?
fnewx    dd ?
fx       dd ?
fy       dd ?
fnewy    dd ?
fa       dd ?
fb       dd ?
fr       dd ?
fc       dd ?
fd       dd ?
ff       dd ?
blob     db 65 * 65 dup(?)
currx    dd ?
curry    dd ?
realp    dd ?
imagp    dd ?
a2       dd ?
b2       dd ?
i2       dd ?
j2       dd ?
crad     dd ?
xx       dd ?
yy       dd ?
radoff   dw ?
angoff   dw ?
alpha    dw ?
angle    dw ?
x1       dw ?
y1       dw ?
flag     dw ?
snowx    dw 700 dup(?)
snowy    dw 700 dup(?)
snows    dw 700 dup(?)

end_var:
