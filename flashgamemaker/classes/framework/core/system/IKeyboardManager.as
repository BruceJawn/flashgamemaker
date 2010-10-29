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
*Under this licence you are free to copy, adapt and distrubute the work. 
*You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/

package framework.core.system{
	import flash.events.EventDispatcher;

	public interface IKeyboardManager {

		/**
		 * Get Dispatcher
		 */
		function getDispatcher():EventDispatcher;
		/**
		 * Define wich keys will be used in the game
		 */
		function setKeysFromPath(path:String, name:String):void;
		/**
		 * Define wich keys will be used in the game
		 */
		function setKeysFromXml(xml:XML):void;
		/**
		 * Set Key 
		 */
		function setKey(keyCode:Number,keyName:String ):void;
		/**
		 * Set Key From Char Code
		 */
		function setKeyFromCharCode(charCode:String,keyName:String ):void;
		/**
		 * Register
		 */
		function register(obj:Object):void;
		/**
		 * Unregister
		 */
		function unregister(obj:Object):void;
		/**
		 * Retourn Key
		 */
		function getKey():Object;
		/**
		 * Retourn Xml Config
		 */
		function getXmlConfig():XMLList;
		/**
		 * To String
		 */
		function ToString():void;
	}
}