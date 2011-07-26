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
package utils.bitmap{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	public class BitmapSet{
		
		public var bitmap:Bitmap = null;
		public var graph:BitmapGraph;
		public var autoAnim:Boolean = false;
		
		public function BitmapSet($bitmap:DisplayObject, $graph:BitmapGraph = null, $autoAnim:Boolean = true){
			_initVar($bitmap,$graph,$autoAnim);
		}
		//------ Init Var ------------------------------------
		protected function _initVar($bitmap:DisplayObject,$graph:BitmapGraph,$autoAnim:Boolean):void {
			bitmap = $bitmap as Bitmap;
			if($graph){
				graph = $graph;
			}else{
				graph = new BitmapGraph;
			}
			autoAnim = $autoAnim;
		}
		//------ Get Cell ------------------------------------
		public function get position():BitmapCell {
			return graph.currentPosition;
		}
		//------ clone ------------------------------------
		public function clone():BitmapSet {
			var bitmapSet:BitmapSet = new BitmapSet(bitmap,graph, autoAnim);
			return bitmapSet;
		}
	}
}