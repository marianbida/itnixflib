package itnix.flib.utils {
	
	public final class StackTrace {
		
		public static function getClassName(object:Object):String {
			var name:String = Object.prototype.toString.apply(object);
			var len:int = name.length;
			return name.substr(8, len - 9);
		}
		
		private var mElements:Vector.<StackElement>;
		
		public function get elements():Vector.<StackElement> {
			return mElements;
		}
		
		public function StackTrace() {
			super();
			mElements = new Vector.<StackElement>();
			init();
		}
		
		private function init():void {
			var err:Error = new Error();
			var stack:String = err.getStackTrace();
			var lines:Array = stack.split('\n');
			lines.shift();
			lines.shift();
			lines.shift();
			for(var i:int = 0; i < lines.length; ++i) {
				mElements.push(new StackElement(lines[i]));
			}
		}
	}
}