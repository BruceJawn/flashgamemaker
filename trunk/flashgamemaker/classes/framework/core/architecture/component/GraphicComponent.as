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

package framework.core.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.system.GraphicManager;
	import framework.core.system.IGraphicManager;
	import utils.iso.IsoPoint;
	import utils.clip.Clip;

	import flash.events.*;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class GraphicComponent extends Component {

		protected var _graphicManager:IGraphicManager=null;
		protected var _graphicName:String=null;
		public var _graphic:* =null;
		public var _mask:Sprite;
		//Render properties
		public var _render_layerId:int=0;
		public var _render_alpha:Number=1;
		//Spatial properties
		public var _spatial_position:IsoPoint=null;
		public var _spatial_dir:IsoPoint=null;
		public var _spatial_speed:IsoPoint=null;// xSpeed, ySpeed and zSpeed
		public var _spatial_rotation:Number=0;
		public var _spatial_properties:Object=null;
		//Tweener Properties
		public var _tweener:Boolean=false;
		public var _tweener_type:String=null;
		public var _tweener_properties:Object=null;

		public function GraphicComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicManager=GraphicManager.getInstance();
			_spatial_position=new IsoPoint(0,0,0);
			_spatial_dir=new IsoPoint(0,0,0);
			_spatial_speed=new IsoPoint(2,2,1);
			_spatial_properties={dynamic:false,isMoving:false};
			_tweener_properties = new Object();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			setPropertyReference("render",_componentName);
			setPropertyReference("spatial",_componentName);
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphic(path:String,graphicName:String, layer:int=0):void {
			_graphicName=graphicName;
			_render_layerId=layer;
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			_graphicManager.loadGraphic(path,graphicName);
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphicsFromPath(path:String,graphicName:String, loadingProgress:Boolean = false):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			_graphicManager.loadGraphicsFromPath(path, graphicName);
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphicsFromXml(xml:XML,graphicName:String):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			_graphicManager.loadGraphicsFromXml(xml, graphicName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			if (_graphicName!=null) {
				_graphic=_graphicManager.getGraphic(_graphicName);
				addChild(_graphic);
			}
			dispatchEvent(evt);
		}
		//------ On Graphic Loading Progress ------------------------------------
		protected function onGraphicLoadingProgress( evt:ProgressEvent ):void {
			/*var bytesLoaded:Number = evt.bytesLoaded;
			var bytesTotal:Number = evt.bytesTotal;
			 _loadingProgress = Math.floor( 100 * bytesLoaded / bytesTotal);
			*/
			dispatchEvent(evt);
		}
		//------ Set Graphic  ------------------------------------
		public function setGraphic(graphicName:String, graphic:*, layer:int=0):void {
			_render_layerId=layer;
			if(_graphic!=null && contains(_graphic)){
				removeChild(_graphic);
			}
			_graphicName=graphicName;
			_graphic=graphic;
			addChild(_graphic);
		}
		//------ Set Graphic From Name ------------------------------------
		public function setGraphicFromName(graphicName:String, layer:int=0):void {
			_render_layerId=layer;
			var graphic:*=_graphicManager.getGraphic(graphicName);
			if(_graphic!=null && contains(_graphic)){
				removeChild(_graphic);
			}
			if(graphic!=null){
				_graphicName=graphicName;
				_graphic=graphic;
				addChild(_graphic);
			}
		}
		//------ Add Graphic ------------------------------------
		public function addGraphic(graphicName:String, clipName:String):void {
			var graphic:*=_graphicManager.getGraphic(graphicName);
			if(_graphic!=null && contains(_graphic) && graphic!=null){
				//_graphic[clipName].addChild(graphic);
			}
		}
		//------ Set Layer  ------------------------------------
		public function setLayer(graphicName:String, layerId:int):void {
			_render_layerId=layerId;
			_graphicManager.setLayer(graphicName,layerId);
		}
		//------ Get Graphic  ------------------------------------
		public function getGraphic(graphicName:String):* {
			var graphic:*=_graphicManager.getGraphic(graphicName);
			return graphic;
		}
		//------ Get Graphic Name  ------------------------------------
		public function getGraphicName():String {
			return _graphicName;
		}
		//------ Move Graphic  ------------------------------------
		public function moveTo(x:Number,y:Number):void {
			_spatial_position.x=x;
			_spatial_position.y=y;
			//update("spatial");
		}
		//------ Center  ------------------------------------
		public function center():void {
			_spatial_position.x=(FlashGameMaker.WIDTH-this.width)/2;
			_spatial_position.y=(FlashGameMaker.HEIGHT-this.height)/2;
			//update("spatial");
		}
		//------ Rotate Graphic  ------------------------------------
		public function rotate():void {
			if (_spatial_rotation!=0) {
				this.rotation+=_spatial_rotation;
			}
		}
		//------ SetRotation  ------------------------------------
		public function setRotation(angle:Number):void {
			_spatial_rotation=angle;
		}
		//------Set Movment Tweener -------------------------------------
		public function setMovmentTweener(destination:Point,speed:int=1,autodestruction:Boolean=false):void {
			_tweener=true;
			_tweener_properties.movment=true;
			_tweener_properties.destination=destination;
			_tweener_properties.speed=speed;
			_tweener_properties.autodestruction=autodestruction;
			setPropertyReference("tween",_componentName);
		}
		//------Set Shape Tweener -------------------------------------
		public function setShapeTweener(width:Number,height:Number,delay:int=30,autodestruction:Boolean=false):void {
			_tweener=true;
			_tweener_properties.shape=true;
			setPropertyReference("tween",_componentName);
		}
		//------ SetMask  ------------------------------------
		public function setMask(x:int,y:int,width:int,height:int):void {
			_mask = new Sprite();
			_mask.graphics.beginFill(0x0000FF);
			_mask.graphics.drawRect(x,y,width,height);
			_mask.graphics.endFill();
			this.mask=_mask;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}