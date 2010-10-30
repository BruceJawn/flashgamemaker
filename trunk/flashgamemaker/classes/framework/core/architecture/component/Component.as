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

	import flash.utils.Dictionary;
	import flash.display.Sprite;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class Component extends Sprite {

		public var _componentName:String;
		protected var _componentOwner:IEntity=null;
		private var _propertyReference:Array = null;
		private var _propertyInfo:Array = null;

		public function Component(componentName:String, componentOwner:IEntity) {
			initVar(componentName,componentOwner);
		}
		//------ Init Var ------------------------------------
		private function initVar(componentName:String, componentOwner:IEntity):void {
			_componentName=componentName;
			_componentOwner=componentOwner;
			_propertyReference = new Array();
			_propertyInfo = new Array();
		}
		//------ Init Property  ------------------------------------
		public function initProperty():void {

		}
		//------ Set Entity Owner ------------------------------------
		public function setComponentOwner(componentOwner:IEntity):void {
			_componentOwner=componentOwner;
		}
		//------ Destroy ------------------------------------
		public function destroy():void {
			_componentOwner.removeComponent(_componentName);
		}
		//------- Get Name -------------------------------
		public function getName():String {
			return _componentName;
		}
		//------ Register Property  ------------------------------------
		public function registerProperty(propertyName:String, componentName:String):void {
			_componentOwner.registerProperty(propertyName,componentName);
		}
		//------- Remove Property -------------------------------
		public function unregisterProperty(propertyName:String, componentName:String):void {
			_componentOwner.unregisterProperty(propertyName,componentName);
		}
		//------ Set Property Reference ------------------------------------
		public function setPropertyReference(propertyReferenceName:String, componentName:String):Boolean {
			return _componentOwner.setPropertyReference(propertyReferenceName,componentName);
		}
		//------ Refresh   ------------------------------------
		public function refresh():void {
			for each (var propertyName:String in  _propertyInfo){
				_componentOwner.refresh(propertyName);
			}
		}
		//------ Update ------------------------------------
		public function update(propertyName:String):void {//I update my son referents
			var componentsProperty:Array=_componentOwner.getComponentsWithPropertyName(propertyName);
			if (componentsProperty!=null) {
				for each (var propertyReference:Object in componentsProperty) {
					var componentName:String=propertyReference.componentName;
					var ownerName:String=propertyReference.ownerName;
					var component:* =_componentOwner.getComponent(ownerName,componentName);
					actualizeComponent(componentName,ownerName,component);
				}
			}
		}
		//------ Reset  ------------------------------------
		public function reset(ownerName:String, componentName:String):void {
			
		}
		//------ Actualize Components  ------------------------------------
		public function actualizeComponent(componentName:String,componentOwner:String,component:*):void {

		}
		//------ If Component Is Registered With Property  ------------------------------------
		public function componentIsRegisteredWithProperty(componentName:String, propertyName:String):Boolean {
			return _componentOwner.componentIsRegisteredWithProperty(componentName,propertyName);
		}
		//------ Create Entity  ------------------------------------
		protected function createEntity(entityName:String):void {
			_componentOwner.createEntity(entityName);
		}
		//------ Add Component  ------------------------------------
		public function addComponent(entityName:String,componentName:String, newName:String):* {
			return _componentOwner.addComponent(entityName,componentName,newName);
		}
		//------ Remove Component  ------------------------------------
		public function removeComponent(componentName:String):void {
			_componentOwner.removeComponent(componentName);
		}
		//------ Get Component  ------------------------------------
		public function getComponent(entityName:String,componentName:String):* {
			return _componentOwner.getComponent(entityName,componentName);
		}
		//------ Get Components With Property Name  ------------------------------------
		public function getComponentsWithPropertyName(propertyName:String):Array {
			return _componentOwner.getComponentsWithPropertyName(propertyName);
		}
		//------ Add Property Reference  ------------------------------------
		public function addPropertyReference(propertyName:String):void {
			_propertyReference.push(propertyName);
		}
		//------ Get Property Reference  ------------------------------------
		public function getPropertyReference():Array {
			return _propertyReference;
		}
		//------ Remove Property Reference  ------------------------------------
		public function removePropertyReference(propertyName:String):void {
			for(var i:int = 0; i<_propertyReference.length;i++){
				if(_propertyReference[i] == propertyName){
				_propertyReference.splice(i,1);
				}
			}
		}
		//------ Add Property Register  ------------------------------------
		public function addPropertyInfo(propertyName:String):void {
			_propertyInfo.push(propertyName);
		}
		//------ Get Property Register  ------------------------------------
		public function getPropertyInfo():Array {
			return _propertyInfo;
		}
		//------ Remove Property Reference  ------------------------------------
		public function removePropertyInfo(propertyName:String):void {
			for(var i:int = 0; i<_propertyInfo.length;i++){
				if(_propertyInfo[i] == propertyName){
				_propertyInfo.splice(i,1);
				}
			}
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_componentName, _componentOwner);
		}

	}
}