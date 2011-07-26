package script{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.add.architecture.component.*;
	import framework.core.architecture.component.*;
	import framework.core.architecture.entity.*;
	
	/**
	 * Test
	 */
	public class Demo {
		
		public function Demo() {
			//EntityFactory.createBgColor("BgColor", 0x0000FF, 0.5);
			//EntityFactory.createBgGradientColor("BgGradientColor", GradientType.LINEAR, [0x0000FF,0xFFFFFF], [1,1], [0,255]);
			//EntityFactory.createScrollingBitmap("ScrollingBitmap","../assets/nuage.jpg", 0, 30, new Point(1,0));
			//EntityFactory.createGraphic("graphic1", "../FGM.png", 90, 300);EntityFactory.createGraphic("graphic2", "../FGM.png", 90, 500);
			//EntityFactory.createSystemInfo("SystemInfo",0,0);
			//EntityFactory.createTime("Time",200, 200, 0, 15);
			//EntityFactory.createGamePad("GamePad", 10,450);
			//EntityFactory.create2DPlayer("BitmapPlayer", "../assets/templeKnightSet.png", 90, 300, new Point(2,2),false, true,true,true);
			EntityFactory.create2DPlayer("SwfPlayer", "../assets/Panda.swf", 90, 300, new Point(2,2),false, true,true,true);
			//EntityFactory.createCursor("Cursor", "../assets/cursor.swf");
			//EntityFactory.createChrono("Chrono", "../assets/chrono.png", 250,500, 100,100);
			
		}
	}
}