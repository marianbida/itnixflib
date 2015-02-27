package itnix.flib.ui {
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.fonts.Fonts;
	import itnix.flib.system.Direction;
	import itnix.flib.system.style.Style;
	
	public class Button extends Label {
		
		private static var COLORS_INIT:Boolean;
		
		public static var defaultStyle:Style;
		public static var defaultFilters:Array;
		
		private var mIcon:Bitmap;
		private var mIconHAlign:String = Direction.LEFT;
		private var mIconVAlign:String = Direction.MIDDLE;
		private var mEnabled:Boolean = true;
		
		public function get enabled():Boolean {
			return mEnabled;
		}
		
		public function set enabled(b:Boolean):void {
			mEnabled = b;
			
			alpha = .3 + int(b) * .5;
			
			redraw();
		}
		
		public function get icon():Object {
			return mIcon;
		}
		
		public function set icon(bmp:Object):void {
			if(mIcon != null) {
				removeChild(mIcon);
			}
			
			if(bmp is Class) {
				mIcon = new bmp();
			} else if(bmp is Bitmap) {
				mIcon = bmp as Bitmap;
			} else {
				mIcon = null;
			}
			
			if(mIcon != null) {
				mIcon.smoothing = true;
				addChild(mIcon);
				redraw();
			}
		}
		
		public function set iconVAlign(va:String):void {
			if(va != Direction.TOP && va != Direction.MIDDLE && va != Direction.BOTTOM) {
				va = Direction.MIDDLE;
			}
			mIconVAlign = va;
			redraw();
		}
		
		public function get iconVAlign():String {
			return mIconVAlign;
		}
		
		public function set iconHAlign(ha:String):void {
			if(ha != Direction.LEFT && ha != Direction.CENTER && ha != Direction.RIGHT) {
				ha = Direction.LEFT;
			}
			mIconHAlign = ha;
			redraw();
		}
		
		public function get iconHAlign():String {
			return mIconHAlign;
		}
		
		public function Button(txt:String="", icon:Object = null, width:Number = 75, height:Number = 20, data:Object = null) {
			super(txt);
			
			ColorShortcuts.init();
			
			this.data = data;
			
			if(!COLORS_INIT) {
				COLORS_INIT = true;
				ColorShortcuts.init();
			}
			
			alpha = .8;
			
			textField.text = txt;
			textField.wordWrap = true;
			
			if(defaultStyle == null) {
				style = new Style(this);
				style.selectionColor = 0xafcfff;
				style.backgroundColor = 0xffffff;
				style.backgroundAlpha = .8;
				style.textAlign = TextFormatAlign.CENTER;
				style.textFont = 'Arial';
				style.textSize = 11;
				style.textBold = true;
				style.textColor = 0x000000;
			} else {
				style = defaultStyle.clone(this);
			}
			
			if(defaultFilters != null) {
				filters = defaultFilters;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
//			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true, 0);
//			addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true, 0);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			
			resize(width, height);
			if(icon != null) this.icon = icon;
		}
		
		private function onResize(e:CanvasEvent):void {
			redraw();
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if(!mEnabled) {
				e.stopImmediatePropagation();
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if(!mEnabled) {
				e.stopImmediatePropagation();
			}
		}
		
		private function onMouseClick(e:MouseEvent):void {
			if(!mEnabled) {
				e.stopImmediatePropagation();
				return;
			}
			
			Tweener.addTween(this, {
				_brightness: .4,
				transition: 'easeOutCirc',
				time: .1
			});
			Tweener.addTween(this, {
				_brightness: 0,
				transition: 'easeInCirc',
				delay: .1,
				time: .2
			});
		}
		
		private function ad2st(e:Event):void {
			redraw();
			mouseChildren = mouseEnabled = true;
			buttonMode = true;
			text = text;
		}
		
		private function onRollOver(e:MouseEvent):void {
			if(!mEnabled) {
				return;
			}
			
			Tweener.addTween(this, {
				alpha: 1,
				transition: "easeOutCirc",
				time: .5
			});
		}
		
		private function onRollOut(e:MouseEvent):void {
			if(!mEnabled && alpha == .3) {
				return;
			}
			Tweener.addTween(this, {
				alpha: mEnabled ? .8: .3,
				transition: "easeOutCirc",
				time: .5
			});
		}
		
		public function redraw():void {
			if(style == null || textField == null) {
				return;
			}
			style.redraw();
			
			var txtFmt:TextFormat = textField.defaultTextFormat;
			txtFmt.font = style.textFont == null ? 'Verdana': style.textFont;
			txtFmt.align = style.textAlign == null ? Style.TEXT_ALIGN_LEFT: style.textAlign;
			txtFmt.size = isNaN(style.textSize) || style.textSize < 0 ? 11: style.textSize;
			txtFmt.color = style.textColor;
			txtFmt.bold = style.textBold;
			txtFmt.italic = style.textItalic;
			txtFmt.underline = style.textUnderline;
			
			textField.autoSize = TextFieldAutoSize.CENTER;
			
			textField.defaultTextFormat = txtFmt;
			textField.text = "" + textField.text;
			textField.x = 0;
			textField.y = height * .1;
			textField.width = width;
			textField.height = height;
			
			buttonMode = mEnabled;
			
			if(mIcon == null) return;
			
			repositionIcon();
		}
		
		private function repositionIcon():void {
			mIconHAlign == null ? mIconHAlign = Direction.LEFT: void;
			mIconVAlign == null ? mIconVAlign = Direction.MIDDLE: void;
			
			if(mIcon.width > width) mIcon.width = width;
			if(mIcon.height > height) mIcon.height = height;
			
			if(	mIcon.width != mIcon.bitmapData.width ||
				mIcon.height != mIcon.bitmapData.height) {
				
				if(mIcon.bitmapData.width > width) {
					mIcon.width = width;
				} else {
					mIcon.width = mIcon.bitmapData.width;
				}
				
				if(mIcon.bitmapData.height > height) {
					mIcon.height = height;
				} else {
					mIcon.height = mIcon.bitmapData.height;
				}
					
			}
			
			switch(mIconHAlign) {
				case Direction.LEFT:
					mIcon.x = mIcon.width + 3 < mWidth ? 3: 0;
					break;
				case Direction.CENTER:
					mIcon.x = (width - mIcon.width) / 2;
					break;
				case Direction.RIGHT:
					mIcon.x = width - mIcon.width - 5;
					break;
			}
			
			switch(mIconVAlign) {
				case Direction.TOP:
					mIcon.y = 0;
					break;
				case Direction.MIDDLE:
					mIcon.y = (height - mIcon.height) / 2;
					break;
				case Direction.BOTTOM:
					mIcon.y = height - mIcon.height;
					break;
			}
		}
	}
}