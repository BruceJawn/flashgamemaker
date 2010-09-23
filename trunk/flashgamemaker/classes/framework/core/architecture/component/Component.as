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
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class Component{

		private var _componentName:String;
		private var _componentOwner:IEntity = null;
		
		public function Component(componentName:String, componentOwner:IEntity){
			initVar(componentName,componentOwner);
		}
		//------ Init Var ------------------------------------
		private function initVar(componentName:String, componentOwner:IEntity):void {
			_componentName= componentName;
			_componentOwner= componentOwner;
		}
		//------ Set Entity Owner ------------------------------------
		public function setComponentOwner(componentOwner:IEntity):void {
			_componentOwner = componentOwner;
		}
		//------ Destroy ------------------------------------
		public function destroy():void{
			_componentOwner.removeComponent(_componentName);
		}
		//------- Get Name -------------------------------
		 public function getName():String{
            return _componentName;
        }
		//------- ToString -------------------------------
		 public function ToString():void{
            trace(_componentName, _componentOwner);
        }
		
	}
}