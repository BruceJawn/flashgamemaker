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
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import framework.core.architecture.entity.IEntity;
	
	import utils.bitmap.BitmapCell;
	import utils.bitmap.BitmapGraph;
	import utils.bitmap.BitmapSet;
	import utils.keyboard.KeyPad;
	
	
	/**
	* BitmapAnimComponent Class
	*/
	public class BitmapAnimComponent extends Component {
		
		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
		
		public function BitmapAnimComponent($componentName:String, $entity:IEntity, $singleton:Boolean=true, $prop:Object = null) {
			super($componentName, $entity, $singleton, $prop);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		protected function _initVar($prop:Object):void {
			_timeline = new Dictionary(true);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("bitmapAnim");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "bitmapAnim") {
				updateComponent($component);
			}
		}
		//------ Update Component------------------------------------
		protected function updateComponent($component:Component):void {
			//Check properties
			if($component.hasOwnProperty("graphic") && $component.graphic is Bitmap && $component.hasOwnProperty("bitmapSet") && $component.bitmapSet) {
				if($component.bitmapSet.autoAnim && !_timeline[$component]){
					_timeline[$component] = $component;
					if(!_isRunning){
						_isRunning = true;
						registerPropertyReference("enterFrame", {callback:onTick});
					}
				}
				updateFrame($component);
			}else{
				throw new Error("A bitmapSet and graphic must exist to be registered by BitmapAnimComponent");
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			for each(var $component:Component in _timeline){
				updateAnim($component);
				updateFrame($component);
			}
		}
		//------ Update Component------------------------------------
		protected function updateFrame($component:Component):void {
			var bitmapSet:BitmapSet = $component.bitmapSet;
			var position:BitmapCell = bitmapSet.position;
			var source:Bitmap = bitmapSet.bitmap;
			if(source){
				var myBitmapData:BitmapData=new BitmapData(position.width,position.height,true,0);
				myBitmapData.lock();
				myBitmapData.copyPixels(source.bitmapData, new Rectangle(position.x, position.y,position.width,position.height), new Point(0, 0),null,null,true);
				myBitmapData.unlock();
				$component.graphic.bitmapData=myBitmapData;
			}else if(position.bitmapData){
				$component.graphic.bitmapData=position.bitmapData.clone();
			}
		}
		//------ Update Anim------------------------------------
		protected function updateAnim($component:Component):void {
			var bitmapSet:BitmapSet = $component.bitmapSet;
			var graph:BitmapGraph = bitmapSet.graph;
			graph.anim();
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}