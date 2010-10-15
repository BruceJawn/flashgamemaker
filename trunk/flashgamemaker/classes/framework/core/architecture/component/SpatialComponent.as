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
	import framework.core.system.PhysicManager;
	import framework.core.system.IPhysicManager;
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;

	/**
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class SpatialComponent extends Component {

		private var _physicManager:IPhysicManager=null;
		//Spatial properties
		public var _spatial_speed:IsoPoint=null;// xSpeed, ySpeed and zSpeed
		public var _spatial_jump:IsoPoint=null;//JumpHorizontal, jumpVertical, jumpStart
		public var _spatial_dir:IsoPoint=null;// dirx, diry and dirz
		public var _spatial_position:IsoPoint=null;// x, y and z
		public var _spatial_properties:Object = null;
		//Timer properties
		public var _timer_delay:Number=30;
		public var _timer_count:Number=0;

		public function SpatialComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			initListener();
		}
		//------ Init Var ------------------------------------
		public function initVar():void {
			_physicManager=PhysicManager.getInstance();
			_spatial_position=new IsoPoint(0,0,0);
			_spatial_dir=new IsoPoint(0,0,0);
			_spatial_speed=new IsoPoint(2,2,1);
			_spatial_jump=new IsoPoint(0,0,-12);
			_spatial_properties = {iso:false, direction:"Diagonal", isMoving:false, isrunning:false, isJumping:false,isDoubleJumping:false, isFalling:false, isAttacking:false,isSliding:false, isClimbing:false};
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			registerProperty("spatial", _componentName);
			setPropertyReference("timer",_componentName);
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {

		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay) {
				_physicManager.move(component,_spatial_position);
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}