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
	* Keyboard Manager
	* @ purpose: Handle the keyboard event
	*/
	public class ServerManager extends LoaderDispatcher implements IServerManager {

		private static var _instance:IServerManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _hostName:String="localhost";
		private var _port:Number=4444;
		private var _online:Boolean=false;
		
		public function ServerManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use ServerManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IServerManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new ServerManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			
		}
		//------ Set Keys ------------------------------------
		public function setConnection(xml:XML):void {
			_hostName = xml.hostName;
			_port = xml.port;
			_online = new Boolean(xml.online);
		}
	}
}