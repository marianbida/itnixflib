package itnix.flib.data {
	
	public final class MenuItem {
		
		public var data:Object;
		public var label:String;
		public var icon:Object;
		public var children:Array = [];
		public var selectable:Boolean = false;
		
		public function MenuItem(label:String, icon:Object = null, data:Object = null) {
			this.label = label;
			this.icon = icon;
			this.data = data;
		}
		
		public function toString():String {
			return "MenuItem('" + label + "', " + children.length + " children)";
		}
	}
}