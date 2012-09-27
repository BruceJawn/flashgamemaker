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
	import com.adobe.serialization.json.JSON;
	
	import data.Data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.entity.EntityManager;
	import framework.system.GraphicManager;
	import framework.system.RessourceManager;
	
	import utils.bitmap.BitmapTo;
	import utils.iso.IsoPoint;
	import utils.keyboard.KeyPad;
	import utils.transform.BitmapDataTransform;
	
	/**
	* LittleFighterObject Class
	*/
	public class LFE_Object {
		private static var _list:Dictionary = new Dictionary;
		
		//------- Create Object  -------------------------------
		public static function CreateObject($oid:int, $caller:LFE_ObjectComponent=null, $keyPad:KeyPad=null, $position:IsoPoint=null):LFE_ObjectComponent {
			var object:Object = Data.OBJECT[$oid];
			var dataString:String = RessourceManager.getInstance().getFile(object.data);
			var dataJSON:Object = JSON.decode(dataString);
			var graphics:Array = object.graphics as Array;
			var lfe_object:LFE_ObjectComponent = null;
			switch(object.kind){
				case Data.OBJECT_KIND_CHARACTER: 
					lfe_object=CreatePlayer(object.kind,dataJSON,graphics,$keyPad,$position);
					break;
				case Data.OBJECT_KIND_SPECIAL_MOVE: 
					lfe_object=CreateSpecialMove(object.kind,dataJSON,graphics,$caller);
					break;
				case Data.OBJECT_KIND_WEAPON: 
					lfe_object=CreateWeapon(object.kind,dataJSON,graphics,$caller,$position);
					break;
				case Data.OBJECT_KIND_THROWN_WEAPON: 
					lfe_object=CreateWeapon(object.kind,dataJSON,graphics,$caller,$position);
					break;
				case Data.OBJECT_KIND_HEAVY_WEAPON: 
					lfe_object=CreateWeapon(object.kind,dataJSON,graphics,$caller,$position);
					break;
			}
			return lfe_object;
		}
		//------- Create Player  -------------------------------
		public static function CreatePlayer($kind:int,$data:Object,$graphics:Array,$keyPad:KeyPad=null, $position:IsoPoint=null):LFE_ObjectComponent {
			var lfe_frame:LFE_Frame = new LFE_Frame($data);
			var player:LFE_ObjectComponent= EntityManager.getInstance().addComponentFromName("LittleFighterEvo","LFE_ObjectComponent",null,{lfe_frame:lfe_frame,kind:$kind,keyPad:$keyPad}) as LFE_ObjectComponent;
			if(_list[$graphics]){
				player.createBitmap(_list[$graphics]);
			}else{
				var bitmaps:Vector.<Bitmap> = Vector.<Bitmap>(GraphicManager.getInstance().getGraphics($graphics as Array));
				var bitmap:Bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"VERTICAL");
				BitmapDataTransform.SwapColor(bitmap.bitmapData,0xFF000000,0);//Remove black to transparent
				player.createBitmap(bitmap);
				_list[$graphics] = bitmap;
			}
			if($position){
				player.x=$position.x;
				player.y=$position.y;
			}
			//player.registerPropertyReference("collisionDetection",player.collisionParam);
			return player;
		}
		//------- Create Special Move  -------------------------------
		public static function CreateSpecialMove($kind:int,$data:Object,$graphics:Array, $source:LFE_ObjectComponent):LFE_ObjectComponent {
			var specialMoveframe:LFE_Frame = new LFE_Frame($data);
			var specialMove:LFE_ObjectComponent=EntityManager.getInstance().addComponentFromName("LittleFighterEvo","LFE_ObjectComponent",null,{lfe_frame:specialMoveframe,kind:$kind, source:$source}) as LFE_ObjectComponent;
			if(_list[$graphics]){
				specialMove.createBitmap(_list[$graphics]);
			}else{
				var bitmaps:Vector.<Bitmap> = Vector.<Bitmap>(GraphicManager.getInstance().getGraphics($graphics as Array));
				var bitmap:Bitmap = BitmapTo.BitmapsToBitmap(bitmaps,"VERTICAL");
				BitmapDataTransform.SwapColor(bitmap.bitmapData,0xFF000000,0);//Remove black to transparent
				specialMove.createBitmap(bitmap);
				_list[$graphics] = bitmap;
			}
			var opoint:Object = $source.getCurrentFrame().opoint;
			if(opoint){
				switch (opoint.facing){
					case 0: specialMove.spatialMove.facingDir = $source.spatialMove.facingDir;//move in front of source
						break;
					case 1: specialMove.spatialMove.facingDir = $source.spatialMove.facingDir.toInverse();//move in front of source
						break;
				}
				specialMove.x=$source.x+(opoint.x+opoint.dvx)*specialMove.spatialMove.facingDir.x;//dvx and dvy are the original propulsion
				specialMove.y=$source.y+opoint.y+opoint.dvy;
			}
			specialMove.registerPropertyReference("collisionDetection");
			return specialMove;
		}
		//------- Create Weapon  -------------------------------
		public static function CreateWeapon($kind:int,$data:Object,$graphics:Array, $source:LFE_ObjectComponent=null, $position:IsoPoint=null):LFE_ObjectComponent {
			var weaponframe:LFE_Frame = new LFE_Frame($data);
			var weapon:LFE_ObjectComponent=EntityManager.getInstance().addComponentFromName("LittleFighterEvo","LFE_ObjectComponent",null,{lfe_frame:weaponframe,kind:$kind, source:$source}) as LFE_ObjectComponent;
			if(_list[$graphics]){
				weapon.createBitmap(_list[$graphics]);
			}else{
				var bitmap:Bitmap = GraphicManager.getInstance().getGraphic($graphics[0]);
				BitmapDataTransform.SwapColor(bitmap.bitmapData,0xFF000000,0);//Remove black to transparent
				weapon.createBitmap(bitmap);	
				_list[$graphics]=bitmap;
			}
			if($source){
				var wpoint:Object = $source.getCurrentFrame().wpoint;
				if(wpoint){
					weapon.x=$source.x+wpoint.x*weapon.spatialMove.facingDir.x;
					weapon.y=$source.y+wpoint.y;
				}
			}else if($position){
				weapon.x = $position.x;
				weapon.y = $position.y;
				weapon.z= $position.z;
			}
			if($position.z>0){
				weapon.updateAnim(weaponframe.data.inTheSky);
				weapon.updateState();
				weapon.spatialMove.speed.z = $position.z;
			}else{
				weapon.updateAnim(weaponframe.data.stand);
				weapon.updateState();
			}
			weapon.registerPropertyReference("collisionDetection",{activeCollision:false});
			return weapon;
		}
	}
}