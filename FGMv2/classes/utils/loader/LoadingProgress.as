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
package utils.loader{

	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	* LoadingProgress Class
	* @ purpose: Loading Progress.
	*/
	public class LoadingProgress extends MovieClip {
		
		private var currentValue:Number=0;
		public var percentDisplay:TextField;
		public var textDisplay:TextField;

		public function LoadingProgress() {
			reset();
			center();
		}
		//------ Reset ------------------------------------
		private function reset():void {
			currentValue=0;
			updateDisplay();
		}
		//------ Center ------------------------------------
		private function center():void {
			//Clip.Center(this);
		}
		//------ Update Display ------------------------------------
		public function updateDisplay():void {
			percentDisplay.text=currentValue.toString();
		}
		//------ Update Error ------------------------------------
		public function updateText(_text:String):void {
			textDisplay.text=_text;
		}
		//------ Add To Value ------------------------------------
		public function addToValue( _amountToAdd:Number ):void {
			currentValue=currentValue+_amountToAdd;
			updateDisplay();
		}

		//------ Set Value ------------------------------------
		public function setValue( _amount:Number ):void {
			currentValue=_amount;
			updateDisplay();
		}

	}
}