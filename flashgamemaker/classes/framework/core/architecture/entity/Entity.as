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
*    Inspired from Ember  
*    Tom Davies 2010
*    http://github.com/tdavies/Ember/wiki
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

package framework.core.architecture.entity{
	import framework.core.architecture.component.*;
	
	import flash.utils.Dictionary;
	
	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class Entity implements IEntity{

		private var _entityName:String;
		private var _entityManager:IEntityManager = null;
		private var _components:Dictionary = new Dictionary();
		
		public function Entity(entityName:String, entityManager:IEntityManager){
			initVar(entityName,entityManager);
		}
		//------ Init Var ------------------------------------
		private function initVar(entityName:String, entityManager:IEntityManager):void {
			_entityName= entityName;
			_entityManager= entityManager;
		}
		//------ Add Component ------------------------------------
		public function addComponent(entityName:String, componentName:String,newName:String):* {
			return _entityManager.addComponent(entityName,componentName,newName);
		}
		//------ Get Component ------------------------------------
		public function getComponent(entityName:String,componentName:String):*{	
			return _entityManager.getComponent(entityName,componentName);
		}
		//------ Get Components'Property With PropertyName ------------------------------------
		public function getComponentsPropertyWithPropertyName(propertyName:String):Array{	
			return _entityManager.getComponentsPropertyWithPropertyName(propertyName);
		}
		//------ Component Is Registered With Property ------------------------------------
		public function componentIsRegisteredWithProperty(componentName:String, propertyName:String):Boolean{
			return _entityManager.componentIsRegisteredWithProperty(_entityName, componentName,propertyName);
		}
		//------ Remove Component ------------------------------------
		public function removeComponent(componentName:String):void {
			_entityManager.removeComponent(_entityName,componentName);
		}
		//------ Register Property ------------------------------------
		public function registerProperty(propertyName:String, parentName:String):void {
			_entityManager.registerProperty(propertyName,parentName,_entityName);
		}
		//------ Unregister Property ------------------------------------
		public function unregisterProperty(propertyName:String, parentName:String):void {
			_entityManager.unregisterProperty(propertyName,parentName,_entityName);
		}
		//------ Set Property Reference ------------------------------------
		public function setPropertyReference(propertyReferenceName:String, componentName:String):Boolean {
			return _entityManager.setPropertyReference(propertyReferenceName,componentName,_entityName);
		}
		//------ Remove Property Reference ------------------------------------
		public function removePropertyReference(propertyReferenceName:String, componentName:String):void {
			_entityManager.removePropertyReference(propertyReferenceName,componentName,_entityName);
		}
		//------ Destroy ------------------------------------
		public function destroy():void{
			_entityManager.removeEntity(_entityName);
		}
		//------- Get Name -------------------------------
		public function getName():String{
            return _entityName;
        }
		//------- Get Components -------------------------------
		public function getComponents():Dictionary{
            return _components;
        }
		//------ Create Entity  ------------------------------------
		public  function createEntity(entityName:String):void {
			_entityManager.createEntity(entityName);
		}
		//------ Refresh  ------------------------------------
		public function refresh(propertyName:String):void {
			_entityManager.refresh(propertyName);
		}
		//------- ToString -------------------------------
		public function ToString():void{
            trace(_entityName);
        }
		
	}
}