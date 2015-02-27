package itnix.flib.events {
	
	import itnix.flib.data.TableItem;
	
	import flash.events.Event;

	public final class TableEvent extends Event {
		
		public static const TABLE_SELECT:String = 'tableSelect';
		public static const TABLE_DOUBLE_CLICK:String = 'tableDoubleClick';
		
		private var mItem:Object;
		
		public function get item():Object {
			return mItem;
		}
		
		public function TableEvent(type:String, item:Object = null) {
			super(type);
			mItem = item;
		}
	}
}