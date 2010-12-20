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
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.events.*;

	/**
	* AI Component 
	* @ purpose: 
	* 
	*/
	public class AIComponent extends Component {

		private var _mode:String="2Dir";
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=120;
		public var _timer_count:Number=0;

		public function AIComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			setPropertyReference("timer",_componentName);
			registerProperty("AI", _componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName && (_timer_count>=_timer_delay||! _timer_on)) {
				update("AI");
			} else if (componentName!=_componentName && (_timer_count>=_timer_delay||! _timer_on)) {
				updateAI(component);
			}
		}
		//-- Update Frame ---------------------------------------------------
		private function updateAI(component:*):void {
			if(component._ai_behaviour=="follower"&&  component._ai_target!=null){
				follow(component);
			}
		}
		//-- Follow ---------------------------------------------------
		private function look(component:*):void {
			if(Math.abs(component.x-component._ai_target.x)>10){
				if(component.x<component._ai_target.x){
					component._spatial_dir.x=1;
				}else if(component.x>component._ai_target.x){
					component._spatial_dir.x=-1;
				}
			}
		}
		//-- Follow ---------------------------------------------------
		private function follow(component:*):void {
			if(Math.abs(component.x-component._ai_target.x)>component.width/2){
				if(component.x<component._ai_target.x){
					component._spatial_dir.x=1;
					component._spatial_properties.isMoving = true;
				}else if(component.x>component._ai_target.x){
					component._spatial_dir.x=-1;
					component._spatial_properties.isMoving = true;
				}
			}else{
				component._spatial_properties.isMoving = false;
			}
		}
		//-- Set AI ---------------------------------------------------
		public function setAI(component:*,behaviour:String, target:*):void {
			component._ai_behaviour=behaviour;
			component._ai_target=target;
		}
		//-- Set Direction ---------------------------------------------------
		public function setDirection(component:*):void {
			
		}

		//------ Set Mode  ------------------------------------
		public function setMode(mode:String):void {
			if (! (mode=="2Dir" || mode=="4Dir"||mode=="4DirIso") ) {
				throw new Error("Error AIComponent: direction must be 2Dir, 4Dir or 4dirIso");
			}
			_mode=mode;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}