package itnix.flib.system {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public final class MouseCursorMngr {
		
		public static function getCursor(stage:Stage):MouseCursor {
			return stage.getChildByName(MouseCursor.NAME) as MouseCursor;
		}
		
		public static function setCursor(stage:Stage, c:MouseCursor):void {
			var oldc:MouseCursor = getCursor(stage);
			if(oldc == c) return;
			if(oldc != null) {
				if(oldc.parent != null)
					oldc.parent.removeChild(oldc);
			}
			
			c != null ?
				addListeners(stage):
				removeListeners(stage);
		}
		
		private static function addListeners(stage:Stage):void {
			var oldc:MouseCursor = getCursor(stage);
			if(oldc.bitmapData == null) {
				Mouse.show();
			} else {
				Mouse.hide();
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
		}
		
		private static function removeListeners(stage:Stage):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
		}
		
		private static function onMouseEvent(e:MouseEvent):void {
			var stage:Stage = e.currentTarget as Stage;
			var c:MouseCursor = getCursor(stage);
			if(c == null) return;
			
			switch(e.type) {
				case MouseEvent.MOUSE_MOVE:
					c.move(stage.mouseX, stage.mouseY);
					break;
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function MouseCursorMngr() {
			throw 'sure... :D';
		}
	}
}