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

package framework.component.core{
	import flash.events.*;
	import flash.events.EventDispatcher;
	
	import framework.component.Component;
	import framework.entity.*;
	
	import utils.iso.IsoPoint;
	import utils.space.Space;

	/**
	* AI Component 
	* @ purpose: 
	* 
	*/
	public class AIComponent extends Component {

		private var _isRunning:Boolean = false;
		private var _timeline:Dictionary;
	
		public function AIComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("AI");
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent($propertyName:String, component:Component,$param:Object = null):void {
			if($component.hasOwnProperty("ai") && $component.hasOwnProperty("collision") &&  !_timeline[$component]){
				_timeline[$component] = {component:$component, param:$param};
				if(!_isRunning){
					_isRunning = true;
					registerPropertyReference("enterFrame", {onEnterFrame:onTick});
				}
			}else{
				throw new Error("An Ai object and a collision array must exist to be registered by AIComponent");
			}
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			for each(var object:Object in _timeline){
				checkAI(object.component,object.param);
			}
		}
		//------ CheckAI ------------------------------------
		private function checkAI():void {
			
		}
		///------ SeekTarget ------------------------------------
		public function seekTarget($component:GraphicComponent, $target:GraphicComponent):void {
			
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}