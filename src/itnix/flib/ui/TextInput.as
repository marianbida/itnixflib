package itnix.flib.ui {
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.Style;
	
	public final class TextInput extends Canvas {
		
		public static var defaultStyle:Style;
		
		private var mTextField:TextField;
		
		public function TextInput(passwd:Boolean = false) {
			
			mTextField = new TextField();
			
			mTextField.displayAsPassword = passwd;
			
			if(defaultStyle == null) {
				style = new Style(this);
				style.backgroundAlpha = 1;
				style.backgroundColor = 0xffffff;
				
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
			
			mTextField.type = TextFieldType.INPUT;
			
			addChild(mTextField);
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			resize(100, 20);
		}
		
		public function get enabled():Boolean {
			return mTextField.type == TextFieldType.INPUT;
		}
		
		public function set enabled(en:Boolean):void {
			if(en) {
				mTextField.type = TextFieldType.INPUT;
				mTextField.alpha = 1;
			} else {
				mTextField.type = TextFieldType.DYNAMIC;
				mTextField.alpha = .6;
			}
		}
		
		public function get text():String {
			return mTextField.text;
		}
		
		public function set text(txt:String):void {
			mTextField.text = txt;
//			onResize();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			var tf:TextFormat = new TextFormat();
			tf.align = style.textAlign;
			tf.bold = style.textBold;
			tf.color = style.textColor;
			tf.font = style.textFont;
			tf.italic = style.textItalic;
			tf.size = style.textSize;
			tf.underline = style.textUnderline;
			
			mTextField.embedFonts = style.textEmbed;
			mTextField.defaultTextFormat = tf;
			
			mTextField.background = false;
			mTextField.border = false;
			
			mTextField.text = mTextField.text.valueOf();
			mTextField.width = width;
			mTextField.height = height;
		}
	}
}