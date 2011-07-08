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

package framework.add.architecture.component{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;
	import utils.adobe.Export;
	import utils.convert.*;

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	import fl.events.*;
	import fl.containers.ScrollPane;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Slider;
	import fl.controls.Label;
	import fl.controls.Button;
	import fl.controls.NumericStepper;
	import fl.controls.ButtonLabelPlacement;
	import fl.data.DataProvider;
	import flash.system.System;
	import flash.net.FileReference;

	/**
	* TileMapEditor Component
	*/
	public class TileMapEditorComponent extends GraphicComponent {

		private var _tool:MovieClip= new MovieClip();
		private var _option:MovieClip= new MovieClip();
		private var _panel:MovieClip= new MovieClip();
		private var _panelScrollPane:ScrollPane;
		private var _panelSelectedTile:MovieClip=null;
		private var _tileMap:TileMapComponent=null;
		private var _toolPosition:Point= null;
		private var _optionPosition:Point= null;
		private var _panelPosition:Point= null;
		//KeyboardInput properties
		public var _keyboard_gamePad:Object=null;

		public function TileMapEditorComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_toolPosition = new Point(15,50);
			_optionPosition = new Point(0,150);
			_panelPosition = new Point(120,80);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("tileMapEditor");
			//setPropertyReference("keyboardInput",_componentName);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
			if (_tileMap==null&&component.constructor==TileMapComponent) {
				_tileMap=component as TileMapComponent;
				component.addEventListener(Event.COMPLETE, onTileMapComplete);
				component.addEventListener(MouseEvent.MOUSE_DOWN, onTileMouseDown);
				component.addEventListener(MouseEvent.MOUSE_UP, onTileMouseUp);
				component.addEventListener(MouseEvent.MOUSE_OVER, onTileMouseRollOver);
				component.addEventListener(MouseEvent.MOUSE_OUT, onTileMouseRollOut);
			} else if (_tileMap!=null && component._keyboard_gamePad!=null) {
				//trace("Bouton pressed");
			}
		}
		//------ Load Texture  ------------------------------------
		private function loadTexture(path:String, name:String):void {
			//loadGraphicsFromPath(path,name);
		}
		//------ On Tile Map Complete ------------------------------------
		private function onTileMapComplete(evt:Event):void {
			evt.target.removeEventListener(Event.COMPLETE,onTileMapComplete);
			initPanel();
			initTool();
			initOption();
		}
		//----- On Mouse Event  -----------------------------------
		private function onTileMouseDown(evt:MouseEvent):void {
			if (_panelSelectedTile!=null) {
				var clip:MovieClip = evt.target as MovieClip;
				var tileFrame:int = _panelSelectedTile.tileFrame;
				tileFrame = (_tileMap._tileMap_layer[_tool.tileLayer.value].X)*(tileFrame-1)+1;
				if(NumberTo.Bool(_tool.tileFlipFrame.value)){
					tileFrame*=-1;
				}
				_tileMap.swapTile(_tool.tileLayer.value,_tool.tileLevel.value,clip.ytile,clip.xtile, tileFrame);
				FlashGameMaker.Focus();
			}
		}
		//----- On Mouse Event  -----------------------------------
		private function onTileMouseUp(evt:MouseEvent):void {
			//trace(evt);
		}
		//----- On Mouse Event  -----------------------------------
		private function onTileMouseRollOver(evt:MouseEvent):void {
			//trace(evt);
			colorTile(evt.target as MovieClip, 1,0,0,1,0,0,0);
		}
		//----- On Mouse Event  -----------------------------------
		private function onTileMouseRollOut(evt:MouseEvent):void {
			//trace(evt);
			colorTile(evt.target as MovieClip, 1,1,1,1,0,0,0);
		}
		//----- Color Tile  -----------------------------------
		private function colorTile(tile:MovieClip, R:Number=1,G:Number=1,B:Number=1,A:Number=1, OR:Number=0,OG:Number=0,OB:Number=0,OA:Number=0):void {
			if (tile!=null) {
				tile.transform.colorTransform=new ColorTransform(R,G,B,A,OR,OG,OB,OA);
			}
		}
		//-----Init Tile Editor Tool  -----------------------------------
		private function initTool():void {
			_tool.x=_toolPosition.x;
			_tool.y=_toolPosition.y;
			addChild(_tool);
			_tool.inside = new CheckBox();
			_tool.inside.x=-280;
			_tool.inside.y=-248;
			_tool.inside.label="Inside";
			_tool.inside.labelPlacement=ButtonLabelPlacement.LEFT;
			//_tool.inside.addEventListener(MouseEvent.CLICK, onTileEditorInsideClick);
			_tool.mapSize = new NumericStepper();
			_tool.mapSize.minimum=2;
			_tool.mapSize.maximum=50;
			//_tool.mapSize.value = game.map.mapWidth;
			_tool.mapSize.x=_tool.inside.x+130;
			_tool.mapSize.y=-245;
			_tool.mapSize.width=40;
			_tool.mapSize.height-=5;
			_tool.mapSize.tabEnabled=false;
			_tool.mapSize.textField.editable=false;
			_tool.mapSizeText = new TextField();
			_tool.mapSizeText.x=_tool.mapSize.x-30;
			_tool.mapSizeText.y=_tool.mapSize.y-2;
			_tool.mapSizeText.text="Size";
			_tool.mapSizeText.selectable=false;
			_tool.mapSizeText.textColor=0x000000;
			//_tool.mapSize.addEventListener(SliderEvent.CHANGE, onTileEditorMapSizeChange);
			_tool.mapLevel = new NumericStepper();
			_tool.mapLevel.minimum=2;
			_tool.mapLevel.maximum=50;
			_tool.mapLevel.value=5;
			_tool.mapLevel.x=_tool.mapSize.x+80;
			_tool.mapLevel.y=_tool.mapSize.y;
			_tool.mapLevel.width=40;
			_tool.mapLevel.height-=5;
			_tool.mapLevel.tabEnabled=false;
			_tool.mapLevel.textField.editable=false;
			_tool.mapLevelText = new TextField();
			_tool.mapLevelText.x=_tool.mapLevel.x-35;
			_tool.mapLevelText.y=_tool.mapLevel.y-2;
			_tool.mapLevelText.text="Level";
			_tool.mapLevelText.selectable=false;
			_tool.mapLevelText.textColor=0x000000;
			//_tool.mapLevel.addEventListener(SliderEvent.CHANGE, onTileEditorMapLevelChange);
			_tool.tileLevel = new NumericStepper();
			_tool.tileLevel.maximum=5;
			_tool.tileLevel.value=0;
			_tool.tileLevel.x=20;
			_tool.tileLevel.width=40;
			_tool.tileLevel.height-=5;
			_tool.tileLevel.tabEnabled=false;
			_tool.tileLevel.textField.editable=false;
			_tool.tileLevelText = new TextField();
			_tool.tileLevelText.x-=10;
			_tool.tileLevelText.y=_tool.tileLevel.y-2;
			_tool.tileLevelText.text="Level";
			_tool.tileLevelText.selectable=false;
			_tool.tileLevelText.textColor=0x000000;
			//_tool.tileLevel.addEventListener(SliderEvent.CHANGE, onTileEditorLevelChange);
			_tool.tileFrameX = new Slider();
			_tool.tileFrameX.maximum=2;
			_tool.tileFrameX.width=50;
			_tool.tileFrameX.tabEnabled=false;
			_tool.tileFrameX.y+=25;
			_tool.tileFrameXText = new TextField();
			_tool.tileFrameXText.text="frame";
			_tool.tileFrameXText.selectable=false;
			_tool.tileFrameXText.textColor=0x000000;
			_tool.tileFrameXText.y=_tool.tileFrameX.y+3;
			_tool.tileFrameXText.x+=12;
			//_tool.tileFrameX.addEventListener(SliderEvent.THUMB_DRAG, onTileEditorFrameXChange);
			//_tool.tileFrameX.addEventListener(SliderEvent.CHANGE, onTileEditorFrameXChange);
			_tool.tileFrameSet = new Slider();
			_tool.tileFrameSet.maximum=2;
			_tool.tileFrameSet.width=50;
			_tool.tileFrameSet.tabEnabled=false;
			_tool.tileFrameSet.y+=_tool.tileFrameX.y+25;
			_tool.tileFrameSetText = new TextField();
			_tool.tileFrameSetText.text="frameSet";
			_tool.tileFrameSetText.selectable=false;
			_tool.tileFrameSetText.textColor=0x000000;
			_tool.tileFrameSetText.y=_tool.tileFrameSet.y+3;
			_tool.tileFrameSetText.x+=8;
			//_tool.tileFrameSet.addEventListener(SliderEvent.THUMB_DRAG, onTileEditorFrameSetChange);
			//_tool.tileFrameSet.addEventListener(SliderEvent.CHANGE, onTileEditorFrameSetChange);
			_tool.tileLayer = new Slider();
			_tool.tileLayer.maximum=_tileMap._tileMap_layer.length-1;
			_tool.tileLayer.width=50;
			_tool.tileLayer.tabEnabled=false;
			_tool.tileLayer.y+=_tool.tileFrameSet.y+25;
			_tool.tileLayerText = new TextField();
			_tool.tileLayerText.text="layer";
			_tool.tileLayerText.selectable=false;
			_tool.tileLayerText.textColor=0x000000;
			_tool.tileLayerText.y=_tool.tileLayer.y+3;
			_tool.tileLayerText.x+=14;
			_tool.tileLayer.addEventListener(SliderEvent.THUMB_DRAG, onTileEditorLayerChange);
			_tool.tileLayer.addEventListener(SliderEvent.CHANGE, onTileEditorLayerChange);
			_tool.tileZoom = new Slider();
			_tool.tileZoom.maximum=10;
			_tool.tileZoom.minimum=5;
			_tool.tileZoom.snapInterval=5;
			_tool.tileZoom.value=10;
			_tool.tileZoom.width=50;
			_tool.tileZoom.tabEnabled=false;
			_tool.tileZoom.y+=_tool.tileLayer.y+25;
			_tool.tileZoomText = new TextField();
			_tool.tileZoomText.text="zoom";
			_tool.tileZoomText.selectable=false;
			_tool.tileZoomText.textColor=0x000000;
			_tool.tileZoomText.y=_tool.tileZoom.y+3;
			_tool.tileZoomText.x+=12;
			//_tool.tileZoom.addEventListener(SliderEvent.CHANGE, onTileEditorZoomChange);
			_tool.tileFlipFrame = new Slider();
			_tool.tileFlipFrame.maximum=1;
			_tool.tileFlipFrame.minimum=0;
			_tool.tileFlipFrame.value=0;
			_tool.tileFlipFrame.width=50;
			_tool.tileFlipFrame.tabEnabled=false;
			_tool.tileFlipFrame.y+=_tool.tileZoom.y+25;
			_tool.tileFlipFrameText = new TextField();
			//_tool.tileFlipFrameText.addEventListener(MouseEvent.CLICK,onTileEditorFlipFrameTextClick);
			//_tool.tileFlipFrameText.addEventListener(MouseEvent.ROLL_OVER,onTileEditorFlipFrameTextRollOver);
			//_tool.tileFlipFrameText.addEventListener(MouseEvent.ROLL_OUT,onTileEditorFlipFrameTextRollOut);
			_tool.tileFlipFrameText.text="flip frame";
			_tool.tileFlipFrameText.selectable=false;
			_tool.tileFlipFrameText.textColor=0x000000;
			_tool.tileFlipFrameText.y=_tool.tileFlipFrame.y+7;
			_tool.tileFlipFrameText.x+=6;
			//_tool.tileFlipFrame.addEventListener(SliderEvent.CHANGE, onTileEditorFlipFrameChange);
			_tool.tileFlipPositionHText = new TextField();
			//_tool.tileFlipPositionHText.addEventListener(MouseEvent.CLICK,onTileEditorFlipPositionHTextClick);
			//_tool.tileFlipPositionHText.addEventListener(MouseEvent.ROLL_OVER,onTileEditorFlipPositionHTextRollOver);
			//_tool.tileFlipPositionHText.addEventListener(MouseEvent.ROLL_OUT,onTileEditorFlipPositionHTextRollOut);
			_tool.tileFlipPositionHText.text="flipH";
			_tool.tileFlipPositionHText.selectable=false;
			_tool.tileFlipPositionHText.textColor=0x000000;
			_tool.tileFlipPositionHText.y=_tool.tileFlipFrameText.y+20;
			_tool.tileFlipPositionHText.x-=5;
			_tool.tileFlipPositionVText = new TextField();
			//_tool.tileFlipPositionVText.addEventListener(MouseEvent.CLICK,onTileEditorFlipPositionVTextClick);
			//_tool.tileFlipPositionVText.addEventListener(MouseEvent.ROLL_OVER,onTileEditorFlipPositionVTextRollOver);
			//_tool.tileFlipPositionVText.addEventListener(MouseEvent.ROLL_OUT,onTileEditorFlipPositionVTextRollOut);
			_tool.tileFlipPositionVText.text="flipV";
			_tool.tileFlipPositionVText.selectable=false;
			_tool.tileFlipPositionVText.textColor=0x000000;
			_tool.tileFlipPositionVText.y=_tool.tileFlipFrameText.y+20;
			_tool.tileFlipPositionVText.x+=40;

			_tool.addChild(_tool.inside);
			_tool.addChild(_tool.mapSizeText);
			_tool.addChild(_tool.mapLevelText);
			_tool.addChild(_tool.tileLevelText);
			_tool.addChild(_tool.tileFrameXText);
			_tool.addChild(_tool.tileFrameSetText);
			_tool.addChild(_tool.tileLayerText);
			_tool.addChild(_tool.tileZoomText);
			_tool.addChild(_tool.tileFlipFrameText);
			_tool.addChild(_tool.tileFlipPositionHText);
			_tool.addChild(_tool.tileFlipPositionVText);
			_tool.addChild(_tool.mapSize);
			_tool.addChild(_tool.mapLevel);
			_tool.addChild(_tool.tileLevel);
			_tool.addChild(_tool.tileFrameSet);
			_tool.addChild(_tool.tileFrameX);
			_tool.addChild(_tool.tileLayer);
			_tool.addChild(_tool.tileZoom);
			_tool.addChild(_tool.tileFlipFrame);
		}
		//-----Move Tile Editor Tool  -----------------------------------
		public function moveTool(x:Number,y:Number):void {
			_tool.x=x;
			_tool.y=y;
			_toolPosition.x=x;
			_toolPosition.y=y;
		}
		//----- On Tile Editor Layer Change -----------------------------------
		private function onTileEditorLayerChange(evt:SliderEvent):void {
			removeChild(_panel);
			_panel = new MovieClip();
			initPanel(_tool.tileLayer.value);
		}
		//-----Init Tile Editor Option  -----------------------------------
		private function initOption():void {
			_option.x=_optionPosition.x;
			_option.y=_optionPosition.y;
			addChild(_option);

			_option.buttonNew = new Button();
			_option.buttonNew.label="New";
			_option.buttonNew.width=75;
			_option.buttonNew.y=175;
			_option.buttonNew.x=0;
			//_option.buttonNew.addEventListener(MouseEvent.CLICK, onButtonNewClick);
			_option.buttonLoad = new Button();
			_option.buttonLoad.label="Load";
			_option.buttonLoad.width=_option.buttonNew.width;
			_option.buttonLoad.y=_option.buttonNew.y;
			_option.buttonLoad.x=_option.buttonNew.x+80;
			//_option.buttonLoad.addEventListener(MouseEvent.CLICK, onButtonLoadClick);
			_option.buttonSave = new Button();
			_option.buttonSave.label="Save";
			_option.buttonSave.width=_option.buttonNew.width;
			_option.buttonSave.y=_option.buttonNew.y;
			_option.buttonSave.x=_option.buttonLoad.x+80;
			_option.buttonSave.addEventListener(MouseEvent.CLICK, onButtonSaveClick);
			_option.buttonProperties = new Button();
			_option.buttonProperties.label="Properties";
			_option.buttonProperties.width=_option.buttonNew.width;
			_option.buttonProperties.y=_option.buttonNew.y;
			_option.buttonProperties.x=_option.buttonSave.x+80;
			//_option.buttonProperties.addEventListener(MouseEvent.CLICK, onButtonPropertiesClick);
			_option.buttonExport = new Button();
			_option.buttonExport.label="Export";
			_option.buttonExport.width=_option.buttonNew.width;
			_option.buttonExport.y=_option.buttonNew.y;
			_option.buttonExport.x=_option.buttonProperties.x+80;
			_option.buttonExport.addEventListener(MouseEvent.CLICK, onButtonExportClick);
			_option.addChild(_option.buttonNew);
			_option.addChild(_option.buttonLoad);
			_option.addChild(_option.buttonSave);
			_option.addChild(_option.buttonProperties);
			_option.addChild(_option.buttonExport);
		}
		//-----Move Tile Editor Option  -----------------------------------
		public function moveOption(x:Number,y:Number):void {
			_option.x=x;
			_option.y=y;
			_optionPosition.x=x;
			_optionPosition.y=y;
		}
		//----- On Button Save Click  -----------------------------------
		public function onButtonSaveClick(event:MouseEvent):void {
			for (var i:Number=0; i<=_tileMap._tileMap_layer.length-1; i++) {
				_tileMap._mapXml.MapTexture.layer[i]=_tileMap._tileMap_layer[i].tileTable;
			}
			System.setClipboard("<?xml version='1.0' encoding='UTF-8'?>"+"\n"+_tileMap._mapXml);
			var file:FileReference = new FileReference();
			file.save("<?xml version='1.0' encoding='UTF-8'?>"+"\n"+_tileMap._mapXml, "map.xml");
		}
		//----- On Button Export Click  -----------------------------------
		public function onButtonExportClick(event:MouseEvent):void {
			var mask: DisplayObject = _tileMap.mask;
			_tileMap.mask = null;
			Export.ExportJPG(_tileMap,"TileMap");
			_tileMap.mask =mask;
		}
		//-----Init Tile Editor Panel  -----------------------------------
		private function initPanel(layerIndex:int=0):void {
			/*_panel.x=_panelPosition.x;
			_panel.y=_panelPosition.y;
			addChild(_panel);

			var layer:Object=_tileMap._tileMap_layer[layerIndex];
			var texture:Bitmap=getGraphic(layer.texture) as Bitmap;
			for (var i:Number=0; i<=5; i++) {
				var tileFrame:Number=i+1;
				var x:int=0;
				var y:int=i;
				var myBitmapData:BitmapData=new BitmapData(layer.tileWidth,layer.tileHeight,true,0);
				myBitmapData.copyPixels(texture.bitmapData, new Rectangle(x * layer.tileWidth,y *layer.tileHeight,layer.tileWidth,layer.tileHeight), new Point(0, 0),null,null,true);
				var bitmap:Bitmap=new Bitmap(myBitmapData);
				var tile:MovieClip = new MovieClip();
				tile.name="tile_"+tileFrame;
				tile.tileFrame=tileFrame;
				tile.bitmapData=myBitmapData;
				tile.bitmap=tile.addChild(bitmap);
				tile.bitmap.x-=layer.tileWidth/2;
				tile.bitmap.y-=layer.tileHeight;
				tile.x=i*layer.tileWidth;
				tile.addEventListener(MouseEvent.MOUSE_DOWN, onPanelMouseDown);
				tile.addEventListener(MouseEvent.MOUSE_UP, onPanelMouseUp);
				tile.addEventListener(MouseEvent.MOUSE_OVER, onPanelMouseRollOver);
				tile.addEventListener(MouseEvent.MOUSE_OUT, onPanelMouseRollOut);
				_panel.addChild(tile);				
			}*/
		}
		//-----Move Tile Editor Panel  -----------------------------------
		public function movePanel(x:Number,y:Number):void {
			_panel.x=x;
			_panel.y=y;
			_panelPosition.x=x;
			_panelPosition.y=y;
		}
		//----- On Mouse Event  -----------------------------------
		private function onPanelMouseDown(evt:MouseEvent):void {
			//trace(evt);
			if (_panelSelectedTile!=evt.target) {
				colorTile(_panelSelectedTile, 1,1,1,1,0,0,0);
				_panelSelectedTile=evt.target as MovieClip;
				colorTile(evt.target as MovieClip, 0.5,0,0,1,0,0,0);
			}
		}
		//----- On Mouse Event  -----------------------------------
		private function onPanelMouseUp(evt:MouseEvent):void {
			//trace(evt);
			//colorTile(evt.target as MovieClip, 1,0,0,1,0,0,0);
		}
		//----- On Mouse Event  -----------------------------------
		private function onPanelMouseRollOver(evt:MouseEvent):void {
			//trace(evt.target);
			if (_panelSelectedTile!=evt.target) {
				colorTile(evt.target as MovieClip, 1,0,0,1,0,0,0);
			}
		}
		//----- On Mouse Event  -----------------------------------
		private function onPanelMouseRollOut(evt:MouseEvent):void {
			//trace(evt);
			if (_panelSelectedTile!=evt.target) {
				colorTile(evt.target as MovieClip, 1,1,1,1,0,0,0);
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}