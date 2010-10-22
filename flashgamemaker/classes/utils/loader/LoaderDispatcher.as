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

package utils.loader {
	import flash.events.*;
	/**
	* Loader Dispatcher
	* @ purpose: Dispatch Events
	*/
	public class LoaderDispatcher {
		protected var _dispatcher:EventDispatcher = null;
		protected var _listeners:Array;
		
		public function LoaderDispatcher(){			
			initVar();
		}
		//------ Get Instance ------------------------------------
		private function initVar():void{
			_dispatcher = new EventDispatcher();
			_listeners = new Array();
		}
		//------ Get Dispatcher ------------------------------------
		public function getDispatcher():EventDispatcher{
			return _dispatcher;
		}
		//------ Dispatch Event ------------------------------------
		public function dispatchEvent(evt:Event):void{
			_dispatcher.dispatchEvent(evt);;
		}
		//------ Register ------------------------------------
		public function register(obj:Object):void {
			_listeners.push(obj);
		}
		//------ Unregister ------------------------------------
		public function unregister(obj:Object):void {
			for (var i:Number=0; i<_listeners.length; i++){
				if(_listeners[i]== obj){
					_listeners[i].removeListener();
					_listeners.splice(i,1);
					return;
				}
			}
		}
	}
}