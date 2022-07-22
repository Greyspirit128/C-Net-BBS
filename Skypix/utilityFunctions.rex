/* some functions to help simplify using Skypix graphics */

SkyPixSetPixel: return         '[1;'||arg(1)||';'||arg(2)||'!'
SkyPixDRAWLINE: return         '[2;'||arg(1)||';'||arg(2)||'!'
SkyPixAREAFILL: return         '[3;'||arg(1)||';'||arg(2)||';'||arg(3)||'!'
SkyPixRECTANGLEFILL: return    '[4;'||arg(1)||';'||arg(2)||';'||arg(3)||';'||arg(4)||'!'
SkyPixELLIPSE: return          '[5;'||arg(1)||';'||arg(2)||';'||arg(3)||';'||arg(4)||'!'
SkyPixMOVEPEN: return          '[8;'||arg(1)||';'||arg(2)||'!'
SkyPixFILLEDELLIPSE: return    '[13;'||arg(1)||';'||arg(2)||';'||arg(3)||';'||arg(4)||'!'
SkyPixDELAY: return            '[14;'||arg(1)||'!'
SkyPixSETCOLOUROFPENA: return  '[15;'arg(1)'!'

CLSx:    /* for clearing screen w/Skypix graphics */
	transmit '[2J'
	transmit SkyPixSETCOLOUROFPENA(4)
	transmit SkyPixRECTANGLEFILL(1,1,640,400)  /* revist to dynamically set x/y max if resolution changed from default */
return 


SkyPixDrawSquare4Points:    /* For drawing 4 cornered square/rectangle. Update to allow n sided polygon? */
	arg	Color,X.1,y.1,X.2,y.2,X.3,y.3,X.4,y.4,Fill 
	x.5=x.1;y.5=y.1
	if color ~='' then ss SkyPixSETCOLOUROFPENA(Color)
	Output = ''
	do i=1 to 4;ii=i+1;Output = Output||SkyPixMovePEN(x.i,y.i)||SkyPixDRAWLINE(x.ii,y.ii);end 
	if Fill = 1 then 
	do 
		Center1 = GetCenterOfSquare(X.1,y.1,X.2,y.2,X.3,y.3,X.4,y.4)
		parse var Center1 Center2 ',' Center3	
		Output = Output||SkyPixAREAFILL(1,int(Center2),int(Center3))
	end 
return output

GetCenterOfSquare: procedure  /* Better way to do this?? */
	arg x1,y1,x2,y2,x3,y3,x4,y4
		xcenter = (x1+x2+x3+x4)/4
		ycenter = (y1+y2+y3+y4)/4
Return XCenter||','||YCenter

