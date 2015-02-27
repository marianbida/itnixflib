package itnix.flib.graphics {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import itnix.flib.events.CanvasEvent;
	
	[Event(name="change", type="flash.events.Event")]
	public class ViewStack extends Canvas {
		
		private var mClasses:Array;
		private var mSelectedIndex:uint;
		private var mView:DisplayObject;
		
		public function get selectedIndex():uint {
			return mSelectedIndex;
		}
		
		public function set selectedIndex(idx:uint):void {
			if(mSelectedIndex == idx) return;
			mSelectedIndex = idx;
			createCurrent();
		}
		
		public function get view():DisplayObject {
			return mView;
		}
		
		public function ViewStack(classes:Array, selectedIndex:uint = 0) {
			super();
			mClasses = classes || [];
			mSelectedIndex = selectedIndex;
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
		}
		
		private function onResize(e:Event = null):void {
			if(mView == null) return;
			if(mView is Canvas) {
				(mView as Canvas).resize(width, height);
			} else {
				mView.width = width;
				mView.height = height;
			}
		}
		
		private function ad2st(e:Event):void {
			createCurrent();
			onResize();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function createCurrent():void {
			if(mSelectedIndex >= mClasses.length)
				mSelectedIndex = mClasses.length - 1;
			
			if(mView != null) {
				removeChild(mView);
				mView = null;
			}
			
			if(mSelectedIndex < 0)
				return;
			
			mView = new mClasses[mSelectedIndex]();
			addChild(mView);
		}
	}
}