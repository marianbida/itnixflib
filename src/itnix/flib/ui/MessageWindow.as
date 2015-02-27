package itnix.flib.ui {
	
	import itnix.flib.events.CanvasEvent;
	
	import flash.events.Event;

	public class MessageWindow extends Window {
		
		internal var mText:Label;
		
		public function get text():String {
			return mText.text;
		}
		
		public function set text(txt:String):void {
			mText.text = txt;
			ad2st(null);
		}
		
		public function MessageWindow(title:String="", msg:String="", closable:Boolean = true, minimizable:Boolean = false) {
			super(title, null, closable, minimizable);
			
			content.alpha = 0;
			content.mouseEnabled = false;
			
			mText = new Label();
			mText.selectable = true;
			//mText.mouseChildren = mText.mouseEnabled = false;
			addChild(mText);
			
			mText.text = msg;
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
		}
		
		private function ad2st(e:Event):void {
			resize(	mText.textWidth + borderSize.x + borderSize.width + 30,
					mText.textHeight + borderSize.y + borderSize.height + 30);
			
			center();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			mText.move(content.x + 15, content.y + 15);
			mText.width = content.width;
			
			if(mText.parent != null) {
				removeChild(mText);
			}
			addChildAt(mText, getChildIndex(content));
		}
	}
}