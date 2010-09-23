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

package framework.core.architecture.entity {
	import framework.core.architecture.component.*;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * manages the relations between compoments and entites and keeps entity families upto date.
	 * @author Tom Davies
	 */
	public class EntityManager implements IEntityManager {
		
		private static var _instance:IEntityManager=null;
		private static var _allowInstanciation:Boolean = false;
		private var _entities:Dictionary = null;
		private var _components:Dictionary = null;
		private var _families:Dictionary = null ;
		
		public function EntityManager(){
			if(!_allowInstanciation){
				 throw new Error("Error: Instantiation failed: Use EntityManager.getInstance() instead of new.");
			}
			initVar();
			//initClassRef();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IEntityManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance = new EntityManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entities = new Dictionary();
			_families = new Dictionary();
		}
		//------ Init Class Ref  ------------------------------------
		public  function initClassRef():void{
			//In order to import your component  classes in the compiled SWF and use them at runtime
			//please insert your component classes here as follow 
			var keyboardInputComponent:KeyboardInputComponent;
		}
		//------ Create Entity ------------------------------------
		public function createEntity(entityName:String):IEntity{
			if(_entities[entityName] != null){
				throw new Error("Error: An Entity already exist with the specified name !!");
			}
			var entity:IEntity = new Entity(entityName, _instance) as IEntity;
			_entities[entityName] = entity;
			return entity;
		}
		//------ Remove Entity ------------------------------------
		public function removeEntity(entityName:String):void {
			delete _components[entityName];
		}
		//------ Add Component ------------------------------------
		public function addComponent(entityName:String,componentName:String):void{
			var classRef:Class = getClass(componentName);
			var entity:IEntity = _entities[entityName];
			var component:Component = new classRef(componentName,entity);
			var components:Dictionary = entity.getComponents();
			components[componentName] = component;
		}
		//------ Get Component ------------------------------------
		public function getComponent(entityName:String,componentName:String):Object{	
			return _components[entityName][componentName];
		}
		//------ Remove Component ------------------------------------
		public function removeComponent(entityName:String,componentName:String):void{
			delete _components[entityName][componentName];
		}
		//------ Destroy ------------------------------------
		public function destroy():void {
			_entities = null;
			_components = null;
			_families = null;
		}
		//------ Checks if a entity has a set of Components ------------------------------------
		private function hasAllComponents(entityName:String,componentNames:Array):Boolean{
			for each(var componentName:String in componentNames){
				if(!_components[entityName][componentName]){
					return false;
				}	
			}
			return true;
		}
		//------ Gets class name from instance ------------------------------------
		private function getClass(componentName:String):Class{
			var classRef:Class=getDefinitionByName("framework.core.architecture.component."+componentName) as Class;
			return (classRef);
		}
	}
}