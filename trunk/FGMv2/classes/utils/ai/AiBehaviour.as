/*
*   @author AngelStreet
*   Blog:http://angelstreetv2.blogspot.com/
*   Google Code: http://code.google.com/p/2d-isometric-engine/
*   Source Forge: https://sourceforge.net/projects/isoengineas3/
*/

/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*
*    This program is distrubuted through the Creative Commons Attribution-NonCommercial 3.0 Unported License.
*    Under this licence you are free to copy, adapt and distrubute the work. 
*    You must attribute the work in the manner specified by the author or licensor. 
*    You may not use this work for commercial purposes.  
*    You should have received a copy of the Creative Commons Public License along with this program.
*    If not,visit http://creativecommons.org/licenses/by-nc/3.0/ or send a letter to Creative Commons,
*    171 Second Street, Suite 300, San Francisco, California, 94105, USA.  
*/

package utils.ai{
	
	/**
	 * AI Class
	 * 
	 */
	public class AiBehaviour {
		public static const SEEK:int 		=0;
		public static const ESCAPE:int	 	=1;
		public static const 2DHor:int =0;	//2D mouvment horizontal
		public static const 2DVer:int =1;	//2D mouvment vertical
		public static const 4D:int =2;		//4D mouvment horizontal

		
		public function AiBehaviour($behaviour:String, $dimension:String){
			
		}
		
		
		public static function Seek($component:GraphicComponent, $target:GraphicComponent):int{
			var dir:int = Space.GetDirection($component.getBounds(null),$target.getBounds(null));	
			/*switch(dir){
				case Space.RIGHT: 		trace("right");		break;
				case Space.LEFT: 		trace("left");		break;
				case Space.UP: 			trace("up");		break;
				case Space.DOWN: 		trace("down");		break;
				case Space.RIGHT_DOWN: 	trace("right_down");break;
				case Space.DOWN_LEFT: 	trace("down_left");	break;
				case Space.LEFT_UP: 	trace("left_up");	break;
				case Space.UP_RIGHT: 	trace("up_right");	break;
				case Space.CENTER: 		trace("center");	break;
			}*/
			//return the direction to follow
			return dir;
		}
	}
}