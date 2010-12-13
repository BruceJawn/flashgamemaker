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
	import utils.iso.IsoPoint;

	import flash.utils.Dictionary;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;

	/**
	* TileMap Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class TileMapCameraComponent extends Component {


		private var _tileMap:TileMapComponent;
		private var _dir:IsoPoint=null;
		private var _speed:IsoPoint=null;
		private var _position:IsoPoint=null;
		//KeyboardInput properties
		public var _keyboard_gamePad:Object=null;

		public function TileMapCameraComponent(componentName:String,componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_dir=new IsoPoint(0,0);
			_speed=new IsoPoint(60,20,10);
			_position=new IsoPoint(0,0);
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			registerProperty("tileMapCamera",_componentName);
			setPropertyReference("keyboardInput",_componentName);
		}
		//----- Set Camera -----------------------------------
		public function setCamera(dir:IsoPoint, speed:IsoPoint, position:IsoPoint):void {
			_dir=dir;
			_speed=speed;
			_position=position;
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_tileMap==null&&component.constructor==TileMapComponent) {
				_tileMap=component;
			} else if (_tileMap!=null && component._keyboard_gamePad!=null) {
				checkDir();
				scrollMap();
				blitMap();
			}
		}
		//------ Check Dir ------------------------------------
		private function checkDir():void {
			if (_keyboard_gamePad.downRight.isDown) {
				_dir.x=1;
				_dir.y=1;
			} else if (_keyboard_gamePad.downLeft.isDown) {
				_dir.x=-1;
				_dir.y=1;
			} else if (_keyboard_gamePad.upLeft.isDown) {
				_dir.x=-1;
				_dir.y=-1;
			} else if (_keyboard_gamePad.upRight.isDown ) {
				_dir.x=1;
				_dir.y=-1;
			} else if (_keyboard_gamePad.right.isDown) {
				_dir.x=1;
			} else if (_keyboard_gamePad.left.isDown) {
				_dir.x=-1;
			} else if (_keyboard_gamePad.up.isDown) {
				_dir.y=-1;
			} else if (_keyboard_gamePad.down.isDown ) {
				_dir.y=1;
			} else {
				_dir.x=0;
				_dir.y=0;
			}
			if (_tileMap._spatial_position.x<=0&&_dir.x<0||Math.abs(_tileMap._spatial_position.x)<_tileMap.width&&_dir.x>0) {
				_position.x-=_dir.x*_speed.x;
			}
			if (_tileMap._spatial_position.y<=0&&_dir.y<0||Math.abs(_tileMap._spatial_position.y)<_tileMap.height&&_dir.y>0) {
				_position.y-=_dir.y*_speed.y;
			}
		}
		//----- Scroll Map  -----------------------------------
		public function scrollMap():void {
			//trace(_dir.x,"left: "+_tileMap._spatial_position.x," right: "+Math.abs(_tileMap._spatial_position.x),_tileMap._mask.width,_tileMap.width);
			//if (_tileMap._spatial_position.x<=0&&_dir.x<0||Math.abs(_tileMap._spatial_position.x)<_tileMap.width&&_dir.x>0) {
				_tileMap._spatial_position.x-=_dir.x*_speed.x;
			//}
			//if (_tileMap._spatial_position.y<=0&&_dir.y<0||Math.abs(_tileMap._spatial_position.y)<_tileMap.height&&_dir.y>0) {
				_tileMap._spatial_position.y-=_dir.y*_speed.y;
			//}
		}
		//----- Scroll Map  -----------------------------------
		public function blitMap():void {
			if (_dir!=null&&_position!=null) {
				if (_dir.x>0 /*&& Math.round(_position.x/(_tileMap._tileMap_tileWidth/2))+1>=_tileMap._tileMap_visibility.endX*/) {
					//trace("Blitz Right");
					blitRight();
				} else if (_dir.x<0/* && Math.round(_position.x/(_tileMap._tileMap_tileWidth/2))+1<=_tileMap._tileMap_visibility.beginX*/) {
					//trace("Blitz Left");
					blitLeft();
				} else if (_dir.y>0 /*&& Math.round(_position.y/(_tileMap._tileMap_tileHeight/2))+1<=_tileMap._tileMap_visibility.endY*/) {
					//trace("Blitz Down");
					blitDown();
				} else if (_dir.y<0 /*&& Math.round(_position.y/(_tileMap._tileMap_tileHeight/2))+1>=_tileMap._tileMap_visibility.beginY*/) {
					//trace("Blitz Up");
					blitUp();
				}
			}
		}
		//------ Blit Right ------------------------------------
		private function blitRight(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var j:int=_tileMap._tileMap_visibility.beginY; j<_tileMap._tileMap_visibility.endY; j++) {
					for (var k:int=_tileMap._tileMap_visibility.beginZ; k<_tileMap._tileMap_visibility.endZ; k++) {
						if (_tileMap.onSight(_tileMap._tileMap_visibility.beginX,j)) {
							_tileMap.removeTile(k,j,_tileMap._tileMap_visibility.beginX);
						}
						for (var l:int=0; l<_tileMap._tileMap_layer.length; l++) {
							if (_tileMap.onSight(_tileMap._tileMap_visibility.endX,j,k)) {
								var tileFrame:int=_tileMap.getFrame(l,k,j,_tileMap._tileMap_visibility.endX);
								_tileMap.createTile(l,k,j,_tileMap._tileMap_visibility.endX,tileFrame);
							}
						}
					}
				}
				_tileMap._tileMap_visibility.beginX++;
				_tileMap._tileMap_visibility.endX++;
			}
		}
		//------ Blit Left ------------------------------------
		private function blitLeft(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var j:int=_tileMap._tileMap_visibility.beginY; j<_tileMap._tileMap_visibility.endY; j++) {
					for (var k:int=_tileMap._tileMap_visibility.beginZ; k<_tileMap._tileMap_visibility.endZ; k++) {
						if (_tileMap.onSight(_tileMap._tileMap_visibility.endX-1,j)) {
							_tileMap.removeTile(k,j,_tileMap._tileMap_visibility.endX-1);
						}
						for (var l:int=0; l<_tileMap._tileMap_layer.length; l++) {
							if (_tileMap.onSight(_tileMap._tileMap_visibility.beginX-1,j,k)) {
								var tileFrame:int=_tileMap.getFrame(l,k,j,_tileMap._tileMap_visibility.beginX-1);
								_tileMap.createTile(l,k,j,_tileMap._tileMap_visibility.beginX-1,tileFrame);
							}
						}
					}
				}
				_tileMap._tileMap_visibility.beginX--;
				_tileMap._tileMap_visibility.endX--;
			}
		}
		//------ Blit Down ------------------------------------
		private function blitDown(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var i:int=_tileMap._tileMap_visibility.beginX; i<_tileMap._tileMap_visibility.endX; i++) {
					for (var k:int=_tileMap._tileMap_visibility.beginZ; k<_tileMap._tileMap_visibility.endZ; k++) {
						if (_tileMap.onSight(i,_tileMap._tileMap_visibility.beginY)) {
							_tileMap.removeTile(k,_tileMap._tileMap_visibility.beginY,i);
						}
						for (var l:int=0; l<_tileMap._tileMap_layer.length; l++) {
							if (_tileMap.onSight(i,_tileMap._tileMap_visibility.endY,k)) {
								var tileFrame:int=_tileMap.getFrame(l,k,_tileMap._tileMap_visibility.endY,i);
								_tileMap.createTile(l,k,_tileMap._tileMap_visibility.endY,i,tileFrame);
							}
						}
					}
				}
				_tileMap._tileMap_visibility.beginY++;
				_tileMap._tileMap_visibility.endY++;
			}
		}
		//------ Blit Up ------------------------------------
		private function blitUp(offset:int=1):void {
			for (var m:int=0; m<offset; m++) {
				for (var i:int=_tileMap._tileMap_visibility.beginX; i<_tileMap._tileMap_visibility.endX; i++) {
					for (var k:int=_tileMap._tileMap_visibility.beginZ; k<_tileMap._tileMap_visibility.endZ; k++) {
						if (_tileMap.onSight(i,_tileMap._tileMap_visibility.endY-1)) {
							_tileMap.removeTile(k,_tileMap._tileMap_visibility.endY-1,i);
						}
						for (var l:int=0; l<_tileMap._tileMap_layer.length; l++) {
							if (_tileMap.onSight(i,_tileMap._tileMap_visibility.beginY-1,k)) {
								var tileFrame:int=_tileMap.getFrame(l,k,_tileMap._tileMap_visibility.beginY-1,i);
								_tileMap.createTile(l,k,_tileMap._tileMap_visibility.beginY-1,i,tileFrame);
							}
						}
					}
				}
				_tileMap._tileMap_visibility.beginY--;
				_tileMap._tileMap_visibility.endY--;
			}
		}
		//------ Blit  ------------------------------------
		private function blit(x:int, y:int, z:int):void {
			if (x>=_tileMap._tileMap_visibility.beginX) {
				var offset:int = x-(_tileMap._tileMap_visibility.endX-_tileMap._tileMap_visibility.beginX)/2;
				blitRight(offset);
			} else if (x< _tileMap._tileMap_visibility.beginX) {
				offset = x-(_tileMap._tileMap_visibility.endX-_tileMap._tileMap_visibility.beginX)/2;
				blitLeft(offset);
			}
			if (y>=_tileMap._tileMap_visibility.beginY) {
				offset = y-(_tileMap._tileMap_visibility.endY-_tileMap._tileMap_visibility.beginY)/2;
				blitDown(offset);
			} else if (y< _tileMap._tileMap_visibility.beginY) {
				offset = y-(_tileMap._tileMap_visibility.endY-_tileMap._tileMap_visibility.beginY)/2;
				blitUp(offset);
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}