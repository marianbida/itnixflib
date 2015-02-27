package itnix.flib.ui {
	
	import itnix.flib.data.MenuItem;
	import itnix.flib.events.MenuEvent;
	import itnix.flib.graphics.Canvas;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	[Event(type="itnix.flib.events.MenuEvent", name="menuSelect")]
	public class Menu extends Canvas {
		
		public static const HORIZONTAL:String = 'horizontal';
		public static const VERTICAL:String = 'vertical';
		
		private var mParentMenu:Menu;
		private var mRootMenu:Menu;
		private var mLayout:String;
		private var mItems:Array = [];
		
		public function get layout():String {
			return mLayout;
		}
		
		public function get rootMenu():Menu {
			return mRootMenu;
		}
		
		public function get parentMenu():Menu {
			return mParentMenu;
		}
		
		public function Menu(layout:String = HORIZONTAL, rootMenu:Menu = null, parentMenu:Menu = null) {
			super();
			mLayout = layout;
			mRootMenu = rootMenu == null ? this: rootMenu;
			mParentMenu = parentMenu;
			
			if(mParentMenu == null) {
//				style.backgroundAlpha = 1;
//				style.backgroundColor = 0xffffff;
//				style.borderColor = 0xafafaf;
//				style.borderSize = 1;
//				
//				style.textFont = 'Verdana';
//				style.textSize = 10;
//				style.textColor = 0;
//				style.textBold = true;
//				style.textItalic = false;
//				style.textUnderline = false;
//				style.textAlign = TextFormatAlign.LEFT;
//			
			} else {
				style = mParentMenu.style.clone(this);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			addEventListener(Event.REMOVED_FROM_STAGE, rm4st);
		}
		
		private function ad2st(e:Event):void {
			trace('Menu::ad2st()');
//			if(mParentMenu == null) {
//				stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown, false, 0, true);
//			}
			rebuild();
		}
		
		private function rm4st(e:Event):void {
			if(mParentMenu == null) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			}
		}
		
		public function set items(arr:Array):void {
			if(mItems == arr) {
				return;
			}
			
			if(arr == null) {
				arr = [];
			}
			
			mItems = arr;
			rebuild();
		}
		
		public function get items():Array {
			return mItems;
		}
		
		private function onStageMouseDown(e:MouseEvent):void {
			close();
		}
		
		private function rebuild():void {
			removeAllChildren();
			
			var n:int = 0, maxn:int = 0;
			var iz:Array = [];
			
			var ww:Number = 0, hh:Number = 0;
			for each(var item:MenuItem in mItems) {
				var renderer:MenuItemRenderer = new MenuItemRenderer(item, Menu.VERTICAL, this);
				addChild(renderer);
				
				if(mLayout == HORIZONTAL) {
					renderer.x = n;
					renderer.width = renderer.contentWidth;
					trace('Render(' + renderer.label + ').contentWidth = ' + renderer.contentWidth);
					n += renderer.width;
					maxn < renderer.contentHeight ? maxn = renderer.contentHeight: void;
					ww += renderer.width;
					hh = renderer.height;
				} else {
					renderer.y = n;
					n += renderer.height;
					maxn < renderer.width ? maxn = renderer.width: void;
					ww < renderer.contentWidth ? ww = renderer.contentWidth: void;
					hh += renderer.height;
				}
				iz.push(renderer);
			}
			
			if(layout == VERTICAL) {
				mWidth = ww;
				mHeight = hh;
				for each(var r:MenuItemRenderer in iz) {
					r.width = ww;
				}
			} else {
				mWidth = super.width;
				mHeight = super.height;
			}
		}
		
		// also called by MouseEvent.MOUSE_DOWN for rootMenu only
		internal function close(e:MouseEvent = null):void {
			if(parent == null) {
				return;
			}
			
			var r:MenuItemRenderer;
			for(var i:int = 0; i < numChildren; ++i) {
				r = getChildAt(i) as MenuItemRenderer;
				if(r == null || r.parent == null) {
					trace('MenuItem "' + r.label.text + '" is not opened (' + (!r.isOpened) + ')');
					continue;
				}
				
				if(e == null || e.target != r) {
					trace(r.label.text + ".close(" +
						(e == null ? "e == null": "e.target != r == " + r) + ")");
					r.close();
				} else if(e != null) {
					trace(r + ' clicked');
				}
			}
		}
	}
}