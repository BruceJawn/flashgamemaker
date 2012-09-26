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
*   Under this licence you are free to copy, adapt and distrubute the work. 
*   You must attribute the work in the manner specified by the author or licensor. 
*   A copy of the license is included in the section entitled "GNU
*   Free Documentation License".
*
*/
package script.game.kawaiiIsland{
	import com.adobe.serialization.json.JSON;
	
	import script.game.kawaiiIsland.data.*;
	
	import utils.stuv.Params;

	public class Data{
		
		private static var _instance:Data=null;
		private static var _allowInstanciation:Boolean=false;
		
		public var constante:Constante = null;
		public var player:Player = null;
		public var userInfo:UserInfo = null;
		public var data:Object = null;
		
		public function Data() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use Data.getInstance() instead of new.");
			}
			_initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():Data {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance = new Data();
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		public function _initVar():void {
			//_parseFlashVars();
			constante = new Constante();
			player = new Player;
			userInfo = new UserInfo();
		}
		//------ Init Var ------------------------------------
		private function _parseFlashVars():void {
			data = Params.GetFlashVars()["params"];
			try{
				data = JSON.decode(data as String);
			}catch(e:Error){
				trace(e);
			}
		}
	}
}