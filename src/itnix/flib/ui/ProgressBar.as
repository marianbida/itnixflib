package itnix.flib.ui {
	
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.Style;
	
	public final class ProgressBar extends Canvas {
		
		public static var defaultBarStyle:Style;
		public static var defaultProgressStyle:Style;
		
		private var mBG:Canvas;
		private var mProgress:Canvas;
		private var mMask:Canvas;
		private var mShadow:Canvas;
		
		private var mPercents:Label;
		
		private var mProgressValue:Number;
		
		public function ProgressBar(w:Number = 100, h:Number = 20) {
			super();
			
			mBG = new Canvas();
			mProgress = new Canvas();
			mMask = new Canvas();
			mShadow = new Canvas();
			mPercents = new Label();
			
			mShadow.filters = [new DropShadowFilter(1, 45, 0, 1, 4, 4, .6, BitmapFilterQuality.HIGH, true, true)];
			
			mShadow.style.backgroundAlpha = 1;
			mShadow.style.backgroundColor = 0;
			mMask.style.backgroundAlpha = 1;
			mMask.style.backgroundColor = 0;
			
			if(defaultBarStyle != null) {
				mBG.style.copyBackgroundStyleFrom(defaultBarStyle);
			} else {
				mBG.style.backgroundAlpha = .5;
				mBG.style.backgroundColor = 0xafafaf;
			}
			
			if(defaultProgressStyle != null) {
				mProgress.style.copyBackgroundStyleFrom(defaultProgressStyle);
			} else {
				mProgress.style.backgroundAlpha = .5;
				mProgress.style.backgroundColor = 0xafcfff;
			}
			
			mProgress.filters = [
					new DropShadowFilter(1, 45, 0, 1, 2, 2, .7, BitmapFilterQuality.HIGH)
			];
			mProgress.mask =  mMask;
			
			addChild(mBG);
			addChild(mShadow);
			addChild(mProgress);
			addChild(mMask);
			addChild(mPercents);
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			resize(w, h);
			
			progress = 1;
		}
		
		public function get progress():Number {
			return mProgressValue;
		}
		
		public function set progress(p:Number):void {
			p < 0 ? p = 0: void;
			p > 1 ? p = 1: void;
			var n:Number = Math.floor(p * 1000) / 10;
			mPercents.text = n + (int(n) == n ? '.0': '') + '%';
			mProgressValue = p;
			onResize();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			mProgress.move(1, 1);
			mBG.resize(mWidth, mHeight);
			mProgress.resize(mWidth - mProgress.x * 2, mHeight - mProgress.y * 2);
			mShadow.resize(mWidth, mHeight);
			
			mPercents.move((mWidth - mPercents.textWidth) / 2, (mHeight - mPercents.textHeight) / 2);
			
			mMask.resize(mWidth, mHeight);
			mMask.scaleX = mProgressValue;
		}
	}
}