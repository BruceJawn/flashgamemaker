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
	
	import flash.geom.Point;
	/**
	* Entity Class
	*/
	public class HealthComponent extends Component {
		
		private var _index:Number=0;
		//Health properties
		public var _health_life:Number=10;
		public var _health_lifeMax:Number=10;		
		public var _health_hit:Number=0;
		
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
			if(component._health_hit!=0){
				if(component._health_life>0){
					displayHit(component);
					component._health_life-=component._health_hit;
				}
				component._health_hit=0;
			}
		}
		//------ Display Hit ------------------------------------
		private function displayHit(component:*):void {
			var textComponent:TextComponent= addComponent(_componentOwner.getName(),"TextComponent","myHealthHitTextComponent"+_index);
			textComponent.moveTo(component._spatial_position.x,component._spatial_position.y-component.height-5);
			textComponent.setText("-"+component._health_hit);
			textComponent.setFormat("Arial",20,0xFF0000);
			textComponent.setMovmentTweener(new Point(textComponent._spatial_position.x,textComponent._spatial_position.y-35),1,30,true);
			_index++;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}