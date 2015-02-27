package itnix.flib.ui {
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.Style;
	import itnix.flib.ui.renders.DefaultListRenderer;
	
	[Event(type="flash.events.Event", name="change")]
	public final class List extends Canvas {
		
		public var itemRenderer:Class;
		public var labelField:String;
		public var iconField:String;
		
		public var verticalGap:Number = 2;
		
		public var rowHeight:Number;
		
		private var mDataProvider:Array;
		private var mMask:Shape;
		
		private var mSelectable:Boolean;
		private var mSelectedIndex:int;
		private var mSelectedItem:Object;
		
		private var mContent:Canvas;
		
		public function get selectable():Boolean {
			return mSelectable;
		}
		
		public function get selectedIndex():int {
			return mSelectedIndex;
		}
		
		public function set selectedIndex(i:int):void {
			mSelectedIndex = i;
			mSelectedItem = mDataProvider[i];
			refreshSelection();
		}
		
		public function get selectedItem():Object {
			return mSelectedItem;
		}
		
		public function set selectable(s:Boolean):void {
			if(mSelectable == s) {
				return;
			}
			
			mSelectable = s;
			rebuildItems();
		}
		
		public function List(labelField:String = "label", iconField:String = "icon") {
			super();
			
			this.labelField = labelField;
			this.iconField = iconField;
			
			style = new Style(this);
			style.backgroundGradientAlphas = [1, 1];
			style.backgroundGradientColors = [0xffffff, 0xcfcfcf];
			style.backgroundGradientAngle = Math.PI / 2.2;
			
			rowHeight = 20;
			
			mSelectedIndex = -1;
			
			mMask = new Shape();
			mContent = new Canvas();
			
			addChild(mMask);
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
		}
		
		public function set dataProvider(data:Array):void {
			mDataProvider = data;
			rebuildItems();
		}
		
		public function get dataProvider():Array {
			return mDataProvider;
		}
		
		public function moveMask(x:Number, y:Number):void {
			mMask.x = x;
			mMask.y = y;
		}
		
		private function onResize(e:CanvasEvent):void {
			mMask.graphics.beginFill(0, 0);
			mMask.graphics.drawRect(0, 0, width, height);
			mMask.graphics.endFill();
			
			rebuildItems();
			mContent.mask = mMask;
			
			addChild(mMask);
			addChild(mContent);
		}
		
		private function rebuildItems():void {
			mContent.removeAllChildren();
			
			if(mDataProvider == null || mDataProvider.length == 0) {
				return;
			}
			
			var o:Object, item:DisplayObject, yy:Number = 0;
			for(var i:int = 0; i < mDataProvider.length; ++i) {
				o = mDataProvider[i];
				if(itemRenderer == null) {
					item = new DefaultListRenderer(labelField, iconField);
				} else {
					item = new itemRenderer();
				}
				if(mSelectable) {
					item.addEventListener(MouseEvent.CLICK, onItemClick);
					item.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
					item.addEventListener(MouseEvent.MOUSE_OUT, onItemOut);
				} else {
					item.removeEventListener(MouseEvent.CLICK, onItemClick);
					item.removeEventListener(MouseEvent.MOUSE_OVER, onItemOver);
					item.removeEventListener(MouseEvent.MOUSE_OUT, onItemOut);
				}
				item['data'] = o;
				item.y = yy;
				
				if(item is Canvas) {
					(item as Canvas).resize(width, rowHeight);
				} else {
					item.width = width;
					item.height = rowHeight;
				}
				
				mContent.addChild(item);
				
				//trace("item @ (" + item.x + ", " + item.y + ") - (" + item.width + ", " + item.height + ")");
				
				yy += rowHeight;
			}
			
			refreshSelection();
		}
		
		private function onItemClick(e:MouseEvent):void {
			var item:DisplayObject = e.currentTarget as DisplayObject;
			if(e.ctrlKey && mSelectedItem == item['data']) {
				mSelectedIndex = -1;
				mSelectedItem = null;
			} else {
				mSelectedItem = item['data'];
				mSelectedIndex = getItemIndex(mSelectedItem);
			}
			
			rebuildItems();
			refreshSelection();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function getItemIndex(o:Object):int {
			if(o == null) return -1;
			for(var i:int = 0; i < mDataProvider.length; ++i) {
				if(mDataProvider[i] == o) {
					return i;
				}
			}
			return -1;
		}
		
		private function onItemOver(e:MouseEvent):void {
			var item:DisplayObject = e.currentTarget as DisplayObject;
			var o:DisplayObject = getChildByName('sel_' + item.y);
			if(o != null) {
				return;
			}
			o = new Shape();
			(o as Shape).graphics.beginFill(style.selectionColor, .3);
			(o as Shape).graphics.drawRect(0, 0, width, rowHeight);
			(o as Shape).graphics.endFill();
			o.y = item.y;
			o.alpha = 0;
			o.name = 'sel_' + item.y;
			
			Tweener.addTween(o, {
				alpha: 1,
				time: .3
			});
			
			addChild(o);
		}
		
		private function onItemOut(e:MouseEvent):void {
			var item:DisplayObject = e.currentTarget as DisplayObject;
			if(mSelectedItem != null && mSelectedItem == item['data']) {
				return;
			}
			var o:DisplayObject = getChildByName('sel_' + item.y);
			if(o != null) {
				o.name = 'removing_selection';
				Tweener.addTween(o, {
					alpha: 0,
					time: .5,
					onComplete: removeMe,
					onCompleteParams: [o]
				});
			}
		}
		
		private function removeMe(o:DisplayObject):void {
			try {removeChild(o)} catch(whatever:Error) {void;}
		}
		
		private function refreshSelection():void {
			var i:int;
			for(i = 0; i < numChildren; ++i) {
				if(getChildAt(i) is Shape && getChildAt(i) != mMask)
					removeChildAt(i--);
			}
			
			if(!mSelectable) mSelectedIndex = -1;
			if(mSelectedIndex < 0) return;
			
			var item:DisplayObject = mContent.getChildAt(mSelectedIndex);
			var s:Shape = new Shape();
			var ww:Number = width;
			var hh:Number = rowHeight;
			
			s.graphics.beginFill(style.selectionColor, style.selectionAlpha);
			s.graphics.drawRect(0, 0, ww, hh);
			s.graphics.endFill();
			s.y = item.y;
			s.name = 'sel_' + item.y;
			
			addChild(s);
		}
	}
}