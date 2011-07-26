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

package framework.core.architecture.component{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.bitmap.BitmapAnim;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.bitmap.SwfSet;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.mouse.MousePad;
	
	/**
	* PlayerComponent Class
	*/
	public class AnimationComponent extends GraphicComponent {

		protected var _bitmapSet:* = null	//BitmapAnim property can be BitmapSet or extended to  SwfSet
		protected var _clonePool:Array;
		
		public function AnimationComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function initVar($prop:Object):void {
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("anim");
			_clonePool = new Array;
		}
		//------ On Graphic Loading Complete ------------------------------------
		override protected function onGraphicLoadingComplete($graphic:DisplayObject):void {
			if($graphic is Bitmap){
				_bitmapSet = createBitmap($graphic as Bitmap)
			}else if($graphic is MovieClip){
				_bitmapSet = createSwf($graphic as MovieClip);
			}
			_graphic = new Bitmap;
			registerPropertyReference("bitmapRender");
			registerPropertyReference("bitmapAnim");
			cloneFlush();
		}
		//------ Create Player ------------------------------------
		protected function createBitmap($graphic:Bitmap):BitmapSet {
			var bitmapSet:BitmapSet = new BitmapSet($graphic,null, true);
			bitmapSet.graph.createSimpleGraph();
			return bitmapSet;
		}
		//------ Create Swf  ------------------------------------
		protected function createSwf($graphic:MovieClip):BitmapSet {
			var frameRate:int = FlashGameMaker.stage.frameRate;
			var swfSet:SwfSet = new SwfSet($graphic,null,true);
			swfSet.createBitmapFrom("AssetDisplay",frameRate);
			swfSet.graph.createSimpleSequence();
			return swfSet;
		}
		//------ Get BitmapSet ------------------------------------
		public function get bitmapSet():BitmapSet {
			return _bitmapSet;
		}
		//------ Set BitmapSet ------------------------------------
		public function set bitmapSet($bitmapSet:BitmapSet):void {
			 _bitmapSet = $bitmapSet;
		}
		//------ Clone  ------------------------------------
		override public function clone($name:String="clone"):Component {
			var clone:AnimationComponent = _entity.entityManager.addComponentFromName(entityName,"AnimationComponent",$name) as AnimationComponent;
			clone.graphic = new Bitmap();
			if(_graphic){
				clone.bitmapSet = _bitmapSet.clone();
				clone.registerPropertyReference("bitmapRender");
				clone.registerPropertyReference("bitmapAnim");
			}else{
				_clonePool.push(clone);
			}
			return clone;
		}
		//------ Clone Flush  ------------------------------------
		private function cloneFlush():void {
			for each(var clone:AnimationComponent in _clonePool){
				clone.bitmapSet = _bitmapSet.clone();
				clone.registerPropertyReference("bitmapRender");
				clone.registerPropertyReference("bitmapAnim");
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}