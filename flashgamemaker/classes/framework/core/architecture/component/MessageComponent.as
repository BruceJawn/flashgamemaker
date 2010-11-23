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
	import flash.display.MovieClip;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class MessageComponent extends GraphicComponent {

		private var _serverManager:IServerManager=null;
		private var _clip:MovieClip=null;
		//ServerInput Properties
		public var _server_data:String;

		public function MessageComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_serverManager=ServerManager.getInstance();
		}
		//------ Init Property Info ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("serverInput",_componentName);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			_clip=getGraphic(_graphicName) as MovieClip;
			if (_clip!=null) {
				_clip.sendBt.addEventListener(MouseEvent.CLICK,onSend);
				_clip.inputTxt.addEventListener(MouseEvent.CLICK,onInput);
				addChild(_clip);
			}
		}
		//------ Set Graphic From Name ------------------------------------
		public override function setGraphicFromName(graphicName:String, layer:int=0):void {
			_render_layerId=layer;
			var graphic:*=_graphicManager.getGraphic(graphicName);
			if(_graphic!=null && contains(_graphic)){
				removeChild(_graphic);
			}
			if(graphic!=null){
				_graphicName=graphicName;
				_clip=graphic;
				_clip.sendBt.addEventListener(MouseEvent.CLICK,onSend);
				_clip.inputTxt.addEventListener(MouseEvent.CLICK,onInput);
				addChild(_clip);
			}
		}
		//-- On Send ---------------------------------------------
		private function onSend(evt:MouseEvent):void {
			var msgToSend:String=getInput();
			if (msgToSend!="") {
				sendMessage(msgToSend);
				_clip.inputTxt.text="";
				_clip.inputTxt.stage.focus=null;
			}
		}
		//-- On Input ---------------------------------------------
		private function onInput(evt:MouseEvent):void {
			if(_clip.inputTxt.text=="Write your message here"){
				_clip.inputTxt.text="";
			}
		}
		//-- Send Message ---------------------------------------------
		public function sendMessage(msgToSend:String):void {
			_serverManager.sendText(msgToSend);
		}
		//-- Get Message ---------------------------------------------
		public function getMessage():String {
			return _clip.messageClip.messageTxt.text;
		}
		//-- Set Message ---------------------------------------------
		public function setMessage(msgReceived:String):void {
			if (_clip!=null) {
				msgReceived=parseMessage(msgReceived);
				if (msgReceived!=null) {
					var msg:String=_clip.messageClip.messageTxt.text;
					_clip.messageClip.messageTxt.text=msgReceived;
					_clip.messageClip.messageTxt.text+="\n"+msg;
				}
			}
		}
		//-- Parse Message ---------------------------------------------
		private function parseMessage(msgReceived:String):String {
			var xml:XML=new XML(msgReceived);
			if (xml.name()=="message") {
				return xml.toString();
			}
			return null;
		}
		//-- Get Input ---------------------------------------------
		public function getInput():String {
			return _clip.inputTxt.text;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			setMessage(_server_data);
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}