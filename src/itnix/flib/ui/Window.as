package itnix.flib.ui {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.events.WindowEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.CornersRoundness;
	import itnix.flib.system.style.Style;
	
	[Event(type="flash.event.Event", name="close")]
	[Event(type="itnix.flib.events.WindowEvent", name="titleChange")]
	public class Window extends Canvas {
		
		protected const MINIMIZE_BUTTON:Button = new Button("_");
		protected const CLOSE_BUTTON:Button = new Button("X");
		
		public static var defaultWindowStyle:Style;
		public static var defaultContentStyle:Style;
		
		private var mDragReg:Point;
		
		private var mTitle:Label;
		private var mBorderSize:Rectangle;
		
		private var mMovable:Boolean;
		private var mMinimizable:Boolean;
		private var mResizable:Boolean;
		private var mClosable:Boolean;
		private var mContent:Canvas;
		private var mContentMask:Canvas;
		
		public function get title():String {
			return mTitle.text;
		}
		
		public function get content():Canvas {
			return mContent;
		}
		
		public function set title(s:String):void {
			mTitle.text = s;
			dispatchEvent(new WindowEvent(WindowEvent.TITLE_CHANGE));
		}
		
		public function get borderSize():Rectangle {
			return mBorderSize;
		}
		
		public function set borderSize(size:Rectangle):void {
			mBorderSize = size != null ? size: new Rectangle(5, 25, 5, 5);
			refreshSize();
		}
		
		public function get movable():Boolean {
			return mMovable;
		}
		
		public function get minimizable():Boolean {
			return mMinimizable;
		}
		
		public function get closable():Boolean {
			return mClosable;
		}
		
		public function get resizable():Boolean {
			return mResizable;
		}
		
		public function set movable(m:Boolean):void {
			mMovable = m;
		}
		
		public function set minimizable(c:Boolean):void {
			mMinimizable = c;
			if(mMinimizable) {
				MINIMIZE_BUTTON.visible = true;
				MINIMIZE_BUTTON.buttonMode = MINIMIZE_BUTTON.useHandCursor = false;
				MINIMIZE_BUTTON.resize(16, 16);
				MINIMIZE_BUTTON.style.selectionColor = 0xffdfbf;
				MINIMIZE_BUTTON.style.corners = new CornersRoundness(3, 3, 3, 3);
				MINIMIZE_BUTTON.addEventListener(MouseEvent.CLICK, onMinimizing);
			} else {
				MINIMIZE_BUTTON.visible = false;
			}
		}
		
		public function set closable(c:Boolean):void {
			mClosable = c;
			if(!mClosable) {
				CLOSE_BUTTON.visible = false;
			} else {
				CLOSE_BUTTON.visible = true;
				CLOSE_BUTTON.buttonMode = CLOSE_BUTTON.useHandCursor = false;
				CLOSE_BUTTON.resize(16, 16);
				CLOSE_BUTTON.style.selectionColor = 0xff0000;
				CLOSE_BUTTON.style.corners = new CornersRoundness(3, 3, 3, 3);
				CLOSE_BUTTON.addEventListener(MouseEvent.CLICK, onClosing);
			}
		}
		
		public function set resizable(r:Boolean):void {
			mResizable = r;
			var sp:Sprite;
			if(mResizable) {
				sp = new Sprite();
				sp.graphics.beginFill(0xff0000, 0.1);
				sp.buttonMode = true;
				sp.graphics.drawRect(0, 0, borderSize.width, borderSize.height);
				sp.graphics.endFill();
				sp.name = 'Window::Resizer';
				sp.addEventListener(MouseEvent.MOUSE_DOWN, onResizeMouseDown);
				addChild(sp);
			} else {
				sp = getChildByName('Window::Resizer') as Sprite;
				if(sp == null) return;
				
				sp.removeEventListener(MouseEvent.MOUSE_DOWN, onResizeMouseDown);
				sp.parent.removeChild(sp);
			}
			dispatchEvent(new CanvasEvent(CanvasEvent.CANVAS_RESIZE));
		}
		
		public function Window(title:String = "", borderSize:Rectangle = null, closable:Boolean = true, minimizable:Boolean = false, resizable:Boolean = false, movable:Boolean = true) {
			super();
			
			mMovable = movable;
			this.borderSize = borderSize;
			
			addChild(MINIMIZE_BUTTON);
			addChild(CLOSE_BUTTON);
			
			this.closable = closable;
			this.minimizable = minimizable;
			this.resizable = resizable;
			
			mTitle = new Label(title);
			mContent = new Canvas();
			mContentMask = new Canvas();
			
			mTitle.mouseChildren = mTitle.mouseEnabled = false;
			
			mTitle.style.textAlign = Style.TEXT_ALIGN_LEFT;
			
			mTitle.style.textFont = 'Arial';
			mTitle.style.textSize = 12;
			mTitle.style.textColor = 0xffffff;
			mTitle.style.textBold = true;
			mTitle.textField.text = mTitle.text;
			
			mTitle.filters = [new DropShadowFilter(1, 45, 0, 1, 5, 5, 1, 3)];
			
			addChild(mTitle);
			addChild(mContent);
			addChild(mContentMask);
			
			mContent.mask = mContentMask;
			
			filters = [new DropShadowFilter(5, -45, 0, .6, 20, 20, 1, 2)];
			mContent.filters = [new DropShadowFilter(1, 45, 0, 1, 4, 4, .35, 2)];
			
			if(defaultWindowStyle == null) {
				style.backgroundGradientColors = [0xafcfff, 0xafefff, 0xcff7ff, 0xafcfff, 0xffffff];
				style.backgroundGradientAlphas = [.8, .7, .6, .9, .3];
				style.backgroundGradientRatios = [0, 74, 130, 135, 255];
				style.corners = new CornersRoundness(10, 10, 10, 10);
			} else {
				defaultWindowStyle.clone(this);
			}
			
			if(defaultContentStyle == null) {
				mContent.style.backgroundAlpha = 1;
				mContent.style.backgroundColor = 0xffffff;
			} else {
				defaultContentStyle.clone(mContent);
			}
			
			mContentMask.style.backgroundAlpha = 0;
			mContentMask.style.backgroundColor = 1;
			
			this.name = 'windowSome';
			mContent.name = 'McContent';
			mContentMask.name = 'McContentMask';
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true, 0);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			
			resize(400, 300);
		}
		
		protected function onClosing(e:MouseEvent):void {
			close();
		}
		
		protected function onMinimizing(e:MouseEvent):void {
			visible = false;
		}
		
		protected function onMoving(oldx:Number, oldy:Number):void {
			//
		}
		
		public override function move(x:Number=NaN, y:Number=NaN):void {
			var oldx:Number = this.x;
			var oldy:Number = this.y;
			super.move(x, y);
			onMoving(oldx, oldy);
		}
		
		public function close():void {
			if(parent == null) return;
			parent.removeChild(this);
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function center():void {
			if(parent == null) {
				trace("[WARNING]: Window::center(): parent is null");
				return;
			}
			
//			trace('center @ ' + parent.width + ", " + parent.height);
//			
			move(
				(parent.width - this.width) / 2,
				(parent.height - this.height) / 2
			);
		}
		
		private function onResize(e:CanvasEvent):void {
			if(isNaN(mWidth) || isNaN(mHeight)) return;
			CLOSE_BUTTON.x = mWidth - CLOSE_BUTTON.width - borderSize.right;
			CLOSE_BUTTON.y = MINIMIZE_BUTTON.y = (borderSize.top - CLOSE_BUTTON.height) / 2;
			MINIMIZE_BUTTON.right = CLOSE_BUTTON.width * 2 + 10;
			
			mContent.left = mContentMask.x = borderSize.left;
			mContent.top = mContentMask.y = borderSize.top;
			
			refresh();
		}
		
		private function addedToStage(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			refresh();
		}
		
		private function removedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			try {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			} catch(err:Object) {
				// silence!
			}
		}
		
		private function refresh():void {
			mTitle.text = title;
			refreshSize();
		}
		
		private function refreshSize():void {
			
			if(mContent == null) {
				return;
			}
			
			var x1:Number = mBorderSize.left;
			var y1:Number = mBorderSize.top;
			var ww:Number = width - (mBorderSize.x + mBorderSize.width);
			var hh:Number = height - (mBorderSize.y + mBorderSize.height);
			
			mTitle.x = x1 + 2;
			mTitle.y = (mBorderSize.y - y1) / 2;
			mTitle.resize(ww, y1);
			
			mContent.move(x1, y1);
			mContent.resize(ww, hh); 
			mContentMask.resize(ww, hh);
			
			//mContent.mask = mContentMask;
			
			//trace("(" + x1 + ", " + y1 + ") - (" + ww + " x " + hh + "): [ " + width + " x  " + height + " ]");
			
			style.redraw();
			mContent.style.redraw();
			mContentMask.style.redraw();
			
			mTitle.y = (borderSize.top - mTitle.textHeight) / 2;
			
			if(mResizable) {
				var sp:Sprite = getChildByName('Window::Resizer') as Sprite;
				if(sp != null) {
					sp.x = mContent.x + mContent.width;
					sp.y = mBorderSize.height;
					setChildIndex(sp, numChildren - 1);
				}
			}
		}
		
		private function onResizeMouseDown(e:MouseEvent):void {
			mDragReg = new Point(mouseX, mouseY);
			stage.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onResizeMouseMove, false, 0, true);
			
		}
		
		private function onResizeMouseMove(e:MouseEvent):void {
			setTimeout(resize, 50, mouseX, mouseY);
		}
		
		private function onResizeMouseUp(e:MouseEvent):void {
			try {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeMouseMove);
			} catch(err:Object) {
				// silence!
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if(!mMovable || !e.altKey && e.target != this && e.target != mContent) {
				return;
			}
			
			bringToFront();
			
			mDragReg = new Point(mouseX, mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			e.stopImmediatePropagation();
		}
		
		private function onMouseMove(e:MouseEvent):void {
			move(parent.mouseX - mDragReg.x, parent.mouseY - mDragReg.y);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			mDragReg = null;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
	}
}