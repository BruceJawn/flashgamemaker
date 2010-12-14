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
	import utils.clip.Clip;
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
		public var _mapXml:XML=null;
		private var _mapName:String=null;
		private var _mapTexture:String=null;
		private var _tileMap_iso:Boolean=true;
		private var _tileMap_rect:Boolean=true;
		private var _elevation:Array=null;
		//TileMap Properties
		public var _tileMap_layer:Array=null;
		public var _tileMap_width:int=0;
		public var _tileMap_height:int=0;
		public var _tileMap_high:int=0;
		public var _tileMap_tileWidth:int=0;
		public var _tileMap_tileHeight:int=0;
		public var _tileMap_tileHigh:int=0;
		public var _tileMap_tiles:Dictionary=null;
		public var _tileMap_world:Dictionary=null;
		public var _tileMap_visibility:Object=null;

		public function TileMapComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_ressourceManager=RessourceManager.getInstance();
			_physicManager=PhysicManager.getInstance();
			_tileMap_layer=new Array  ;
			_tileMap_tiles=new Dictionary  ;
			_tileMap_world=new Dictionary  ;
			_tileMap_visibility={beginX:0,beginY:0,beginZ:0,endX:10,endY:10,endZ:5};
			_spatial_properties={dynamic:true,iso:true,direction:"Diagonal",collision:false,isMoving:false,isrunning:false,isJumping:false,isDoubleJumping:false,isFalling:false,isAttacking:false,isSliding:false,isClimbing:false};
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
			var begin:Array=_mapXml.@begin.split(",");
			_tileMap_visibility.beginX=begin[0];
			_tileMap_visibility.beginY=begin[1];
			_tileMap_visibility.beginZ=begin[2];
			var end:Array=_mapXml.@end.split(",");
			_tileMap_visibility.endX=end[0];
			_tileMap_visibility.endY=end[1];
			_tileMap_visibility.endZ=end[2];
			_tileMap_iso=StringTo.Bool(_mapXml.@iso);
			_tileMap_rect=StringTo.Bool(_mapXml.@rect);
			_mapTexture=_mapXml.MapTexture.path;
			for each (var layer:XML in _mapXml.MapTexture.layer) {
				var texture:String=layer.@texture;
				var tileHigh:int=layer.@tileHigh;
				var tileHeight:int=layer.@tileHeight;
				var tileWidth:int=layer.@tileWidth;
				var X:int=layer.@X;
				var Y:int=layer.@Y;
				_tileMap_layer.push({tileTable:layer.toString(),texture:texture,tileHigh:tileHigh,tileHeight:tileHeight,tileWidth:tileWidth,X:X,Y:Y});
			}
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful(evt:Event):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE,onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS,onGraphicLoadingProgress);
			buildMap();
		}
		//------- Build Map -------------------------------
		private function buildMap():void {
			for (var l:int=0; l<_tileMap_layer.length; l++) {
				createLayer(l);
			}
		}
		//------- Set Map -------------------------------
		public function setMap():void {
			var mapPosition:IsoPoint=new IsoPoint(_spatial_position.x,_spatial_position.y);
			mapPosition.x+=_tileMap_tileWidth/4+_tileMap_width*_tileMap_tileWidth/2-1;
			var map:Object={position:mapPosition,mapHigh:_tileMap_high,mapHeight:_tileMap_height,mapWidth:_tileMap_width,tileHigh:_tileMap_tileHigh,tileHeight:_tileMap_tileHeight,tileWidth:_tileMap_tileWidth,tiles:_tileMap_tiles};
			_physicManager.setMap(map);
		}
		//------ Create Layer ------------------------------------
		private function createLayer(l:int):void {
			var layer:String=_tileMap_layer[l].tileTable;
			var tileTable:Array=layer.split(",");
			var sum:Number=0;
			for each (var cell:String in tileTable) {
				var content:Array=cell.split("*");
				if (content.length==2) {
					var num:Number=content[0];
					var tileFrame:Number=content[1];
				} else {
					num=1;
					tileFrame=content[0];
				}
				if (tileFrame!=0) {
					for (var i:Number=0; i<num; i++) {
						var z:int = Math.floor((i+sum)/(_tileMap_height*_tileMap_width));
						var y:int=Math.floor((i+sum)/_tileMap_width);
						var x:int=(i+sum)%_tileMap_width;
						if (onSight(x,y)&&isVisible(x,y,z)) {
							createTile(l,z,y,x,tileFrame);
						}
					}
				}
				sum+=num;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		//------ Create Tile ------------------------------------
		public function createTile(l:int,k:int,j:int,i:int,tileFrame:int):void {
			var tileName:String="tile_"+l+"_"+k+"_"+j+"_"+i;
			var textureName:String=_tileMap_layer[l].texture;
			var tileHigh:int=_tileMap_layer[l].tileHigh;
			var tileHeight:int=_tileMap_layer[l].tileHeight;
			var tileWidth:int=_tileMap_layer[l].tileWidth;
			var X:int=_tileMap_layer[l].X;
			var Y:int=_tileMap_layer[l].Y;
			var tile:Object = new Object();
			updateTile(tile,l,k,j,i,tileHigh,tileHeight,tileWidth,tileFrame,textureName,X,Y);
			displayTile(tile);
			moveTile(tile);
		}
		//------ Update Tile ------------------------------------
		private function updateTile(tile:Object,l:int,k:int,j:int,i:int,tileHigh:int,tileHeight:int,tileWidth:int,tileFrame:int,textureName:String,X:int,Y:int):void {
			var tileName:String="tile_"+l+"_"+k+"_"+j+"_"+i;
			tile.tileName=tileName;
			tile.layer=l;
			tile.ztile=k;
			tile.ytile=j;
			tile.xtile=i;
			tile.tileHigh=tileHigh;
			tile.tileHeight=tileHeight;
			tile.tileWidth=tileWidth;
			tile.tileFrame=tileFrame;
			tile.textureName=textureName;
			tile.flip=false;
			tile.X=X;
			tile.Y=Y;
			_tileMap_tiles[tileName]=tile;
		}
		//------ Move Tile ------------------------------------
		private function displayTile(tile:Object):void {
			if (tile==null) {
				return;
			}
			var tileName:String="tile_"+tile.ztile+"_"+tile.ytile+"_"+tile.xtile;
			if (! _tileMap_world[tileName]) {
				var clip:MovieClip = new MovieClip();
				clip.tileName=tileName;
				clip.tileFrame=tile.tileFrame;
				clip.ztile=tile.ztile;
				clip.ytile=tile.ytile;
				clip.xtile=tile.xtile;
				clip.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
				clip.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				clip.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				clip.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				_tileMap_world[tileName]=Clip.AddChild(this,clip);
			} else {
				clip=_tileMap_world[tileName];
				if (tile.layer==0) {
					clip.graphics.clear();
				}
			}
			if (tile.tileFrame!=0) {
				if (tile.tileFrame<0) {
					tile.flip=true;
					tile.tileFrame*=-1;
				}
				var x:int=(tile.tileFrame-1)% tile.X;
				var y:int=Math.floor((tile.tileFrame-1)/(tile.X));
				var bitmap:Bitmap=getGraphic(tile.textureName) as Bitmap;
				if (! clip.bitmapData) {
					var myBitmapData:BitmapData=new BitmapData(tile.tileWidth,tile.tileHeight,true,0);
				} else {
					if (tile.tileWidth>clip.bitmapData.width||tile.tileHeight>clip.bitmapData.height) {
						var tmp:BitmapData=new BitmapData(tile.tileWidth,tile.tileHeight,true,0);
						tmp.copyPixels(clip.bitmapData, clip.bitmapData.rect, new Point(0, tile.tileHeight-clip.bitmapData.height),null,null,true);
						clip.bitmapData=tmp;
					}
					myBitmapData=clip.bitmapData;
				}
				myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tile.tileWidth, y * tile.tileHeight,tile.tileWidth/2,tile.tileHeight), new Point(tile.tileWidth/2, 0),null,null,true);
				myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tile.tileWidth+tile.tileWidth/2, y * tile.tileHeight,tile.tileWidth/2,tile.tileHeight), new Point(0, 0),null,null,true);
				if (tile.flip) {
					clip.flip=true;
					tile.flip=true;
					flipBitmapData(myBitmapData);
				}
				clip.bitmapData=myBitmapData;
				clip.graphics.beginBitmapFill(myBitmapData);
				clip.graphics.drawRect(-tile.tileWidth/2,-tile.tileHeight,tile.tileWidth,tile.tileHeight);
				clip.graphics.endFill();
			}
		}
		//----- Swap Tile  -----------------------------------
		public function swapTile(l:int,k:int,j:int,i:int, tileFrame:Number):void {
			var tileName:String="tile_"+l+"_"+k+"_"+j+"_"+i;
			if (! _tileMap_tiles[tileName]) {
				createTile(l,k,j,i,tileFrame);
			} else {
				_tileMap_tiles[tileName].tileFrame=tileFrame;
				var tile:Object=_tileMap_tiles[tileName];
				tileName="tile_"+tile.ztile+"_"+tile.ytile+"_"+tile.xtile;
				var clip:MovieClip=_tileMap_world[tileName];
				clip.graphics.clear();
				var myBitmapData:BitmapData=new BitmapData(clip.bitmapData.width,clip.bitmapData.height,true,0);
				for (var l:int = 0; l<_tileMap_layer.length; l++) {
					tileName="tile_"+l+"_"+k+"_"+j+"_"+i;
					tile=_tileMap_tiles[tileName];
					if (tile!=null) {
						if (tile.tileFrame!=0) {
							if (tile.tileFrame<0) {
								tile.flip=true;
								tile.tileFrame*=-1;
							}
							var x:int=(tile.tileFrame-1)% tile.X;
							var y:int=Math.floor((tile.tileFrame-1)/(tile.X));
							var bitmap:Bitmap=getGraphic(tile.textureName) as Bitmap;
							if (tile.tileWidth>clip.bitmapData.width||tile.tileHeight>clip.bitmapData.height) {
								var tmp:BitmapData=new BitmapData(tile.tileWidth,tile.tileHeight,true,0);
								tmp.copyPixels(clip.bitmapData, clip.bitmapData.rect, new Point(0, tile.tileHeight-clip.bitmapData.height),null,null,true);
								clip.bitmapData=tmp;
							}
							myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tile.tileWidth, y * tile.tileHeight,tile.tileWidth/2,tile.tileHeight), new Point(tile.tileWidth/2, 0),null,null,true);
							myBitmapData.copyPixels(bitmap.bitmapData, new Rectangle(x * tile.tileWidth+tile.tileWidth/2, y * tile.tileHeight,tile.tileWidth/2,tile.tileHeight), new Point(0, 0),null,null,true);
							if (tile.flip) {
								clip.flip=true;
								tile.flip=true;
								flipBitmapData(myBitmapData);
							}
							clip.bitmapData=myBitmapData;
							clip.graphics.beginBitmapFill(myBitmapData);
							clip.graphics.drawRect(-tile.tileWidth/2,-tile.tileHeight,tile.tileWidth,tile.tileHeight);
							clip.graphics.endFill();
							setFrame(l,k,j,i,tile.tileFrame);
						}
					}
				}
			}
		}
		//----- On Mouse Event  -----------------------------------
		private function onMouseEvent(evt:MouseEvent):void {
			//trace(evt.target.tileName);
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
			if (tile.layer==0) {
				var position:IsoPoint=tileToScreen(tile.ztile,tile.ytile,tile.xtile,_tileMap_tileHigh,_tileMap_tileHeight,_tileMap_tileWidth);
				if (_tileMap_iso) {
					position=screenToIso(position);
				} else if (_tileMap_rect) {
					position=screenToIsoRectange(position,tile.ytile);
				}
				position.y-=/*- _elevation[tile.ztile][tile.ytile][tile.xtile]+*/tile.ztile*_tileMap_tileHigh;
				var tileName:String="tile_"+tile.ztile+"_"+tile.ytile+"_"+tile.xtile;
				_tileMap_world[tileName].x=position.x;
				_tileMap_world[tileName].y=position.y;
			}
		}
		//----- Tile To Screen -----------------------------------
		private function tileToScreen(k:int,j:int,i:int,tileMap_tileHigh:int,tileMap_tileHeight:int,tileMap_tileWidth:int):IsoPoint {
			var point:IsoPoint=new IsoPoint  ;
			if (_tileMap_iso) {
				point.x=i*tileMap_tileWidth/2;
				point.y=j*tileMap_tileWidth/2;
			} else if (_tileMap_rect) {
				point.x=i*(tileMap_tileWidth-2);
				point.y=j*(tileMap_tileHeight-2)/2;
			}
			return point;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIso(point:IsoPoint):IsoPoint {
			var isoPoint:IsoPoint=new IsoPoint  ;
			isoPoint.x=point.x-point.y;
			isoPoint.y=(point.x+point.y)/2;
			return isoPoint;
		}
		//----- Screen To Iso -----------------------------------
		private function screenToIsoRectange(point:IsoPoint, ytile:Number):IsoPoint {
			var isoPoint:IsoPoint=new IsoPoint  ;
			isoPoint.x=point.x;
			isoPoint.y=point.y;
			if (ytile%2==1) {
				isoPoint.x+=_tileMap_tileWidth/2;
			}
			return isoPoint;
		}
		//------ Reset  ------------------------------------
		public override function reset(ownerName:String,componentName:String):void {
			destroyMap();
		}
		//------- Destroy Map -------------------------------
		private function destroyMap():void {
			trace("Destroy");
		}
		//------ Remove Tile ------------------------------------
		public function removeTile(k:int,j:int,i:int):void {
			var tileName:String="tile_"+k+"_"+j+"_"+i;
			if (_tileMap_world[tileName]) {
				Clip.RemoveChild(this,_tileMap_world[tileName]);
				delete _tileMap_world[tileName];
				for (var l:int =0; l<_tileMap_layer.length; l++) {
					tileName="tile_"+l+"_"+k+"_"+j+"_"+i;
					delete _tileMap_tiles[tileName];
				}
			}
		}
		//------ Set Visibility ------------------------------------
		public function setVisibility(beginX:int, beginY:int,beginZ:int,endX:int,endY:int,endZ:int):void {
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
		public function onSight(i:int, j:int, k:int=0):Boolean {
			if (k>=_tileMap_high||j>=_tileMap_height||i>=_tileMap_width) {
				return false;
			} else if (k<0||j<0||i<0) {
				return false;
			}
			return true;
		}
		//------ is Visible ------------------------------------
		public function isVisible(i:int, j:int, k:int=0):Boolean {
			if (k>=_tileMap_visibility.endZ||j>=_tileMap_visibility.endY||i>=_tileMap_visibility.endX) {
				return false;
			} else if (k<_tileMap_visibility.beginZ||j<_tileMap_visibility.beginY||i<_tileMap_visibility.beginX) {
				return false;
			}
			return true;
		}
		//------ Get Frame ------------------------------------
		public function getFrame(l:int,k:int, j:int, i:int):int {
			var layer:String=_tileMap_layer[l].tileTable;
			var tileTable:Array=layer.split(",");
			var index:Number=0;
			var sum:Number=0;
			while (index<tileTable.length) {
				var cell:String=tileTable[index];
				var content:Array=cell.split("*");
				if (content.length==2) {
					var num:Number=content[0];
					var tileFrame:Number=content[1];
				} else {
					num=1;
					tileFrame=content[0];
				}
				sum+=num;
				if (k*_tileMap_height*_tileMap_width+j*_tileMap_width+i<sum) {
					return tileFrame;
				}
				index++;
			}
			return 0;
		}
		//------ Set Frame ------------------------------------
		public function setFrame(l:int,k:int, j:int, i:int, frame:int):void {
			var layer:String=_tileMap_layer[l].tileTable;
			var tileTable:Array=layer.split(",");
			var index:Number=0;
			var sum:Number=0;
			while (index<tileTable.length) {
				var cell:String=tileTable[index];
				var content:Array=cell.split("*");
				if (content.length==2) {
					var num:Number=content[0];
					var tileFrame:Number=content[1];
				} else {
					num=1;
					tileFrame=content[0];
				}
				sum+=num;
				if (k*_tileMap_height*_tileMap_width+j*_tileMap_width+i<sum) {
					if (content.length==2) {
						var res:String = frame.toString();
						var pos:Number = k*_tileMap_height*_tileMap_width+j*_tileMap_width+i;
						if(sum-pos>2){
							res =res+","+(sum-pos-1)+"*"+tileFrame;
						}else if (sum-pos>1){
							res =res+ ","+tileFrame;
						}
						if(pos-sum+num>1){
							 res= pos-sum+num+"*"+tileFrame+","+res;
						}else if (pos-sum+num==1){
							 res= tileFrame+","+res;
						}
						tileTable[index] = res;
					}else{
						tileTable[index] = frame;
					}
					_tileMap_layer[l].tileTable = tileTable.toString();
					return;
				}
				index++;
			}
			return ;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}