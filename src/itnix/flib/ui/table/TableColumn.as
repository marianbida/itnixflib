package itnix.flib.ui.table {
	
	import itnix.flib.data.TableItem;
	
	public class TableColumn extends TableItem {
		
		public var data:Object;
		
		public var width:Number;
		
		public var labelField:String;
		public var iconField:String;
		
		public function TableColumn(label:String = "", icon:Object = null,
										data:Object = null, width:Number = 100,
										labelField:String = "label", iconField:String = "icon") {
			super(label, icon);
			this.data = data;
			this.width = width;
			
			this.labelField = labelField;
			this.iconField = iconField;
		}
		
		public override function toString():String {
			return "TableColumn('" + label + "', " + width + ")";
		}
	}
}