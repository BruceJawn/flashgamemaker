package utils.senocular{
	import flash.events.Event; 
	
	public class PassParameters{
		public function PassParameters(){
		}
		public static function addArguments (method:Function, additionalArguments:Array):Function{
			return function(event:Event):void{
				method.apply(null, [event].concat(additionalArguments));
			}
		}
		//Example
		/*var aNum:int = 5;
		mc.addEventListener(MouseEvent.CLICK, PassParameters.addArguments(onMouseEvent, [aNum]));
		private function onMouseEvent(e:Event,a:int):void{
			trace(a);
		} */
	}
}