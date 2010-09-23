/*
*   @author AngelStreet
*   Blog:http://angelstreetv2.blogspot.com/
*   Google Code: http://code.google.com/p/2d-isometric-engine/
*   Source Forge: https://sourceforge.net/projects/isoengineas3/
*/

/*
* Copyright (C) <2010>  <Joachim N'DOYE>
*
*    This program is distrubuted through the Creative Commons Attribution-NonCommercial 3.0 Unported License.
*    Under this licence you are free to copy, adapt and distrubute the work. 
*    You must attribute the work in the manner specified by the author or licensor. 
*    You may not use this work for commercial purposes.  
*    You should have received a copy of the Creative Commons Public License along with this program.
*    If not,visit http://creativecommons.org/licenses/by-nc/3.0/ or send a letter to Creative Commons,
*    171 Second Street, Suite 300, San Francisco, California, 94105, USA.  
*/

package utils.system{
	import flash.display.*;
	import flash.text.TextField;
	import flash.system.System;
	import utils.time.*;
	import utils.textfield.*;

	/**
	* System Performance  Class
	* Implements the core .
	*/
	public class Performance extends Sprite {

		private var Memory:TextField=null;
		private var FPS:TextField=null;
		private var currentTime:Number=0;

		public function Performance() {
			initVar();
			update();
			addChild(Memory);
			addChild(FPS);
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			Memory = new TextField();
			FPS = new TextField();
			Textfield.moveTextfield(FPS,80,0);
		}
		//------Update  -------------------------------------
		public function update():void {
			updateMemory();
			updateFPS();
		}
		//------Update Memory -------------------------------------
		public function updateMemory():void {
			Memory.text = "Mem :"+(Math.round((System.totalMemory/1048576)*10)/10).toString()+" MB";
		}
		//------Update FPS -------------------------------------
		public function updateFPS():void {
			var fps:Number = 1/((Time.getTime()-currentTime)/1000);
			currentTime=Time.getTime();
			FPS.text="FPS: "+Math.round(fps).toString();
		}
	}
}