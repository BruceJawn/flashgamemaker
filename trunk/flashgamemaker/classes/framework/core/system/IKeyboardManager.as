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
		 * Register
		 */
		function register(obj:Object):void;
		/**
		 * Unregister
		 */
		function unregister(obj:Object):void;
		/**
		 * Configure manually the keys to move
		 */
		function mapDirection(up:int, down:int, left:int, right:int, replaceExisting:Boolean = false):void;
		/**
		 * Use the keys WASD to move 
		 */
		function useWASD(replaceExisting:Boolean = false):void;
		/**
		 * Use the keys IJKL to move
		 */
		function useIJKL(replaceExisting:Boolean = false):void;
		/**
		 * Use the keys ZQSD to move
		 */
		function useZQSD(replaceExisting:Boolean = false):void;
		/**
		 * Configure manually the gaming buttons
		 */
		function mapFireButtons(fire1:int, fire2:int,fire3:int,fire4:int, replaceExisting:Boolean = false):void;
		/**
		 * Use the keys JKLM as buttons
		 */
		function useJKLM(replaceExisting:Boolean = false):void;
		/**
		 * Use the keys OKLM as buttons
		 */
		function useOKLM(replaceExisting:Boolean = false):void;
		/**
		 * Return GamePad
		 */
		function getGamePad():Object;
		/**
		 * To String
		 */
		function ToString():void;
	}
}