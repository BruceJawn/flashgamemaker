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
	import utils.loader.*;
	import flash.utils.Dictionary;
	import flash.events.*;
	/**
	* Mouse Manager Class
	* @ purpose: Handle the mouse events
	*/
	public class MouseManager extends LoaderDispatcher implements IMouseManager {

		private static var _instance:IMouseManager=null;
		private static var _allowInstanciation:Boolean=false;
		
		public function MouseManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use MouseManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IMouseManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new MouseManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			
		}
	}
}