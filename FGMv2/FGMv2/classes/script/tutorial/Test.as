package script.tutorial{
	import flash.display.GradientType;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import framework.core.architecture.component.*;
	import framework.core.architecture.entity.*;
	
	/**
	 * Test
	 */
	public class Test {
		
		public function Test() {
			var entityManager:IEntityManager=EntityManager.getInstance(); 
			var entity:IEntity=entityManager.createEntity("Entity");
			var renderComponent:RenderComponent=entityManager.addComponentFromName("Entity","RenderComponent","myRenderComponent") as RenderComponent;
			var graphicComponent:GraphicComponent=entityManager.addComponentFromName("Entity","GraphicComponent","myGraphicComponent") as GraphicComponent;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(50, 50, Math.PI/2, 0, 0);
			var rectangle:Rectangle = new Rectangle(0,0,100,100)
			graphicComponent.setBgColor({color:0xFF0000, alpha:1, rectangle:rectangle, matrix:matrix});
			//graphicComponent.setBgColor({type:GradientType.LINEAR, colors:[0x000000,0x999999], alphas:[1.0,1.0], ratios:[0,255], rectangle:rectangle, matrix:matrix});
			graphicComponent.loadGraphic("../FGM.png");
			graphicComponent.moveTo(100,100);
		}
	}
}