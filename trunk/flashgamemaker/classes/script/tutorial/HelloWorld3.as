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

package script.tutorial{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;

	/**
	* Hello World
	*
	*/
	public class HelloWorld3 {
		
		private var _entityManager:IEntityManager=null;
		
		public function HelloWorld3() {
			initVar();
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar():void {
			_entityManager = EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			var entity:IEntity=_entityManager.createEntity("Entity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var renderComponent:RenderComponent=_entityManager.addComponent("Entity","RenderComponent","myRenderComponent");
			var textComponent=_entityManager.addComponent("Entity","TextComponent","myText");
			textComponent.moveTo(160,160);
			textComponent.setText("HelloWorld");
			textComponent.setFormat("Times New Roman",16, 0xFF0000);//Font police, size, color
			var spatialComponent:SpatialComponent=_entityManager.addComponent("Entity","SpatialComponent","mySpatialComponent");
		}
	}
}