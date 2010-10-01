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
	
	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.display.*;
    import flash.geom.Matrix;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class GraphicComponent extends Component{

		protected var _graphicManager:IGraphicManager = null;
		protected var _graphicName:String = null;
		protected var _loadingProgress:Boolean = false;
  		protected var _graphic:* = null;
        
		//Render properties
		public var _render_layerId:int=0;
		public var _render_alpha:Number =1;
		/*public var _width:Number;
		public var _height:Number;
		public var _scaleX:Number = 1;
		public var _scaleY:Number = 1;
        public var _rotation:Number = 0;
		public var _blendMode:String = BlendMode.NORMAL;
		public var _transformMatrix:Matrix = new Matrix();*/
		
		//Spatial properties
		public var _spatial_speed:IsoPoint = null;
		public var _spatial_position:IsoPoint = null
		public var _spatial_dir:IsoPoint = null
		public var _spatial_isMoving:Boolean = false;
		        
		public function GraphicComponent(componentName:String, componentOwner:IEntity){
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicManager = GraphicManager.getInstance();
			_graphic = addChild(new Sprite());
			_spatial_position = new IsoPoint(0,0,0);
			_spatial_dir = new IsoPoint(0,0,0);
			_spatial_speed= new IsoPoint(4,4,2);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			setPropertyReference("render",_componentName);
			setPropertyReference("spatial",_componentName);
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphic(path:String,graphicName:String, loadingProgress:Boolean = false):void {
			_graphicName = graphicName;
			_loadingProgress = loadingProgress;
			var dispatcher:EventDispatcher = _graphicManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			_graphicManager.loadGraphic(path,graphicName);
		}
		//------ Load Graphic  ------------------------------------
		public function loadGraphicsFromPath(path:String,graphicName:String, loadingProgress:Boolean = false):void {
			var dispatcher:EventDispatcher = _graphicManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			_graphicManager.loadGraphicsFromPath(path, graphicName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher = _graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			if(_graphicName!=null){
				setGraphic(_graphicName,_graphicName);
			}
		}
		//------ On Graphic Loading Progress ------------------------------------
		protected function onGraphicLoadingProgress( evt:ProgressEvent ):void {
			if(_loadingProgress){
				trace(evt);
			}
		}
		//------ Set Graphic  ------------------------------------
		public function setGraphic(graphicName:String, graphic:*):void {
			removeChild(_graphic);
			_graphicName = graphicName;
			_graphic = graphic;
			addChild(_graphic);
		}
		//------ Get Graphic  ------------------------------------
		public function getGraphic(graphicName:String):* {
			var graphic = _graphicManager.getGraphic(graphicName);
			return graphic;
		}
		//------ Get Graphic Name  ------------------------------------
		public function getGraphicName():String {
			return _graphicName;
		}
		//------ Display Graphic  ------------------------------------
		private function displayGraphic():void {
			_graphicManager.displayGraphic(_graphicName,this,0);
		}
		//------ Remove Graphic  ------------------------------------
		private function removeGraphic(graphicName:String):void {
			_graphicManager.removeGraphic(_graphicName);
		}
		//------ Move Graphic  ------------------------------------
		public function moveTo(x:Number,y:Number):void {
			_spatial_position.x=x;
			_spatial_position.y=y;
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}