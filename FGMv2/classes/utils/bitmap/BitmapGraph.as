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
		public var currentAnim:BitmapAnim;
		
		public function BitmapGraph(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			animations = new Dictionary;
		}
		//------ Create Graph ------------------------------------
		public function createGraph($name:String,$column:int,$row:int, $cellWidth:Number, $cellHeight:Number, $numFrame:int ,$position:int=0):void {
			if(animations[$name]){
				throw new Error(" An animation already exist with the name: "+$name);
			}
			animations[$name] = createAnim($name,$column,$row,$cellWidth,$cellHeight,$numFrame, $position);
			position = animations[$name].getCell();
		}
		//------ Create Classic Graph ------------------------------------
		public function createSimpleGraph():void {
			animations["STAND"] = createAnim("STAND",0,0,64,64,4,0,10);
			animations["RIGHT"] = createAnim("RIGHT",0,1,64,64,4,0,10);
			animations["DOWN"] = createAnim("DOWN",4,1,64,64,4,0,10);
			animations["LEFT"] = createAnim("LEFT",8,1,64,64,4,0,10);
			animations["UP"] = createAnim("UP",12,1,64,64,4,0,10);
			currentAnim = animations["STAND"];
			position = currentAnim.getCell();
		}
		//------ Create Classic Graph ------------------------------------
		public function createAnim($name:String,  $column:int,$row:int, $cellWidth:Number, $cellHeight:Number, $numFrame:int,$position:int=0,$fps:int=0):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			var cell:BitmapCell;
			var x:Number, y:Number;
			for(var i:int =0; i<$numFrame; i++){
				x = $column*$cellWidth+$cellWidth*i;
				y = $row*$cellHeight;
				cell = new BitmapCell(null, x , y, $cellWidth, $cellHeight);
				list.push(cell);
			}
			return new BitmapAnim($name, list, $position, $fps);
		}
		//------ Create Classic Graph ------------------------------------
		public function anim($anim:String, $inversed:Boolean = false, $reset:Boolean=false):void{
			if(animations[$anim]){
				if(currentAnim != animations[$anim]){
					currentAnim.position = 0;
				}
				if($reset){
					animations[$anim].position=0;
					position =animations[$anim].getCell();
				}else if($inversed){
					position = animations[$anim].prev();
				}else{
					position = animations[$anim].next();
				}
			}
		}
	}
}