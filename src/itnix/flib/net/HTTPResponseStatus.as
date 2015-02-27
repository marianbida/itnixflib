package itnix.flib.net {
	
	public final class HTTPResponseStatus {
		
		public static const OK:String = "ok";
		public static const ERROR:String = "err";
		//public static const ERROR:String = "err";
		
		public function HTTPResponseStatus() {
			throw new Error("Don't do instantiate this class!"); 
		}
	}
}