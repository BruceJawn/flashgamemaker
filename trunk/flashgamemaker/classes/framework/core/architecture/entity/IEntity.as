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
	
	public interface IEntity{
		
		/**
		 * Add a compoment to the entity
		 * @param name of component to be added
		 */		
		function addComponent(componentName:String):void;
		
		/**
		 * R a component from the entity
		 * @param  name of component to be removed
		 */	
		function removeComponent(componentName:String):void;
		/**
		 * Return the name of the entity
		 */	
		function getName():String;
		/**
		 * Get Component
		 */	
		function getComponent(entityName:String,componentName:String):*;
		/**
		 * Return the List of Components
		 */	
		function getComponents():Dictionary;
		/**
		 * Get Components'Property with PropertyName
		 */	
		function getComponentsPropertyWithPropertyName(propertyName:String):Array;
		/**
		 * Component Is Registered With Property
		 */	
		 function componentIsRegisteredWithProperty(componentName:String, propertyName:String):Boolean;
		/**
		 * Invoked when instance is to be destroyed
		 */	
		function destroy():void;
		/**
		 * Register property
		 */	
		function registerProperty(propertyName:String, parentName:String):void;
		/**
		 * Unregister property
		 */	
		function unregisterProperty(propertyName:String, parentName:String):void;
		/**
		 * Set property Reference
		 */	
		function setPropertyReference(propertyReferenceName:String, componentName:String):void;
		/**
		 * Remove property Reference
		 */	
		function removePropertyReference(propertyReferenceName:String, componentName:String):void;
		/**
		 * Trace the Name of the Entity
		 */	
		function ToString():void;
		
	}
}