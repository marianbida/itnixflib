package itnix.flib.ui.table {
	
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.utils.setTimeout;
	
	import itnix.flib.data.TableItem;
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.Style;
	import itnix.flib.ui.ImageHolder;
	import itnix.flib.ui.Label;
	
	public final class TableItemRenderer extends Canvas {
		
		public var iconSize:int = 16;
		
		public var col:int;
		public var row:int;
		
		private var mColumn:TableColumn;
		private var mItem:TableItem;
		private var mHeading:Boolean;
		private var mSelected:Boolean;
		private var mSelection:Sprite;
		
		private var mIcon:ImageHolder;
		private var mLabel:Label;
		
		public function get label():Label {
			return mLabel;
		}
		
		public function get item():TableItem {
			return mItem;
		}
		
		public function get selected():Boolean {
			return mSelected;
		}
		
		public function set selected(sel:Boolean):void {
			if(Tweener.isTweening(mSelection)) Tweener.removeTweens(mSelection, "alpha");
			mSelected = sel;
			Tweener.addTween(mSelection, { 
				alpha: uint(mSelected),
				transition: "ease" + (sel ? "Out": "In") + "Circ",
				time: .3
			});
			//trace("\tselected = " + sel + ", alpha = " + mSelection.alpha);
		}
		
		public function TableItemRenderer(col:TableColumn, item:TableItem, head:Boolean = false, otherStyle:Style = null) {
			super();
			
			if(otherStyle != null) {
				otherStyle.clone(this);
			}
			
			mColumn = col;
			if(head) {
				style.backgroundAlpha = 1;
				style.backgroundColor = 0xffffff;
			}
			
			mItem = item;
			mHeading = head;
			
			mIcon = new ImageHolder(iconSize, iconSize);
			mLabel = new Label();
			mSelection = new Sprite();
			mSelection.alpha = 0;
			mIcon.filters = [new DropShadowFilter(1, 45, 0, .7)];
			
			mLabel.style.copyTextStyleFrom(style);
			mLabel.mouseEnabled = mLabel.mouseChildren = false;
			
			if(col.iconField != null) {
				mIcon.source = mItem[col.iconField];
			} else {
				mIcon.source = null;
			}
			
			height = 20;
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			
			addChild(mIcon);
			addChild(mLabel);
			addChild(mSelection);
			
			resize(mLabel.x + mLabel.textWidth + 10, mHeight);
		}
		
		private function ad2st(e:Event):void {
			onResize();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			if(isNaN(width) || isNaN(height) || parent == null) return;
			
			style.selectionColor = (parent as Table).style.selectionColor;
			style.selectionAlpha = (parent as Table).style.selectionAlpha;
			
			mLabel.style.textBold = mHeading;
			var s:String;
			if(mColumn.labelField == null) {
				s = mItem[mColumn.labelField];
			} else {
				s = mItem.label;
			}
			mLabel.text = s;
			mLabel.height = height;
			mLabel.width = mLabel.textWidth;
			if(mIcon.source == null) {
				mLabel.x = 5;
			} else {
				mIcon.x = 5;
				mIcon.y = (height - mIcon.height) / 2;
				mLabel.x = 6 + mIcon.width;
			}
			mLabel.y = 1;
			
			mLabel.width = width - mLabel.x;
			
			mSelection.graphics.clear();
			mSelection.graphics.beginFill(style.selectionColor, style.selectionAlpha);
			mSelection.graphics.drawRect(0, 0, width, height);
			mSelection.graphics.endFill();
			
			if(mLabel.x + mLabel.width + 20 < width) {
				setTimeout(resize, 1, mLabel.x + mLabel.width + 20);
			}
			
			style.redraw();
		}
	}
}