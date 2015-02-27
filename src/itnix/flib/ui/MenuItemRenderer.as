package itnix.flib.ui {
	
	import caurina.transitions.Tweener;
	
	import itnix.flib.data.MenuItem;
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.events.MenuEvent;
	import itnix.flib.graphics.Canvas;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	[Event(type="itnix.flib.events.MenuEvent", name="select")]
	internal final class MenuItemRenderer extends Canvas {
		
		public var iconSize:int = 16;
		
		private var mItem:MenuItem;
		private var mMenu:Menu;
		private var mIcon:ImageHolder;
		private var mLabel:Label;
		
		private var mChild:Menu;
		private var mOpened:Boolean = false;
		
		private const mSelection:Canvas = new Canvas();
		
		public function get label():Label {
			return mLabel;
		}
		
		public function get item():MenuItem {
			return mItem;
		}
		
		public function get child():Menu {
			return mChild;
		}
		
		public function get isOpened():Boolean {
			return mOpened;
		}
		
		public function get contentWidth():Number {
			if(parent == null) return NaN;
			return mLabel.x + mLabel.textWidth + 30;
		}
		
		public function get contentHeight():Number {
			if(parent == null) return NaN;
			return mLabel.y + mLabel.textHeight;
		}
		
		public function MenuItemRenderer(item:MenuItem, childrenLayout:String, menu:Menu) {
			super();
			
			mHeight = 20;
			mMenu = menu;
			
			style = mMenu.style.clone(this);
//			style.backgroundGradientColors = [0x333333, 0];
//			style.backgroundGradientAlphas = [.1, .1];
//			mSelection.style.backgroundGradientColors = [0, 0x333333];
//			mSelection.style.backgroundGradientAlphas = [.3, .3];
//			mSelection.style.backgroundGradientRatios = [0, 255];
			style.borderSize = NaN;
				
			mItem = item;
			mChild = new Menu(childrenLayout, mMenu.rootMenu, mMenu.parentMenu);
			mIcon = new ImageHolder(iconSize, iconSize, mItem.icon);
			mLabel = new Label();
			mLabel.style.copyTextStyleFrom(mMenu.rootMenu.style);
			mLabel.textField.mouseEnabled = false;
			mLabel.text = mItem.label;
			mSelection.style.backgroundColor = style.selectionColor;
			mSelection.style.backgroundAlpha = .3;
			
			mIcon.filters = [new DropShadowFilter(1, 45, 0, .7)];
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			addEventListener(MouseEvent.ROLL_OVER, onMouseRoll, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRoll, true);
			if(mItem.children.length > 0) {
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			} else {
				addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			
			mSelection.alpha = 0;
			
			addChild(mIcon);
			addChild(mLabel);
			addChild(mSelection);
			
			onResize();
			
			if(mMenu.layout == Menu.HORIZONTAL) {
//				trace('MenuItemRenderer::resize(' + width + 'x' + height + ')');
				resize(mLabel.x + mLabel.textWidth + 10, mHeight);
			}
		}
		
		private function onResize(e:CanvasEvent = null):void {
			if(isNaN(mWidth) || isNaN(mHeight)) return;
			
			mLabel.height = mHeight;
			if(mIcon.source == null) {
				mLabel.x = 5;
			} else {
				mIcon.x = 5;
				mIcon.y = (height - mIcon.height) / 2;
				mLabel.x = 6 + mIcon.width;
			}
			mLabel.y = 1;
			
			if(isNaN(mWidth) || mWidth <= 0 || mMenu.layout == Menu.HORIZONTAL) {
				mWidth = contentWidth;
			}
			
			mLabel.width = mWidth - mLabel.x;
			mSelection.resize(mWidth, mHeight);
			style.redraw();
//			trace('MenuItem.onResize(' + mWidth + ', ' + mHeight + ')');
		}
		
		private function onMouseRoll(e:MouseEvent):void {
			Tweener.addTween(mSelection, {
				alpha: uint(e.type == MouseEvent.ROLL_OVER),
				time: .3
			});
		}
		
		private function onMouseClick(e:MouseEvent):void {
//			trace('MenuItemRenderer::onMouseClick()');
			mMenu.rootMenu.dispatchEvent(new MenuEvent(MenuEvent.MENU_SELECT, mItem));
			mMenu.rootMenu.close();
		}
		
		internal function close():void {
			if(mOpened) onMouseDown();
		}
		
		private function onMouseDown(e:MouseEvent = null):void {
//			trace('onMouseDown(): mOpened = ' + mOpened);
			if(mOpened) {
				mOpened = false;
				mChild.parent.removeChild(mChild);
			} else {
				mOpened = true;
				if(mMenu.rootMenu == mMenu) {
					mChild.x = x;
					mChild.y = y + height;
					mChild.addEventListener(Event.REMOVED_FROM_STAGE, onChildRemoved);
				} else {
					mChild.x = x + width;
					mChild.y = y;
				}
				mChild.items = mItem.children;
				parent.addChild(mChild);
			}
		}
		
		private function onChildRemoved(e:Event):void {
			mOpened = false;
		}
	}
}