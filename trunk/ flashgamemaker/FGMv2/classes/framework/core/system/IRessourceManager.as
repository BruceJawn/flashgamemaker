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
	import utils.loader.*;
	import flash.display.Sprite;
	import flash.events.*;
	
	public interface IRessourceManager	{
		/**
		 * Load Xmls From Xml using XmlManager
		 */		
		function loadXmlsFromPath(path:String, name:String):void
		/**
		 * Load Xmls From Xml using XmlManager
		 */		
		function loadXmlsFromXml(xml:XML, name:String):void
		/**
		 * Load xml using XmlManager
		 */		
		function loadXml(path:String, name:String):void;
		/**
		 * Get Xml
		 */		
		function getXml(xmlName:String):XML
		/**
		 * Load Graphics From an Existing XML
		 */		
		function loadGraphicsFromXml(xml:XML, name:String):void;
		/**
		 * Load an XML and load All The Graphics Targeted
		 */		
		function loadGraphicsFromPath(path:String, name:String):void;
		/**
		 * Load Graphic
		 */		
		function loadGraphic(path:String,name:String):void;
		/**
		 * Get Graphics
		 */		
		function getGraphics():Array;
		/**
		 * Get Graphic By Name
		 */		
		function getGraphic(graphicName:String):Sprite;
		/**
		 * Get number of graphics to load
		 */		
		function getNumGraphicsToLoad():Number ;
		 /**
		 * Display Graphic
		 */		
		function displayGraphic(graphicName:String, graphic:Sprite, layerId:int):void;
		/**
		 * Remove Graphic
		 */		
		function removeGraphic(graphicName:String):void;
		/**
		 * To String
		 */		
		function ToString():void ;
	}
}