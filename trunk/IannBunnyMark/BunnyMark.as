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
package {
	import flash.display.Bitmap;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.component.core.*;
	import framework.entity.*;
	import framework.system.*;
	
	/**
	 * Bunny Mark test
	 * http://blog.iainlobb.com/2011/02/bunnymark-compiled-from-actionscript-to.html
	 */
	public class BunnyMark {
		
		private var _entityManager:IEntityManager =null;
		private var _bunnies:Array = null;
		public var numBunnies:int = 1000;
		public var gravity:Number = 3;
		public var maxX:int = 640;
		public var minX:int = 0;
		public var maxY:int = 480;
		public var minY:int = 0;
		
		public function BunnyMark() {
			_initVar();
			_initComponent();
			_createBunnies();
			_initLoop();
		}
		//------ Init Var ------------------------------------
		private function _initVar():void {
			_entityManager = EntityManager.getInstance();
			_bunnies = new Array();
		}
		//------ Init Component ------------------------------------
		private function _initComponent():void {
			var entity:IEntity=_entityManager.createEntity("Entity");
			var renderComponent:RenderComponent = _entityManager.addComponentFromName("Entity","RenderComponent","myRenderComponent") as RenderComponent;
			var bitmapRenderComponent:BitmapRenderComponent=_entityManager.addComponentFromName("Entity","BitmapRenderComponent","myBitmapRenderComponent",{sortDepth:false}) as BitmapRenderComponent;
			var enterFrameComponent:EnterFrameComponent=_entityManager.addComponentFromName("Entity","EnterFrameComponent","myEnterFrameComponent") as EnterFrameComponent;
			//var systemInfoComponent:SystemInfoComponent=_entityManager.addComponentFromName("Entity","SystemInfoComponent","mySystemInfoComponent") as SystemInfoComponent;
			//systemInfoComponent.moveTo(0, 30);
		}
		//------ Create Bunnies ------------------------------------
		private function _createBunnies():void {
			var bunny:GraphicComponent 
			for (var i:Number=0; i<numBunnies; i++){
				bunny =_entityManager.addComponentFromName("Entity","GraphicComponent",null,{render:"bitmapRender"}) as GraphicComponent;
				bunny.loadGraphic(Framework.root+"assets/wabbit_alpha.png");
				bunny.moveTo(Math.random()*300,Math.random()*300+100,1);
				_bunnies.push(bunny);
				bunny.prop.speedX = Math.random() * 10;
				bunny.prop.speedY = (Math.random() * 10) - 5;
			}
		}
		//------ Init Loop ------------------------------------
		private function _initLoop():void {
			var loop:Component = _entityManager.addComponentFromName("Entity","Component","myLoopComponent") as Component;
			loop.registerPropertyReference("enterFrame",{onEnterFrame:onTick});
		}
		//------ On Tick ------------------------------------
		private function onTick():void {
			for each(var bunny:GraphicComponent in _bunnies){
				bunny.x += bunny.prop.speedX;
				bunny.y += bunny.prop.speedY;
				bunny.prop.speedY += gravity;
				
				if (bunny.x > maxX)
				{
					bunny.prop.speedX *= -1;
					bunny.x = maxX;
				}
				else if (bunny.x < minX)
				{
					bunny.prop.speedX *= -1;
					bunny.x = minX;
				}
				
				if (bunny.y > maxY)
				{
					bunny.prop.speedY *= -0.8;
					bunny.y = maxY;
					
					if (Math.random() > 0.5)
					{
						bunny.prop.speedY -= Math.random() * 12;
					}
				} 
				else if (bunny.y < minY)
				{
					bunny.prop.speedY = 0;
					bunny.y = minY;
				}
			}
		}
	}
}