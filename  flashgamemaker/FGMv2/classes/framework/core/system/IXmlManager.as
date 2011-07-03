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
*	Under this licence you are free to copy, adapt and distrubute the work. 
*	You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system{
	import flash.events.EventDispatcher;
	
	public interface IXmlManager {
		
		/**
		 * Load all the XML contained in the source XML 
		 */		
		function loadXmlsFromPath(path:String, name:String):void
		/**
		 * Load all the XML contained in the source XML 
		 */		
		function loadXmlsFromXml(xml:XML, name:String):void
		/**
		 * Load XML 
		 */		
		function loadXml(path:String, name:String):void;
		/**
		 * Select and return XML by name
		 */		
		function getXml(xmlName:String):XML;
		/**
		 * Trace XML 
		 */		
		function printXml(xmlName:String):void;
		/**
		 * To String
		 */		
		function ToString():void ;
		
	}
}