package itnix.flib.ui {
	
	import itnix.flib.graphics.Canvas;
	
	public final class VRule extends Canvas {
		
		public function VRule(x:Number = 0, y:Number = 0, w:Number = 1, h:Number = 20) {
			super();
			
			style.backgroundAlpha = 1;
			style.backgroundColor = 0xafafaf;
			
			move(x, y);
			resize(w, h);
		}
	}
}