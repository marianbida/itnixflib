package itnix.flib.system {
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;

	public class Application extends Canvas {
		
		private static var mDebug:Boolean;
		
		public static function get debug():Boolean {
			return mDebug;
		}
		
		private var mAutoResize:Boolean;
		
		protected var mStage:Stage;
		
		public function Application(autoResize:Boolean = true, debug:Boolean = false, stg:Stage = null) {
			super();
			
			mAutoResize = autoResize;
			mDebug = debug;
			
			style.backgroundAlpha = 0;
			style.backgroundColor = 0xffffff;
			
			if(stg == null)
				stg = stage;
			if(stg == null)
				return;
			
			mStage = stg;
			stg.scaleMode = StageScaleMode.NO_SCALE;
			stg.align = StageAlign.TOP_LEFT;
			stg.showDefaultContextMenu = false;
			
			if(mAutoResize) {
				stg.addEventListener(Event.RESIZE, onStageResize);
				onStageResize();
			}
		}
		
		public function set autoResize(a:Boolean):void {
			if(mAutoResize == a) return;
			mAutoResize = a;
			if(mAutoResize) {
				stage.addEventListener(Event.RESIZE, onStageResize);
			} else {
				stage.removeEventListener(Event.RESIZE, onStageResize);
			}
		}
		
		public function get autoResize():Boolean {
			return mAutoResize;
		}
		
		public override function get width():Number {
			return stage != null && mAutoResize ? stage.stageWidth: super.width;
		}
		
		public override function get height():Number {
			return stage != null && mAutoResize ? stage.stageHeight: super.height;
		}
		
		private function onStageResize(e:Event = null):void {
			if(!mAutoResize) return;
			
			dispatchEvent(new CanvasEvent(CanvasEvent.CANVAS_RESIZE));
			
			if(mDebug) {
				graphics.lineStyle(1, 0xff0000);
				graphics.drawRect(0, 0, width - 1, height - 1);
				graphics.moveTo(0, 0);
				graphics.lineTo(width - 1, height - 1);
				graphics.moveTo(width - 1, 0);
				graphics.lineTo(0, height - 1);
			}
		}
	}
}