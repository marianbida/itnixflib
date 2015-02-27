package itnix.flib.system {
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import itnix.flib.graphics.Canvas;
	
	public final class Popups {
		
		private static var mStage:Stage;
		private static var mLayer:Sprite;
		private static var mModalBG:Canvas;
		
		private static var mCurrent:Canvas;
		
		public static function init(stage:Stage):void {
			mStage = stage;
			mLayer = new Sprite();
			mModalBG = new Canvas();
			mModalBG.style.backgroundAlpha = .75;
			mModalBG.style.backgroundColor = 0xffffff;
			
			mLayer.addChild(mModalBG);
			mStage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		public static function show(win:Canvas):void {
			hide();
			mCurrent = win;
			mLayer.addChild(mCurrent);
			onStageResize();
		}
		
		public static function hide():void {
			if(mCurrent == null)
				return;
			mLayer.removeChild(mCurrent);
			mCurrent = null;
		}
		
		private static function onStageResize(e:Event = null):void {
			if(mCurrent == null)
				return;
			mModalBG.resize(mStage.stageWidth, mStage.stageHeight);
			mCurrent.move((mStage.stageWidth - mCurrent.width) / 2, (mStage.stageHeight - mCurrent.height) / 2);
		}
		
		
		
		public function Popups() {
			throw 'nope!';
		}
	}
}