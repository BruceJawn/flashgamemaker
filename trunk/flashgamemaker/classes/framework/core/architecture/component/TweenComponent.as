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

	/**
	* Tween Class
	*/
	public class TweenComponent extends Component {

		//Tweener Properties
		public var _tweener:Boolean=false;
		public var _tweener_type:String=null;
		public var _tweener_properties:Object=null;
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=15;
		public var _timer_count:Number=0;


		public function TweenComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("tween",_componentName);
			setPropertyReference("timer",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName && (_timer_count>=_timer_delay||! _timer_on)) {
				update("tween");
			} else if (componentName!=_componentName) {
				if (component._tweener) {
					if (component._tweener_properties.movment) {
						tweenMove(component);
					}
					if (component._tweener_properties.shape) {
						tweenShape(component);
					}
				}
			}
		}
		//------- Tween Move -------------------------------
		private function tweenMove(component:*):void {
			if (Math.round(component._spatial_position.x)!=Math.round(component._tweener_properties.destination.x)||Math.round(component._spatial_position.y)!=Math.round(component._tweener_properties.destination.y)) {
				if (component._spatial_position.x<component._tweener_properties.destination.x) {
					component._spatial_position.x+=component._tweener_properties.speed;
					if (component._spatial_position.x>component._tweener_properties.destination.x) {
						component._spatial_position.x=component._tweener_properties.destination.x;
					}
				} else if (component._spatial_position.x>component._tweener_properties.destination.x) {
					component._spatial_position.x-=component._tweener_properties.speed;
					if (component._spatial_position.x<component._tweener_properties.destination.x) {
						component._spatial_position.x=component._tweener_properties.destination.x;
					}
				}
				if (component._spatial_position.y<component._tweener_properties.destination.y) {
					component._spatial_position.y+=component._tweener_properties.speed;
					if (component._spatial_position.y>component._tweener_properties.destination.y) {
						component._spatial_position.y=component._tweener_properties.destination.y;
					}
				} else if (component._spatial_position.y>component._tweener_properties.destination.y) {
					component._spatial_position.y-=component._tweener_properties.speed;
					if (component._spatial_position.y<component._tweener_properties.destination.y) {
						component._spatial_position.y=component._tweener_properties.destination.y;
					}
				}
			} else {
				if (component._tweener_properties.autodestruction) {
					removeComponent(component._componentName);
				}
			}
		}
		//------- Tween Shape -------------------------------
		private function tweenShape(component:*):void {

		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}