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
*    Thanks to Box2DFlashAS3 by boristhebrave, shaktool, skatehead
*    Flash ActionScript 3.0 port of Erin Catto's 2D Physics library Box2D. 
*    https://sourceforge.net/projects/box2dflash/
*    Tutorial from Emanuele Feronato
* 	 http://www.emanueleferonato.com/2010/02/19/box2d-flash-game-creation-tutorial-part-1/
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

package framework.component.add{
	import framework.entity.*;
	import framework.component.*;
	//import Box2D.Dynamics.*;
	//import Box2D.Collision.*;
	//import Box2D.Collision.Shapes.*;
	//import Box2D.Common.Math.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	/**
	* Box2D Component
	*/
	public class Box2DComponent extends GraphicComponent {

		 //_world creation
		//private var _world:b2World;
		//private var _world_scale:int=30;
		//private var _timestep:Number;
		//private var _iterations:uint;
		//private var _pixelsPerMeter:int = 30;
		 //the _player
		//public var _player:b2Body;
		 //_force to apply to the _player
		//public var _force:b2Vec2;
	
		public function Box2DComponent($componentName:String, $entity:IEntity, $singleton:Boolean=false, $prop:Object=null) {
			super($componentName, $entity, $singleton, $prop);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			//makeWorld();
			//makeDebugDraw();
			//updateWorld();
		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------- Make World -------------------------------
		public function makeWorld(gravityX:Number=0,gravityY:Number=10,doSleep=true,timeStep:int=1,iterations:int=10):void{
			 //Define the gravity vector
			//var gravity:b2Vec2 = new b2Vec2(gravityX, gravityY);
			 //Construct a world object
			//_world = new b2World(gravity, doSleep);
			//_world.SetWarmStarting(true);
			//_timestep = timeStep / 30.0;
			//_iterations = iterations;
		}
		// simple function to draw a box
		public function makeBox(x:Number, y:Number, width:Number, height:Number):void {
			//makeWall(x+200,y+height+75,width-100,50);//Bottom
			//makeWall(x+200,y-175,width-100,50);//UP
			//makeWall(x-45,y+125,50,height-100);//Left
			//makeWall(x+width+45,y+125,50,height-100);//Right
		}

		//------- Make Wall -------------------------------
		public function makeWall(x:Number,y:Number,width:Number,height:Number):void{
			//var wall:b2PolygonShape= new b2PolygonShape();
			//var wallBd:b2BodyDef = new b2BodyDef();
			//var wallB:b2Body;
			//wallBd.position.Set( x/ _pixelsPerMeter, y / _pixelsPerMeter / 2);
			//wall.SetAsBox(width/_pixelsPerMeter, height/_pixelsPerMeter/2);
			//wallB = _world.CreateBody(wallBd);
			//wallB.CreateFixture2(wall);
			//updateWorld();
		}
		//------- Make Debug Draw -------------------------------
		private function makeDebugDraw():void{
			//var debugDraw:b2DebugDraw = new b2DebugDraw();
			//var debugSprite:Sprite = new Sprite();
			//addChild(debugSprite);
			//debugDraw.SetSprite(debugSprite);
			//debugDraw.SetDrawScale(30.0);
			//debugDraw.SetFillAlpha(0.3);
			//debugDraw.SetLineThickness(1.0);
			//debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			//_world.SetDebugDraw(debugDraw);
		}
		
		//------- Add Player -------------------------------
		public function addPlayer(px,py):void {
			//var my_body:b2BodyDef= new b2BodyDef();
			//my_body.position.Set(px/_world_scale, py/_world_scale);
			//my_body.type=b2Body.b2_dynamicBody;
			//var my_circle:b2CircleShape=new b2CircleShape(10/_world_scale);
			//var my_fixture:b2FixtureDef = new b2FixtureDef();
			//my_fixture.shape=my_circle;
			//_player=_world.CreateBody(my_body);
			//_player.CreateFixture(my_fixture);
			/*_force=new b2Vec2(0,0);
			_player.ApplyForce(_force,_player.GetWorldCenter());*/
		}
		//------- Update World -------------------------------
		private function updateWorld(e:Event = null):void{
			//_world.Step(_timestep, _iterations, _iterations);
			//_world.ClearForces();
			//_world.DrawDebugData();
		}

		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
	}
}