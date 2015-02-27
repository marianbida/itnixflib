package itnix.flib.ui {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import itnix.flib.graphics.Canvas;
	
	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.IOErrorEvent", name="ioError")]
	public class ImageHolder extends Canvas {
		
		public var backgroundAlpha:Number;
		public var backgroundColor:uint = 0xffffff;
		
		private var mLoader:Loader;
		
		private var mBitmap:Bitmap;
		
		private var mSource:Object;
		private var mRealWidth:Number;
		private var mRealHeight:Number;
		
		public function get realWidth():Number {
			return mRealWidth;
		}
		
		public function get realHeight():Number {
			return mRealHeight;
		}
		
		public function get bitmap():BitmapData {
			return mBitmap.bitmapData;
		}
		
		public function ImageHolder(width:Number = NaN, height:Number = NaN, source:Object = null) {
			mWidth = width;
			mHeight = height;
			mSource = source;
			
			mLoader = new Loader();
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageHere);
			mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
		}
		
		public override function set width(value:Number):void {
			mWidth = value;
			resetSize();
		}
		
		public override function set height(value:Number):void {
			mHeight = value;
			resetSize();
		}
		
		public override function get width():Number {
			return mWidth;
		}
		
		public override function get height():Number {
			return mHeight;
		}
		
		public function set source(src:Object):void {
			mSource = src;
			doLoad();
		}
		
		public function get source():Object {
			return mSource;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function ad2st(e:Event):void {
			redrawBackground();
			doLoad();
		}
		
		private function doLoad():void {
			if(mSource == null) {
				if(mBitmap != null) {
					mBitmap.bitmapData = null;
				}
				mLoader.unload();
				return;
			}
			
			if(mSource is String) {
				var context:LoaderContext = new LoaderContext();
				context.checkPolicyFile = true;
				mLoader.load(new URLRequest(mSource as String), context);
			} else if(mSource is Class) {
				var bmp:Bitmap;
				try {
					bmp = new mSource() as Bitmap;
				} catch(err:Error) {
					bmp = null;
				}
				
				loadBitmap(bmp);
			} else if(mSource is Bitmap) {
				loadBitmap(mSource as Bitmap);
			} else {
				throw "ImageHolder::Unknown source: " + mSource;
			}
		}
		
		private function onImageHere(e:Event):void {
			//trace("Image here: " + mLoader.content);
			if(!(mLoader.content is Bitmap)) {
				return;
			}
			
			loadBitmap(mLoader.content as Bitmap);
			dispatchEvent(e);
		}
		
		private function loadBitmap(bmp:Bitmap):void {
			if(mBitmap != null) {
				removeChild(mBitmap);
				mBitmap = null;
			}
			
			if(bmp == null) {
				return;
			}
			
			mBitmap = bmp;
			mBitmap.smoothing = true;
			
			mRealWidth = mBitmap.bitmapData.width;
			mRealHeight = mBitmap.bitmapData.height;
			
			resetSize();
			
			addChild(mBitmap);
		}
		
		private function redrawBackground():void {
			graphics.clear();
			
			if(!isNaN(backgroundAlpha)) {
				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRect(0, 0, mWidth, mHeight);
				graphics.endFill();
			}
		}
		
		private function resetSize():void {
			redrawBackground();
			
			if(mBitmap == null) {
				return;
			}
			var k1:Number = mWidth / mHeight;
			var k2:Number = mRealWidth / mRealHeight;
			
			var ww:Number, hh:Number;
			if(k1 < k2) {
				ww = mWidth;
				hh = ww / k2;
			} else {
				hh = mHeight;
				ww = hh * k2;
			}
			
			mBitmap.width = ww;
			mBitmap.height = hh;
			
			mBitmap.x = (mWidth - ww) / 2;
			mBitmap.y = (mHeight - hh) / 2;
		}
		
		private function onImageError(e:IOErrorEvent):void {
			trace("Image error: " + e.text);
			dispatchEvent(e);
		}
	}
}