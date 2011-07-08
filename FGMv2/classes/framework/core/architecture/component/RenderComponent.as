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
	import flash.display.*;
	import flash.utils.Dictionary;
	
	import framework.core.architecture.entity.*;

	/**
	* Renderer Component: Manage the graphical rendering and layout of an Entity's graphical components
	*/
	public class RenderComponent extends Component {

		private var _layers:Array;
		private var _defaultLayer:int = 0;
		private var _defaultAlign:String = "left";
		
		public function RenderComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true, $param:Object = null) {
			super($componentName, $entity, $singleton);
			_initVar();
			_initListener();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_layers = new Array();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("render");
		}
		//------ Init Listener ------------------------------------
		private function _initListener():void {

		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeProperty($propertyName:String):void {
			var components:Vector.<Object> = _properties[$propertyName];
			if ($propertyName == "render" && components) {
				for each (var object:Object in components){
					actualizePropertyComponent($propertyName, object.component);
				}
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizePropertyComponent($propertyName:String, $component:Component, $param:Object = null):void {
			if ($propertyName == "render") {
				super.actualizePropertyComponent($propertyName,$component, $param);
				displayComponent($component, $param);
			}
		}
		//------ Display Component ------------------------------------
		public function displayComponent($component:Component, $param:Object = null):void {
			var layer:int = _defaultLayer;
			if($param && $param.hasOwnProperty("layer")){
				layer = $param.layer;
			}	
			if (layer>=_layers.length) {
				createNewLayer();
			}
			_layers[layer].layer.addChild($component);
			_layers[layer].components.push($component);
		}
		//------ Create New Layer ------------------------------------
		public function createNewLayer():void {
			var layer:Sprite = new Sprite();
			FlashGameMaker.AddChild(layer as DisplayObject);
			var components:Vector.<Component> = new Vector.<Component>;
			_layers.push({layer:layer, components:components});
		}
		//------ Remove Graphic ------------------------------------
		public function removeComponent($component:Component):void {
			
		}
		//------ Remove Layer ------------------------------------
		public function removeLayer($layer:int):void {
			if ($layer>=_layers.length) {
				throw new Error("The index "+$layer+" is out of bond!!");
			}
			var layer:Sprite=_layers[$layer];
			FlashGameMaker.RemoveChild(layer);
			_layers.splice($layer,1);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}