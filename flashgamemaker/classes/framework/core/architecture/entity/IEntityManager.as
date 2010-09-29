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
	
	public interface IEntityManager{
		
		/**
		 * creates a new entity
		 * @return the new entity
		 */		
		function createEntity(entityName:String):IEntity;	
		/**
		 * unregisters an entity
		 * @param entity
		 */	
		function removeEntity(entityName:String):void;
		
		/**
		 * registers a component with an entity
		 * @param entity the component is to be registered with
		 * @param component to be registered
		 */	
		function addComponent(entityName:String,componentName:String,newName:String):*;
		/**
		 * Retrieves a component
		 * @param entity the component is registered with
		 * @param Component to be retrieves
		 * @return component 
		 */		
		function getComponent(entityName:String,componentName:String):*;
		/**
		 * Get Components with Property
		 */	
		function getComponentsPropertyWithPropertyName(propertyName:String):Array;
		/**
		 * Component Is Registered With Property
		 */	
		function componentIsRegisteredWithProperty(ownerName:String,componentName:String, propertyName:String):Boolean;
		/**
		 * Remove a component from an entity
		 * @param entity the component is registered with
		 * @param Component to be unregisters
		 */	
		 
		function removeComponent(entityName:String,componentName:String):void;
		/**
		 * Register a property 
		 */	
		function registerProperty(propertyName:String, parentName:String, entityName:String):void;
		/**
		 * Iregister a property
		 */	
		function unregisterProperty(propertyName:String, parentName:String):void;
		/**
		 * Set property Reference
		 */	
		function setPropertyReference(propertyReferenceName:String, componentName:String, entityName:String):void;
		/**
		 * Remove property Reference
		 */	
		function removePropertyReference(propertyReferenceName:String, componentName:String, entityName:String):void;
		/**
		 * Refresh
		 */	
		function refresh(propertyName:String):void 
	}
}