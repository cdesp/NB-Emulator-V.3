{
    <Grundy NewBrain Emulator Pro Made by Despsoft>
    Copyright (C) 2004  <Despinidis Chris>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit FramePaint;

interface
uses graphics,windows;

Type

{remember each stored value is 65536
times its actual value} 

PVector = ^TVector; 

{pointer type for dynamic instantiation} 

TVector = record 
X:integer; 
Y:integer; 
end; 

TFramePnt = class(TObject)
  private
    Bitmap : HBitmap;
    Bitmapinfo : PBitmapinfo;
    FHeight : integer;
    FLineLen : integer;
    FSize : integer;
{Bitmap will hold the windows handle of
the DIB, lpvbits will be a pointer to the
DIB's pixel array, and Bitmapinfo is a
pointer to an instance of the Windows
Bitmapinfo structure in which we shall
describe the format of the DIB, ie.
width, height and color depth}
    FWidth : integer;
    lpvbits : Pointer;
    procedure AirBrush(FX, FY, Radius, Color: integer);

    procedure VPlot(V: PVector; Color: integer);
  public
    constructor Create(ACanvas:TCanvas;Width,Height:integer);
    destructor Destroy;override;
{the size of the DIB to be created
will be determined by the width and height
parameters, the canvas parameter determines
the palette to be used but this is best
explained in 'Create's' implementation. The
destructor must free up any memory allocated
to the DIB. The memory usage is
likely to be considerable.}
    function GetPixel(X, Y: integer): TColor;
    function Draw(ACanvas:TCanvas;X,Y:integer):integer;
    procedure Fill(FColor: integer);
    procedure Plot(X,Y,Color:integer);
    function getheight:Integer;
end;



implementation


constructor TFramePnt.Create(ACanvas:TCanvas;Width,Height:integer);
var LineAdj:integer;
begin
FWidth := Width;
FHeight := Height; 
FLineLen := 3*Width; 
LineAdj := FLineLen and 3; 
LineAdj := 4 - LineAdj; 
LineAdj := LineAdj and 3; 
FLineLen := FLineLen + LineAdj; 
FSize := FLineLen * FHeight; 
{Storing the values of width and height
in the appropriate fields is straightforward
enough, the tricky bit is calculating the
size of the DIB. Each horizontal scan line
of the DIB must be double word aligned, that
is to say, each scan line must start at an
address which is a multiple of four bytes.
Windows demands this is true and will fail to
create the DIB if it is not. Why this demand is
made is a matter of cpu architecture and
optimizing performance. This is why I asked
you to check that 'aligned record fields' is
switched on in the compiler. To calculate the
memory required to store one horizontal scan
line we multiply the width by three and then
work out how many bytes we must tag on the end
to make this value divisible by four. Summing
these values gives us FLineLen the number of
bytes required to store a single horizontal
line. The total memory used by the DIB being
the product of FLineLen and the number of
Horizontal lines FHeight.} 
New(Bitmapinfo); 
with Bitmapinfo^.bmiHeader do 
begin 
bisize := 40; {size of the bmiHeader structure} 
biWidth := Width; 
biHeight := Height; 
biPlanes := 1; {must always be one} 
biBitCount := 24; {24bits required to store each pixel} 
biCompression := BI_RGB; {image uncompressed, no palette} 
biSizeImage := FSize; {size of image pixel array} 
biXPelsPerMeter := 0; {info for scaling when printing etc.} 
biYPelsPerMeter := 0; 
biClrUsed := 0; {number of colors in palatte} 
biClrImportant := 0; {number of important colors in palette} 
end; 
{The PBitmapinfo type is defined in
Delphi's Graphics unit and encapsulates the
Windows Bitmapinfo structure itself containing
two record structures, bmiHeader and bmiColors.
The latter defines a palette, but as we are
using explicit 24bit true color values, a palette
is not required. Consequently bmiColors remains
null. The bmiHeader structure defines the size
and color usage as above.} 
Bitmap := CreateDIBSection(ACanvas.Handle,Bitmapinfo^, 
DIB_RGB_COLORS,lpvbits,0,0); 
{If we look at the parameters in order,
ACanvas.Handle is the handle of a valid
device context and is used to define the
logical palette of the DIB if the color
usage is defined as DIB_PAL_COLORS, it
isn't so the handle passed doesn't matter
except it must be a valid device context.
Bitmapinfo^ passes the size, format and
color data in the required structure.
DIB_RGB_COLORS defines the color usage, in this
case explicit RGB values. lpvbits is a
pointer whose value will be changed so that
it points to the pixel array of the DIB.
The last two parameters tell windows how the
memory required by the DIB is to be allocated,
in this case the values tell windows to allocate
the memory itself. It is possible to handle the
memory allocation yourself, but why bother.
The function returns a valid handle
in Bitmap if successful.} 
end;

destructor TFramePnt.Destroy;
begin
DeleteObject(Bitmap);
Dispose(Bitmapinfo);
end;


procedure TFramePnt.AirBrush
(FX,FY,Radius,Color:integer);assembler;
var X,Y,X0,Y0,X1,Y1,Xd,Yd,R2,D2,newColor:integer; 
{the variables declared are all
of the constant values which will be used 
X,Y centre of airbrush plot 
X0,Y0 bottom left coordinate of square
to scan = X-Radius,Y-Radius 
X1,Y1 top right coordinate of square to
scan = X+Radius,Y+Radius 
Xd,Yd current point being considered 
R2 square of the Radius 
D2 square of the distance of current
point Xd,Yd from centre 
newColor holds the color value for current
point as it is being constructed} 
asm 
jmp @airstart 
{define subroutines} 
@airpointok: 
{checks point Xd,Yd is valid,
if valid edx = address, if not edx = 0} 
push ecx 
mov ecx,Yd 
cmp ecx,0 
jl @airpointerror 
cmp ecx,[eax].FHeight 
jge @airpointerror 
push eax 
mov eax,[eax].FLineLen 
mul ecx 
mov edx,eax 
pop eax 
mov ecx,Xd 
cmp ecx,0 
jl @airpointerror 
cmp ecx,[eax].FWidth 
jge @airpointerror 
add edx,ecx 
shl ecx,1 
add edx,ecx 
pop ecx 
add edx,[eax].lpvbits 
ret 
@airpointerror: 
pop ecx 
mov edx,0 
ret 
@airblend: 
{takes the intensity of R,G or B, 0 -> 255,
ecx = current value, edx = new value and
blends them according to current value of
D2, the square of the distance from X,Y.
returns value in ecx} 
push eax 
push edx 
mov eax,D2 
mul ecx 
mov ecx,eax 
pop edx 
mov eax,R2 
sub eax,D2 
mul edx 
add eax,ecx 
xor edx,edx 
mov ecx,R2 
div ecx 
mov ecx,eax 
pop eax 
ret 
@airstart: 
{initialize all variables} 
mov X,edx 
mov Y,ecx 
sub edx,Radius 
mov X0,edx 
mov Xd,edx 
add edx,Radius 
add edx,Radius 
mov X1,edx 
sub ecx,Radius 
mov Y0,ecx 
mov Yd,edx 
add ecx,Radius 
add ecx,Radius 
mov Y1,ecx 
mov ecx,Radius 
cmp ecx,0 
jle @airdone 
push eax 
mov eax,Radius 
imul eax 
mov R2,eax 
pop eax 
@airloop: 
{start of main loop} 
mov ecx,Xd 
push eax 
sub ecx,X 
mov eax,Yd 
sub eax,Y 
imul eax 
mov D2,eax 
pop eax 
{D2, square of the distance
of current Xd,Yd from centre
now calculated and stored} 
call @airpointok 
cmp edx,0 
je @airpointdone 
{now know current point
OK and have it's address in edx} 
mov ecx,[edx] 
push edx 
push ecx 
{get pixel color value and save
pixel address and color on stack} 
and ecx,0ff000000h 
mov newColor,ecx 
{grab fourth byte of color
value and store in newColor) 
pop ecx 
push ecx 
and ecx,0ff0000h 
shr ecx,16 
mov edx,Color 
and edx,0ff0000h 
shr edx,16 
call @airblend 
{recover color value but maintain stack status,
isolate Red value and shift right so that Red
intensity is in range 0->255 to keep subroutine
@airblend happy. Do same with color value to be
applied. Call @airblend to blend these color values
according to status of R2 and D2, returning
modified value in ecx} 
shl ecx,16 
{shift back to position
of red intensity} 
mov edx,newColor 
xor edx,ecx 
mov newColor,edx 
{update newColor} 
{now do this again
for the Green values} 
pop ecx 
push ecx 
and ecx,0ff00h 
shr ecx,8 
mov edx,Color 
and edx,0ff00h 
shr edx,8 
call @airblend 
shl ecx,8 
mov edx,newColor 
xor edx,ecx 
mov newColor,edx 
{and again for Blue} 
pop ecx 
and ecx,0ffh 
mov edx,Color 
and edx,0ffh 
call @airblend 
mov edx,newColor 
xor ecx,edx 
pop edx 
mov [edx],ecx 
{finally recover address of pixel,
and update using newColor} 
@airpointdone: 
{and we end with the standard
loop control checks} 
mov ecx,Xd
inc ecx 
mov Xd,ecx 
cmp ecx,X1 
jle @airloop 
mov ecx,X0 
mov Xd,ecx 
mov edx,Yd 
inc edx 
mov Yd,edx 
cmp edx,Y1 
jle @airloop 
@airdone: 
end;

function TFramePnt.Draw(ACanvas:TCanvas;X,Y:integer):integer;
begin
StretchDIBits(ACanvas.Handle,X,Y,FWidth,FHeight,0,0,FWidth,FHeight,
lpvbits,Bitmapinfo^,DIB_RGB_COLORS,SRCCOPY); 
Result := GetLastError; 
end; 

procedure TFramePnt.Fill(FColor:integer);assembler; 
var X,Y,indexY,indexP,Color:integer;
asm 
mov ecx,[eax].Bitmap 
cmp ecx,0 
je @filldone 
{check DIB exists and exit if not} 
mov ecx,[eax].FWidth 
mov X,ecx 
mov ecx,[eax].FHeight 
mov Y,ecx 
mov ecx,[eax].lpvbits 
mov indexY,ecx 
mov indexP,ecx 
and edx,0ffffffh 
mov Color,edx 
{initialize variables X and Y act as counts,
each horizontal line is considered in turn
indexY holding the address of point (0,Y)
for a given Y. There after each iteration
adds three to this value storing the result
in indexP, each successive value corresponding
to the address of a point on the horizontal
scan line. When the count reaches zero the
line has been completed, and the next scan
line is considered by adding FLineLen to indexY
and resetting X and indexP. When Y equals
zero the fill has been completed without
resorting to multiplication} 
@startfill: 
mov edx,indexP 
mov ecx,[edx] 
and ecx,0ff000000h 
xor ecx,Color 
mov [edx],ecx 
add edx,3 
mov indexP,edx 
mov ecx,X 
dec ecx 
mov X,ecx 
cmp ecx,0 
jg @startfill 
mov edx,indexY 
add edx,[eax].FLineLen 
mov indexY,edx 
mov indexP,edx 
mov ecx,[eax].FWidth 
mov X,ecx 
mov edx,Y 
dec edx 
mov Y,edx 
cmp edx,0 
jg @startfill 
@filldone: 
end; 

function TFramePnt.getheight: Integer;
begin
 result:=fheight;
end;

function TFramePnt.GetPixel(X,Y:integer):TColor;assembler;
asm
push ebx
mov ebx,[eax].Bitmap
cmp ebx,0
je @getpixeldone
pop ebx
push ebx
cmp edx,0
jl @getpixeldone
cmp edx,[eax].FWidth
jge @getpixeldone
cmp ecx,0
jl @getpixeldone
cmp ecx,[eax].FHeight 
jge @getpixeldone 
{we need to calculate the memory
offset of point X,Y in the DIB and then add
the memory address of the start of the DIB
to find the actual address of the point. The
offset is FLineLen*Y+3*X  this is the same
as the Plot routine} 
push eax 
push edx 
mov eax,[eax].FLineLen 
mul ecx 
mov edx,eax 
pop ecx 
pop eax 
add edx,ecx 
shl ecx,1 
add edx,ecx 
add edx,[eax].lpvbits 
mov eax,[edx] 
and eax,0ffffffh 
{having got four bytes of data from
the DIB, we dispose of the fourth,
most significant byte, leaving just
the color value of point X,Y} 
@getpixeldone: 
pop ebx 
end; 

procedure TFramePnt.Plot(X,Y,Color:integer);assembler; 
asm
push ebx 
mov ebx,[eax].Bitmap 
cmp ebx,0 
je @plotdone 
{if the value of Bitmap is zero
then no memory has been allocated to the DIB.
All we can do is abort the plot.} 
pop ebx 
push ebx 
{recover value of ebx without affecting the stack} 
cmp edx,0 
jl @plotdone 
{if X coordinate is less then zero then abort} 
cmp edx,[eax].FWidth 
jge @plotdone 
{if X coordinate is greater then
or equal to the DIB's width then abort} 
cmp ecx,0 
jl @plotdone 
cmp ecx,[eax].FHeight 
jge @plotdone 
{same checks on Y coordinate} 
{we need to calculate the memory
offset of point X,Y in the DIB and then
add the memory address of the start of the
DIB to find the actual address of the point.
The offset is FLineLen*Y+3*X} 
push eax 
push edx 
{eax = object base address, edx = X.
since we are about to use the mul
operation we must save these values} 
mov eax,[eax].FLineLen 
{eax = FLineLen, ecx = Y,
so we can now multiply} 
mul ecx 
{eax = FLineLen*Y, edx = 0} 
mov edx,eax 
{we need to recover the values
of X and the object base address from the stack,
so we move the value of FLineLen*Y to edx before
recovering eax's value} 
pop ecx 
pop eax 
{eax = object base address,
edx = FLineLen*Y, ecx = X} 
add edx,ecx 
{edx = FLineLen*Y+X} 
shl ecx,1 
{ecx = 2*X} 
add edx,ecx 
{edx = FLineLen*Y+X+2*X = FLineLen*Y+3*X,
which is what we want} 
add edx,[eax].lpvbits 
{add the memory address of the
start of the DIB, and edx now holds the
actual address of the pixel X,Y} 
mov ecx,[edx] 
and ecx,0ff000000h 
{get the current value of the pixel,
as we can only move four bytes around at a
time and the pixel color value is only
three bytes long, the fourth and most significant
byte is part of the color value of the
next pixel. Using the 'and' operation we
isolate the value of this fourth byte and
store it in ecx} 
mov ebx,Color 
and ebx,0ffffffh 
{the value of ebx is currently on
the stack, so this can be recovered in
a moment. Having loaded ebx with the
color value to be 'plotted' we must
ensure it is only three bytes long} 
xor ecx,ebx 
mov [edx],ecx 
{using 'xor' we combine the three
byte color value in ebx with the fourth byte
in ecx, and in doing so avoid affecting the
color of the next pixel. This combined value
is then written over the pixel address
achieving the 'plot'} 
@plotdone: 
pop ebx 
{before exiting we recover ebx's value}
end; 

procedure TFramePnt.VPlot(V:PVector;Color:integer);assembler;
asm
push ebx 
mov ebx,[eax].Bitmap 
cmp ebx,0 
je @vplotdone 
{if the value of Bitmap is zero
then no memory has been allocated to the DIB.
All we can do is abort the plot.} 
pop ebx 
push ebx 
{recover value of ebx
without affecting the stack} 
cmp edx,0 
je @vplotdone 
{if edx = V = 0 then the vector
pointer passed is undefined, so exit} 
mov ecx,[edx].TVector.Y 
mov edx,[edx].TVector.X 
{now move the vector coordinate
values into edx and ecx and the
rest of the routine is the same as Plot} 
cmp edx,0 
jl @vplotdone 
cmp edx,[eax].FWidth 
jge @vplotdone 
cmp ecx,0 
jl @vplotdone 
cmp ecx,[eax].FHeight 
jge @vplotdone 
push eax 
push edx 
mov eax,[eax].FLineLen 
mul ecx 
mov edx,eax 
pop ecx 
pop eax 
add edx,ecx 
shl ecx,1 
add edx,ecx 
add edx,[eax].lpvbits 
mov ecx,[edx] 
and ecx,0ff000000h 
mov ebx,Color 
and ebx,0ffffffh 
xor ecx,ebx 
mov [edx],ecx 
@vplotdone: 
pop ebx 
end; 

end.
 