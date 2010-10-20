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
		private var _tileMap_world:Dictionary=null;
		private var _tileMap_visibility:Object=null;
		private var _walkable:Array=null;
		private var _slopes:Array=null;
		private var _ladder:Array=null;
		private var _slide:Array=null;
		private var _bounce:Array=null;
		private var _teleportation:Array=null;
		private var _elevation:Array=null;

		//KeyboardInput properties
		public var _keyboard_key:Object=null;

		public function TileMapComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_physicManager=PhysicManager.getInstance();
			_mapLayer=new Array  ;
			_tileMap_tiles=new Dictionary  ;
			_tileMap_world=new Dictionary  ;
			_tileMap_visibility={beginX:0,beginY:0,beginZ:0,endX:10,endY:10,endZ:5};
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------ Load Map ------------------------------------
		public function loadMap(path:String,mapName:String):void {
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
				loadGraphicsFromPath(_mapTexture,"TileMap");
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
				_mapLayer.push({tileTable:tab,texture:texture,tileHigh:tileHigh,tileHeight:tileHeight,tileWidth:tileWidth,X:X,Y:Y});
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
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,onGraphicLoadingProgress);
			buildMap();
			centerMap(FlashGameMaker.WIDTH/2,FlashGameMaker.HEIGHT/2);
			//setMap();
		}
		//------- Build Map -------------------------------
		private function buildMap():void {
			for (var j:int=_tileMap_visibility.beginY; j<_tileMap_visibility.endY; j++) {
				for (var i:int=_tileMap_visibility.beginX; i<_tileMap_visibility.endX; i++) {
					for (var k:int=_tileMap_visibility.beginZ; k<_tileMap_visibility.endZ; k++) {
						for (var l:int=0; l<_mapLayer.length; l++) {
							if (onSight(i,j,k)) {
								createTile(l,k,j,i);
							}
						}
					}
				}
			}
		}
		//------- Set Map -------------------------------
		public function setMap():void {
			var mapPosition:IsoPoint=new IsoPoint(_spatial_position.x,_spatial_position.y);
			mapPosition.x+=_tileMap_tileWidth/4+_tileMap_width*_tileMap_tileWidth/2-1;
			var map:Object={position:mapPosition,mapHigh:_tileMap_high,mapHeight:_tileMap_height,mapWidth:_tileMap_width,tileHigh:_tileMap_tileHigh,tileHeight:_tileMap_tileHeight,tileWidth:_tileMap_tileWidth,tiles:_tileMap_tiles};
			_physicManager.setMap(map);
		}
		//------ Create Tile ------------------------------------
		private function createTile(l:int,k:int,j:int,i:int):void {
			var tileName:String="tile_"+l+"_"+k+"_"+j+"_"+i;
			var tileFrame:int=_mapLayer[l].tileTable[k][j][i];
			var textureName:String=_mapLayer[l].texture;
			var tileHigh:int=_mapLayer[l].tileHigh;
			var tileHeight:int=_mapLayer[l].tileHeight;
			var tileWidth:int=_mapLayer[l].tileWidth;
			var X:int=_mapLayer[l].X;
			var Y:int=_mapLayer[l].Y;
			var tile:Object = new Object();
			updateTile(tile,l,k,j,i,tileHigh,tileHeight,tileWidth,tileFrame,textureName,X,Y);
			displayTile(tile);
			moveTile(tile);
		}
		//------ Update Tile ------------------------------------
		private function updateTile(tile:Object,l:int,k:int,j:int,i:int,tileHigh:int,tileHeight:int,tileWidth:int,tileFrame:int,textureName:String,X:int,Y:int):void {
			var tileName:String="tile_"+l+"_"+k+"_"+j+"_"+i;
			tile.layer=l;
			tile.ztile=k;
			tile.ytile=j;
			tile.xtile=i;
			tile.tileHigh=tileHigh;
			tile.tileHeight=tileHeight;
			tile.tileWidth=tileWidth;
			tile.tileFrame=tileFrame;
			tile.textureName=textureName;
			tile.X=X;
			tile.Y=Y;
			tile.walkable=_walkable[k][j][i];
			tile.slopes=_slopes[k][j][i];
			tile.ladder=_ladder[k][j][i];
			tile.slide=_slide[k][j][i];
			tile.bounce=_bounce[k][j][i];
			tile.teleportation=_teleportation[k][j][i];
			tile.elevation=_elevation[k][j][i];
			_tileMap_tiles[tileName]=tile;
		}
		//------ Move Tile ------------------------------------
		private function displayTile(tile:Object):void {
			var tileName:String="tile_"+tile.ytile+"_"+tile.xtile;
			if (tile.ztile==0) {
				var clip:MovieClip = new MovieClip();
				_tileMap_world[tileName]=addChild(clip);
			} else {
				clip=_tileMap_world[tileName];
			}
			if (tile.tileFrame<0) {
				tile.flip=true;
				tile.tileFrame*=-1;
			}
			if (tile.tileFrame!=0) {
				var x:int=(tile.tileFrame-1)% clip.X;
				var y:int=Math.floor((tile.tileFrame-1)/(tile.X));
				var bitmap:Bitmap=getGraphic(tile.textureName) as Bitmap;
				var myBitmapData:BitmapData=new BitmapData(tile.tileWidth,tile.tileHeight,true,0);
				myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tile.tileWidth, y * tile.tileHeight,tile.tileWidth,tile.tileHeight), new Point(0, 0),null,null,true);
				if (tile.flip) {
					flipBitmapData(myBitmapData);
				}
				clip.bitmapData=myBitmapData;
				clip.bitmap=clip.addChild(new Bitmap(myBitmapData));
			}
		}
		//----- Flip BitmapData  -----------------------------------
		public function flipBitmapData(myBitmapData:BitmapData):void {
			var flipHorizontalMatrix:Matrix = new Matrix();
			flipHorizontalMatrix.scale(-1,1);
			flipHorizontalMatrix.translate(myBitmapData.width,0);
			var flippedBitmapData:BitmapData=new BitmapData(myBitmapData.width,myBitmapData.height,true,0);
			flippedBitmapData.draw(myBitmapData,flipHorizontalMatrix);
			myBitmapData.fillRect(myBitmapData.rect,0);
			myBitmapData.draw(flippedBitmapData);
		}
		//------ Move Tile ------------------------------------
		private function moveTile(tile:Object):void {
			if (tile.ztile==0) {
				var tileName:String="tile_"+tile.ytile+"_"+tile.xtile;
				var position:IsoPoint=tileToScreen(tile.ztile,tile.ytile,tile.xtile,_tileMap_tileHigh,_tileMap_tileHeight,_tileMap_tileWidth);
				if (_tileMap_iso) {
					position=screenToIso(position);
				}
				//position.x+=_tileMap_width*_tileMap_tileWidth/2-1;
				position.y-=- _elevation[tile.ztile][tile.ytile][tile.xtile]+tile.ztile*_tileMap_tileHigh+tile.tileHeight;
				_tileMap_world[tileName].x=position.x;
				_tileMap_world[tileName].y=position.y;
			}
		}
		//----- Tile To Screen -----------------------------------
		private function tileToScreen(k:int,j:int,i:int,tileMap_tileHigh:int,tileMap_tileHeight:int,tileMap_tileWidth:int):IsoPoint {
			var point:IsoPoint=new IsoPoint  ;
			point.x=i*tileMap_tileWidth/2;
			point.y=j*tileMap_tileWidth/2;
			return point;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIso(point:IsoPoint):IsoPoint {
			var isoPoint:IsoPoint=new IsoPoint  ;
			isoPoint.x=point.x-point.y;
			isoPoint.y=(point.x+point.y)/2;
			return isoPoint;
		}
		//------ Reset  ------------------------------------
		public override function reset(ownerName:String,componentName:String):void {
			destroyMap();
		}
		//------- Destroy Map -------------------------------
		private function destroyMap():void {
			for (var j:int=_tileMap_visibility.beginY; j<_tileMap_visibility.endY; j++) {
				for (var i:int=_tileMap_visibility.beginX; i<_tileMap_visibility.endX; i++) {
					if (onSight(i,j)) {
						removeTile(j,i);
					}
				}
			}
		}
		//------ Remove Tile ------------------------------------
		private function removeTile(j:int,i:int):void {
			var tileName:String="tile_"+j+"_"+i;
			removeChild(_tileMap_world[tileName]);
			delete _tileMap_world[tileName];
		}
		//------ Set Visibility ------------------------------------
		private function setVisibility(beginX:int, beginY:int,beginZ:int,endX:int,endY:int,endZ:int):void {
			if (beginX>endX||beginY>endY||beginZ>endZ) {
				throw new Error("Visibility Error: Begin can not be bigger than End");
			}
			_tileMap_visibility.beginX=beginX;
			_tileMap_visibility.beginY=beginY;
			_tileMap_visibility.beginZ=beginZ;
			_tileMap_visibility.endX=endX;
			_tileMap_visibility.endY=endY;
			_tileMap_visibility.endZ=endZ;
		}
		//------ On Sight ------------------------------------
		private function onSight(i:int, j:int, k:int=0):Boolean {
			if (k>=_tileMap_high||j>=_tileMap_height||i>=_tileMap_width) {
				return false;
			} else if (k<0||j<0||i<0) {
				return false;
			}
			return true;
		}
		//------ Blit Right ------------------------------------
		private function blitRight(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var j:int=_tileMap_visibility.beginY; j<_tileMap_visibility.endY; j++) {
					if (onSight(_tileMap_visibility.beginX,j)) {
						removeTile(j,_tileMap_visibility.beginX);
					}
					for (var k:int=_tileMap_visibility.beginZ; k<_tileMap_visibility.endZ; k++) {
						if (onSight(_tileMap_visibility.endX,j,k)) {
							for (var l:int=0; l<_mapLayer.length; l++) {
								createTile(l,k,j,_tileMap_visibility.endX);
							}
						}
					}
				}
				_tileMap_visibility.beginX++;
				_tileMap_visibility.endX++;
			}
		}
		//------ Blit Left ------------------------------------
		private function blitLeft(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var j:int=_tileMap_visibility.beginY; j<_tileMap_visibility.endY; j++) {
					if (onSight(_tileMap_visibility.endX-1,j)) {
						removeTile(j,_tileMap_visibility.endX-1);
					}
					for (var k:int=_tileMap_visibility.beginZ; k<_tileMap_visibility.endZ; k++) {
						if (onSight(_tileMap_visibility.beginX-1,j,k)) {
							for (var l:int=0; l<_mapLayer.length; l++) {
								createTile(l,k,j,_tileMap_visibility.beginX-1);
							}
						}
					}
				}
				_tileMap_visibility.beginX--;
				_tileMap_visibility.endX--;
			}
		}
		//------ Blit Down ------------------------------------
		private function blitDown(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var i:int=_tileMap_visibility.beginX; i<_tileMap_visibility.endX; i++) {
					if (onSight(i,_tileMap_visibility.beginY)) {
						removeTile(_tileMap_visibility.beginY,i);
					}
					for (var k:int=_tileMap_visibility.beginZ; k<_tileMap_visibility.endZ; k++) {
						if (onSight(i,_tileMap_visibility.endY,k)) {
							for (var l:int=0; l<_mapLayer.length; l++) {
								createTile(l,k,_tileMap_visibility.endY,i);
							}
						}
					}
				}
				_tileMap_visibility.beginY++;
				_tileMap_visibility.endY++;
			}
		}
		//------ Blit Up ------------------------------------
		private function blitUp(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var i:int=_tileMap_visibility.beginX; i<_tileMap_visibility.endX; i++) {
					if (onSight(i,_tileMap_visibility.endY-1)) {
						removeTile(_tileMap_visibility.endY-1,i);
					}
					for (var k:int=_tileMap_visibility.beginZ; k<_tileMap_visibility.endZ; k++) {
						if (onSight(i,_tileMap_visibility.beginY-1,k)) {
							for (var l:int=0; l<_mapLayer.length; l++) {
								createTile(l,k,_tileMap_visibility.beginY-1,i);
							}
						}
					}
				}
				_tileMap_visibility.beginY--;
				_tileMap_visibility.endY--;
			}
		}
		//------ Blit  ------------------------------------
		private function blit(x:int, y:int, z:int):void {
			if(x>= _tileMap_visibility.beginX){
				var offset:int = x-(_tileMap_visibility.endX-_tileMap_visibility.beginX)/2;
				blitRight(offset);
			}else if(x< _tileMap_visibility.beginX){
				offset = x-(_tileMap_visibility.endX-_tileMap_visibility.beginX)/2;
				blitLeft(offset);
			}
			if(y>= _tileMap_visibility.beginY){
				offset = y-(_tileMap_visibility.endY-_tileMap_visibility.beginY)/2;
				blitDown(offset);
			}else if(y< _tileMap_visibility.beginY){
				offset = y-(_tileMap_visibility.endY-_tileMap_visibility.beginY)/2;
				blitUp(offset);
			}
		}
		//------ Center Map  ------------------------------------
		private function centerMap(x:int=0, y:int=0):void {
			_spatial_position.x=x;
			_spatial_position.y=y ;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}