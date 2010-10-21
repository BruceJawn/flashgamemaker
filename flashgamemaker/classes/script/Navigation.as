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

package script{
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;

	/**
	* Navigation Script Class
	*
	*/
	public class Navigation {

		private var _scriptName:String = null;
		private var _entityManager:IEntityManager=null;
		
		public function Navigation(scriptName:String) {
			initVar(scriptName);
			initEntity();
			initComponent();
		}
		//------ Init Var ------------------------------------
		private function initVar(scriptName:String):void {
			_scriptName = scriptName;
			_entityManager=EntityManager.getInstance();
		}
		//------ Init Entity ------------------------------------
		private function initEntity():void {
			var entity:IEntity=_entityManager.createEntity("myGameEntity");
		}
		//------ Init Component ------------------------------------
		private function initComponent():void {
			var spatialComponent:SpatialComponent=_entityManager.addComponent("myGameEntity","SpatialComponent","mySpatialComponent");
			var renderComponent:RenderComponent=_entityManager.addComponent("myGameEntity","RenderComponent","myRenderComponent");
			var navigationComponent:NavigationComponent=_entityManager.addComponent("myGameEntity","NavigationComponent","myNavigationComponent");
			navigationComponent.setScript(_scriptName);
		}
		//------- ToString -------------------------------
		public function ToString():void {
			trace(_scriptName);
		}
	}
}