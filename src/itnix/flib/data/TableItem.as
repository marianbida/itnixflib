package itnix.flib.data {
	
	public class TableItem {
		
		public var label:String;
		public var icon:Object;
		
		public function TableItem(label:String, icon:Object = null) {
			this.label = label;
			this.icon = icon;
		}
		
		public function toString():String {
			return "TableItem('" + label + "')";
		}
	}
}