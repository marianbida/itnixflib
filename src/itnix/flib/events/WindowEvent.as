package itnix.flib.events {
	
	import flash.events.Event;
	
	public final class WindowEvent extends Event {
		
		public static const TITLE_CHANGE:String = 'titleChange';
		
		public function WindowEvent(type:String) {
			super(type);
		}
	}
}