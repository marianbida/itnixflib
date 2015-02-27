package itnix.flib.ui {
	
	import caurina.transitions.Tweener;
	
	import itnix.flib.data.TreeItem;
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.events.TreeEvent;
	import itnix.flib.graphics.Canvas;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(type="itnix.flib.events.TreeEvent", name="treeSelect")]
	public final class Tree extends Canvas {
		
		private var mItem:TreeItem;
		private var mRootTree:Tree;
		private var mParentTree:Tree;
		
		private var mOpened:Boolean;
		
		private const mMask:Sprite = new Sprite();
		
		public function Tree(item:TreeItem, rootTree:Tree = null, parentTree:Tree = null) {
			super();
			
			resize(200, 300);
			
			mItem = item;
			mRootTree = rootTree;
			mParentTree = parentTree;
			
			if(mRootTree == null) {
				style.backgroundAlpha = 1;
				style.backgroundColor = 0xffffff;
				style.borderColor = 0xafafaf;
				style.borderSize = 1;
			} else {
				style = mRootTree.style.clone(this);
				style.backgroundAlpha = NaN;
				style.borderSize = NaN;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			addEventListener(Event.REMOVED_FROM_STAGE, rm2st);
			
			rebuild();
			
			if(mParentTree == null) {
				open();
			} else {
				close();
			}
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onMyResize);
		}
		
		private function ad2st(e:Event):void {
			parent.addChild(mMask);
			mask = mMask;
		}
		
		private function rm2st(e:Event):void {
			parent.removeChild(mMask);
		}
		
		private function rebuild():void {
			removeAllChildren();
			
			var yy:int = 0,
				r:TreeItemRenderer;
			for each(var item:TreeItem in mItem.children) {
				r = new TreeItemRenderer(item, mRootTree == null ? this: mRootTree, this);
				r.width = mWidth;
				r.height = 20;
				r.y = yy;
				r.x = 0;
				
				r.child.addEventListener(CanvasEvent.CANVAS_RESIZE, onChildResize, false, 0, true);
				addChild(r);
				
				yy += 20;
			}
		}
		
		public function onItemSelected(item:TreeItem):void {
			dispatchEvent(new TreeEvent(TreeEvent.TREE_SELECT, mItem));
		}
		
		// also called by MouseEvent.MOUSE_DOWN for rootMenu only
		public function close():void {
//			trace("Tree::close()");
			if(mParentTree == null || !mOpened) {
				return;
			}
			
			mOpened = false;
			Tweener.addTween(mMask, {
				height: 20,
				onUpdate: onMyResize,
				transition: "easeOutCirc",
				time: .3
			});
		}
		
		public function open():void {
			if(mOpened) {
				return;
			}
			
			var h:Number = height;
			onChildResize(null);
			var maxh:Number = height;
			height = h;
			
			mOpened = true;
//			trace("Tree::open(" + width + ", " + maxh + ")");
			Tweener.addTween(mMask, {
				height: maxh,
				onUpdate: onMyResize,
				transition: "easeOutCirc",
				time: .3
			});
		}
		
		private function onChildResize(e:CanvasEvent):void {
			var maxw:int = 0;
			var h:int = 0;
			var o:TreeItemRenderer;
			for(var i:int = 0; i < numChildren; ++i) {
				o = getChildAt(i) as TreeItemRenderer;
				if(o == null) continue;
				
				maxw < o.x + o.width ? maxw = o.x + o.width: void;
				h += o.height + o.child.height;
			}
			
			//e != null ? resize(maxw, h): void;
		}
		
		private function onMyResize(e:CanvasEvent = null):void {
//			trace("Tree::onMyResize(" + x + ", " + y + ", " + width + ", " + height + ")");
			mMask.graphics.clear();
			mMask.graphics.beginFill(0, 0);
			mMask.graphics.drawRect(x, y, mWidth, mHeight);
			mMask.graphics.endFill();
			style.redraw();
		}
	}
}