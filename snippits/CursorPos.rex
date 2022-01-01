/* call with screen X & Y and it returns formatted escape sequence to position it
Note: uses ansi escape code.  Usually I use in a C-Net BBS pfile.*/

CurPos:
	arg CurPosY,CurPosX
	/*error checking for valid Col,Line) here*/
return '['CurPosX';'CurPosY'f'    /* Note: Escape character before [ but GitHub might strip it out */

Shorter version

CurPos:procedure;rerturn '['Arg(2)';'Arg(1)'f'

example 
transmit CurPos(10,5)   /*Transmit is a C-Net Built in Arexx command*/
