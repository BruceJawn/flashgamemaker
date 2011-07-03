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

package framework.core.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.system.ServerManager;
	import framework.core.system.IServerManager;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	
	/**
	* Server Component Class
	* @ purpose: 
	*/
	public class MultiPlayerComponent extends Component {

		private var _serverManager:IServerManager=null;
		//Server Input Properties
		public var _server_data:String;

		public function MultiPlayerComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_serverManager=ServerManager.getInstance();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerPropertyReference("serverInput");
			registerProperty("multiPlayer");
		}
		//-- On Send ---------------------------------------------
		private function movePlayer(evt:MouseEvent):void {
			
		}
		//-- Send Message ---------------------------------------------
		public function sendMessage(msgToSend:String):void {
			
		}
		//-- Parse Message ---------------------------------------------
		private function parseMessage(msgReceived:String):String {
			var xml:XML=new XML(msgReceived);
			if (xml.name()=="player") {
				return xml.toString();
			}
			return null;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
			/*var keyboardMove_iso:Boolean = component._keyboardMove_iso;
			var spatial_dir:IsoPoint=getKey(_keyboard_key,keyboardMove_iso);
			component._spatial_dir.x=spatial_dir.x;
			component._spatial_dir.y=spatial_dir.y;
			component._spatial_dir.z=spatial_dir.z;
			component._spatial_isMoving=isMoving(spatial_dir);
			component._keyboard_key=_keyboard_key;*/
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}