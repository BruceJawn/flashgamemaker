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
	* Entity Class
	*/
	public class HealthComponent extends Component {
		
		public function HealthComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
			
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("health",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (componentName==_componentName) {
				var healthComponents:Array=getComponentsWithPropertyName("health");
				for each (var obj in healthComponents) {
					var healthComponent:*=getComponent(obj.ownerName,obj.componentName);
					updateHealth(healthComponent);
				}
			} else {
				updateHealth(component);
			}
		}
		//------ Update Health ------------------------------------
		private function updateHealth(component:*):void {
			trace(component._health);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}