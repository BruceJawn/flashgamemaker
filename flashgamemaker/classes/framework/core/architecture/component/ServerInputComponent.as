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
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class ServerInputComponent extends Component{

		private var _serverManager:IServerManager = null;
		private var _data:String;
		
		public function ServerInputComponent(componentName:String, componentOwner:IEntity){
			super(componentName,componentOwner);
			initVar();
			initListener();
			sendMessage("HelloWorld");
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_serverManager = ServerManager.getInstance();
			_serverManager.register(this);
			_serverManager.getServer();
		}
		//------ Init Listener ------------------------------------
		private function initListener():void {
			var dispatcher:EventDispatcher = _serverManager.getDispatcher();
			dispatcher.addEventListener(Event.CLOSE, onConnectionClose);
			dispatcher.addEventListener(DataEvent.DATA, onReceiveData);
			dispatcher.addEventListener(Event.CONNECT, onConnectionSuccessful);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		//------ Remove Listener ------------------------------------
		private function removetListener():void {
			var dispatcher:EventDispatcher = _serverManager.getDispatcher();
			dispatcher.removeEventListener(Event.CLOSE, onConnectionClose);
			dispatcher.removeEventListener(DataEvent.DATA, onReceiveData);
			dispatcher.removeEventListener(Event.CONNECT, onConnectionSuccessful);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		//-- Close Handler ---------------------------------------------
		private function onConnectionClose(evt:Event):void {
			trace("Clonnection to server closed");
		}
		//-- Connect Handler ---------------------------------------------
		private function onConnectionSuccessful(evt:Event):void {
			trace("Connection to server Successfull ");
		}
		//-- On Receive Data ---------------------------------------------
		private function onReceiveData(evt:DataEvent):void {
			var data:String=evt.data.split('\n').join('');
			trace(data);
		}
		//-- IO Error Handler ---------------------------------------------
		private function onIoError(evt:IOErrorEvent):void {
			trace("Connection to server Failed ");
		}
		//-- Progress Handler ---------------------------------------------
		private function onProgress(evt:ProgressEvent):void {
			trace("progressHandler loaded:" + evt.bytesLoaded + " total: " + evt.bytesTotal);
		}
		//-- Security Error Handler ---------------------------------------------
		private function onSecurityError(evt:SecurityErrorEvent):void {
		}
		//-- Send Message ---------------------------------------------
		public function sendMessage(msgToSend:String):void {
			_serverManager.sendText(msgToSend);
		}
		//------ Get Server ------------------------------------
		private function getServer():void {
			var server:Object = _serverManager.getServer;
			var serverObject:String="ServerConfig HostName:"+server.hostName+" ,Port:"+server.port+" ,Online:"+server.online;
			trace(serverObject);
		}
		//------- ToString -------------------------------
		 public override function ToString():void{
           
        }
		
	}
}