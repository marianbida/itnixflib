package itnix.flib.system.style {
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.Direction;
	
	public final class Style {
		
		public static const TEXT_ALIGN_LEFT:String = TextFormatAlign.LEFT;
		public static const TEXT_ALIGN_CENTER:String = TextFormatAlign.CENTER;
		public static const TEXT_ALIGN_RIGHT:String = TextFormatAlign.RIGHT;
		public static const TEXT_ALIGN_JUSTIFY:String = TextFormatAlign.JUSTIFY;
		
		private var mOwner:Canvas;
		
		public var backgroundColor:uint;
		public var backgroundAlpha:Number;
		public var backgroundGradientColors:Array;
		public var backgroundGradientAlphas:Array;
		public var backgroundGradientRatios:Array;
		public var backgroundGradientAngle:Number;
		
		public var selectionColor:uint;
		public var selectionAlpha:Number = .3;
		
		public var textEmbed:Boolean = false;
		public var textFont:String = 'courier';
		public var textSize:Number = 11;
		public var textColor:uint = 0;
		public var textBold:Boolean = false;
		public var textItalic:Boolean = false;
		public var textUnderline:Boolean = false;
		public var textAlign:String = TextFormatAlign.LEFT;
		
		public var borderSize:Number;
		public var borderAlpha:Number;
		public var borderColor:uint;
		
		public var corners:CornersRoundness;
		
		public function get owner():Canvas {
			return mOwner;
		}
		
		public function set owner(o:Canvas):void {
			mOwner = o;
			if(mOwner == null) return;
			mOwner.style = this;
			mOwner.addEventListener(Event.ADDED_TO_STAGE, ad2st, false, 0, true);
			mOwner.addEventListener(Event.REMOVED_FROM_STAGE, rm2st, false, 0, true);
			borderAlpha = 1;
			redraw();
		}
		
		public function Style(owner:Canvas) {
			this.owner = owner;
			corners = new CornersRoundness();
		}
		
		public function copyBackgroundStyleFrom(style:Style):void {
			backgroundAlpha = style.backgroundAlpha;
			backgroundColor = style.backgroundColor;
			backgroundGradientAlphas = style.backgroundGradientAlphas;
			backgroundGradientColors = style.backgroundGradientColors;
			backgroundGradientAngle = style.backgroundGradientAngle;
			backgroundGradientRatios = style.backgroundGradientRatios;
		}
		
		public function copyTextStyleFrom(style:Style):void {
			textAlign = style.textAlign;
			textBold = style.textBold;
			textColor = style.textColor;
			textFont = style.textFont;
			textItalic = style.textItalic;
			textSize = !isNaN(style.textSize) ? style.textSize: textSize;
			textUnderline = style.textUnderline;
			selectionColor = style.selectionColor;
			selectionAlpha = style.selectionAlpha;
		}
		
		public function clone(newOwner:Canvas = null):Style {
			var s:Style = new Style(newOwner);
			s.borderColor = borderColor;
			s.borderSize = borderSize;
			s.corners = corners == null ? null: corners.clone();
			
			s.copyBackgroundStyleFrom(this);
			s.copyTextStyleFrom(this);
			s.owner = newOwner;
			return s;
		}
		
		private function ad2st(e:Event):void {
			mOwner.addEventListener(CanvasEvent.CANVAS_RESIZE, onResize, false, 0, true);
		}
		
		private function rm2st(e:Event):void {
			mOwner.removeEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
		}
		
		private function onResize(e:CanvasEvent):void {
			redraw();
		}
		
		public function redraw():void {
			if(owner == null) {
				return;
			}
			
			owner.graphics.clear();
			redrawBackground();
			redrawBorder();
		}
		
		public function getTextFormat():TextFormat {
			var tformat:TextFormat = new TextFormat(textFont, textSize, textColor, textBold, textItalic, textUnderline);
			tformat.align = textAlign;
			return tformat;
		}
		
		
		
		
		private function redrawBackground():void {
			if(owner == null || isNaN(owner.width) || isNaN(owner.height)) {
				return;
			}
			
			if(isNaN(backgroundAlpha) && backgroundGradientColors == null) {
				return;
			} 
			
			if(backgroundGradientColors != null && backgroundGradientColors.length > 0) {
				if(backgroundGradientAlphas == null) {
					backgroundGradientAlphas = [];
					for(var i:int = 0; i < backgroundGradientColors.length; ++i) {
						backgroundGradientAlphas.push(1);
					}
				}
				
				if(isNaN(backgroundGradientAngle)) {
					backgroundGradientAngle = Math.PI/2;
				}
				
				var m3x:Matrix = new Matrix();
				m3x.createGradientBox(owner.width, owner.height, backgroundGradientAngle);
				owner.graphics.beginGradientFill(GradientType.LINEAR,
													backgroundGradientColors,
													backgroundGradientAlphas,
													backgroundGradientRatios,
													m3x);
			} else if(!isNaN(backgroundAlpha)) {
				owner.graphics.beginFill(backgroundColor, backgroundAlpha);
			}
			
			if(corners.isZero()) {
				owner.graphics.drawRect(0, 0, owner.width, owner.height);
			} else {
				owner.graphics.drawRoundRectComplex(0, 0, owner.width, owner.height,
					corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight);
			}
			
			owner.graphics.endFill();
		}
		
		private function redrawBorder():void {
			if(isNaN(borderSize) || borderSize <= 0 || isNaN(owner.width) || isNaN(owner.height)) {
				return;
			}
			
			owner.graphics.lineStyle(borderSize, borderColor, borderAlpha, true, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.BEVEL);
			if(corners.isZero()) {
				owner.graphics.drawRect(0, 0, owner.width, owner.height);
			} else {
				owner.graphics.drawRoundRectComplex(0, 0, owner.width, owner.height,
					corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight);
			}
		}
	}
}