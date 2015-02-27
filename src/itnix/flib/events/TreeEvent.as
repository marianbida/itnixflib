package itnix.flib.events {
	
	import itnix.flib.data.TreeItem;
	
	import flash.events.Event;

	public final class TreeEvent extends Event {
		
		public static const TREE_SELECT:String = 'treeSelect';
		
		private var mItem:TreeItem;
		
		public function get item():TreeItem {
			return mItem;
		}
		
		public function TreeEvent(type:String, item:TreeItem = null) {
			super(type);
			mItem = item;
		}
	}
}