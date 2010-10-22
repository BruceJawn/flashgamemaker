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
	import framework.core.system.GraphicManager;
	import framework.core.system.IGraphicManager;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Matrix;

	/**
	* Renderer Component
	* @ purpose: 
	* 
	*/
	public class RenderComponent extends Component {

		private var _graphicManager:IGraphicManager=null;

		protected var _layerIndex:int=0;

		protected var _width:Number=50;
		protected var _height:Number=50;

		protected var _alpha:Number=1;
		protected var _scaleX:Number=1;
		protected var _scaleY:Number=1;
		protected var _rotation:Number=0;

		protected var _blendMode:String=BlendMode.NORMAL;
		protected var _transformMatrix:Matrix = new Matrix();

		public function RenderComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_graphicManager=GraphicManager.getInstance();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("render", _componentName);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {

		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (! _graphicManager.containsGraphic(componentName)) {
				var _render_layerId:int=component._render_layerId;
				var _render_alpha:Number=component._render_alpha;
				component.alpha = _render_alpha;
				_graphicManager.displayGraphic(componentName,component,_render_layerId);
			}
		}
		//------ Reset  ------------------------------------
		public override function reset(ownerName:String, componentName:String):void {
			_graphicManager.removeGraphic(componentName);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}