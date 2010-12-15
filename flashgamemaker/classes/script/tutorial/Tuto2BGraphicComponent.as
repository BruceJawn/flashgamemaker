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
	/**
	* Tutorial#2-GraphicComponent
	* This tutorial is designed to explain how to use the GraphicComponent
	* In this tutorial you will learn to load dynamically an external graphic file (.png, .jog, .gif or .swf)
	*/
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;
	
	public class Tuto2BGraphicComponent {

		public function Tuto2BGraphicComponent() {
			//Instanciation of the entity manager
			var entityManager:IEntityManager=EntityManager.getInstance(); 
			//Creation of the main entity
			var entity:IEntity=entityManager.createEntity("Entity");
			//In order to be displayed a graphic component need to be registered to the RenderComponent
			var renderComponent:RenderComponent=entityManager.addComponent("Entity","RenderComponent","myRenderComponent");
			//After having called the GraphicComponent, the function loadGraphic load and display
			//a graphic from an url which could be local or remote and display it.
			var graphicComponent:GraphicComponent =entityManager. addComponent("Entity","GraphicComponent","myGraphicComponent");
			graphicComponent.loadGraphic("FGM.png", "myGraphicName");
			//Move the graphicComponent to (x,y)
			graphicComponent.moveTo(100,100);
			//In order to be moved a graphic component need to be registered to the SpatialComponent
			var spatialComponent:SpatialComponent=entityManager.addComponent("Entity","SpatialComponent","mySpatialComponent");			
		}
	}
}