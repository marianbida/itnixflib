package itnix.flib.system {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	
	public final class MouseCursor extends Bitmap {
		
		public static const NAME:String = '_ixflib_sys_mCursor';
		
		private var mOffset:Point;
		
		public function get offset():Point {
			return mOffset;
		}
		
		public function get bmpWidth():int {
			return bitmapData.width;
		}
		
		public function get bmpHeight():int {
			return bitmapData.height;
		}
		
		public function MouseCursor(bitmapData:BitmapData = null, offsetX:Number = NaN, offsetY:Number = NaN) {
			super(bitmapData, PixelSnapping.ALWAYS, true);
			mOffset = new Point(offsetX, offsetY);
			
			if(isNaN(offsetX) && isNaN(offsetY) && bitmapData != null) {
				mOffset.x = - bitmapData.width / 2;
				mOffset.y = - bitmapData.height / 2;
			}
		}
		
		public function move(x:int, y:int):void {
			this.x = x + mOffset.x;
			this.y = y + mOffset.y;
		}
	}
}