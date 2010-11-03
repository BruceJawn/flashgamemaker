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
	import flash.geom.ColorTransform;
	
	/**
	* BackGround Class
	*/
	public class BackGroundColorComponent extends Component {
		
		private var _bgColor:uint = 0; //HecColor
		
		public function BackGroundColorComponent(componentName:String, componentOwner:IEntity) {
			super(componentName,componentOwner);
			initVar();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			changeColor("FFFFFF");
		}
		//------- Change Color -------------------------------
		public  function changeColor(hexColor:String):void {
			_bgColor= uint("0x"+hexColor);
			FlashGameMaker.CLIP.graphics.beginFill(_bgColor);
            FlashGameMaker.CLIP.graphics.drawRect(0, 0, FlashGameMaker.WIDTH, FlashGameMaker.HEIGHT);
            FlashGameMaker.CLIP.graphics.endFill();			
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace("Color:"+_bgColor);
		}

	}
}