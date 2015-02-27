package itnix.flib.net {
	
	import flash.events.EventDispatcher;
	
	public class HTTPService extends EventDispatcher {
		
		private var mWebRoot:String;
		private var mSeparator:String;
		private var mDebug:Boolean;
		
		public function get webRoot():String {
			return mWebRoot;
		}
		
		public function get debug():Boolean {
			return mDebug;
		}
		
		public function HTTPService(webroot:String, debug:Boolean = false) {
			super();
			mWebRoot = webroot;
			mDebug = debug;
		}
		
		public function call(func:String, callBack:Function = null, params:Object = null, extraData:Object = null):void {
			var ldr:HTTPLoader = new HTTPLoader(mWebRoot, func, callBack, params, mDebug);
			ldr.extraData = extraData;
		}
	}
}