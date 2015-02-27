package itnix.flib.enc.img {
	
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.graphics.codec.PNGEncoder;
	
	public final class IcoEncoder {
		
		private static const HEADER_LENGHT:uint = 6;
		private static const ENTRY_LENGHT:uint = 16;
		
		private var mImages:Vector.<BitmapData>;
		private var mImageBytes:Vector.<ByteArray>;
		
		public function IcoEncoder() {
			super();
			
			mImages = new Vector.<BitmapData>();
			mImageBytes = new Vector.<ByteArray>();
		}
		
		public function addImage(bmp:BitmapData):void {
			if(bmp.width > 256 || bmp.height > 256) {
				throw new ArgumentError('Invalid BitmapData: size must not exceed 256x256.');
			}
			mImages.push(bmp);
		}
		
		public function getIcoBytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			createHeader(bytes);
			createDir(bytes);
			createImages(bytes);
			return bytes;
		}
		
		private function createHeader(bytes:ByteArray):void {
			bytes.writeShort(0);
			bytes.writeShort(1); // 1=ico,2=cur
			bytes.writeShort(mImages.length);
		}
		
		private function createDir(bytes:ByteArray):void {
			var enc:PNGEncoder = new PNGEncoder();
			var imgBytes:ByteArray;
			var bmp:BitmapData;
			var tx:uint;
			mImageBytes.splice(0, mImageBytes.length);
			for(var i:int = 0; i < mImages.length; ++i) {
				bmp = mImages[i];
				imgBytes = enc.encode(bmp);
				mImageBytes.push(imgBytes);
				
				bytes.writeByte(255 & bmp.width);
				bytes.writeByte(255 & bmp.height);
				
				// Specifies number of colors in the color palette. Should be 0 if the image does not use a color palette.
				bytes.writeByte(0);
				// Reserved. Should be 0
				bytes.writeByte(0);
				// In ICO format: Specifies color planes. Should be 0 or 1
				bytes.writeShort(0);
				// In ICO format: Specifies bits per pixel.
				bytes.writeShort(24);
				bytes.writeInt(imgBytes.length);
				
				var offset:uint = HEADER_LENGHT + ENTRY_LENGHT * mImages.length + tx;
				bytes.writeUnsignedInt(offset);
				
				tx += imgBytes.length;
			}
		}
		
		private function createImages(bytes:ByteArray):void {
			for(var i:int = 0; i < mImageBytes.length; ++i) {
				bytes.writeBytes(mImageBytes[i]);
			}
		}
	}
}