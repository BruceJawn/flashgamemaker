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
		public var dimension:Object;// width and height
		
		public function SwfSet($swf:DisplayObject,$graph:BitmapGraph = null,$autoAnim:Boolean=false){
			super($swf,$graph,$autoAnim);
		}
		//------ Init Var ------------------------------------
		override protected function _initVar($swf:DisplayObject,$graph:BitmapGraph, $autoAnim:Boolean):void {
			swf = $swf as MovieClip;
			if($graph){
				graph = $graph;
			}else{
				graph = new BitmapGraph;
			}
			autoAnim = $autoAnim;
		}
		//------ Create Bitmap ------------------------------------
		public function createBitmapFrom($className:String,$fps:int=30):void {
			realDisp = getAssetByClass($className);
			realDisp.x =realDisp.y=0;
			dimension = getDimension(realDisp);
			if(!realDisp){
				throw new Error("The MovieClip specified "+$className+" doesn't exist or is not exported"); 
			}
			var labels:Array = realDisp.currentLabels;
			var bitmapData:BitmapData = new BitmapData(dimension.width, dimension.height, true,0);
			var y:int =0;
			for each(var label:FrameLabel in labels){
				graph.animations[label.name] = createBitmapAnim(label, y, $fps);
				y++;
			}
			graph.currentAnim = graph.animations[labels[0].name];
			graph.currentPosition = graph.currentAnim.getCell();
		}
		//------ Create Bitmap Anim------------------------------------
		public function createBitmapAnim($label:FrameLabel, $y:int, $fps:int):BitmapAnim {
			var list:Vector.<BitmapCell> = new Vector.<BitmapCell>;
			realDisp.gotoAndStop($label.name);
			var bitmapCell:BitmapCell;
			var x:int =0;
			var bitmapData:BitmapData = new BitmapData(dimension.width, dimension.height, true,0);;
			while(realDisp.currentLabel == $label.name && realDisp.currentFrame<realDisp.totalFrames){
				bitmapData.lock();
				bitmapData.fillRect(bitmapData.rect, 0);
				if(realDisp.width> dimension.width)	trace("Error: The dimension of the clip are wrong ", realDisp.width, dimension.width);
				bitmapData.draw(realDisp,realDisp.transform.matrix);
				bitmapData.unlock();
				bitmapCell = new BitmapCell(bitmapData.clone(),x,$y,dimension.width,dimension.height);
				list.push(bitmapCell);
				x++;
				realDisp.nextFrame();
			}
			return new BitmapAnim($label.name, list, 0, $fps);
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
		/**
		 * Retrieve the max width and height of the asset SWF.
		 */
		public function getDimension( $clip:MovieClip ):Object {
			var width:Number = 0;
			var height:Number = 0;
			for(var i:int=1;  i<=$clip.totalFrames ; i++){
				width = Math.max(width, $clip.width);
				height = Math.max(height, $clip.height);
				$clip.nextFrame();
			}			
			return {width:Math.ceil(width),height:Math.ceil(height)};
		}
		//------ clone ------------------------------------
		override public function clone():BitmapSet {
			return this;
		}
	}
}