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
	import flash.utils.Dictionary;
	import flash.events.*;
	import fl.controls.ProgressBar;

	/**
	* Spatial Component 
	* @ purpose: 
	* 
	*/
	public class JaugeMoveComponent extends Component {

		//Jauge properties
		public var _jauge:ProgressBar=null;
		public var _jauge_count:Number=0;
		public var _jauge_max:Number=100;

		public function JaugeMoveComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		protected function initVar():void {

		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("jauge",_componentName);
			registerProperty("jaugeMove",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			updateSpeed(component);
		}
		//------ Update Speed  ------------------------------------
		private function updateSpeed(component:*):void {
			if (_jauge_count>0) {
				component._spatial_dir.x=1;
				component._spatial_speed.x=Math.round(_jauge_count/20);
				component._spatial_properties.isMoving=true;
				component._spatial_properties.isRunning=true;
			} else {
				component._spatial_dir.x=0;
				component._spatial_speed.x=2;
				component._spatial_properties.isMoving=false;
				component._spatial_properties.isRunning=false;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}