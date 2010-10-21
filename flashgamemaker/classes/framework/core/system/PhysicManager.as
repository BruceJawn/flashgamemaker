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
	import flash.geom.Rectangle;

	/**
	* Physic Manager
	* @ purpose: Handle the physic
	*/
	public class PhysicManager extends LoaderDispatcher implements IPhysicManager {

		private static var _instance:IPhysicManager=null;
		private static var _allowInstanciation:Boolean=false;
		private var _boundaries:Rectangle=null;
		private var _spatial_gravity:int=2;
		private var _spatial_friction:int=1;
		private var _map:Object=null;
		public function PhysicManager() {
			if (! _allowInstanciation||_instance!=null) {
				throw new Error("Error: Instantiation failed: Use PhysicManager.getInstance() instead of new.");
			}
			initVar();
		}
		//------ Get Instance ------------------------------------
		public static function getInstance():IPhysicManager {
			if (_instance==null) {
				_allowInstanciation=true;
				_instance=new PhysicManager  ;
				return _instance;
			}
			return _instance;
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_boundaries=new Rectangle(0,0,FlashGameMaker.WIDTH,FlashGameMaker.HEIGHT);
		}
		//------- Move -------------------------------
		public function move(component:*,spatial_position:IsoPoint):void {
			if (component._spatial_properties.isMoving||hasMoved(component)) {
				if(!component._spatial_properties.dynamic){
					component.x=spatial_position.x+component._spatial_position.x;//Position of the entity + position of the component
					component.y=spatial_position.y+component._spatial_position.y;//Position of the entity + position of the component
				}else{
					moveDynamic(component,spatial_position);
				}				
			}
		}
		//------- Move Dynamic -------------------------------
		private function moveDynamic(component:*,spatial_position:IsoPoint):void {
			var speedX:Number=component._spatial_speed.x;
				var speedY:Number=component._spatial_speed.y;
				if (component._spatial_properties.isRunning) {
					speedX*=2;
					speedY*=2;
				}
				if(component._spatial_properties.direction == "Diagonal" || component._spatial_properties.direction == "Horizontal"){
					horizontalMove(component,component._spatial_dir.x*speedX);
				}
				if(component._spatial_properties.direction == "Diagonal" || component._spatial_properties.direction == "Vertical"){
					verticalMove(component,component._spatial_dir.y*speedY);
				}
				component.x=spatial_position.x+component._spatial_position.x;//Position of the entity + position of the component
				component.y=spatial_position.y+component._spatial_position.y;//Position of the entity + position of the component
				if (component._spatial_properties.iso) {
					isoMove(component);
				}
				if (component._spatial_properties.isJumping) {
					jumpMove(component);
				} else if (component._spatial_properties.isFalling) {
					fallMove(component);
				}
		}
		//------- Horizontal Move -------------------------------
		private function horizontalMove(component:*, value:Number):void {
			if(!component._spatial_properties.collision || component._spatial_position.x-component.width+value>_boundaries.x && component._spatial_position.x+component.width<_boundaries.x+_boundaries.width){
				component._spatial_position.x+=value;
			}
		}
		//------- Vertical Move -------------------------------
		private function verticalMove(component:*, value:Number):void {
			if(!component._spatial_properties.collision || component._spatial_position.y-component.height+value>_boundaries.y && component._spatial_position.y+component.height<_boundaries.y+_boundaries.height){
				component._spatial_position.y+=value;
			}
		}
		//------- Iso Move -------------------------------
		private function isoMove(component:*):void {
			var x:Number=component.x-component.y;
			var y:Number=(component.x+component.y)/2;
			component.x=x;
			component.y=y;
		}
		//------ Is Moved  ------------------------------------
		private function isMoving(component:*):Boolean {
			if (component._spatial_dir.x!=0||component._spatial_dir.y!=0||component._spatial_dir.z!=0||component._spatial_jump.x!=0||component._spatial_jump.y!=0||component._spatial_jump.z!=0) {
				component._spatial_properties.isMoving=true;
				return true;
			}
			component._spatial_properties.isMoving=false;
			return false;
		}
		//------ Has Moved  ------------------------------------
		private function hasMoved(component:*):Boolean {
			if (component._spatial_position.x!=component.x||component._spatial_position.y!=component.y) {
				return true;
			}
			return false;
		}
		//------- Jump Move -------------------------------
		private function jumpMove(component:*):void {
			component._spatial_jump.z+=_spatial_gravity;
			component.y+=component._spatial_jump.z;
			component._spatial_position.y+=component._spatial_jump.z;
			if (component._spatial_jump.z>=0) {
				component._spatial_jump.z=0;
				component._spatial_properties.isJumping=false;
				component._spatial_properties.isFalling=true;
			}
		}
		//------- Fall Move -------------------------------
		private function fallMove(component:*):void {
			component._spatial_jump.z-=_spatial_gravity;
			component.y-=component._spatial_jump.z;
			component._spatial_position.y-=component._spatial_jump.z;
			if (component._spatial_jump.z<=component._spatial_jumpStart.z+_spatial_gravity) {
				component._spatial_jump.z=0;
				component._spatial_properties.isFalling=false;
				isMoving(component);
			}
		}
		//------ Check Position ------------------------------------
		public function checkPosition(component:*):void {
			if (component!=null) {
				var corners:Object=getCorner(component);
				//checkBoundaries(corners,component);
			}
		}
		//------ Get Corner ------------------------------------
		private function getCorner(component:*):Object {
			var position:IsoPoint=component._spatial_position;
			var cornerUR:IsoPoint=new IsoPoint(component.x+component.width/2,component.y-component.height/2,position.z);
			var cornerUL:IsoPoint=new IsoPoint(component.x-component.width/2,component.y-component.height/2,position.z);
			var cornerDR:IsoPoint=new IsoPoint(component.x+component.width/2,component.y+component.height/2,position.z);
			var cornerDL:IsoPoint=new IsoPoint(component.x-component.width/2,component.y+component.height/2,position.z);
			return {cornerUR:cornerUR,cornerUL:cornerUL,cornerDR:cornerDR,cornerDL:cornerDL};
		}
		//------ checkBoundaries  ------------------------------------
		private function checkBoundaries(corners:Object,component:*):void {
			if (component._spatial_dir.x==1&&corners.cornerUR.x>_boundaries.x+_boundaries.width) {
				trace("collision Right");
				component.x=_boundaries.x+_boundaries.width-component.width/2;
			} else if (component._spatial_dir.x==-1&&corners.cornerUL.x<_boundaries.x) {
				trace("collision Left");
				component.x=_boundaries.x+component.width/2;
			} else if (component._spatial_dir.y==-1&&corners.cornerUL.y<_boundaries.y) {
				trace("collision Up");
				component.y=_boundaries.y+component.height;
			} else if (component._spatial_dir.y==1&&corners.cornerDL.y>_boundaries.y+_boundaries.height) {
				trace("collision Down");
				component.y=_boundaries.y+_boundaries.height;
			}
		}
		//------ Set Map ------------------------------------
		public function setMap(map:Object):void {
			_map=map;
		}
		//------- ToString -------------------------------
		public function ToString():void {

		}
	}
}