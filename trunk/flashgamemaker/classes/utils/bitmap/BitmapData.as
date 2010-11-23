﻿/*
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

package utils.bitmap{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.geom.Rectangle;

	/**
	* Bitmap Data Class
	* 
	*/
	public class BitmapData {

		public function BitmapData() {

		}
		//------ Color Bitmap Data ------------------------------------
		public static function ColorBitmapData(bitmapData:flash.display.BitmapData , R:Number,G:Number,B:Number,A:Number):flash.display.BitmapData {
			var resultColorTransform:ColorTransform=new ColorTransform(R,G,B,A,0,0,0,0);
			bitmapData.colorTransform(bitmapData.rect, resultColorTransform);
			return bitmapData;
		}
	}
}