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
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SwfSet extends BitmapSet{
		
		public var swf:MovieClip = null; 		//SWF Container
		public var realDisp:MovieClip = null;	//MovieClip to display
		
		public function SwfSet($swf:DisplayObject){
			super($swf);
		}
		//------ Init Var ------------------------------------
		override protected function _initVar($swf:DisplayObject):void {
			swf = $swf as MovieClip;
			graph = new BitmapGraph;
			var s:Sprite = new Sprite;
			s.graphics.beginFill(0);
			s.graphics.drawCircle(10,10,50);
			s.graphics.endFill();
			createBitmapFrom("AssetDisplay");
		}
		//------ Create Bitmap ------------------------------------
		public function createBitmapFrom($className:String):void {
			realDisp = getAssetByClass($className);
			if(!realDisp){
				throw new Error("The MovieClip specified "+$className+" doesn't exist or is not exported"); 
			}
			var labels:Array = realDisp.currentLabels;
			var bitmapData:BitmapData = new BitmapData(realDisp.width, realDisp.height, true,0);
			var y:int =0;
			for each(var label:FrameLabel in labels){
				graph.animations[label.name] = createBitmapAnim(label, y);
				y++;
			}
			graph.currentAnim = graph.animations[labels[0].name];
			graph.position = graph.currentAnim.getCell();
		}
		//------ Create Bitmap Anim------------------------------------
		public function createBitmapAnim($label:FrameLabel, $y:int):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			realDisp.gotoAndStop($label.name);
			var bitmapCell:BitmapCell;
			var x:int =0;
			var bitmapData:BitmapData = new BitmapData(realDisp.width, realDisp.height, true,0);
			while(realDisp.currentLabel == $label.name && realDisp.currentFrame<realDisp.totalFrames){
				bitmapData.floodFill(0,0,0);
				bitmapData.draw(realDisp);
				//draw(bitmapData,realDisp);
				bitmapCell = new BitmapCell(bitmapData.clone(),x,$y,realDisp.width,realDisp.height);
				list.push(bitmapCell);
				x++;
				realDisp.nextFrame();
			}
			bitmapData.dispose();
			return new BitmapAnim($label.name, list);
		}
		//------ Create Bitmap Anim------------------------------------
		public function draw($bitmapData:BitmapData, $realDisp:DisplayObject):void {
			$bitmapData.draw($realDisp);
			if(!($realDisp is MovieClip))	 return;
			var newRealDisp:MovieClip = $realDisp as MovieClip;
			for (var i:int = 0; i<newRealDisp.numChildren;i++){
				var clip:DisplayObject = newRealDisp.getChildAt(i);
				draw($bitmapData,clip);
			}
		}
		/**
		 * Retrieve an exported class from the asset SWF.
		 */
		public function getAssetClass( $className:String ):Class {
			if (swf) {
				return swf.loaderInfo.applicationDomain.getDefinition($className) as Class;
			}
			return null;
		}
		/**
		 * Get an instance of a MovieClip from an asset.
		 */
		public function getAssetByClass( $className:String ):MovieClip {
			var theClass:Class = getAssetClass( $className );
			if (theClass is Class) {
				return new theClass();
			}
			return null;
		}
	}
}