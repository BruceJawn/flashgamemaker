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

package framework.core.system{
	import utils.loader.*;
	import utils.iso.IsoPoint;
	
	import flash.utils.Dictionary;
	import flash.events.*;
	
	/**
	* Physic Manager
	* @ purpose: Handle the physic
	*/
	public class PhysicManager extends LoaderDispatcher implements IPhysicManager {

		private static var _instance:IPhysicManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _spatial_gravity:int =1;
		private var _spatial_friction:int =1;
		private var _map:Object = null
		
		public function PhysicManager() {
			if (! _allowInstanciation) {
				throw new Error("Error: Instantiation failed: Use PhysicManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IPhysicManager {
			if (! _instance) {
				_allowInstanciation=true;
				_instance= new PhysicManager();
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			
		}
		//------ Check Position ------------------------------------
		public function checkPosition(component:*):void {
			if(_map!=null){
				var corners:Object = getCorner(component._spatial_position);
				checkBoundaries(corners);
			}
		}
		//------ Get Corner ------------------------------------
		private function getCorner(spatial_position:IsoPoint):Object {
			var cornerUR:IsoPoint = new IsoPoint(spatial_position.x + _map.tileWidth/4,spatial_position.y - _map.tileHeight/4, spatial_position.z);
			var cornerUL:IsoPoint = new IsoPoint(spatial_position.x - _map.tileWidth/4,spatial_position.y - _map.tileHeight/4, spatial_position.z);
			var cornerDR:IsoPoint = new IsoPoint(spatial_position.x + _map.tileWidth/4,spatial_position.y + _map.tileHeight/4, spatial_position.z);
			var cornerDL:IsoPoint = new IsoPoint(spatial_position.x - _map.tileWidth/4,spatial_position.y + _map.tileHeight/4, spatial_position.z);
			var cornerTop:IsoPoint = new IsoPoint(spatial_position.x,spatial_position.y, spatial_position.z + _map.tileHigh);
			//trace(cornerUR,cornerUL,cornerDR,cornerDL);
			return {cornerUR:cornerUR,cornerUL:cornerUL,cornerDR:cornerDR, cornerDL:cornerDL};
		}
		//------ checkBoundaries  ------------------------------------
		private function checkBoundaries(corners:Object):void {
			trace(corners.cornerUR.x-_map.position.x,corners.cornerUL.x-_map.position.x);
			if(corners.cornerUR.x-_map.position.x>_map.mapWidth*_map.tileWidth){
				trace("collision Right");
			}else if(corners.cornerUL.x-_map.position.x<0){
				trace("collision Left");
			}else if(corners.cornerUL.y-_map.position.y<0){
				trace("collision Left");
			}else if(corners.cornerDL.y-_map.position.y>_map.mapHeight*_map.tileHeight){
				trace("collision Left");
			}/*else if(corners.cornerTop.z>_map.mapHigh*_map.tileHigh){
				trace("collision Top");
			}*/
		}
		//------ Set Map ------------------------------------
		public function setMap(map:Object):void {
			_map=map;
		}
		//------- ToString -------------------------------
		 public  function ToString():void{
           
        }
	}
}