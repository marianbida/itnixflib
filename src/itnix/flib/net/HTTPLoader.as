package itnix.flib.net {
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	public final class HTTPLoader extends URLLoader {
		
		public var extraData:Object;
		
		private var mUrl:String;
		private var mCallBack:Function;
		private var mDebug:Boolean;
		
		public function HTTPLoader(root:String, func:String, callBack:Function, params:Object, debug:Boolean) {
			super();
			
			mCallBack = callBack;
			mDebug = debug;
			
			if(params == null) {
				params = {};
			}
			
			addEventListener(Event.COMPLETE, onComplete);
			addEventListener(IOErrorEvent.IO_ERROR, onError);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			
			mUrl = root + func;
			var req:URLRequest = new URLRequest(mUrl);
			req.method = URLRequestMethod.POST;
			
			if(params is ByteArray || params is String || params is Number) {
				req.data = params;
			} else {
				req.data = JSON.stringify(params);
			}
			
			//trace("--\nLoading: " + req.method + " " + url + "\n\n" + req.data + "--\n");
			dataFormat = URLLoaderDataFormat.BINARY;
			if(mDebug) trace('HTTPService::call(): ' + mUrl + "\n\t" + req.data);
			load(req);
		}
		
		public function onComplete(e:Event):void {
			if(mDebug) trace('HTTPService::onComplete(): "' + data + '" (' + bytesLoaded + ' bytes)');
			if(mCallBack == null) {
				return;
			}
			var r:HTTPResponse = new HTTPResponse(mUrl, data);
			r.extraData = extraData;
			mCallBack(r);
			mCallBack = null;
		}
		
		public function onError(e:ErrorEvent):void {
			if(mDebug) trace('HTTPService::onError(): "' + e.text + '"');
			if(mCallBack == null) {
				return;
			}
			var r:HTTPResponse = new HTTPResponse(mUrl, null);
			r.extraData = extraData;
			r.errorEvent = e;
			mCallBack(r);
			mCallBack = null;
		}
		
		private function onHTTPStatus(e:HTTPStatusEvent):void {
			if(mDebug) trace('HTTPService::onComplete(): HTTP STATUS = ' + e.status);
		}
	}
}