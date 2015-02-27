package itnix.flib.ui {
	
	import itnix.flib.graphics.Canvas;
	
	public final class HRule extends Canvas {
		
		public function HRule(x:Number = 0, y:Number = 0, w:Number = 20, h:Number = 1) {
			super();
			
			style.backgroundAlpha = 1;
			style.backgroundColor = 0x4f4f4f;
			
			move(x, y);
			resize(w, h);
		}
	}
}