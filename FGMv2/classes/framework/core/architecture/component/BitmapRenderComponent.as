﻿/*
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
/*
* Inspired from Iain Lobb - iainlobb@googlemail.com
* BunnyBenchMark Experiment http://www.iainlobb.com/bunnies/BlitTest.html
*/

package framework.core.architecture.component{
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.core.architecture.entity.*;
	
	import utils.mouse.MousePad;

	/**
	* Bitmap Render Component: Manage the graphical rendering
	*/
	public class BitmapRenderComponent extends Component {

		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _isRunning:Boolean = false;
		private var _timeline:Vector.<Component>;
		private var _drawableComponent:Vector.<Component>;
		private var _lastClick:Point = null;
		private var _position:Point = null;
		
		public function BitmapRenderComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $param:Object = null) {
			super($componentName, $entity, $singleton);
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_bitmapData = new BitmapData(FlashGameMaker.width, FlashGameMaker.height,true,0);
			_bitmap = new Bitmap(_bitmapData);
			_timeline = new Vector.<Component>;
			FlashGameMaker.AddChild(_bitmap,this);//Properties of BitmapRender will influe Display
			FlashGameMaker.AddChild(this);
			_position = new Point(0,0);
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("bitmapRender");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "bitmapRender") {
				displayComponent($component, $param);
			}
		}
		//------ Display Component ------------------------------------
		public function displayComponent($component:Component, $param:Object = null):void {
			//Check properties
			if($component.hasOwnProperty("graphic") && $component.graphic is Bitmap) {
				if(_timeline.indexOf($component)==-1){
					_timeline.push($component);
					if(!_isRunning){
						_isRunning = true;
						registerPropertyReference("enterFrame", {onEnterFrame:onTick});
						registerPropertyReference("mouseInput",{onMouseDown:onMouseDown, onMouseUp:onMouseUp});
						
					}
				}
			}else{
				throw new Error("A graphic must exist to be registered by BitmapRenderComponent");
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			updateView();
			_bitmapData.lock();
			_bitmapData.fillRect(_bitmapData.rect, 0);
			_drawableComponent = new Vector.<Component>;
			for each(var component:Component in _timeline){
				component.x-=_position.x;
				component.y-=_position.y;
				if (component.x+component.width >_bitmap.x && component.x <_bitmap.x+FlashGameMaker.width){
					if (component.y+component.height>_bitmap.y && component.y <_bitmap.y+FlashGameMaker.height){
						_drawableComponent.push(component);
					}
				}
			}
			_drawableComponent.sort(sortDepths);
			for each(component in _drawableComponent){
				_bitmapData.draw(component.graphic, component.transform.matrix); 
			}
			_bitmapData.unlock();
		}
		//------ Update View ------------------------------------
		private function updateView():void {
			if(_lastClick){
				/*_bitmap.x-=_lastClick.x - mouseX;
				_bitmap.y-= _lastClick.y - mouseY;*/
				_position.x= _lastClick.x - mouseX;
				_position.y= _lastClick.y - mouseY;
				_lastClick.x = mouseX;
				_lastClick.y = mouseY;
			}
		}
		//------ Sort Depths ------------------------------------
		private function sortDepths($component1:Component, $component2:Component):int{
			if ($component1.y < $component2.y ) return -1;
			if ($component1.y > $component2.y) return 1;
			return 0;
		}
		//------ Remove Graphic ------------------------------------
		public function removeComponent($component:Component):void {
			
		}
		//------ On Mouse Down  ------------------------------------
		public function onMouseDown($mousePad:MousePad ,$hitTest:Boolean, $isClicked:Boolean):void {
			if(!_lastClick && !$isClicked){
				_lastClick = new Point($mousePad.mouseEvent.stageX,$mousePad.mouseEvent.stageY);
			}
		}
		//------ On Mouse UP  ------------------------------------
		public function onMouseUp($mousePad:MousePad ,$hitTest:Boolean, $isClicked:Boolean):void {
			_lastClick = null;
			_position = new Point(0,0)
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}