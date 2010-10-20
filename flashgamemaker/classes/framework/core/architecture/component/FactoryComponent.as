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
	import framework.core.architecture.component.*;

	import fl.controls.ComboBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;

	/**
	* Entity Class
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class FactoryComponent extends GraphicComponent {

		private var _title:TextComponent=null;
		private var _description:TextComponent=null;
		private var _name:TextComponent=null;
		private var _cursor:CursorComponent=null;
		private var _text:TextComponent=null;
		private var _chrono:ChronoComponent=null;
		private var _time:TimeComponent=null;
		private var _systemInfo:SystemInfoComponent=null;
		private var _jauge:JaugeComponent=null;
		private var _scrollingBitmap:ScrollingBitmapComponent=null;
		private var _tileMap:TileMapComponent=null;
		private var _bitmapPlayer:BitmapPlayerComponent=null;
		private var _swfPlayer:SwfPlayerComponent=null;
		private var _sound:SoundComponent=null;
		private var _export:ExportComponent=null;
		private var _message:MessageComponent=null;
		private var _comboBox:ComboBox=null;
		private var _button:Button=null;

		public function FactoryComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_title=addComponent(_componentOwner.getName(),"TextComponent","myTitle");
			_title.moveTo(20,10);
			_title.setText("The Factory Component");
			_title.setFormat("Times New Roman",16, 0x0000FF);
			_description=addComponent(_componentOwner.getName(),"TextComponent","myDescription");
			_description.moveTo(15,30);
			_description.setText("My FactoryComponent permits \nto create dynamically a component.");
			_description.setFormat("Times New Roman",12, 0x000000);
			_name=addComponent(_componentOwner.getName(),"TextComponent","myName");
			_name.moveTo(225,20);
			_name.setText("Name");
			_name.setFormat("Times New Roman",12, 0x000000);
			_comboBox = new ComboBox();
			_comboBox.move(260,20);
			_comboBox.width=130;
			_comboBox.addItem({label:""});
			_comboBox.addItem({label:"Cursor"});
			_comboBox.addItem({label:"Text"});
			_comboBox.addItem({label:"Chrono"});
			_comboBox.addItem({label:"Message"});
			_comboBox.addItem({label:"Time"});
			_comboBox.addItem({label:"SystemInfo"});
			_comboBox.addItem({label:"Jauge"});
			_comboBox.addItem({label:"Sound"});
			_comboBox.addItem({label:"Export"});
			_comboBox.addItem({label:"ScrollingBitmap"});
			_comboBox.addItem({label:"TileMap"});
			_comboBox.addItem({label:"BitmapPlayer"});
			_comboBox.addItem({label:"SwfPlayer"});
			_comboBox.addEventListener(Event.CHANGE, onComboBoxChange);
			//addChild(_comboBox);
			displayGraphic("myFactoryComboBox",_comboBox,2);
			_button = new Button();
			_button.label = "Create";
			_button.width = 80;
			_button.x=310;
			_button.y=50;
			_button.addEventListener(MouseEvent.CLICK, onCreate);
			//addChild(_button);
			displayGraphic("myFactoryButton",_button,2);
		}
		//------- On ComboBox Change -------------------------------
		private function onComboBoxChange(evt:Event):void {
			var selectedComponent:String=_comboBox.selectedItem.label;
			if (selectedComponent=="Cursor" && _cursor!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Cursor") {
				_button.label = "Create";
			}else if (selectedComponent=="Text" && _text!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Text") {
				_button.label = "Create";
			}if (selectedComponent=="Message" && _message!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Message") {
				_button.label = "Create";
			}if (selectedComponent=="Chrono" && _chrono!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Chrono") {
				_button.label = "Create";
			}else if (selectedComponent=="Time"&& _time!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Time") {
				_button.label = "Create";
			}else if (selectedComponent=="SystemInfo" && _systemInfo!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="SystemInfo") {
				_button.label = "Create";
			}else if (selectedComponent=="Jauge" && _jauge!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Jauge") {
				_button.label = "Create";
			}else if (selectedComponent=="Sound" && _sound!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Sound") {
				_button.label = "Create";
			}else if (selectedComponent=="Export" && _export!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="Export") {
				_button.label = "Create";
			}else if (selectedComponent=="ScrollingBitmap" && _scrollingBitmap!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="ScrollingBitmap") {
				_button.label = "Create";
			}else if (selectedComponent=="TileMap" && _tileMap!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="TileMap") {
				_button.label = "Create";
			}else if (selectedComponent=="BitmapPlayer" && _bitmapPlayer!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="BitmapPlayer") {
				_button.label = "Create";
			}else if (selectedComponent=="SwfPlayer" && _swfPlayer!=null) {
				_button.label = "Remove";
			}else if (selectedComponent=="SwfPlayer") {
				_button.label = "Create";
			}
		}
		//------- Init Text Component -------------------------------
		private function initCursorComponent():void {
			_cursor.loadGraphic("texture/framework/interface/kawaiiCursor.swf", "KawaiiCursor");
			_cursor.moveTo(150,250);
		}
		//------- Init Text Component -------------------------------
		private function initTextComponent():void {
			_text.moveTo(140,150);
			_text.setText("HelloWorld");
			_text.setFormat("Times New Roman",20, 0x000000);
		}
		//------- Init Message Component -------------------------------
		private function initMessageComponent():void {
		 	_message.loadGraphic("texture/framework/interface/messageClip.swf", "MessageClip");
			_message.moveTo(150,250);
		}
		//------- Init Chrono Component -------------------------------
		private function initChronoComponent():void {
		 	_chrono.moveTo(150,150);
		}
		//------- Init Time Component -------------------------------
		private function initTimeComponent():void {
			_time.moveTo(20,110);
		}
		//------- Init Text Component -------------------------------
		private function initSystemInfoComponent():void {
			_systemInfo.moveTo(100,300);
		}
		//------- Init Jauge Component -------------------------------
		private function initJaugeComponent():void {
			_jauge.moveTo(250,250);
		}
		//------- Init Sound Component -------------------------------
		private function initSoundComponent():void {
			
		}
		//------- Init Export Component -------------------------------
		private function initExportComponent():void {
			_export.createJPG(FlashGameMaker.STAGE, "FGM_screenshot");
			
		}
		//------- Init Scrolling Bitmap Component -------------------------------
		private function initScrollingBitmapComponent():void {
		 	_scrollingBitmap.loadGraphic("texture/framework/game/backGround/mario.jpg","Bg");
			//_scrollingBitmap.setPropertyReference("keyboardInput",_scrollingBitmap._componentName);
			_scrollingBitmap.setPropertyReference("timer",_scrollingBitmap._componentName);
		}
		//------- Init TileMap Component -------------------------------
		private function initTileMapComponent():void {
		 	//_tileMap.loadMap("xml/framework/game/map.xml", "TileMap");
			_tileMap.loadMap("xml/framework/game/mapKawaii.xml", "TileMap");
		}
		//------- Init Bitmap Player Component -------------------------------
		private function initBitmapPlayerComponent():void {
			_bitmapPlayer.loadPlayer("xml/framework/game/bitmapPlayer.xml", "Knight");
			_bitmapPlayer.moveTo(200,0);
			_bitmapPlayer.setIso(true);
		}
		//------- Init Swf Player Component -------------------------------
		private function initSwfPlayerComponent():void {
			_swfPlayer.loadPlayer("xml/framework/game/swfPlayer.xml", "SwfPlayer");
			//_swfPlayer.loadPlayer("xml/framework/game/swfPlayerKawaiiFight.xml","SwfPlayer");
			_swfPlayer.setPropertyReference("keyboardMove",_swfPlayer._componentName);
			//_swfPlayer.setDirection("Horizontal");
			//swfPlayerComponent.setPropertyReference("jaugeMove",swfPlayerComponent._componentName);
			_swfPlayer.moveTo(200,0);
			_swfPlayer.setIso(true);
		}
		//------- On Create Change -------------------------------
		private function onCreate(evt:MouseEvent):void {
			var selectedComponent:String=_comboBox.selectedItem.label;
			if (selectedComponent=="Cursor" && _cursor==null) {
				_cursor = addComponent(_componentOwner.getName(), "CursorComponent", "myFactoryCursor");
				initCursorComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Cursor") {
				removeComponent("myFactoryCursor");
				_cursor = null;
				_button.label = "Create";
			}else if (selectedComponent=="Text" && _text==null) {
				_text = addComponent(_componentOwner.getName(), "TextComponent", "myFactoryText");
				initTextComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Text") {
				removeComponent("myFactoryText");
				_text = null;
				_button.label = "Create";
			}else if (selectedComponent=="Message" && _message==null) {
				_message = addComponent(_componentOwner.getName(), "MessageComponent", "myFactoryMessage");
				initMessageComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Message") {
				removeComponent("myFactoryMessage");
				_message = null;
				_button.label = "Create";
			}else if (selectedComponent=="Chrono" && _chrono==null) {
				_chrono = addComponent(_componentOwner.getName(), "ChronoComponent", "myFactoryChrono");
				initChronoComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Chrono") {
				removeComponent("myFactoryChrono");
				_chrono = null;
				_button.label = "Create";
			}else if (selectedComponent=="Time" && _time==null) {
				_time = addComponent(_componentOwner.getName(), "TimeComponent", "myFactoryTime");
				initTimeComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Time") {
				removeComponent("myFactoryTime");
				_time = null;
				_button.label = "Create";
			}else if (selectedComponent=="SystemInfo" && _systemInfo==null) {
				_systemInfo = addComponent(_componentOwner.getName(), "SystemInfoComponent", "myFactorySystemInfo");
				initSystemInfoComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="SystemInfo") {
				removeComponent("myFactorySystemInfo");
				_systemInfo = null;
				_button.label = "Create";
			}else if (selectedComponent=="Jauge" && _jauge==null) {
				_jauge = addComponent(_componentOwner.getName(), "JaugeComponent", "myFactoryJauge");
				initJaugeComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Jauge") {
				removeComponent("myFactoryJauge");
				_jauge = null;
				_button.label = "Create";
			}else if (selectedComponent=="Sound" && _sound==null) {
				_sound = addComponent(_componentOwner.getName(), "SoundComponent", "myFactorySound");
				initSoundComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Sound") {
				removeComponent("myFactorySound");
				_sound = null;
				_button.label = "Create";
			}else if (selectedComponent=="Export" && _export==null) {
				_export = addComponent(_componentOwner.getName(), "ExportComponent", "myFactoryExport");
				initExportComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="Export") {
				removeComponent("myFactoryExport");
				_export = null;
				_button.label = "Create";
			}else if (selectedComponent=="ScrollingBitmap" && _scrollingBitmap==null) {
				_scrollingBitmap = addComponent(_componentOwner.getName(), "ScrollingBitmapComponent", "myFactoryScrollingBitmap");
				initScrollingBitmapComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="ScrollingBitmap") {
				removeComponent("myFactoryScrollingBitmap");
				_scrollingBitmap = null;
				_button.label = "Create";
			}else if (selectedComponent=="TileMap" && _tileMap==null) {
				_tileMap = addComponent(_componentOwner.getName(), "TileMapComponent", "myFactoryTileMap");
				initTileMapComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="TileMap") {
				removeComponent("myFactoryTileMap");
				_tileMap = null;
				_button.label = "Create";
			}else if (selectedComponent=="BitmapPlayer" && _bitmapPlayer==null) {
				_bitmapPlayer = addComponent(_componentOwner.getName(), "BitmapPlayerComponent", "myFactoryBitmapPlayer");
				initBitmapPlayerComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="BitmapPlayer") {
				removeComponent("myFactoryBitmapPlayer");
				_bitmapPlayer = null;
				_button.label = "Create";
			}else if (selectedComponent=="SwfPlayer" && _swfPlayer==null) {
				_swfPlayer = addComponent(_componentOwner.getName(), "SwfPlayerComponent", "myFactorySwfPlayer");
				initSwfPlayerComponent();
				_button.label = "Remove";
			}else if (selectedComponent=="SwfPlayer") {
				removeComponent("myFactorySwfPlayer");
				_swfPlayer = null;
				_button.label = "Create";
			}
			refresh();
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}

	}
}