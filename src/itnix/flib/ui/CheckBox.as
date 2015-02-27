package itnix.flib.ui {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.graphics.CheckBoxGraphic;
	import itnix.flib.system.style.Style;
	
	import mx.events.DropdownEvent;
	
	[Event(type="flash.events.Event", name="change")]
	public final class CheckBox extends Canvas {
		
		public static var defaultStyle:Style;
		
		private var mGraphic:CheckBoxGraphic;
		
		public function CheckBox(txt:String = '', w:Number = 150, h:Number = 20) {
			super();
			
			
			if(defaultStyle == null) {
				style.backgroundAlpha = 0;
				style.backgroundColor = 1;
				
				style.textFont = 'Verdana';
				style.textSize = 10;
				style.textColor = 0;
				style.textBold = false;
				style.textItalic = false;
				style.textUnderline = false;
				style.textAlign = TextFormatAlign.LEFT;
			} else {
				style = defaultStyle.clone(this);
			}
			
			buttonMode = true;
			
			mGraphic = new CheckBoxGraphic();
			
			mGraphic.thumb.mouseEnabled =
			mGraphic.text.mouseEnabled = false;
			mGraphic.text.autoSize = TextFieldAutoSize.LEFT;
			
			mGraphic.icon.filters = [
				new DropShadowFilter(1, 45, 0, 1, 3, 3, .35, BitmapFilterQuality.HIGH)
			];
			
			label = txt;
			
			addChild(mGraphic);
			
			addEventListener(MouseEvent.CLICK, onThumbClick);
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			resize(w, h);
		}
		
		public function get checked():Boolean {
			return mGraphic.thumb.visible;
		}
		
		public function set checked(v:Boolean):void {
			if(mGraphic.thumb.visible == v) return; 
			mGraphic.thumb.visible = v;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get label():String {
			return mGraphic.text.text;
		}
		
		public function set label(txt:String):void {
			mGraphic.text.text = txt;
		}
		
		private function onThumbClick(e:MouseEvent):void {
			checked = !checked;
		}
		
		private function onResize(e:CanvasEvent):void {
			
			var tf:TextFormat = style.getTextFormat();
			mGraphic.text.defaultTextFormat = tf;
			mGraphic.text.embedFonts = style.textEmbed;
			mGraphic.text.text = mGraphic.text.text;
			
			mGraphic.icon.width = mGraphic.icon.height = mHeight;
			mGraphic.thumb.width = mGraphic.thumb.height = mHeight;
			
			mGraphic.text.x = mGraphic.icon.x + mGraphic.icon.width + 5;
			mGraphic.text.y = (mHeight - mGraphic.text.textHeight) / 2;
			mGraphic.text.width = mWidth - mGraphic.text.x;
		}
	}
}