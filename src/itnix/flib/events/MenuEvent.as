package itnix.flib.events {
	
	import itnix.flib.data.MenuItem;
	
	import flash.events.Event;

	public final class MenuEvent extends Event {
		
		public static const MENU_SELECT:String = 'menuSelect';
		
		private var mItem:MenuItem;
		
		public function get item():MenuItem {
			return mItem;
		}
		
		public function get data():Object {
			return mItem == null ? null: mItem.data;
		}
		
		public function MenuEvent(type:String, item:MenuItem = null) {
			super(type);
			mItem = item;
		}
	}
}