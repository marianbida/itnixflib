package itnix.flib.utils {
	
	public final class StackElement {
		
		private var mPackage:String;
		private var mClass:String;
		private var mNamespace:String;
		private var mFunction:String;
		
		private var mFilename:String;
		private var mLineNum:Number;
		
		public function get pkg():String		{	return mPackage;	}
		public function get className():String	{	return mClass;		}
		public function get namespace():String	{	return mNamespace;	}
		public function get func():String		{	return mFunction;	}
		public function get filename():String	{	return mFilename;	}
		public function get lineNum():Number	{	return mLineNum;	}
		
		public function get hasDebug():Boolean {
			return mFilename != null && !isNaN(mLineNum);
		}
		
		public function StackElement(src:String = null) {
			super();
			if(src == null) {
				var err:Error = new Error();
				var stack:String = err.getStackTrace();
				var lines:Array = stack.split('\n');
				lines.shift();
				lines.shift();
				src = lines.shift();
			}
			
			var rx:RegExp = /^\s+at (?:([^\/]+)::)?(?:([^\/]+)\/)?(?:(.+)::)?(.+)\(\)(?:\[(.+):(\d+)\])?$/gm;
			var o:Object = rx.exec(src);
			/*	[Call Stack]
				package: $1
				class: $2
				namespace: $3
				function: $4
				file: $5
				line: $6
			*/
			mPackage = o[1];
			mClass = o[2];
			mNamespace = o[3];
			mFunction = o[4];
			mFilename = o[5];
			mLineNum = parseFloat(o[6]);
		}
		
		public function toString():String {
			return 'StackElement('+
				(mNamespace ? mNamespace + '::': '')+
				(mPackage ? mPackage + '::': '')+
				(mClass ? mClass + '->': '') + mFunction + '()'+
				(hasDebug ? ' @ ' + mFilename + ' - line ' + mLineNum: '')+
				')';
		}
	}
}