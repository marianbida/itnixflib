package itnix.flib.graphics.layout {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	
	public class LayoutedContainer extends Canvas {
		
		public static const LAYOUT_RELATIVE:String = "relative";
		public static const LAYOUT_HORIZONTAL:String = "horizontal";
		public static const LAYOUT_VERTICAL:String = "vertical";
		
		public static const LEFT:int = 0;
		public static const TOP:int = 1;
		public static const RIGHT:int = 2;
		public static const BOTTOM:int = 3;
		
//		private var mAutoResize:Boolean;
		private var mLayout:String;
		private var mMargin:Array;
		private var mPadding:Array;
		private var mGap:Number;
		
//		public function get autoSize():Boolean {
//			return mAutoResize;
//		}
//		
//		public function set autoSize(a:Boolean):void {
//			mAutoResize = a;
//			rearrange();
//		}
//		
		public function get layout():String {
			return mLayout;
		}
		
		public function set layout(layout:String):void {
			if(mLayout == layout) {
				return;
			}
			mLayout = layout;
			rearrange();
		}
		
		public function get margin():Array {
			return mMargin;
		}
		
		public function set margin(mar:Array):void {
			var m:Array;
			if(mar == null || mar.length == 0) {
				m = [0, 0, 0, 0];
			} else if(mar.length >= 4) {
				m = mar;
			} else if(mar.length == 3) {
				m = [mar[0], mar[1], mar[2], mar[0]];
			} else if(mar.length == 2) {
				m = [mar[0], mar[1], mar[0], mar[1]];
			} else if(mar.length == 1) {
				m = [mar[0], mar[0], mar[0], mar[0]];
			}
			mMargin = m;
			rearrange();
		}
		
		public function get padding():Array {
			return mPadding;
		}
		
		public function set padding(pad:Array):void {
			var p:Array;
			if(pad == null || pad.length == 0) {
				p = [0, 0, 0, 0];
			} else if(pad.length >= 4) {
				p = pad;
			} else if(pad.length == 3) {
				p = [pad[0], pad[1], pad[2], pad[0]];
			} else if(pad.length == 2) {
				p = [pad[0], pad[1], pad[0], pad[1]];
			} else if(pad.length == 1) {
				p = [pad[0], pad[0], pad[0], pad[0]];
			}
			mPadding = p;
			rearrange();
		}
		
		public function get gap():Number {
			return mGap;
		}
		
		public function set gap(gap:Number):void {
			mGap = isNaN(gap) ? 0: gap;
			rearrange();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			if(child is Canvas) child.addEventListener(CanvasEvent.CANVAS_RESIZE, onChildResize);
			rearrange();
			return child;
		}
		
		
		
		
		
		
		public function LayoutedContainer(layout:String = null, autoResize:Boolean = true) {
			this.layout = layout == null ? LAYOUT_HORIZONTAL: layout;
//			mAutoResize = autoResize;
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
		}
		
		private function ad2st(e:Event):void {
			rearrange();
		}
		
		private function onChildResize(e:CanvasEvent):void {
			var c:Canvas = e.currentTarget as Canvas;
			rearrange();
		}
		
		protected function rearrange():void {
			if(parent == null) {
				return;
			}
			
			if(mPadding == null) {
				mPadding = [0, 0, 0, 0];
			}
			
			if(mMargin == null) {
				mMargin = [0, 0, 0, 0];
			}
			
			var o:DisplayObject, c:Canvas;
			var xx:Number = mPadding[LEFT];
			var yy:Number = mPadding[TOP];
			var maxw:Number = 0, maxh:Number = 0;
			var l:Number, t:Number, r:Number, b:Number, hc:Number, vc:Number;
			for(var i:int = 0; i < numChildren; ++i) {
				o = getChildAt(i);
				c = o as Canvas;
				if(o == null || !o.visible) {
					continue;
				}
				
				if(maxw < o.width) maxw = o.width;
				if(maxh < o.height) maxh = o.height;
				
				switch(mLayout) {
					case LAYOUT_HORIZONTAL:
						i > 0 ? xx += int(mGap): void;
						o.x = xx;
						o.y = mPadding[TOP];
						xx += o.width;
						break;
					case LAYOUT_VERTICAL:
						i > 0 ? yy += int(mGap): void;
						o.x = mPadding[LEFT];
						o.y = yy;
						yy += o.height;
						break;
					case LAYOUT_RELATIVE:
						if(c != null) {
							l = c.left;
							t = c.top;
							r = c.right;
							b = c.bottom;
							
							hc = c.horizontalCenter;
							vc = c.verticalCenter;
							if(!isNaN(l)) o.x = l;
							if(!isNaN(t)) o.y = t;
							if(!isNaN(r)) o.x = width - (o.width + r);
							if(!isNaN(b)) o.y = height - (o.height + b);
							
							if(!isNaN(hc)) o.x = ((width - o.width) / 2) + hc;
							if(!isNaN(vc)) o.y = ((height - o.height) / 2) + vc;
						}
						
						if(maxw < o.x + o.width) maxw = o.x + o.width;
						if(maxh < o.y + o.height) maxh = o.y + o.height;
						
						break;
				}
			}
			
//			var mustW:Number;
//			var mustH:Number;
//			if(mAutoResize) {
//				if(mLayout == LAYOUT_HORIZONTAL) {
//					mustW = xx + mPadding[RIGHT];
//					mustH = maxh + mPadding[TOP] + mPadding[BOTTOM];
//				} else if(mLayout == LAYOUT_VERTICAL) {
//					mustW = mPadding[LEFT] + maxw + mPadding[RIGHT];
//					mustH = yy + mPadding[BOTTOM];
//				} else if(mLayout == LAYOUT_RELATIVE) {
//					mustW = maxw + mPadding[RIGHT];
//					mustH = maxh + mPadding[BOTTOM];
//				}
//			}
//			
//			if(!isNaN(mustW) && !isNaN(mustH)) {
//				setTimeout(resize, 1, mustW, mustH);
//			}
		}
	}
}