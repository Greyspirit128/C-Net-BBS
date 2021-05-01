/* Windowing test */
CLS = 'F1}'
options results
ss=sendstring
tr=transmit
call WindowInit

ScrollRate = 1  /* Maybe move to be window specific as Window.<Window#>.ScrollRate  */

ss CLS
tr '1234567890123456789012345678901234567890123456789012345678901234567890'
call WindowCreate(1,1,40,3,1,1,'Header',1,1);WinHeader = result;call WindowDrawBorder(WinHeader)
call WindowCreate(1,4,20,26,1,1,'MainDisplay',2,1);WinMain = result;call WindowDrawBorder(WinMain)
call WindowCreate(42,4,10,10,1,1,'WindowStats',3,1);WinStats = result;call WindowDrawBorder(WinStats)

call WindowCreate(22,4,20,15,2,1,'Scroller',2,1);WinScroller = result;call WindowDrawBorder(WinScroller)


 /*WindowTypes 1=Graphic 2=Text Scrolling 3=Text Static 4=Text Readout (stats) 5=Input */
/* 	Arg X,Y,Length,Height,Type,Border,Name,BorderColor,Enabled */
/*Main:
	do until CowsComeHome = 1
		Do IndexWindow = 1 to WindowCount
			if Window.IndexWindow.Enabled = 1 then 
			do
				if Length(Window.IndexWindow.WindowQueuedText) > 0 then 
				do 
					if time('e') >= Window.IndexWindow.WindowTimer + 1 then 
					do 
						
					end 
				end 
			end 
				
		end 
	if time('e') > 300 then CowsComeHome = 1 
	end 
exit
*/

Window.WinMain.BODY.1='Once upon a midnight dreary,while I pondered, weak and weary, Over many a quaint and curious volume of forgotten lore - While I nodded, nearly napping, suddenly there came a tapping, As of some one gently rapping, rapping at my chamber door. ''Tis some visitor,'' I muttered, ''tapping at my chamber door - Only this and nothing more.'''
Window.WinScroller.BODY.1='Once upon a midnight dreary,while I pondered, weak and weary, Over many a quaint and curious volume of forgotten lore - While I nodded, nearly napping, suddenly there came a tapping, As of some one gently rapping, rapping at my chamber door. ''Tis some visitor,'' I muttered, ''tapping at my chamber door - Only this and nothing more.'''


call TextWrap1(WinMain)
call WindowPrintStatic(WinMain) 

call TextWrap1(WinScroller)
Window.WindowCount.WindowScrollPos = 1
call WindowPrintScroll(WinScroller)

transmit Curpos(32,1) 'successful'
exit 


WindowPrintScroll:
	arg WindowNumber

	tmp1 = Window.windowNumber.WindowHeight - ( Window.WindowNumber.WindowBorder *2) + 1
do m = 1 to 50
	tmp2 = Window.WindowCount.WindowScrollPos
	/* see if pos is less than body stem size. If so, load next line into off screen line or load empty string */
	if Window.WindowCount.WindowScrollPos <= Window.WindowNumber.Body.0  then 
		do 
			Window.windowNumber.WindowScrollData.tmp1 = Left(Window.WindowNumber.Body.tmp2,(Window.windowNumber.WindowLength - ( Window.WindowNumber.WindowBorder *2)),' ')
			Window.WindowCount.WindowScrollPos = Window.WindowCount.WindowScrollPos + 1
		end 
		Else do
			Window.windowNumber.WindowScrollData.tmp1 = copies(' ',Window.windowNumber.WindowLength - ( Window.WindowNumber.WindowBorder *2))
		end 
	do i = 1 to tmp1
		tmp2 = i + 1
		Window.windowNumber.WindowScrollData.i = Window.windowNumber.WindowScrollData.tmp2
	end 
	
	do i = 1 to tmp1 -1
		transmit CurWinPos(WindowNumber,i,0)Window.WindowNumber.WindowScrollData.I
	end 
	call pause(0.1)

end 

return

Pause:
	arg delayTime
	elapsed = 0
	time('r')
	do until elapsed > delaytime
		elapsed = time('e')
	end
return


CurWinPos: 
	arg WindowNumber,CurY,CurX
	CurY = Window.WindowNumber.WindowY + CurY 
	CurX = Window.WindowNumber.WindowX + CurX 
	if Window.WindowNumber.WindowBorder = 1 then do;CurX=CurX+1;CurY=CurY+1;end 
return '['CurY';'CurX'f' 


TextWrap1:
	arg WindowNumber
	seg=1
	POS=1
	Width=Window.WindowNumber.WindowLength - (Window.WindowNumber.WindowBorder * 2) 
	if length(Window.WindowNumber.BODY.1) > Width then do forever 
		RESLEN=length(Window.WindowNumber.BODY.SEG)
		if RESLEN > Width then do
			SEG=SEG+1
			RESCHU=left( Window.WindowNumber.BODY.POS , Width)
			RESSPA=LASTPOS(' ', RESCHU)
			if RESSPA~=0 then RESCHU=left(RESCHU,RESSPA-1)
			else RESSPA=length(RESCHU)
			RESREM=RESLEN-RESSPA
			Window.WindowNumber.BODY.SEG=right(Window.WindowNumber.BODY.POS,RESREM)
			Window.WindowNumber.BODY.POS=RESCHU
			POS=POS+1
			Window.WindowNumber.BODY.0=SEG
		end
		else leave
	end

return 

WindowPrintStatic:
	arg WindowNumber

	if Window.WindowNumber.Body.0 > 0 then 
	do i = 1 to Window.WindowNumber.BODY.0
		if i < (Window.WindowNumber.WindowHeight - (Window.WindowNumber.WindowBorder * 2)) then 
		transmit CurWinPos(WindowNumber,I,0)Window.WindowNumber.body.i
	end 

return 

CurPos: return '['arg(1)';'arg(2)'f' 

WindowDrawBorder: 
	arg WindowNumber
	ss Window.WindowNumber.WindowBorderColor
	if Window.WindowNumber.WindowBorder = 1 then 
		do 
			do Y = 0 to Window.WindowNumber.WindowHeight -1
				do X = 0 to Window.WindowNumber.WindowLength -1
					if Y = 1 then ss curpos(Window.WindowNumber.WindowY+Y,Window.WindowNumber.WindowX+X)||WindowBorderTop
					if Y = (Window.WindowNumber.WindowHeight)-1  then ss curpos(Window.WindowNumber.WindowY+Y+1,Window.WindowNumber.WindowX+X)||WindowBorderBottom
					if X = 0 & (Y > 1) & (Y < Window.WindowNumber.WindowHeight) then ss curpos(Window.WindowNumber.WindowY+Y,Window.WindowNumber.WindowX+X)||WindowBorderLeft
					if X = Window.WindowNumber.WindowLength -1 & (Y > 1) & (Y < Window.WindowNumber.WindowHeight) then ss curpos(Window.WindowNumber.WindowY+Y,Window.WindowNumber.WindowX+X)||WindowBorderRight
				end 
			end 
		end 
return 

WindowClear:
	Arg WindowNumber 
	do Y = 0 + Window.WindowNumber.WindowBorder to Window.WindowNumber.WindowHeight - Window.WindowNumber.WindowBorder -1
		ss CurPos( Window.WindowNumber.WindowY + Y +1 , (Window.WindowNumber.WindowX + Window.WindowNumber.WindowBorder) )copies(' ',Window.WindowNumber.WindowLength - (Window.WindowNumber.WindowBorder*2))
	end	
return 

Fillshit:
	arg WindowNumber,FillChar
	do Y = 0 + Window.WindowNumber.WindowBorder to Window.WindowNumber.WindowHeight - Window.WindowNumber.WindowBorder -1
		do X = 0 + Window.WindowNumber.WindowBorder to Window.WindowNumber.WindowLength - Window.WindowNumber.WindowBorder -1
			ss curpos(Window.WindowNumber.WindowY+Y+1,Window.WindowNumber.WindowX+X)||FillChar
		end 
	end 
return 

WindowCreate:    /* Returns new window # */
	Arg X,Y,Length,Height,Type,Border,Name,BorderColor,Enabled
	/* TODO - add error checks for sanity */
	WindowCount=WindowCount+1
	Window.WindowCount.WindowName		 = 	Name
	Window.WindowCount.WindowX			 =	X
	Window.WindowCount.WindowY			 =	Y
	Window.WindowCount.WindowLength 	 = 	Length
	Window.WindowCount.WindowType		 =	Type
	Window.WindowCount.WindowBorder		 =	Border
	Window.WindowCount.WindowHeight		 =	Height
	Window.Windowcount.WindowBorderColor =	color(BorderColor)
	Window.WindowCount.WindowEnabled     =  Enabled
	Window.WindowCount.WindowTimer       =  time('e')
	Window.windowCount.Body.             =  ' '
	Window.WindowCount.WindowScrollPos	 =  0
	Window.windowcount.WindowScrollData. =  ' ' 
	do i = 1 to 15; Window.windowcount.WindowScrollData.i=' ' ; end 

Return WindowCount 
	

WindowInit:
	time('r')
	WindowTypes.       = 0   /* 1=Graphic 2=Text Scrolling 3=Text Static 4=Text Readout (stats) 5=Input */
	Window.            = 0   /* X,y,length,Height,type,border,name */
	WindowCount        = 0   /* running index of number of windows */
	WindowX		       = 1   /* Window X Location */
	WindowY		       = 2   /* Window Y Location */
	WindowLength       = 3   /* Window Width */
	WindowHeight       = 4   /* Window Height */
	WindowType	       = 5   /* Window Type (See WindowTypes) */
	WindowBorder       = 6   /* 0=no border 1 = borders */
	WindowName	       = 7   /* Window Name..not used currently */
	WindowBorderColor  = 8   /* Window border color 0-F  0=black 1=red 2=green 3=yellow 4=blue 5=purple 6=cyan 7=white Color codes 8, 9, a, b, c, d, e, and f are INTENSE versions of the first 8 */
	WindowEnabled      = 9   /* To show if it is "enabled" or not. Boolean value 0 = false. 1 = true */
	WindowScrollData  =  10 
	WindowScrollPos    = 11
	WindowBorderTop    = '-' /* character for window border - top */ 
	WindowBorderLeft   = '|' /* character for window border - Left */ 
	WindowBorderRight  = '|' /* character for window border - right */ 
	WindowBorderBottom = '-' /* character for window border - Bottom */ 
return 

PressAKey:
tr 'Press any key...g1}' 
return

GetInputTimed:
	Arg WaitTime
	bufferflush
	ans=0
	time('r')
		do until C2D(ans) ~= 48
		maygetchar;ans=upper(result)
		if ans = 'NOCHAR' then ans = 0
		elapsed = time('e')
		if elapsed > WaitTime then do;leave;end
	end
Return ans

Color:	Return 'c'arg(1)'}'   /*0=black 1=red 2=green 3=yellow 4=blue 5=purple 6=cyan 7=white Color codes 8, 9, a, b, c, d, e, and f are INTENSE versions of the first 8 */

