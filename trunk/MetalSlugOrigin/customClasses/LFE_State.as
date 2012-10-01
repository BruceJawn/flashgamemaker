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

package customClasses{
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.getClassByAlias;
	
	import framework.Framework;
	
	import utils.bitmap.BitmapSet;
	import utils.convert.BoolTo;
	import utils.keyboard.KeyPad;
	import utils.math.SimpleMath;
	import utils.physic.SpatialMove;
	import utils.richardlord.State;

	/**
	* LFE_State
	*/
	public class LFE_State extends State implements LFE_IState{
		protected var _object:LFE_ObjectComponent = null;
		private var _throw:Boolean = false;
		private var _bitmap:Bitmap = null;
		protected var _bitmapData:BitmapData = null;
		protected var _debugMode:Boolean = false;
		
		public function LFE_State(){
			_initVar();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			if(_debugMode){
				_initDebugMode();
			}
		}
		//------ Init Var ------------------------------------
		protected function _initDebugMode():void {
			_bitmapData = new BitmapData(10,10,true,0);
			_bitmap = new Bitmap(_bitmapData);
			Framework.AddChild(_bitmap);
		}
		//------ Enter ------------------------------------
		public override function enter($previousState:State):void {
			//trace("Enter Stand");
			if (!_object.bitmapSet)	return;
			var spatialMove:SpatialMove = _object.spatialMove;
			if(!_object.bitmapSet.flip && spatialMove.facingDir.x==-1 || _object.bitmapSet.flip && spatialMove.facingDir.x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
			update();
		}
		//------ Enter ------------------------------------
		public override function update():void {
			//trace("Update Stand");
			if (!_object.bitmapSet)	return;
			if(_debugMode)	_updateDebugMode();
			var spatialMove:SpatialMove = _object.spatialMove;
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			if(frame.hasOwnProperty("hit_Da") && keyPad.down.isDown && keyPad.fire1.isDown && !keyPad.fire1.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Da);
			}else if(frame.hasOwnProperty("hit_Fa") && keyPad.right.isDown && keyPad.fire1.isDown && !keyPad.fire1.getLongClick(125) && (keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)||keyPad.isPreviousKeydPadInputAtIndex(1,keyPad.fire3))){
				updateAnim(frame.hit_Fa);
			}else if(frame.hasOwnProperty("hit_Fa") && keyPad.left.isDown && keyPad.fire1.isDown && !keyPad.fire1.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Fa);
			}else if(frame.hasOwnProperty("hit_Ua") && keyPad.up.isDown && keyPad.fire2.isDown && !keyPad.fire2.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Ua);
			}else if(frame.hasOwnProperty("hit_Dj") && keyPad.down.isDown && keyPad.fire2.isDown && !keyPad.fire2.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Dj);
			}else if(frame.hasOwnProperty("hit_Fj") && keyPad.right.isDown && keyPad.fire2.isDown && !keyPad.fire2.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Fj);
			}else if(frame.hasOwnProperty("hit_Fj") && keyPad.left.isDown && keyPad.fire2.isDown && !keyPad.fire2.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Fj);
			}else if(frame.hasOwnProperty("hit_Uj") && keyPad.up.isDown && keyPad.fire2.isDown && !keyPad.fire2.getLongClick(125) && keyPad.isPreviousKeydPadInputAtIndex(0,keyPad.fire3)){
				updateAnim(frame.hit_Uj);
			}/*else if(frame.hasOwnProperty("dbl_hit_up") && keyPad.up.doubleClick  && keyPad.up.isDown && !keyPad.up.getLongClick(20)){
				updateAnim(frame.dbl_hit_up);
			}else if(frame.hasOwnProperty("dbl_hit_down")&& keyPad.down.doubleClick && keyPad.down.isDown && !keyPad.down.getLongClick(20)){
				updateAnim(frame.dbl_hit_down);
			}*/else if(frame.hasOwnProperty("dbl_hit_right") && keyPad.right.doubleClick){
				updateAnim(frame.dbl_hit_right);
			}else if(frame.hasOwnProperty("dbl_hit_left") && keyPad.left.doubleClick){
				updateAnim(frame.dbl_hit_left);
			}else if(frame.hasOwnProperty("hit_a") && keyPad.fire1.isDown && !keyPad.fire1.getLongClick(30)){
				if(_object.weapon == null){
					if(_object.collision.length>0 && checkWeapon()){
						return;
					}else{
						if(frame.hit_a is Array){
							updateAnim(frame.hit_a[SimpleMath.RandomBetween(0,frame.hit_a.length-1)]);
						}else{	
							updateAnim(frame.hit_a);
						}
					}
				}else{
					checkWeaponThrow();
				}
			}else if(frame.hasOwnProperty("hit_j") && keyPad.fire2.isDown && !keyPad.fire2.getLongClick()){
				updateAnim(frame.hit_j);
			}else if(frame.hasOwnProperty("hit_d") && keyPad.fire3.isDown && !keyPad.fire3.getLongClick()){
				updateAnim(frame.hit_d);
			}else if(frame.hasOwnProperty("hit_up") && keyPad.up.isDown &&  _object.bitmapSet.currentAnimName!=frame.hit_up){
				updateAnim(frame.hit_up);
			}else if(frame.hasOwnProperty("hit_down")&& keyPad.down.isDown &&  _object.bitmapSet.currentAnimName!=frame.hit_down){
				updateAnim(frame.hit_down);
			}else if(frame.hasOwnProperty("hit_right") && keyPad.right.isDown && _object.bitmapSet.currentAnimName!=frame.hit_right){
				updateAnim(frame.hit_right);
			}else if(frame.hasOwnProperty("hit_left") && keyPad.left.isDown &&  _object.bitmapSet.currentAnimName!=frame.hit_left){
				updateAnim(frame.hit_left);
			}else if(frame.hasOwnProperty("next") && _object.bitmapSet.endAnim && (_object.bitmapSet.currentPosition == 0 && _object.bitmapSet.reverse==-1 || _object.bitmapSet.currentPosition == _object.bitmapSet.lastPosition || _object.hasOwnProperty("isDisplayed") && !_object.isDisplayed)){
				if(_object.bitmapSet.readyToAnim){
					if(_object.weapon && (_object.kind == Data.OBJECT_KIND_THROWN_WEAPON || Data.OBJECT_KIND_HEAVY_WEAPON)){
						_object.weapon.updateAnim(frame.wpoint.weaponact);
					}
					updateAnim(frame.next);
				}
		    }
			updateSpeed();
			updateWeapon();
			checkFlip();
			updateState();
		}
		//------ Update Speed ------------------------------------
		public function updateSpeed():void {
			var frame:Object = _object.getCurrentFrame();
			var spatialMove:SpatialMove = _object.spatialMove;
			if(frame.hasOwnProperty("dvx")){
				spatialMove.speed.x = frame.dvx;
				checkMovingDirX(frame.dvx);
			}
			if(frame.hasOwnProperty("dvy")){
				spatialMove.speed.y = frame.dvy;
				checkMovingDirY(frame.dvy);
			}
		}
		//------ CheckMovingDirX ------------------------------------
		public function checkMovingDirX($dvx:Number):void {
			var spatialMove:SpatialMove = _object.spatialMove;
			var keyPad:KeyPad = _object.keyPad;
			if($dvx!=0 && spatialMove.movingDir.x==0 && spatialMove.movingDir.y==0){
				if(spatialMove.facingDir.x!=0){
					spatialMove.movingDir.x = spatialMove.facingDir.x;
				}else if($dvx>0){
					spatialMove.movingDir.x = 1;
				}else if($dvx<0){
					spatialMove.movingDir.x = -1;
				}
			}
		}
		//------ CheckMovingDirY ------------------------------------
		public function checkMovingDirY($dvy:Number):void {
			var spatialMove:SpatialMove = _object.spatialMove;
			if($dvy!=0  && spatialMove.movingDir.x==0 && spatialMove.movingDir.y==0){
				if(spatialMove.facingDir.y!=0){
					spatialMove.movingDir.y = spatialMove.facingDir.y;
				}else if($dvy>0){
					spatialMove.movingDir.y = 1;
				}else if($dvy<0){
					spatialMove.movingDir.y = -1;
				}
			}
		}
		//------ Update Anim ------------------------------------
		public function updateAnim($frameId:int):void {
			var frame:Object = _object.getLfeFrame($frameId);
			_object.lastHit = null;
			if(!frame){
				trace("[WARNING] LFE_STATE : Frame is null !");
			}else{
				_object.setCurrentFrame(frame);
				_object.bitmapSet.graph.anim(frame.name);
			}
		}
		//------ Update State ------------------------------------
		public function updateState():void {
			var frame:Object = _object.getCurrentFrame();
			if(_name!=frame.state){
				//trace(_name,frame.state);
				_finiteStateMachine.changeStateByName(frame.state);
			}
		}
		//------ Check Weapon ------------------------------------
		public function checkWeapon():Boolean {
			var frame:Object = _object.getCurrentFrame();
			if(! _object.weapon && frame && frame.hasOwnProperty("wpoint")){
				var wpoint:Object = frame.wpoint;
				for each(var weapon:LFE_ObjectComponent in _object.collision){
					if(_object.y<weapon.y+weapon.height+_object.lfe_Frame.d/2 && _object.y>weapon.y-_object.lfe_Frame.d/2)	continue;
					if((weapon.kind == Data.OBJECT_KIND_WEAPON || weapon.kind == Data.OBJECT_KIND_THROWN_WEAPON) && weapon.getCurrentState().name=="Stand"){
						updateAnim(_object.lfe_Frame.knee);
						updateState();
						_object.weapon = weapon;
						weapon.source = _object;
						weapon.spatialMove.facingDir.x = _object.spatialMove.facingDir.x;
						weapon.updateAnim(weapon.lfe_Frame.onHand);
						updateWeapon();
						return true;
					}else if(weapon.kind == Data.OBJECT_KIND_HEAVY_WEAPON  && weapon.getCurrentState().name=="Stand"){
						updateAnim(_object.lfe_Frame.heavyObjectStand);
						updateState();
						_object.weapon = weapon;
						weapon.source = _object;
						weapon.spatialMove.facingDir.x = _object.spatialMove.facingDir.x;
						weapon.updateAnim(weapon.lfe_Frame.onHand);
						updateWeapon();
						return true;
					}
				}
			}
			return false;
		}
		//------ Update Weapon ------------------------------------
		public function updateWeapon():void {
			if(_object.weapon ){
				var wpoint:Object = _object.getCurrentFrame().wpoint;
				if(!wpoint){
					_object.weapon.visible = false;
					return;
				}	
				var weaponFrame:Object =_object.weapon.getCurrentFrame();
				if(_object.spatialMove.facingDir.x==1){
					_object.weapon.x = _object.x+wpoint.x;
					if(weaponFrame.hasOwnProperty("offsetX"))	_object.weapon.x+=weaponFrame.offsetX;
				}else{
					_object.weapon.x = _object.x+_object.width-_object.weapon.width-wpoint.x;
					if(weaponFrame.hasOwnProperty("offsetX"))	_object.weapon.x-=weaponFrame.offsetX;
				}
				if(_object.weapon.kind==Data.OBJECT_KIND_HEAVY_WEAPON){
					_object.weapon.y=_object.y-_object.weapon.height+wpoint.y;
					_object.weapon.z=_object.weapon.y-_object.y-_object.weapon.height;
				}else {		
					_object.weapon.y = _object.y+wpoint.y;
					_object.weapon.z=-(_object.y+_object.height-_object.z)+_object.weapon.y+_object.weapon.height;
				}
				if(weaponFrame.hasOwnProperty("offsetY"))	_object.weapon.y+=weaponFrame.offsetY;
				_object.weapon.updateAnimPosition(wpoint.weaponact);
				_object.weapon.updateState();
			}
		}
		//------ Check Weapon Throw ------------------------------------
		public function checkWeaponThrow():void {
			if(_object.weapon ){
				var frame:Object = _object.getCurrentFrame();
				var lfeFrame:Object = _object.lfe_Frame;
				var weaponKind:int = _object.weapon.kind
				if(weaponKind == Data.OBJECT_KIND_WEAPON){
					if(lfeFrame.normalWeaponAttackId is Array){
						updateAnim(lfeFrame.normalWeaponAttackId[SimpleMath.RandomBetween(0,lfeFrame.normalWeaponAttackId.length-1)]);
					}else{	
						updateAnim(lfeFrame.normalWeaponAttackId);
					}
				}else if(weaponKind == Data.OBJECT_KIND_THROWN_WEAPON){
					updateAnim(lfeFrame.lightWeaponAttackId);
				}else if(weaponKind == Data.OBJECT_KIND_HEAVY_WEAPON){
					updateAnim(frame.hit_a);
				}
			}
		}
		//------ Drop Weapon ------------------------------------
		public function dropWeapon():void {
			if(_object.weapon){
				var weaponLfeFrame:Object=_object.weapon.lfe_Frame;
				if(_object.weapon.kind == Data.OBJECT_KIND_HEAVY_WEAPON ){
					if(weaponLfeFrame.hasOwnProperty("inTheSky")){
						object.weapon.source=null;
						object.weapon.updateAnim(weaponLfeFrame.inTheSky);
						object.weapon.updateState();
						object.weapon = null;
					}
				}
			}
		}
		//------ Check Flip ------------------------------------
		protected function checkFlip($force:Boolean=false):void {
			var keyPad:KeyPad = _object.keyPad;
			var frame:Object = _object.getCurrentFrame();
			if(frame.flip || _object.kind>1 || $force){
				if(keyPad.right.isDown || _object.spatialMove.facingDir.x==1 && !keyPad.left.isDown){
					checkFlipX(1);
				}else if(keyPad.left.isDown || _object.spatialMove.facingDir.x==-1){
					checkFlipX(-1);
				}
			}
			if(_object.weapon)	_object.weapon.spatialMove.facingDir.x = _object.spatialMove.facingDir.x;
		}
		//------ Check Flip x ------------------------------------
		protected function checkFlipX($x:Number):void {
			if(!_object.bitmapSet.flip && $x==-1 || _object.bitmapSet.flip && $x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
			if($x==1 && _object.spatialMove.facingDir.x==-1){
				_object.spatialMove.facingDir.x =1;
			}else if($x==-1 && _object.spatialMove.facingDir.x==1){
				_object.spatialMove.facingDir.x =-1;
			} 
		}
		//------ Move ------------------------------------
		protected function move($x:Number, $y:Number,  $z:Number):void {
			//Change moving direction
			var spatialMove:SpatialMove = _object.spatialMove;
			spatialMove.movingDir.x = $x;
			spatialMove.movingDir.y = $y;
			spatialMove.movingDir.z = $z;
		}
		//------ Move ------------------------------------
		protected function moveDir($x:Number, $y:Number,  $z:Number):void {
			//Change facing direction
			var spatialMove:SpatialMove = _object.spatialMove;
			spatialMove.facingDir.x = $x;
			spatialMove.facingDir.y = $y;
			spatialMove.facingDir.z = $z;
			if(!_object.bitmapSet.flip && $x==-1 || _object.bitmapSet.flip && $x==1){
				_object.bitmapSet.flip = !_object.bitmapSet.flip;
			}
		}
		//------ Stop Moving ------------------------------------
		protected function stopMoving():void {
			var spatialMove:SpatialMove = _object.spatialMove;
			spatialMove.movingDir.x = 0;
			spatialMove.movingDir.y = 0;
			spatialMove.movingDir.z = 0;
		}
		//------ CheckObject ------------------------------------
		public function checkObject():void {
			var frame:Object = _object.getCurrentFrame();
			if(frame.hasOwnProperty("opoint") &&_object.bitmapSet.currentAnim.iteration==0 ){
				var object:LFE_ObjectComponent = LFE_Object.CreateObject(frame.opoint.oid,_object);
			}
		}
		//------ GET/SET ------------------------------------
		public function get object():LFE_ObjectComponent {
			return _object;
		}
		//------ UpdateDebugMode ------------------------------------
		protected function  _updateDebugMode():void {
			var frame:Object = _object.getCurrentFrame();
			if(_debugMode && _object.kind==Data.OBJECT_KIND_CHARACTER){
				_drawArea(_object,frame.bdy,0x5F0000FF);
			}
		}
		//------ Draw area ------------------------------------
		protected function  _drawArea($object:LFE_ObjectComponent,$frameArea:Object,$color:uint):void {
			if($frameArea){
				_bitmapData.dispose();
				_bitmap.bitmapData = new BitmapData($frameArea.w,$frameArea.h);
				_bitmapData = _bitmap.bitmapData;
				_bitmapData.lock();
				_bitmapData.fillRect(new Rectangle(0,0,$frameArea.w,$frameArea.h),$color);
				_bitmapData.unlock();
				_bitmap.x=$object.x+$frameArea.x;
				_bitmap.y=$object.y+$frameArea.y;
				if(!_object.bitmapSet.flip){
					_bitmap.x=$object.x+$frameArea.x;
				}else{
					_bitmap.x=$object.x+$object.width-$frameArea.x-$frameArea.w;
				}
			}
		}
		public function set object($object:LFE_ObjectComponent):void {
			_object=$object;
		}
		//------ Exit ------------------------------------
		public override function exit($nextState:State):void {
			//trace("Exit LFE_STATE");
			if(_debugMode){
				if(_bitmapData){
					_bitmapData.lock();
					_bitmapData.fillRect(_bitmapData.rect, 0);
					_bitmapData.unlock();
				}
			}
		}
	}
}