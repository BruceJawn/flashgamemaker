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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * manages the relations between compoments and entites and keeps entity families upto date.
	 * @author Tom Davies
	 */
	public class EntityManager implements IEntityManager {
		private static var _instance:IEntityManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _entities:Dictionary=null;
		private var _families:Dictionary=null;
		private var _propertyInfos:Dictionary=null;
		private var _propertyReferences:Dictionary=null;

		public function EntityManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use EntityManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IEntityManager {
			if (_instance==null) {
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
			_propertyInfos = new Dictionary();
			_propertyReferences = new Dictionary();
		}
		//------ Create Entity ------------------------------------
		public function createEntity(entityName:String):IEntity {
			if (_entities[entityName]!=null) {
				throw new Error("Error: An Entity already exist with the name "+entityName+" !!");
			}
			var entity:IEntity=new Entity(entityName,_instance) as IEntity;
			_entities[entityName]=entity;
			return entity;
		}
		//------ Remove Entity ------------------------------------
		public function removeEntity(entityName:String):void {
			delete _entities[entityName];
		}
		//------ Add Component ------------------------------------
		public function addComponent(entityName:String,componentName:String,newName:String):* {
			var classRef:Class=getClass(componentName);
			var entity:IEntity=_entities[entityName];
			if (entity==null) {
				throw new Error("Error: The entity "+entityName+" doesn't exist!!\n Impossible to add the component"+componentName);
			}
			var component:Component=new classRef(newName,entity);
			var components:Dictionary=entity.getComponents();

			if (components[newName]!=null) {
				throw new Error("Error: A Component already exist with the name "+newName+" !!");
			}
			components[newName]=component;
			component.initProperty();
			return component;
		}
		//------ Get Component ------------------------------------
		public function getComponent(entityName:String,componentName:String):* {
			var entity:IEntity=_entities[entityName];
			if (_entities[entityName]==null) {
				throw new Error("Error:The entity with the name "+entityName+" doesn't exist!!");
			}
			var components:Dictionary=entity.getComponents();
			if (components[componentName]==null) {
				throw new Error("Error:The component with the name "+componentName+" doesn't belong to the entity "+entityName+" !!");
			}
			return components[componentName];
		}
		//------ Get Components With PropertyName ------------------------------------
		public function getComponentsWithPropertyName(propertyName:String):Array {
			if (_propertyReferences[propertyName]==null) {
				//trace("Error: The Property "+propertyName+" is not registered !!");
			}
			return _propertyReferences[propertyName];
		}
		//------ Component Is Registered With Property ------------------------------------
		public function componentIsRegisteredWithProperty(ownerName:String,componentName:String, propertyName:String):Boolean {
			var propertyReference:Array=_propertyReferences[propertyName] as Array;
			for each (var obj:Object in propertyReference) {
				if (obj.componentName==componentName&&obj.ownerName==ownerName) {
					return true;
				}
			}
			return false;
		}
		//------ Remove Component ------------------------------------
		public function removeComponent(entityName:String,componentName:String):void {
			var entity:IEntity=_entities[entityName];
			var components:Dictionary=entity.getComponents();
			try{
				var component:Component=getComponent(entityName,componentName);
				component.reset(entityName,componentName);
				unregisterComponent(entityName,componentName);
				delete components[componentName];
			}catch(e:Error){
				trace("Error EntityManager!!!\n"+e);
			}
		}
		//------ Remove All Components ------------------------------------
		public function removeAllComponents(entityName:String):void {
			/*var entity:IEntity=_entities[entityName];
			var components:Dictionary=entity.getComponents();
			try{
				var component:Component=getComponent(entityName,componentName);
				component.reset(entityName,componentName);
				unregisterComponent(entityName,componentName);
				delete components[componentName];
			}catch(e:Error){
				trace("Error EntityManager!!!\n"+e);
			}*/
		}
		//------ Unregister Component ------------------------------------
		public function unregisterComponent(entityName:String,componentName:String):void {
			var component:Component=getComponent(entityName,componentName);
			var propertyReference:Array=component.getPropertyReference();
			for each (var propertyName:String in propertyReference) {
				try {
					unregisterPropertyReference(propertyName, componentName,entityName);
				} catch (e:Error) {
					trace(e);
				}
			}
			var propertyInfo:Array=component.getPropertyInfo();
			for each (propertyName in propertyInfo) {
				try {
					unregisterProperty(propertyName, componentName,entityName);
				} catch (e:Error) {
					trace(e);
				}
			}
		}
		//------ Register Property ------------------------------------
		public function registerProperty(propertyName:String, componentName:String, ownerName:String):void {
			if (_propertyInfos[propertyName]!=null) {
				throw new Error("Error: A Property already exist with the name "+propertyName+" !!");
			}
			_propertyInfos[propertyName]={componentName:componentName,ownerName:ownerName};
			if (_propertyReferences[propertyName]==null) {
				_propertyReferences[propertyName] = new Array();
			}
			var component:Component=getComponent(ownerName,componentName);
			component.update(propertyName);
			component.addPropertyInfo(propertyName);
		}
		//------ Get Property Info ------------------------------------
		public function getPropertyInfo(propertyName:String):* {
			if (_propertyInfos[propertyName]==null) {
				throw new Error("Error: There is no component registered the property with the name "+propertyName+" !!");
			}
			var propertyInfo:Object=_propertyInfos[propertyName];
			var component:* =getComponent(propertyInfo.ownerName,propertyInfo.componentName);
			return component;
		}
		//------ Unregister Property ------------------------------------
		public function unregisterProperty(propertyName:String, componentName:String, ownerName:String):void {
			if (_propertyInfos[propertyName]==null) {
				throw new Error("Error: The Property "+propertyName+" is not registered !!");
			}
			if (_propertyInfos[propertyName].componentName!=componentName) {
				throw new Error("Error: You can only unregister a Property if you are the parent !!");
			}
			var component:Component=getComponent(ownerName,componentName);
			component.removePropertyInfo(propertyName);
			delete _propertyInfos[propertyName];
			_propertyReferences[propertyName]=null;
			component.reset(ownerName,componentName);
		}
		//------ Set Property Reference ------------------------------------
		public function setPropertyReference(propertyReferenceName:String, componentName:String, ownerName:String):Boolean {
			var bool:Boolean=false;
			var propertyReference:Array=_propertyReferences[propertyReferenceName] as Array;
			if (propertyReference==null) {
				_propertyReferences[propertyReferenceName] = new Array();
				//trace("The Property "+propertyReferenceName+" is not registered !!");
			} else if (propertyReference.lastIndexOf(componentName)!=-1) {
				throw new Error("Error: You already have a PropertyReference with the name "+propertyReferenceName+" !!");
			}
			_propertyReferences[propertyReferenceName].push({componentName:componentName,ownerName:ownerName});
			if (_propertyInfos[propertyReferenceName]!=null) {
				var propertyInfo:Object=_propertyInfos[propertyReferenceName];
				var parentEntityName:String=propertyInfo.ownerName;
				var parentComponentName:String=propertyInfo.componentName;
				var component:Component=getComponent(parentEntityName,parentComponentName);
				component.update(propertyReferenceName);
				bool=true;
			}
			component=getComponent(ownerName,componentName);
			component.addPropertyReference(propertyReferenceName);
			return bool;
		}
		//------ Unregister Property Reference ------------------------------------
		public function unregisterPropertyReference(propertyReferenceName:String, componentName:String, ownerName:String):void {
			if (_propertyReferences[propertyReferenceName]==null) {
				throw new Error("Error: There is no Property Reference with the name "+propertyReferenceName+" !!");
			}
			var propertyReferences:Array=_propertyReferences[propertyReferenceName] as Array;
			for(var i:int =0; i<propertyReferences.length; i++){;
			if (propertyReferences[i].componentName==componentName) {
				var propertyInfo:Object=_propertyInfos[propertyReferenceName];
				var parentEntityName:String=propertyInfo.ownerName;
				var parentComponentName:String=propertyInfo.componentName;
				var component:Component=getComponent(parentEntityName,parentComponentName);
				component.reset(ownerName,componentName);
				component.removePropertyReference(propertyReferenceName);
				propertyReferences.splice(i,1);
				return;
			}
		}
		throw new Error("Error: The component "+componentName+" doesn't have property reference with the name "+propertyReferenceName+" !!");
	}
	//------ Refresh  ------------------------------------
	public function refresh(propertyName:String):void {
		var propertyInfo:Object=_propertyInfos[propertyName];
		var ownerName:String=propertyInfo.ownerName;
		var componentName:String=propertyInfo.componentName;
		var component:Component=getComponent(ownerName,componentName);
		component.actualizeComponent(componentName,ownerName,component);
	}
	//------ Destroy ------------------------------------
	public function destroy():void {
		_entities=null;
		_families=null;
	}
	//------ Checks if a entity has a set of Components ------------------------------------
	private function hasAllComponents(entityName:String,componentNames:Array):Boolean {
		/*for each(var componentName:String in componentNames){
		if(!_entities[entityName][componentName]){
		return false;
		}
		}*/
		return true;
	}
	//------ Gets class name from instance ------------------------------------
	private function getClass(componentName:String):Class {
		try{
			var classRef:Class=getDefinitionByName("framework.core.architecture.component."+componentName) as Class;
		}catch(e:Error){
			classRef=getDefinitionByName("framework.core.architecture.component.add."+componentName) as Class;
		}
		return (classRef);
	}
}
}