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
	import framework.core.architecture.entity.*;
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;
	import framework.core.system.ServerManager;
	import framework.core.system.IServerManager;

	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.display.*;
	import flash.utils.Dictionary;
	import fl.controls.ColorPicker;

	/**
	* Player Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class PlayerComponent extends GraphicComponent {

		private var _ressourceManager:IRessourceManager=null;
		private var _serverManager:IServerManager=null;
		protected var _playerXml:XML=null;
		protected var _playerName:String=null;
		protected var _playerTexture:String=null;
		protected var _playerHeight:Number;
		protected var _playerWidth:Number;
		protected var _colorPicker:ColorPicker=null;
		//Graphic properties
		public var _graphic_frame:int=1;
		public var _graphic_oldFrame:int=0;
		public var _graphic_numFrame:int=4;
		//Animation properties
		public var _animation:Dictionary=null;
		//Keyboard properties
		public var _keyboard_key:Object=null;

		public function PlayerComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_serverManager=ServerManager.getInstance();
			_render_layerId=1;
			_animation = new Dictionary();
			_animation["STATIC"]=0;
			_animation["WALK"]=1;
			_colorPicker = new ColorPicker();
			addChild(_colorPicker);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			_colorPicker.addEventListener(Event.CHANGE, onColorPickerChange);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("animation",_componentName);
			setPropertyReference("progressBar",_componentName);
		}
		//------ Load Player ------------------------------------
		public function loadPlayer(path:String, playerName:String):void {
			_playerName=playerName;
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
			_ressourceManager.loadXml(path,playerName);
		}
		//------ Set Player ------------------------------------
		public function setPlayer(playerName:String):void {
			var graphic:* =getGraphic(playerName);
			if (graphic==null) {
				throw new Error("The graphic "+playerName+" doesn't exist !!");
			}
			setGraphic(playerName,graphic);
		}
		//------ On Xml Loading Successfull ------------------------------------
		protected function onXmlLoadingSuccessful(evt:Event):void {
			_playerXml=_ressourceManager.getXml(_playerName);
			if (_playerXml!=null) {
				var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
				dispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
				serializeXml();
				if (_playerXml.children().length()>1) {
					loadGraphicsFromXml(_playerXml, _playerName);
				} else {
					loadGraphic(_playerTexture, _playerName);
				}
			}
		}
		//------ Serialize Xml ------------------------------------
		private function serializeXml():void {
			_playerTexture=_playerXml.children().path;
			_playerWidth=_playerXml.@playerWidth;
			_playerHeight=_playerXml.@playerHeight;
		}
		//------ Create Player ------------------------------------
		protected function createPlayer():void {

		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			createPlayer();
		}
		//------ Set Animation ------------------------------------
		public function setAnimation(animation:Dictionary):void {
			_animation=animation;
		}
		//------ Set Iso ------------------------------------
		public function setIso(iso:Boolean):void {
			_spatial_properties.iso=iso;

		}
		//------ On Color Picker Change ------------------------------------
		private function onColorPickerChange(evt:Event):void {
			var hexColor:String=evt.target.hexValue;
			changeColor(hexColor);
			evt.target.stage.focus=null;
		}
		//------ Change Color ------------------------------------
		public function changeColor(hexColor:String):void {

		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}