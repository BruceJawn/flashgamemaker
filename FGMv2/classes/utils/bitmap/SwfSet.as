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
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SwfSet extends BitmapSet{
		
		public var swf:MovieClip = null; 		//SWF Container
		public var realDisp:MovieClip = null;	//MovieClip to display
		public var bounds:Rectangle = null;// width and height
		
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
			if(!bounds)	bounds = getDimension(realDisp);
			if(!realDisp){
				throw new Error("The MovieClip specified "+$className+" doesn't exist or is not exported"); 
			}
			var labels:Array = realDisp.currentLabels;
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true,0);
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
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true,0);
			while(realDisp.currentLabel == $label.name && realDisp.currentFrame<realDisp.totalFrames){
				bitmapData.lock();
				bitmapData.fillRect(bitmapData.rect, 0);
				if(realDisp.width> bounds.width || realDisp.height> bounds.height)	
					trace("Error: The dimension of the clip are wrong ", realDisp.width, bounds.width , realDisp.height, bounds.height);
				var matrix:Matrix = new Matrix()
				matrix.tx = -bounds.x;
				matrix.ty = -bounds.y;
				bitmapData.draw(realDisp,realDisp.transform.matrix);
				bitmapData.unlock();
				bitmapCell = new BitmapCell(bitmapData.clone(),x,$y,bounds.width,bounds.height);
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
		public function getDimension( $clip:MovieClip ):Rectangle {
			var width:Number = 0;
			var height:Number = 0;
			var x:Number = 0;
			var y:Number = 0;
			var bounds:Rectangle = $clip.getBounds(null);
			for(var i:int=1;  i<=$clip.totalFrames ; i++){
				bounds = $clip.getBounds(null);
				width = Math.max(width, bounds.width);
				height = Math.max(height, bounds.height);
				x = Math.max(x, bounds.x);
				y = Math.max(y, bounds.y);
				$clip.nextFrame();
			}
			return new Rectangle(x,y,width+x,height+y);
		}
		//------ clone ------------------------------------
		override public function clone():BitmapSet {
			return this;
		}
	}
}