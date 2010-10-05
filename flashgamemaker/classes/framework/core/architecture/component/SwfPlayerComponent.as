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
	import flash.geom.ColorTransform;
	/**
	* Player Component
	* @ purpose: An entity is an object wich represents something in the game such as player or map. 
	* In FGM an entity is an empty container manager by the EntityManager.
	*/
	public class SwfPlayerComponent extends PlayerComponent {

		private var _source:MovieClip = null; //Swf Source
		private var _swf:MovieClip = null;//container of player
		private var _name:String ="clip";
		
		public function SwfPlayerComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {

		}
		//------ Init Property  ------------------------------------
		public override function initProperty():void {
			setPropertyReference("render",_componentName);
			setPropertyReference("spatial",_componentName);
			setPropertyReference("animation",_componentName);
			setPropertyReference("loadingBar",_componentName);
			setPropertyReference("keyboardMove",_componentName);
		}
		//------ Create Player ------------------------------------
		protected override function createPlayer():void {
				var graphic: MovieClip =getGraphic(_playerName) as MovieClip;
				var SourceClass:Class = graphic.constructor;
				 _source = new SourceClass();
				 initSource();
				 _swf = new MovieClip(); 
				_swf.addChild(_source[_name+"1"]);
				
				setGraphic(_playerName,_swf);
		}
		//------ Actualize Components  ------------------------------------
		public override function actualizeComponent(componentName:String,componentOwner:String,component:*):void {
				swapFrame();
		}
		//----- Swap Frame -----------------------------------
		public function swapFrame():void {
			if(_swf!=null && _graphic_oldFrame!= _graphic_frame && _swf.numChildren>0){
				var index:int = Math.floor((_graphic_frame-1)/4+1);
				if(!_swf.contains(_source[_name+index])){
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
			var i:int=1;
			while(i<_source.numChildren){
				var clip:MovieClip = _source[_name+i];
				colorSourceSkin(clip,hexColor);
				i++;
			}
		}
		//----- Color Source Skin -----------------------------------
		private function colorSourceSkin(source:MovieClip, hexColor:String):void {
			var i:int=0;
			while(i<source.numChildren){
				if(source.getChildAt(i) is MovieClip){
					var clip:MovieClip = source.getChildAt(i) as MovieClip;
					if(clip.name.indexOf("skin")!=-1){
						var colorTransform:ColorTransform =new ColorTransform();
						colorTransform.color = uint("0x"+hexColor);
						clip.transform.colorTransform=colorTransform;
					}
					if(clip.numChildren>1){
						colorSourceSkin(clip,hexColor);
					}
				}
				i++;
			}
		}
		//------- ToString -------------------------------
		public override function ToString():void {

		}

	}
}