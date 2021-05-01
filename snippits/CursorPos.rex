/* call with screen X & Y and it returns formatted escape sequence to position it */

CurPos:
	arg CurPosY,CurPosX
	/*error checking for valid Col,Line) here*/
return '['CurPosX';'CurPosY'f'    /* Note: Escape character before [ but GitHub might strip it out */



Shorter version

CurPos:procedure;rerturn '['Arg(2)';'Arg(1)'f'



example 
transmit CurPos(10,5)
