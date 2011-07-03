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
	* Tutorial#3-BackgroundColorComponent
	* This tutorial is designed to explain how to use the GraphicComponent
	* In this tutorial you will learn to load dynamically an external graphic file (.png, .jog, .gif or .swf)
	*/
	import framework.core.architecture.entity.*;
	import framework.core.architecture.component.*;
	
	public class Tuto2_SimpleGraphicComponent {

		public function Tuto2_SimpleGraphicComponent() {
			var entityManager:IEntityManager=EntityManager.getInstance(); 
			var entity:IEntity=entityManager.createEntity("Entity");
			var renderComponent:RenderComponent=entityManager.addComponentFromName("Entity","RenderComponent","myRenderComponent") as RenderComponent;
			var simpleGraphicComponent:SimpleGraphicComponent=entityManager.addComponentFromName("Entity","SimpleGraphicComponent","myGraphicComponent") as SimpleGraphicComponent;
			simpleGraphicComponent.setBgColor({color:"FF0000", alpha:1});
		}
	}
}