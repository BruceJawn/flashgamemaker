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
	import framework.core.system.ServerManager;
	import framework.core.system.IServerManager;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.geom.Point;
	import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.geom.Matrix;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class RenderComponent extends Component{

		private var _graphicManager:IGraphicManager = null;
  
        protected var _layerIndex:int = 0;
        protected var _zIndex:int = 0;
		
        protected var _position:Point = new Point();
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _alpha:Number = 1;
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
        protected var _rotation:Number = 0;
       
		protected var _blendMode:String = BlendMode.NORMAL;
		protected var _transformMatrix:Matrix = new Matrix();
        
		public function RenderComponent(componentName:String, componentOwner:IEntity){
			super(componentName,componentOwner);
			initVar();
			initProperties();
			initListener();
			
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicManager = GraphicManager.getInstance();
		}
		//------ Load Graphic  ------------------------------------
		private function loadGraphic(graphicName:String):Sprite {
			
		}
		//------ Get Graphic  ------------------------------------
		private function getGraphic(graphicName:String):Sprite {
			
		}
		//------ Display Graphic  ------------------------------------
		private function displayGraphic(graphicName:String):Sprite {
			
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}