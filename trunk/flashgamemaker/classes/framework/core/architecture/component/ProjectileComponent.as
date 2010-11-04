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

	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	/**
	* Projectile Component
	*/
	public class ProjectileComponent extends GraphicComponent {

		private var _source:Bitmap=null;
		private var _rect:Rectangle=null;
		private var _bitmap:Bitmap=null;
		//Attack properties
		public var _attack:Number=1;
		//Timer properties
		public var _timer_on:Boolean=false;
		public var _timer_delay:Number=30;
		public var _timer_count:Number=0;

		public function ProjectileComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
			setPropertyReference("tween",_componentName);
			setPropertyReference("timer",_componentName);
		}
		//------ Load Graphic  ------------------------------------
		public function loadProjectile(path:String,graphicName:String, layer:int, rect:Rectangle,beginX:Number,beginY:Number, destX:Number,destY:Number,speed:int):void {
			_rect=rect;
			_spatial_position.x=beginX;
			_spatial_position.y=beginY;
			loadGraphic(path,graphicName,layer);
			setMovmentTweener(new Point(destX,destY),speed,true);
		}
		//------ On Graphic Loading Successful ------------------------------------
		protected override function onGraphicLoadingSuccessful( evt:Event ):void {
			var dispatcher:EventDispatcher=_graphicManager.getDispatcher();
			dispatcher.removeEventListener(Event.COMPLETE, onGraphicLoadingSuccessful);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, onGraphicLoadingProgress);
			if (_graphicName!=null) {
				_source=_graphicManager.getGraphic(_graphicName) as Bitmap;
				createProjectile();
			}
		}
		//------ Create Projectile ------------------------------------
		private function createProjectile():void {
			if (_source!=null) {
				var myBitmapData:BitmapData=new BitmapData(_rect.width,_rect.height,true,0);
				myBitmapData.copyPixels(_source.bitmapData, _rect, new Point(0, 0),null,null,true);
				_bitmap=new Bitmap(myBitmapData);
				setGraphic(_graphicName,_bitmap);
			}
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
			if (_timer_count>=_timer_delay||! _timer_on) {
				var componentWithProperty:Array=getComponentsWithPropertyName("health");
				for each (var obj:Object in componentWithProperty) {
					var componentName:String=obj.componentName;
					var ownerName:String=obj.ownerName;
					var playerHit:*=getComponent(ownerName,componentName);
					if (isHit(this,playerHit)) {
						playerHit._health_hit=this._attack;
						removeComponent(_componentName);
						refresh("health");
					}
				}
			}
		}
		//------- Is Hit -------------------------------
		private function isHit(bullet:ProjectileComponent, playerHit:*):Boolean {
			if (bullet.hitTestObject(playerHit)) {
				return true;
			}
			return false;
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}
	}
}