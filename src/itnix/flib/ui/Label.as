package itnix.flib.ui {
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flashx.textLayout.operations.RedoOperation;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.Style;
	
	public class Label extends Canvas {
		
		public static var defaultStyle:Style;
		
		private var mTextField:TextField;
		
		public function get textField():TextField {
			return mTextField;
		}
		
		/**
		 *	The selectable property on the TextField
		 */
		public function get selectable():Boolean {
			return mTextField.selectable;
		}
		
		public function set selectable(sel:Boolean):void {
			mTextField.selectable = sel;
		}
		
		public function Label(txt:String = "", x:Number = NaN, y:Number = NaN) {
			super();
			
			if(!isNaN(x)) this.x = x;
			if(!isNaN(y)) this.y = y;
			
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
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			
			mouseEnabled = mouseChildren = false;
			
			mTextField = new TextField();
			mTextField.selectable = false;
			mTextField.mouseEnabled = false;
			
			mTextField.autoSize = TextFieldAutoSize.LEFT;
			
			text = txt == null ? "": txt;
			
			addChild(mTextField);
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
		}
		
		private function ad2st(e:Event):void {
			text = mTextField.text;
		}	  
		
		public function get text():String {
			return mTextField.text;
		}
		
		public function set text(txt:String):void {
			if(txt == null) txt = "";
			
			var tf:TextFormat = new TextFormat();
			tf.bold = style.textBold;
			tf.color = style.textColor;
			tf.font = style.textFont;
			tf.italic = style.textItalic;
			tf.size = style.textSize;
			tf.underline = style.textUnderline;
			
			mTextField.defaultTextFormat = tf;
			mTextField.embedFonts = style.textEmbed;
			
			mTextField.text = txt;
			repositionText();
		}
		
		public function get htmlText():String {
			return mTextField.htmlText;
		}
		
		public function set htmlText(txt:String):void {
			mTextField.htmlText = txt;
			repositionText();
		}
		
		public override function set width(value:Number):void {
			super.width = value;
		}
		
		public override function set height(value:Number):void {
			super.height = value;
		}
		
		public function get textWidth():Number {
			return mTextField.textWidth;
		}
		
		public function get textHeight():Number {
			return mTextField.textHeight;
		}
		
		private function repositionText():void {
			switch(style.textAlign) {
				case TextFormatAlign.CENTER:
					if(isNaN(width)) return;
					mTextField.x = (width - mTextField.width) / 2;
					break;
				default:
					mTextField.x = 0;
					break;
			}
			
			mTextField.y = 0;
			if(!isNaN(width)) {
				mTextField.width = width;
			}
			if(!isNaN(height)) {
				mTextField.height = height;
			} else {
				mHeight = mTextField.textHeight;
			}
		}
		
		private function onResize(e:CanvasEvent):void {
			repositionText();
//			style.redraw();
		}
	}
}