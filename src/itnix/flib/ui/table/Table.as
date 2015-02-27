package itnix.flib.ui.table {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import itnix.flib.data.TableItem;
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.events.TableEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.system.style.Style;
	
	[Event(type="itnix.flib.events.TableEvent", name="tableSelect")]
	[Event(type="itnix.flib.events.TableEvent", name="tableDoubleClick")]
	public final class Table extends Canvas {
		
		public static var defaultTableStyle:Style;
		public static var defaultItemStyle:Style;
		
		private var mSelectedIndex:int;
		private const mSelectedIndexes:Array = [];
		private const mSelectedItems:Array = [];
		
		private var mBackground:Canvas;
		private var mColumns:Array;
		private var mItems:Array;
		
		private var mRowHeight:Number;
		
		private var mMask:Canvas;
		
		private var mLastItemClickTime:int;
		
		public function set columns(cols:Array):void {
			if(mColumns == cols) return;
			mColumns = cols;
			rebuild();
		}
		
		public function get columns():Array {
			return mColumns;
		}
		
		public function set items(itms:Array):void {
			if(mItems == itms) return;
			deselectAll();
			mItems = itms;
			rebuild();
		}
		
		public function get items():Array {
			return mItems;
		}
		
		public function get selectedIndex():int {
			return mSelectedIndex;
		}
		
		public function get selectedIndexes():Array {
			return mSelectedIndexes;
		}
		
		public function get selectedItem():Object {
			return mSelectedIndex >= 0 ? mItems[mSelectedIndex]: null;
		}
		
		public function get selectedItems():Object {
			return mSelectedItems;
		}
		
		public function set selectedIndex(idx:int):void {
			if(idx == mSelectedIndex) return;
			mSelectedIndex = idx;
			selectRow(idx);
		}
		
		public function get background():Canvas {
			return mBackground;
		}
		
		public function Table(columns:Array = null, rowHeight:Number = 20) {
			super();
			
			mRowHeight = rowHeight;
			
			mBackground = new Canvas();
			mMask = new Canvas();
			
			mMask.style.backgroundAlpha = 1;
			mMask.style.backgroundColor = 0;
			
			if(defaultTableStyle == null) {
				mBackground.style.backgroundAlpha = 1;
				mBackground.style.backgroundColor = 0xcfcfcf;
			} else {
				defaultTableStyle.clone(this);
			}
			
			this.columns = columns;
			
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, ad2st, true, 0, false);
			
			mSelectedIndex = -1;
		}
		
		private function ad2st(e:Event):void {
			onResize();
		}
		
		private function onResize(e:CanvasEvent = null):void {
			mMask.resize(width, height);
			mMask.style.redraw();
			mBackground.resize(width, height);
			
			mask = mMask;
			
			style.redraw();
			
			addChildAt(mBackground, 0);
			addChild(mMask);
		}
		
		public function rebuild():void {
			removeAllChildren();
			
			if(isNaN(width) && isNaN(height) || mColumns == null || mColumns.length == 0) {
				return;
			}
			
			var ti:TableItemRenderer;
			var c:TableColumn;
			var xx:Number = 0;
			for each(c in mColumns) {
				ti = new TableItemRenderer(c, c, true);
				ti.selected = false;
				ti.row = -1;
				ti.resize(c.width, mRowHeight);
				ti.x = xx;
				addChild(ti);
				
				xx += ti.width + 1;
			}
			
			if(mItems != null && mItems.length > 0) {
				var yy:Number = mRowHeight + 1,
					rowNum:int = 0;
				for each(var o:Object in mItems) {
					xx = 0;
					var colNum:int = 0;
					for each(c in mColumns) {
						var item:TableItem = new TableItem(o[c.labelField], c.iconField == null ? null: o[c.iconField]);
						trace('item = ' + JSON.stringify(o));
						var s:Style = defaultItemStyle != null ? defaultItemStyle.clone(): null;
						ti = new TableItemRenderer(c, item, false, s);
						ti.style.copyTextStyleFrom(this.style);
						ti.addEventListener(MouseEvent.MOUSE_DOWN, onItemSelected, false, 0, true);
						ti.row = rowNum;
						ti.col = colNum;
						ti.x = xx;
						ti.y = yy;
						ti.data = o;
						
						ti.selected = ti.row == mSelectedIndex;
						
						addChild(ti);
						ti.resize(c.width, mRowHeight);
						
						xx += c.width + 1;
						++colNum;
					}
					yy += mRowHeight + 1;
					++rowNum;
				}
			}
		}
		
		public function getRendersAt(row:uint):Array {
			var item:TableItem;
			if(mItems.length <= row) {
				item = mItems[row] as TableItem;
			}
			
			var o:TableItemRenderer;
			var itmz:Array = [];
			for(var i:int = 0; i < numChildren; ++i) {
				o = getChildAt(i) as TableItemRenderer;
				if(o == null || o.row != row) continue;
				itmz.push(o);
			}
			return itmz;
		}
		
		public function deselectAll():void {
			var o:TableItemRenderer;
			for(var i:int = 0; i < numChildren; ++i) {
				o = getChildAt(i) as TableItemRenderer;
				if(o == null || !o.selected) continue;
				o.selected = false;
			}
		}
		
		public function selectRow(row:int = -1):void {
			if(row < 0) {
				deselectAll(); 
				return;
			}
			
			var o:TableItemRenderer;
			for(var i:int = 0; i < numChildren; ++i) {
				o = getChildAt(i) as TableItemRenderer;
				if(o == null || o.row != row || o.selected) continue;
				o.selected = true;
			}
		}
		
		public function deselectRow(row:int = -1):void {
			var o:TableItemRenderer;
			for(var i:int = 0; i < numChildren; ++i) {
				o = getChildAt(i) as TableItemRenderer;
				if(o == null || o.row != row || !o.selected) continue;
				o.selected = false;
			}
		}
		
		private function onItemSelected(e:MouseEvent):void {
			var ti:TableItemRenderer = e.currentTarget as TableItemRenderer;
			var now:int = getTimer();
			var td:int = now - mLastItemClickTime;
			mLastItemClickTime = now;
			if(td > 200) {
				onItemSelectedTimeout(ti, false);
			} else {
				mLastItemClickTime = 0;
				dispatchEvent(new TableEvent(TableEvent.TABLE_DOUBLE_CLICK, ti.data));
				e.stopImmediatePropagation();
			}
		}
		
		private function onItemSelectedTimeout(ti:TableItemRenderer, ctrlKey:Boolean):void {
			if(ti.selected && !ctrlKey) return;
			
			mSelectedIndex = ti.row;
			if(ctrlKey) {
				if(ti.selected) {
					for(var i:int = 0; i < mSelectedIndexes.length; ++i) {
						if(mSelectedIndexes[i] == ti.row) {
							mSelectedIndexes.splice(i, 1);
							mSelectedItems.splice(i, 1);
						}
					}
					if(mSelectedIndexes.length == 0) {
						mSelectedIndex = -1;
					}
					deselectRow(ti.row);
				} else {
					mSelectedIndexes.push(ti.row);
					mSelectedItems.push(ti.data);
					selectRow(ti.row);
				}
			} else if(!ti.selected) {
				deselectAll();
				mSelectedIndexes.splice(0);
				mSelectedItems.splice(0);
				
				mSelectedIndexes.push(ti.row);
				mSelectedItems.push(ti.data);
				
				selectRow(mSelectedIndex);
			}
			
			dispatchEvent(new TableEvent(TableEvent.TABLE_SELECT, ti.data));
		}
		
		public override function toString():String {
			var cls:String = '';
			for each(var col:TableColumn in mColumns) {
				cls += (cls == '' ? '': ',') + col.label;
			}
			return "Table(cols='" + (cls == '' ? '<none>': cls) + "', " +
							"rows=" + (mItems == null ? 0: mItems.length) + ")";
		}
	}
}