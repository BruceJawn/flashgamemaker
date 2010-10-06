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
	import framework.core.system.GraphicManager;
	import framework.core.system.IGraphicManager;
	import framework.core.system.RessourceManager;
	import framework.core.system.IRessourceManager;
	import framework.core.system.PhysicManager;
	import framework.core.system.IPhysicManager;
	import utils.convert.*;
	import utils.iso.IsoPoint;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;

	/**
	* TileMap Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TileMapComponent extends GraphicComponent {

		private var _ressourceManager:IRessourceManager=null;
		private var _physicManager:IPhysicManager=null;
		private var _mapXml:XML=null;
		private var _mapName:String=null;
		private var _mapTexture:String=null;
		private var _mapLayer:Array=null;
		private var _tileMap_width:int=0;
		private var _tileMap_height:int=0;
		private var _tileMap_high:int=0;
		private var _tileMap_tileWidth:int=0;
		private var _tileMap_tileHeight:int=0;
		private var _tileMap_tileHigh:int=0;
		private var _tileMap_iso:Boolean=true;
		private var _tileMap_tiles:Dictionary=null;
		private var _walkable:Array=null;
		private var _slopes:Array=null;
		private var _ladder:Array=null;
		private var _slide:Array=null;
		private var _bounce:Array=null;
		private var _teleportation:Array=null;
		private var _elevation:Array=null;


		public function TileMapComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_physicManager=PhysicManager.getInstance();
			_mapLayer = new Array();
			_tileMap_tiles = new Dictionary();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			registerProperty("tileMap",_componentName);
		}
		//------ Load Map ------------------------------------
		public function loadMap(path:String, mapName:String):void {
			_mapName=mapName;
			var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
			dispatcher.addEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
			_ressourceManager.loadXml(path,mapName);
		}
		//------ On Xml Loading Successfull ------------------------------------
		private function onXmlLoadingSuccessful(evt:Event):void {
			_mapXml=_ressourceManager.getXml(_mapName);
			if (_mapXml!=null) {
				var dispatcher:EventDispatcher=_ressourceManager.getDispatcher();
				dispatcher.removeEventListener(Event.COMPLETE,onXmlLoadingSuccessful);
				_mapXml=_ressourceManager.getXml(_mapName);
				serializeXml();
				loadGraphicsFromPath(_mapTexture, "TileMap");
			}
		}
		//------ Serialize Xml ------------------------------------
		private function serializeXml():void {
			_tileMap_width=_mapXml.@mapWidth;
			_tileMap_height=_mapXml.@mapHeight;
			_tileMap_high=_mapXml.@mapHigh;
			_tileMap_tileWidth=_mapXml.@tileWidth;
			_tileMap_tileHeight=_mapXml.@tileHeight;
			_tileMap_tileHigh=_mapXml.@tileHigh;
			_tileMap_iso=_mapXml.@iso;
			_mapTexture=_mapXml.MapTexture.path;
			for each (var layer:XML in _mapXml.MapTexture.layer) {
				var tab:Array=StringTo.Tab(layer.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
				var texture:String=layer.@texture;
				var tileHigh:int=layer.@tileHigh;
				var tileHeight:int=layer.@tileHeight;
				var tileWidth:int=layer.@tileWidth;
				var X:int=layer.@X;
				var Y:int=layer.@Y;
				_mapLayer.push({tileTable: tab,texture:texture,tileHigh:tileHigh,tileHeight:tileHeight,tileWidth:tileWidth,X:X,Y:Y});
			}
			_walkable=StringTo.Tab(_mapXml.MapProperties.walkable.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
			_slopes=StringTo.Tab(_mapXml.MapProperties.slopes.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
			_ladder=StringTo.Tab(_mapXml.MapProperties.ladder.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
			_slide=StringTo.Tab(_mapXml.MapProperties.slide.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
			_bounce=StringTo.Tab(_mapXml.MapProperties.bounce.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
			_teleportation=StringTo.Tab(_mapXml.MapProperties.teleportation.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
			_elevation=StringTo.Tab(_mapXml.MapProperties.elevation.toString(),_tileMap_high,_tileMap_height,_tileMap_width);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			buildMap();
			setMap();
		}
		//------- Build Map -------------------------------
		private function buildMap():void {
			for (var k:int=0; k<_tileMap_high; k++) {
				for (var j:int=0; j<_tileMap_height; j++) {
					for (var i:int=0; i<_tileMap_width; i++) {
						createTile(k,j,i);
					}
				}
			}
		}
		//------- Set Map -------------------------------
		public function setMap():void {
			var mapPosition:IsoPoint = new IsoPoint(_spatial_position.x,_spatial_position.y);
			mapPosition.x+=_tileMap_tileWidth/4+_tileMap_width*(_tileMap_tileWidth/2-1);
			var map:Object={position:mapPosition,mapHigh:_tileMap_high,mapHeight:_tileMap_height,mapWidth:_tileMap_width,tileHigh:_tileMap_tileHigh,tileHeight:_tileMap_tileHeight,tileWidth:_tileMap_tileWidth,tiles:_tileMap_tiles};
			_physicManager.setMap(map);
		}
		//------ Create Tile ------------------------------------
		private function createTile(k:int, j:int, i:int):void {
			var tileName:String="tile_"+k+"_"+j+"_"+i;
			var tileFrame:int=_mapLayer[0].tileTable[k][j][i];
			var textureName:String=_mapLayer[0].texture;
			var tileHigh:int=_mapLayer[0].tileHigh;
			var tileHeight:int=_mapLayer[0].tileHeight;
			var tileWidth:int=_mapLayer[0].tileWidth;
			var X:int=_mapLayer[0].X;
			var Y:int=_mapLayer[0].Y;
			var tileComponent:TileComponent=addComponent(_componentOwner.getName(),"TileComponent",tileName);
			updateTile(tileComponent,k,j,i,tileHigh,tileHeight,tileWidth,tileFrame,textureName,X,Y);
			moveTile(tileComponent, k,j,i);
			_tileMap_tiles[tileName]=tileComponent;
		}
		//------ Update Tile ------------------------------------
		private function updateTile(tileComponent:TileComponent,k:int, j:int, i:int,tileHigh:int, tileHeight:int,tileWidth:int,tileFrame:int, textureName:String, X:int, Y:int ):void {
			var tileName:String="tile_"+k+"_"+j+"_"+i;
			tileComponent._ztile=k;
			tileComponent._ytile=j;
			tileComponent._xtile=i;
			tileComponent._tileHigh=tileHigh;
			tileComponent._tileHeight=tileHeight;
			tileComponent._tileWidth=tileWidth;
			tileComponent._tileFrame=tileFrame;
			tileComponent._textureName=textureName;
			tileComponent._X=X;
			tileComponent._Y=Y;
			tileComponent._walkable=_walkable[k][j][i];
			tileComponent._slopes=_slopes[k][j][i];
			tileComponent._ladder=_ladder[k][j][i];
			tileComponent._slide=_slide[k][j][i];
			tileComponent._bounce=_bounce[k][j][i];
			tileComponent._teleportation=_teleportation[k][j][i];
			tileComponent._elevation=_elevation[k][j][i];
			tileComponent.actualizeComponent(tileName,_componentOwner.getName(),tileComponent);
		}
		//------ Move Tile ------------------------------------
		private function moveTile(tileComponent:TileComponent,k:int, j:int, i:int):void {
			var spatial_position:IsoPoint=tileToScreen(k,j,i,_tileMap_tileHigh,_tileMap_tileHeight,_tileMap_tileWidth);
			if (_tileMap_iso) {
				spatial_position=screenToIso(spatial_position);
			}
			spatial_position.x+=_spatial_position.x+_tileMap_width*(_tileMap_tileWidth/2-1);
			spatial_position.y+=_spatial_position.y-_elevation[k][j][i]-k*_tileMap_tileHigh;
			tileComponent._spatial_position=spatial_position;
		}
		//----- Tile To Screen -----------------------------------
		private function tileToScreen(k:int, j:int, i:int,tileMap_tileHigh:int,tileMap_tileHeight:int,tileMap_tileWidth:int):IsoPoint {
			var point:IsoPoint = new IsoPoint();
			point.x=i*tileMap_tileWidth/2;
			point.y=j*tileMap_tileWidth/2;
			return point;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIso(point:IsoPoint):IsoPoint {
			var isoPoint:IsoPoint = new IsoPoint();
			isoPoint.x = (point.x-point.y);
			isoPoint.y = (point.x+point.y)/2;
			return isoPoint;
		}
		//------ Reset  ------------------------------------
		public override function reset(ownerName:String, componentName:String):void {
			destroyMap();
		}
		//------- Destroy Map -------------------------------
		private function destroyMap():void {
			for (var k:int=0; k<_tileMap_high; k++) {
				for (var j:int=0; j<_tileMap_height; j++) {
					for (var i:int=0; i<_tileMap_width; i++) {
						removeTile(k,j,i);
					}
				}
			}
		}
		//------ Remove Tile ------------------------------------
		private function removeTile(k:int, j:int, i:int):void {
			var tileName:String="tile_"+k+"_"+j+"_"+i;
			removeComponent(tileName);
			delete _tileMap_tiles[tileName];
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}