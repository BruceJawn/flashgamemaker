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
	import flash.utils.Dictionary;

	public class BitmapGraph{
		
		public var animations:Dictionary;
		public var position:BitmapCell;
		
		public function BitmapGraph(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			animations = new Dictionary;
		}
		//------ Create Classic Graph ------------------------------------
		public function createSimpleGraph():void {
			animations["RIGHT"] = createSimpleAnim("RIGHT",0,1,64,64,4);
			animations["DOWN"] = createSimpleAnim("DOWN",4,1,64,64,4);
			animations["LEFT"] = createSimpleAnim("LEFT",8,1,64,64,4);
			animations["UP"] = createSimpleAnim("UP",12,1,64,64,4);
			animations["DEFAULT"] = animations["RIGHT"];
			position = animations["DEFAULT"].getCell();
		}
		//------ Create Classic Graph ------------------------------------
		public function createSimpleAnim($name:String,  $column:int,$row:int, $cellWidth:Number, $cellHeight:Number, $numFrame:int):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			var cell:BitmapCell;
			var x:Number, y:Number;
			for(var i:int =0; i<$numFrame; i++){
				x = $column*$cellWidth+$cellWidth*i;
				y = $row*$cellHeight;
				cell = new BitmapCell(x , y, $cellWidth, $cellHeight);
				list.push(cell);
			}
			return new BitmapAnim($name, list);
		}
		//------ Create Classic Graph ------------------------------------
		public function anim($anim:String):void{
			if(animations[$anim]){
				position = animations[$anim].next();
			}
		}
	}
}