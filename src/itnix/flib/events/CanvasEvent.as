package itnix.flib.events {
	
	import flash.events.Event;
	
	import itnix.flib.graphics.Canvas;

	public class CanvasEvent extends Event {
		
		public static const CANVAS_MOVE:String = 'canvasMove'; 
		public static const CANVAS_RESIZE:String = 'canvasResize';
		
		public function CanvasEvent(type:String) {
			super(type);
		}
		
		public function get hasBothSize():Boolean {
			return !isNaN(currentTarget.width) && !isNaN(currentTarget.height);
		}
	}
}