package itnix.flib.data {
	
	public final class TreeItem {
		
		public var label:String;
		public var icon:Object;
		public var data:Object;
		public var children:Array;
		
		public function TreeItem(label:String, icon:Object = null, data:Object = null) {
			this.label = label;
			this.icon = icon;
			this.data = data;
		}
		
		public function toString():String {
			return "TreeItem('" + label + "')";
		}
	}
}