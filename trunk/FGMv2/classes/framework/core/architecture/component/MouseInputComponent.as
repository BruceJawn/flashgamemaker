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
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import framework.core.architecture.entity.*;
	
	import utils.mouse.MousePad;
	import utils.time.*;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MouseInputComponent extends Component {
		private var _isListening:Boolean = false;
		
		private var _mousePad:MousePad;
		private var _doubleClick:Boolean = false;
		private var _longClick:Boolean = false;
		private var _longClickLatence:Number = 575;
		private var _timer:Number = 0;
		private var _interval:Number = 0;
		private var _list:Dictionary;
		private var _rollOverComponent:Component = null;//track the last rollovered component
		private var _rollOutCallBack:Function = null;
		private var _isClicked:Boolean = false;
		
		public function MouseInputComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $prop:Object = null) {
			super($componentName, $entity, $singleton);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_mousePad = new MousePad;
			FlashGameMaker.clip.doubleClickEnabled = true;
			_list = new Dictionary(true);
			_list["Component"] = new Array;
			_list["onMouseClick"] = new Array;
			_list["onMouseDown"] = new Array;
			_list["onMouseUp"] = new Array;
			_list["onMouseMove"] = new Array;
			_list["onMouseWheel"] = new Array;
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("mouseInput");
		}
		//------ Init Listener ------------------------------------
		public function initListener():void {
			FlashGameMaker.stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			FlashGameMaker.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		//------ Remove Listener ------------------------------------
		public function removeListener():void {
			FlashGameMaker.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			FlashGameMaker.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "mouseInput") {
				if(!_isListening){
					_isListening=true;
					initListener();
					registerPropertyReference("enterFrame", {onEnterFrame:onTick});
				}
				addToList($component,$param);
			}
		}
		//------ Add To List ------------------------------------
		private function addToList($component:Component, $param:Object):void {
			var componentList:Array = _list["Component"];
			if(componentList.indexOf($component)!=-1)		return; //Component already assigned to list
			
			if($param.hasOwnProperty("onMouseMove") || $param.hasOwnProperty("onMouseRollOut") || $param.hasOwnProperty("onMouseRollOver")){
				_list["onMouseMove"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseDown")){
				_list["onMouseDown"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseUp")){
				_list["onMouseUp"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseClick")){
				_list["onMouseClick"].push({component:$component,param:$param});
			}
			if($param.hasOwnProperty("onMouseWheel")){
				_list["onMouseWheel"].push({component:$component,param:$param});
			}
		}
		//------ On Dispatch ------------------------------------
		private function dispatch($callback:String):void {
			var components:Vector.<Object> = _properties["mouseInput"];
			_list[$callback].sort(sortDepths);
			for each (var object:Object in _list[$callback]){
				if($callback == "onMouseMove"){
					if(object.param.hasOwnProperty("onMouseRollOut") && _rollOverComponent==object.component && !checkPosition(object.component)){
						switchHandCursor(false);
						object.param["onMouseRollOut"](_mousePad);
						_rollOverComponent=null;
						return;
					}else if(object.param.hasOwnProperty("onMouseRollOver") && _rollOverComponent!=object.component && checkPosition(object.component)){
						if(_rollOverComponent && checkPosition(_rollOverComponent) && _rollOverComponent.y>object.component.y){
							return
						}
						switchHandCursor(true);
						if(_rollOverComponent){
							_rollOutCallBack(_mousePad);
						}
						object.param["onMouseRollOver"](_mousePad);
						_rollOverComponent=object.component;
						if(object.param.hasOwnProperty("onMouseRollOut"))
							_rollOutCallBack = object.param["onMouseRollOut"];
						return;
					}
				}else{
					object.param[$callback](_mousePad, checkPosition(object.component), _isClicked);
					if($callback == "onMouseDown" && checkPosition(object.component) &&!_isClicked)	
						_isClicked = true;
				}
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			if(_mousePad && _mousePad.mouseEvent)
				dispatch("onMouseMove");
		}
		//------ Check Position ------------------------------------
		private function checkPosition($component:Component):Boolean {
			if(!$component)	return false;
			var graphic:DisplayObject = $component as DisplayObject;
			var bounds:Rectangle = $component.getBounds(null);
			if(bounds.width == 0 || bounds.height == 0){
				if(!($component.hasOwnProperty("graphic") &&  $component.graphic) || $component.graphic.width==0 || $component.graphic.height ==0){
					return false
				}
				graphic =  $component.graphic as DisplayObject;
				bounds  =  $component.graphic.getBounds(null);
			}
			bounds.x=$component.x;
			bounds.y=$component.y;
			//Bounds Drawing
//			var b:Sprite= new Sprite();
//			b.graphics.beginFill(0xFF0000);
//			b.graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
//			b.graphics.endFill();
//			FlashGameMaker.AddChild(b);
			var mouse:Point = new Point(_mousePad.mouseEvent.stageX,_mousePad.mouseEvent.stageY);
			//Mouse Drawing
//			var ms:Sprite= new Sprite();
//			ms.graphics.beginFill(0x0000FF);
//			ms.graphics.drawRect(mouse.x-15,mouse.y-15,30,30);
//			ms.graphics.endFill();
//			FlashGameMaker.AddChild(ms);
			
			if(bounds.containsPoint(mouse)){
				var bitmapData:BitmapData =new BitmapData(graphic.width,graphic.height,true, 0);
				bitmapData.draw(graphic,graphic.transform.matrix);
				var pixel:uint = bitmapData.getPixel32(mouse.x-bounds.x ,mouse.y-bounds.y);
				var alphaValue:uint = pixel >> 24 & 0xFF;
				if(alphaValue>0){
					return true;
				}
				return false
			}
			return false;
		}
		//------ On MouseEvent ------------------------------------
		private function onMouseEvent($evt:MouseEvent ,$callBack:String):void {
			updateMouse($evt);
			dispatch($callBack);
		}
		//------ On Mouse Down ------------------------------------
		private function onMouseDown($evt:MouseEvent):void {
			initTimer();
			onMouseEvent($evt, "onMouseDown");
		}
		//------ On Mouse Up ------------------------------------
		private function onMouseUp($evt:MouseEvent):void {
			updateTimer();
			checkLongClick();
			onMouseEvent($evt, "onMouseUp");
			_isClicked = false;
		}
		//------ On Mouse Click ------------------------------------
		private function onMouseClick($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseClick");
		}
		//------ On Mouse Move ------------------------------------
		private function onMouseMove($evt:MouseEvent):void {
			updateMouse($evt);
		}
		//------ On Mouse Wheel ------------------------------------
		private function onMouseWheel($evt:MouseEvent):void {
			onMouseEvent($evt, "onMouseWheel");
		}
		//------ Update Mouse ------------------------------------
		private function updateMouse($evt:MouseEvent):void {
			_mousePad.mouseEvent = $evt;
			_mousePad.clickDuration = _interval;
		}
		//------ Init Timer ------------------------------------
		private function initTimer():void {
			_timer = getTime();
			_interval = -1;
		}
		//------ Update Timer ------------------------------------
		private function checkTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Update Timer ------------------------------------
		private function updateTimer():void {
			_interval = getTime() - _timer;
		}
		//------ Check Long Click ------------------------------------
		private function checkLongClick():void {
			if(_interval>_longClickLatence){
				_longClick = true;
			}else{
				_longClick = false;
			}
		}
		//---- Get Time ------------------------------------------------
		private function getTime():Number{
			return Time.GetTime();
		}	
		//---- Use Hand Cursor ------------------------------------------------
		private function switchHandCursor($bool:Boolean):void{
			if($bool)
				Mouse.cursor=MouseCursor.BUTTON;
			else
				Mouse.cursor=MouseCursor.AUTO;
		}
		//------ Sort Depths ------------------------------------
		private function sortDepths($object1:Object, $object2:Object):int{
			if ($object1.component.y < $object2.component.y ) return 1;
			if ($object1.component.y > $object2.component.y) return -1;
			return 0;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}