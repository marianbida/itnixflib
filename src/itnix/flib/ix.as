package itnix.flib {
	
	import itnix.flib.utils.StackElement;
	import itnix.flib.utils.StackTrace;
	
	public class ix {
		
		public static var LOG_FUNCTION:Function = defaultLogFunc;
		
		public static function getObjKeys(o:Object):Array {
			var arr:Array = [];
			for each(var k:* in o)
				arr.push(k);
				return arr;
		}
		
		public static function mes(s:String):String {
			s =		s.replace(/\"/gm, '\\"')
					 .replace(/\r/gm, '\\r"')
					 .replace(/\n/gm, '\\n"');
			return s;
		}
		
		public static function sqlDate(d:Date = null):String {
			if(d == null) d = new Date();
			var YY:Number = d.fullYear;
			var mm:Number = d.month + 1;
			var dd:Number = d.date;
			
			return YY + '-'+
				(mm < 10 ? '0': '') + mm + '-' +
				(dd < 10 ? '0': '') + dd;
		}
		
		public static function log(...args):void {
			LOG_FUNCTION.apply(null, args);
		}
		
		private static function defaultLogFunc(...args):void {
			var stack:StackTrace = new StackTrace();
			var thizFunc:StackElement = stack.elements.shift() as StackElement;
			var applyFunc:StackElement = stack.elements.shift() as StackElement;
			var logFunc:StackElement = stack.elements.shift() as StackElement;
			var callee:StackElement = stack.elements.shift() as StackElement;
			var cname:String = (callee.className == null ? '': callee.className + '::');
			for each(var arg:String in args) {
				trace(callee.func + '(): ' + arg);
			}
		}
		
		public static function extend(obj:Object, add:Object):Object {
			var o:Object = new Object(), k:*;
			try { if(obj !== null) for(k in obj)	o[k] = obj[k]; } catch(err:*) {};
			try { if(add !== null) for(k in add)	o[k] = add[k]; } catch(err:*) {};
			return o;
		}
	}
}

