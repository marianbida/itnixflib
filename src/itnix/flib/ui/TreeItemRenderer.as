package itnix.flib.ui {
	
	import itnix.flib.data.TreeItem;
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(type="itnix.flib.events.MenuEvent", name="select")]
	public final class TreeItemRenderer extends Canvas {
		
		public var iconSize:int = 16
		
		private var mItem:TreeItem;
		private var mRootTree:Tree;
		private var mParentTree:Tree;
		private var mIcon:ImageHolder;
		private var mLabel:Label;
		
		private var mChild:Tree;
		private var mOpened:Boolean = false;
		
		private const mSelection:Sprite = new Sprite();
		
		public function get label():Label {
			return mLabel;
		}
		
		public function get item():TreeItem {
			return mItem;
		}
		
		public function get child():Tree {
			return mChild;
		}
		
		public function get isOpened():Boolean {
			return mOpened;
		}
		
		public function TreeItemRenderer(item:TreeItem, rootTree:Tree, parentTree:Tree) {
			super();
			
			style = parentTree.style.clone(this);
			style.borderSize = NaN;
			style.redraw();
				
			mItem = item;
			mChild = new Tree(item, rootTree, parentTree);
			style = rootTree.style.clone(this);
			mRootTree = rootTree;
			mParentTree = parentTree;
			
			mIcon = new ImageHolder(iconSize, iconSize);
			mLabel = new Label(mItem.label);
			
			mIcon.source = mItem.icon;
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			mSelection.addEventListener(MouseEvent.ROLL_OVER, onMouseRoll);
			mSelection.addEventListener(MouseEvent.ROLL_OUT, onMouseRoll);
			if(mItem.children != null && mItem.children.length > 0) {
				mSelection.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			} else {
				mSelection.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			
			mSelection.alpha = 0;
			
			addChild(mIcon);
			addChild(mLabel);
			addChild(mSelection);
			addChild(mChild);
			
			mChild.close();
			onResize();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			mLabel.height = 20;
			if(mIcon.source == null) {
				mLabel.x = 5;
			} else {
				mIcon.x = 5;
				mIcon.y = (height - mIcon.height) / 2;
				mLabel.x = 10 + iconSize;
			}
			mLabel.y = 1;
			
			mLabel.width = width - mLabel.x;
			
			mChild.x = 15;
			mChild.y = height + 1;
			
			mSelection.graphics.clear();
			mSelection.graphics.beginFill(style.selectionColor, .5);
			mSelection.graphics.drawRect(0, 0, width, height);
			mSelection.graphics.endFill();
			style.redraw();
		}
		
		private function onMouseRoll(e:MouseEvent):void {
			mSelection.alpha = uint(e.type == MouseEvent.ROLL_OVER);
		}
		
		private function onMouseClick(e:MouseEvent):void {
			mRootTree.onItemSelected(mItem);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if(mOpened) {
				close();
			} else {
				open();
			}
			e.stopImmediatePropagation();
		}
		
		public function open():void {
			mChild.open();
			mOpened = true;
		}
		
		public function close():void {
			mChild.close();
			mOpened = false;
		}
		
		private function onChildRemoved(e:Event):void {
			mOpened = false;
		}
	}
}