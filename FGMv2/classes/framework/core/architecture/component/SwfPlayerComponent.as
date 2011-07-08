﻿/*
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
	import flash.events.Event;
	import flash.geom.ColorTransform;
	/**
	* Player Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class SwfPlayerComponent extends PlayerComponent {

		public var _source:MovieClip = null; //Swf Source
		public var _swf:MovieClip = null;//container of player
		private var _name:String ="clip";
		
		public function SwfPlayerComponent($componentName:String, $entity:IEntity, $singleton:Boolean = false, $prop:Object = null) {
			super($componentName, $entity);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_animation["RUN"]=2;
			_animation["JUMP"]=3;
			_animation["DOUBLE_JUMP"]=4;
			_animation["ATTACK"]=5;
			//addChild(_colorPicker);
		}
/*		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			super.initProperty();
		}
		//------ Create Player ------------------------------------
		protected override function createPlayer():void {
			if(_swf==null){
				_graphic=_graphicManager.getGraphic(_graphicName);
				var SourceClass:Class = _graphic.constructor;
				_source = new SourceClass();
				initSource();
				_swf = new MovieClip(); 
				_swf.addChild(_source[_name+"1"]);
				setGraphic(_graphicName,_swf);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:Component):void {
				swapFrame();
		}
		//----- Swap Frame -----------------------------------
		public function swapFrame():void {
			if(_swf!=null && _graphic_oldFrame!= _graphic_frame && _swf.numChildren>0){
				var index:int = Math.floor((_graphic_frame-1)/4+1);
				if(_source[_name+index]!=null && !_swf.contains(_source[_name+index])){
					_swf.removeChildAt(0);
					_swf.addChild(_source[_name+index]);   
				}
			}
		}
		//----- Init Source -----------------------------------
		private function initSource():void {
			for (var i:int=0; i<_source.numChildren;i++){
				var clip:MovieClip = _source.getChildAt(i) as MovieClip;
				clip.x=0;
				clip.y=0;
			}
		}
		//------ Change Color ------------------------------------
		public override function changeColor(hexColor:String):void {
			changeClipColor(_source,hexColor,"skin");
		}
		//----- Change Clip Color -----------------------------------
		public function changeClipColor(source:MovieClip, hexColor:String,clipName:String="skin"):void {
			var i:int=0;
			while(i<source.numChildren){
				if(source.getChildAt(i) is MovieClip){
					var clip:MovieClip = source.getChildAt(i) as MovieClip;
					if(clip.name.indexOf(clipName)!=-1){
						var colorTransform:ColorTransform =new ColorTransform();
						colorTransform.color = uint("0x"+hexColor);
						clip.transform.colorTransform=colorTransform;
					}
					if(clip.numChildren>0){
						changeClipColor(clip,hexColor,clipName);
					}
				}
				i++;
			}
		}
		//------ Add Graphic ------------------------------------
		public function addGraphic(graphicName:String, clipName:String, offset:int=0):void {
			
		}
		//------ Add Graphic ------------------------------------
		public function addGraphicFromName(graphicName:String, clipName:String, offset:int=0):void {
			var graphic:*=_graphicManager.getGraphic(graphicName);
			var i:int=0;
			if(_graphic!=null && contains(_graphic) && graphic){
				while(i<_source.numChildren){
					if(_source[_name+i] is MovieClip && _source[_name+i][clipName]){
						var SourceClass:Class = graphic.constructor;
						var clip:MovieClip = new SourceClass();
						clip.name = graphicName;
						if(offset==0 || (offset==2 && i%4<=2 && i%4!=0) || (offset==1 && i%4>2)){
							_source[_name+i][clipName].addChild(clip);
						}else{
							_source[_name+i][clipName].addChildAt(clip,1);
						}
					}
					i++;
				}
			}
		}
		//------ Remove Graphic ------------------------------------
		public function removeGraphicFromName(graphicName:String, clipName:String):void {
			var i:int=0;
			if(_graphic!=null && contains(_graphic)){
				while(i<_source.numChildren){
					if(_source[_name+i] is MovieClip && _source[_name+i][clipName]){
						var clip:MovieClip = _source[_name+i][clipName].getChildByName(graphicName);
						if(clip){
							_source[_name+i][clipName].removeChild(clip);
						}
					}
					i++;
				}
			}
		}
		//------ Clip With Name Go To And Stop ------------------------------------
		public function clipWithNameGoTo(graphicName:String, clipName:String, frame:int):void {
			var i:int=0;
			if(_graphic!=null && contains(_graphic)){
				while(i<_source.numChildren){
					if(_source[_name+i] is MovieClip && _source[_name+i][clipName]){
						var clip:MovieClip = _source[_name+i][clipName].getChildByName(graphicName);
						if(clip){
							clip.gotoAndStop(frame);
						}
					}
					i++;
				}
			}
		}*/
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}