﻿/*
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
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	public interface IGraphicManager {
		
		/**
		 * Get the Loader Dispatcher
		 */		
		function getDispatcher():EventDispatcher;
		/**
		 * Load Graphics From the loaded XML targeted By the Path 
		 */		
		function loadGraphicsFromPath(path:String, name:String):void;
		/**
		 * Load Graphics From the XML targeted
		 */		
		function loadGraphicsFromXml(xml:XML, name:String):void;
		/**
		 * Load Graphic in the path
		 */		
		function loadGraphic(path:String, name:String):void;
		/**
		 * Get Graphics Loaded
		 */		
		 function getGraphics():Array;
		 /**
		 * Get Graphic By Name
		 */		
		 function getGraphic(graphicName:String):*;
		 /**
		 * Get The Number Of Graphics To Load
		 */		
		 function getNumGraphicsToLoad():Number;
		 /**
		 * Register and Display Graphic
		 */		
		 function displayGraphic(graphicName:String, graphic:*, layerId:int):void;
		 /**
		 * Unregister and remove Graphic
		 */		
		 function removeGraphic(graphicName:String):void;
		 /**
		 * Contains Graphic
		 */		
		 function containsGraphic(graphicName:String):Boolean
	}
}