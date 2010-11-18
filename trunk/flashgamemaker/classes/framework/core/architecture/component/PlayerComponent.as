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
	import utils.iso.IsoPoint;

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
		public var _keyboard_gamePad:Object=null;
		//Spatial properties
		public var _spatial_jump:IsoPoint=null;
		public var _spatial_jumpStart:IsoPoint=null;
		//Attack properties
		public var _attack:Number=1;
		//Health properties
		public var _health_life:Number=10;
		public var _health_lifeMax:Number=10;
		public var _health_hit:Number=0;

		public function PlayerComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_serverManager=ServerManager.getInstance();
			_render_layerId=1;
			_animation=new Dictionary  ;
			_animation["STATIC"]=0;
			_animation["WALK"]=1;
			_colorPicker=new ColorPicker  ;
			_spatial_properties={dynamic:true,collision:false,isMoving:false,isrunning:false,isJumping:false,isDoubleJumping:false,isFalling:false,isAttacking:false,isSliding:false,isClimbing:false};
			_spatial_jump=new IsoPoint(0,0,0);
			_spatial_jumpStart=new IsoPoint(-12,-12,-20);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			_colorPicker.addEventListener(Event.CHANGE,onColorPickerChange);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("animation",_componentName);
			setPropertyReference("progressBar",_componentName);
		}
		//------ Load Player ------------------------------------
		public function loadPlayer(path:String,playerName:String,layer:int=0):void {
			_playerName=playerName;
			_render_layerId=layer;
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
					loadGraphicsFromXml(_playerXml,_playerName);
				} else {
					loadGraphic(_playerTexture,_playerXml.children()[0].name(),_render_layerId);
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
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			createPlayer();
			dispatchEvent(evt);
		}
		//------ Set Graphic From Name ------------------------------------
		public override function setGraphicFromName(graphicName:String,layer:int=0):void {
			_render_layerId=layer;
			var graphic:*=_graphicManager.getGraphic(graphicName);
			if (_graphic!=null&&contains(_graphic)) {
				removeChild(_graphic);
			}
			if (graphic!=null) {
				_graphicName=graphicName;
				_graphic=graphic;
				createPlayer();
			}
		}
		//------ Set Animation ------------------------------------
		public function setAnimation(animation:Dictionary):void {
			_animation=animation;
		}
		//------ Set Anim ------------------------------------
		public function setAnim(animation:String,index:int):void {
			_animation[animation]=index;
		}
		//------ Get Position ------------------------------------
		public function getPosition():IsoPoint {
			return _spatial_position;
		}
		//------ Get Direction ------------------------------------
		public function getDirection():IsoPoint {
			return _spatial_dir;
		}
		//------ Get Facing Direction ------------------------------------
		public function getFacingDirection():String {
			if (Math.round(_graphic_frame/_graphic_numFrame)==1) {
				return "RIGHT";
			} else if (Math.round(_graphic_frame/_graphic_numFrame)==2) {
				return "DOWN";
			} else if (Math.round(_graphic_frame/_graphic_numFrame)==3) {
				return "LEFT";
			}
			return "UP";
		}
		//------ Get Speed ------------------------------------
		public function getSpeed():IsoPoint {
			return _spatial_speed;
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
		//------ Set Collision  ------------------------------------
		public function setCollision(collision:Boolean):void {
			_spatial_properties.collision=collision;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}