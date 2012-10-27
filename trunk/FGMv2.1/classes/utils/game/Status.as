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
package utils.game{

	public class Status {

		public var life:Number=0;
		public var lifeMax:Number=0;
		public var mp:Number=0;
		public var mpMax:Number=0;
		public var energy:Number=0;
		public var energyMax:Number=0;
		public var level:int = 1;
		public var xp:Number = 0;
		public var xpMax:Number=0;
		public var attack:Number=0; //damage you did to others
		public var kill:Number=0;
		public var unlimitedMp:Boolean=false;
		public var unlimitedLife:Boolean=false;
		
		public function Status($lifeMax:Number, $mpMax:Number, $energyMax:Number=0){
			_initVar($lifeMax,$mpMax,$energyMax);
		}
		private function _initVar($lifeMax:Number, $mpMax:Number, $energyMax:Number):void{
			life = lifeMax = $lifeMax;
			mp = mpMax = $mpMax;
			energy = energyMax = $energyMax;
		}
		public function removeLife($life:Number):void{
			if (unlimitedLife) return;
			life-=$life;
			if(life<0)			life = 0;
			if(life>lifeMax)	life = lifeMax;
		}
		public function removeMp($mp:Number):void{
			if (unlimitedMp) return;
			mp-=$mp;
			if(mp<0)			mp = 0;
			if(mp>mpMax)		mp = mpMax;
		}
		public function removeEnergy($energy:Number):void{
			energy-=$energy;
			if(energy<0)			energy = 0;
			if(energy>energyMax)	energy = energyMax;
		}
		public function reset():void{
			life=lifeMax;
			mp=mpMax;
			energy=energyMax;
			kill=0;
			attack=0;
		}
		public function resetLife():void{
			life=lifeMax;
		}
		public function resetMp():void{
			mp=mpMax;
		}
		public function resetEnergy():void{
			energy=energyMax;
		}
		public function get lifePercent():Number{
			return life/lifeMax;
		}
		public function get mpPercent():Number{
			return mp/mpMax;
		}
		public function get energyPercent():Number{
			return energy/energyMax;
		}
		public function toString():String{
			var res:String= "life="+life+"/"+lifeMax+", mp="+mp+"/"+mpMax+", energy="+energy+"/"+energyMax;
			return res;
		}
	}
}