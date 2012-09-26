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

package script{
	import script.game.*;
	import script.game.kawaii.*;
	import script.game.kawaiiIsland.KawaiiIsland;
	import script.game.littleFighterEvo.LittleFighterEvo;
	import script.tutorial.*;
	
	/**
	* MyGame Script 
	*
	*/
	public class MyGame {

		public function MyGame() {
			// ----- Start your game here ------------------------------------------------------
			//----------------------------------------------------------------------------------
			//new HelloWorld();
			//new HelloWorld2();
			//new Tuto2_SimpleGraphicComponent();
			//new Tuto3_BackgroundColorComponent();
			//new Navigation("tutorial.HelloWorld");
			//new Navigation("game.KawaiiFight");
			//new Navigation("game.KawaiiIsland");
			//new Navigation("game.KawaiiOlympic");
			//new Navigation("game.MSOrigin");
			//new KawaiiWorld();
			//new KawaiiIsland();
			new LittleFighterEvo();
			//new Demo();
		}
	}
}