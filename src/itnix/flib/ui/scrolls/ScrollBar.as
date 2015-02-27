package itnix.flib.ui.scrolls {
	
	import itnix.eu.graphics.ScrollBarDownArrow;
	import itnix.eu.graphics.ScrollBarThumb;
	import itnix.eu.graphics.ScrollBarTrack;
	import itnix.eu.graphics.ScrollBarUpArrow;
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	
	public final class ScrollBar extends Canvas {
		
		private var mTrack:ScrollBarTrack;
		private var mArrowUp:ScrollBarUpArrow;
		private var mArrowDown:ScrollBarDownArrow;
		private var mThumb:ScrollBarThumb;
		
		public function ScrollBar(w:Number = NaN, h:Number = NaN) {
			super();
			
			mTrack = new ScrollBarTrack();
			mArrowUp = new ScrollBarUpArrow();
			mArrowDown = new ScrollBarDownArrow();
			mThumb = new ScrollBarThumb();
			
			mThumb.useHandCursor = false;
			
			addChild(mTrack);
			addChild(mArrowUp);
			addChild(mArrowDown);
			addChild(mThumb);
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			
			if(isNaN(w)) w = mTrack.width;
			if(isNaN(h)) h = mTrack.height;
			resize(w, h);
		}
		
		private function onResize(e:CanvasEvent):void {
			mTrack.width =
			mArrowUp.width =
			mArrowDown.width =
			mThumb.width = mWidth;
			
			mArrowUp.scaleY = mArrowUp.scaleX;
			mArrowDown.scaleY = mArrowDown.scaleX;
			
			mTrack.y = mArrowUp.height;
			mTrack.height = mHeight - mTrack.y - mArrowDown.height;
			mArrowDown.y = mHeight - mArrowDown.height;
			mThumb.y = mArrowUp.height;
		}
	}
}