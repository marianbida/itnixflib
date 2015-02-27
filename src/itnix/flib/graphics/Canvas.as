package itnix.flib.graphics {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.system.style.Style;
	
	[Event(type="itnix.flib.events.CanvasEvent", name="canvasMove")]
	[Event(type="itnix.flib.events.CanvasEvent", name="canvasResize")]
	public class Canvas extends Sprite {
		
		// General purpose
		private var mData:Object;
		
		public function set data(o:Object):void {
			mData = o;
		}
		
		public function get data():Object {
			return mData;
		}
		
		public function get style():Style {
			return mStyle;
		}
		
		public function set style(s:Style):void {
			mStyle = s;
			onResize();
		}
		
		public function get left():Number {
			return mLeft;
		}
		
		public function set left(n:Number):void {
			mLeft = n;
			alignMe();
		}
		
		public function get top():Number {
			return mTop;
		}
		
		public function set top(n:Number):void {
			mTop = n;
			alignMe();
		}
		
		public function get right():Number {
			return mRight;
		}
		
		public function set right(n:Number):void {
			mRight = n;
			alignMe();
		}
		
		public function get bottom():Number {
			return mBottom;
		}
		
		public function set bottom(n:Number):void {
			mBottom = n;
			alignMe();
		}
		
		public function get horizontalCenter():Number {
			return mHorizontalCenter;
		}
		
		public function set horizontalCenter(hc:Number):void {
			mHorizontalCenter = hc;
			alignMe();
		}
		
		public function get verticalCenter():Number {
			return mVerticalCenter;
		}
		
		public function set verticalCenter(vc:Number):void {
			mVerticalCenter = vc;
			alignMe();
		}
		
		private var mStyle:Style;
		
		private var mLeft:Number;
		private var mRight:Number;
		private var mTop:Number;
		private var mBottom:Number;
		
		private var mHorizontalCenter:Number;
		private var mVerticalCenter:Number;
		
		protected var mWidth:Number;
		protected var mHeight:Number;
		
		private var mMinWidth:Number;
		private var mMaxWidth:Number;
		private var mMinHeight:Number;
		private var mMaxHeight:Number;
		
		public override function set x(xx:Number):void {
			super.x = xx;
			dispatchEvent(new CanvasEvent(CanvasEvent.CANVAS_MOVE));
		}
		
		public override function set y(yy:Number):void {
			super.y = yy;
			dispatchEvent(new CanvasEvent(CanvasEvent.CANVAS_MOVE));
		}
		
		public override function set width(n:Number):void {
			mWidth = n;
			mRight = NaN;
			dispatchResize();
		}
		
		public override function get width():Number {
			return isNaN(mWidth) ? 0: mWidth;
		}
		
		public function get scaledWidth():Number {
			return isNaN(mWidth) ? 0: mWidth * scaleX;
		}
		
		public function get scaledHeight():Number {
			return isNaN(mHeight) ? 0: mHeight * scaleY;
		}
		
		public override function set height(n:Number):void {
			mHeight = n;
			mBottom = NaN;
			dispatchResize();
		}
		
		public override function get height():Number {
			return isNaN(mHeight) ? 0: mHeight;
		}
		
		public function set minWidth(n:Number):void {
			mMinWidth = n;
			dispatchResize();
		}
		
		public function set minHeight(n:Number):void {
			mMinHeight = n;
			dispatchResize();
		}
		
		public function set maxWidth(n:Number):void {
			mMaxWidth = n;
			dispatchResize();
		}
		
		public function set maxHeight(n:Number):void {
			mMaxHeight = n;
			dispatchResize();
		}
		
		public function get minWidth():Number {
			return mMinWidth;
		}
		
		public function get minHeight():Number {
			return mMinHeight;
		}
		
		public function get maxWidth():Number {
			return mMaxWidth;
		}
		
		public function get maxHeight():Number {
			return mMaxHeight;
		}
		
		
		
		public function move(xx:Number = NaN, yy:Number = NaN):void {
			if(!isNaN(xx)) {
				x = xx;
				mHorizontalCenter = mLeft = NaN;
			}
			
			if(!isNaN(yy)) {
				y = yy;
				mVerticalCenter = mTop = NaN;
			}
		}
		
		public function resize(w:Number, h:Number):void {
			var changed:Boolean;
			
			if(mWidth != w)
			{
				mWidth = w;
				changed = true;
			}
			
			if(mHeight != h)
			{
				mHeight = h;
				changed = true;
			}
			
			if(changed)
			{
				dispatchResize();
			}
		}
		
		public function Canvas() {
			super();
			
			style = new Style(this);
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			addEventListener(Event.REMOVED_FROM_STAGE, rm2st);
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize, true);
		}
		
		private function ad2st(e:Event):void {
			onResize();
			try {
				if(parent is Canvas) {
					parent.addEventListener(CanvasEvent.CANVAS_RESIZE, onParentResize, false, 0, true);
					onParentResize();
				}
			} catch(err:Object) {
				// silence!
			}
		}
		
		private function rm2st(e:Event):void {
			var c:Canvas = parent as Canvas;
			if(c != null) c.removeEventListener(CanvasEvent.CANVAS_RESIZE, onParentResize);
		}
		
		public function removeAllChildren():void {
			while(numChildren > 0) {
				removeChildAt(0);
			}
		}
		
		public function bringToFront():void {
			try {
				if(parent == null) return;
				parent.setChildIndex(this, parent.numChildren - 1);
			} catch(err:Object) {
				// silence!
			}
			visible = true;
		}
		
		private function checkSize():void {
			if(!isNaN(mMinWidth) && mWidth < mMinWidth) mWidth = mMinWidth;
			if(!isNaN(mMinHeight) && mHeight < mMaxHeight) mHeight = mMaxHeight;
			if(!isNaN(mMaxWidth) && mWidth > mMaxWidth) mWidth = mMaxWidth;
			if(!isNaN(mMaxHeight) && mHeight > mMaxHeight) mHeight = mMaxHeight;
		}
		
		private function onParentResize(e:CanvasEvent = null):void {
			alignMe();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			if((isNaN(mWidth) || isNaN(mHeight)) && (isNaN(mLeft) || isNaN(mRight)))
				return;
			alignMe();
			checkSize();
			style.redraw();
		}
		
		private function alignMe():void {
			var moved:Boolean;
			var resized:Boolean;
			var value:Number;
			if(parent == null || (isNaN(mWidth) || isNaN(mHeight)) && (isNaN(mLeft) || isNaN(mRight)))
				return;
			
			if(!isNaN(mLeft) && x != mLeft)
			{
				super.x = mLeft;
				moved = true;
			}
			
			if(!isNaN(mTop) && y != mTop)
			{
				super.y = mTop;
				moved = true;
			}
			
			if(!isNaN(mRight))
			{
				if(!isNaN(mLeft)) {
					value = (parent.width - x) - mRight
					if(mWidth != value)
					{
						mWidth = value;
						resized = true;
					}
				} else {
					value = (parent.width - mWidth) - mRight;
					if(x != value)
					{
						super.x = value;
						moved = true;
					}
				}
			}
			
			if(!isNaN(mBottom))
			{
				if(!isNaN(mTop)) {
					value = (parent.height - y) - mBottom;
					if(mHeight != value)
					{
						mHeight = value;
						resized = true;
					}
				} else {
					value = (parent.height - mHeight) - mBottom;
					if(y != value)
					{
						super.y = value;
						moved = true;
					}
				}
			}
			
			if(!isNaN(mHorizontalCenter)) {
				value = ((parent.width - mWidth) / 2) + mHorizontalCenter;
				if(x != value)
				{
					super.x = value;
					moved = true;
				}
			}
			
			if(!isNaN(mVerticalCenter)) {
				value = ((parent.height - mHeight) / 2) + mVerticalCenter;
				if(y != value)
				{
					super.y = value;
					moved = true;
				}
			}
			
			if(moved)
			{
				dispatchEvent(new CanvasEvent(CanvasEvent.CANVAS_MOVE));
			}
			
			if(resized)
			{
				dispatchResize();
			}
		}
		
		private function dispatchResize():void {
			var e:CanvasEvent = new CanvasEvent(CanvasEvent.CANVAS_RESIZE);
			dispatchEvent(e);
		}
	}
}