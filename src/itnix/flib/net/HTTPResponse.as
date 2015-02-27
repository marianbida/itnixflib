package itnix.flib.net {
	
	import flash.events.ErrorEvent;
	import flash.utils.ByteArray;
	
	public final class HTTPResponse {
		
		public var extraData:Object;
		
		private var mUrl:String;
		private var mRawData:Object;
		private var mData:Object;
		private var mErrorEvent:ErrorEvent;
		private var mError:Error;
		
		public function HTTPResponse(url:String, rawData:Object) {
			mUrl = url;
			mRawData = rawData;
		}
		
		public function parseJSON():Boolean {
			if(mRawData == null) {
				mRawData = "";
				return true;
			}
			var success:Boolean = false;
			var src:String = mRawData.toString();
			try {
				mData = JSON.parse(src);
				success = true;
			} catch(err:*) {
				mError = err;
			}
			return success;
		}
		
		public function get url():String {
			return mUrl;
		}
		
		public function get rawData():Object {
			return mRawData;
		}
		
		public function get data():Object {
			return mData;
		}
		
		public function get error():Error {
			return mError;
		}
		
		public function get errorEvent():ErrorEvent {
			return mErrorEvent;
		}
		
		public function set errorEvent(err:ErrorEvent):void {
			mErrorEvent = err;
		}
		
		public function get hasError():Boolean {
			return mError != null || mErrorEvent != null;
		}
		
		public function get errorText():String {
			if(mErrorEvent != null) {
				return mErrorEvent.text;
			} else if(mError != null) {
				return mError.message + "\n" + mError.getStackTrace();
			}
			return "";
		}
		
		public function toString():String {
			return "HTTPResponse(data='" + data + "')";
		}
	}
}