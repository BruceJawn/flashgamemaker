/*
*   @author AngelStreet
*   @langage_version ActionScript 3.0
*   @player_version Flash 10.1
*   Blog:         http://flashgamemakeras3.blogspot.com/
*   Group:        http://groups.google.com.au/group/flashgamemaker
*   Google Code:  http://code.google.com/p/flashgamemaker/downloads/list
*   Source Forge: https://sourceforge.net/projects/flashgamemaker/files/
*/
/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*  
*   Permission is granted to copy, distribute and/or modify this document
*   under the terms of the GNU Free Documentation License, Version 1.3
*   or any later version published by the Free Software Foundation;
*   with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
*   Under this licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/
package utils.transform{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class BitmapDataTransform{
		
		//----- Flip BitmapData  -----------------------------------
		public static function FlipBitmapData($bitmapData:BitmapData):void {
			var flipHorizontalMatrix:Matrix = new Matrix();
			flipHorizontalMatrix.scale(-1,1);
			flipHorizontalMatrix.translate($bitmapData.width,0);
			var flippedBitmapData:BitmapData=new BitmapData($bitmapData.width,$bitmapData.height,true,0);
			flippedBitmapData.draw($bitmapData,flipHorizontalMatrix);
			$bitmapData.fillRect($bitmapData.rect,0);
			$bitmapData.draw(flippedBitmapData);
		}
		//----- Swap Color  -----------------------------------
		public static function SwapColor($bitmapData:BitmapData, $color:uint, $newColor:uint=0):void {
			$bitmapData.threshold($bitmapData, $bitmapData.rect, new Point(0, 0), "==", $color, $newColor);
		}
		
	}
}
