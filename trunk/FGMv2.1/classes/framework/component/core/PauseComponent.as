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

package framework.component.core{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	
	import framework.Framework;
	import framework.component.Component;
	import framework.entity.IEntity;
	
	import utils.text.StyleManager;
	import utils.ui.LayoutUtil;
	
	/**
	 * PauseComponent Component
	 * 
	 */
	public class PauseComponent extends Component {
		
		private var _textField:TextField = null;
		public function PauseComponent($componentName:String, $entity:IEntity, $singleton:Boolean = true,  $prop:Object = null) {
			super($componentName, $entity, true);
			_initVar($prop);
		}
		//------ Init Var ------------------------------------
		private function _initVar($prop:Object):void {
			_textField = new TextField();
			_textField.text = "Pause";
			_textField.setTextFormat(StyleManager.Pause);
			_textField.filters = StyleManager.DropShadow;
			if ($prop != null) {
				if($prop.hasOwnProperty("text"))		_textField.text = $prop.text;
				if($prop.hasOwnProperty("textFormat"))	_textField.setTextFormat($prop.textFormat);
				if($prop.hasOwnProperty("filters"))		_textField.filters = $prop.filters;
			}
			Framework.AddChild(_textField,this);
			Framework.AddChild(this);
			Framework.SetChildIndex(this,Framework.numChildren-1);
			LayoutUtil.Align(this,LayoutUtil.ALIGN_CENTER_CENTER);
		}
		//------- ToString -------------------------------
		public override function ToString():void {
			trace();
		}
		
	}
}