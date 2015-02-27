package itnix.flib.ui.renders {
	
	import itnix.flib.events.CanvasEvent;
	import itnix.flib.graphics.Canvas;
	import itnix.flib.ui.ImageHolder;
	import itnix.flib.ui.Label;
	
	import flash.events.Event;
	
	public class DefaultListRenderer extends Canvas {
		
		private var mData:Object;
		
		public override function get data():Object {
			return super.data;
		}
		
		public override function set data(o:Object):void {
			super.data = o;
			
			refresh();
		}
		
		private var mLabelField:String;
		private var mIconField:String;
		private var mIcon:ImageHolder;
		private var mLabel:Label;
		
		public function DefaultListRenderer(labelField:String, iconField:String) {
			super();
			mLabelField = labelField;
			mIconField = iconField;
			
			addEventListener(Event.ADDED_TO_STAGE, ad2st);
			addEventListener(CanvasEvent.CANVAS_RESIZE, onResize);
		}
		
		private function ad2st(e:Event):void {
			refresh();
		}
		
		private function refresh():void {
			var o:Object = super.data;
			if(parent == null || o == null ||
				(o[mLabelField] == null && o[mIconField] == null)) {
				return;
			}
			
			var icon:Object;
			var label:String;
			label = o[mLabelField];
			if(o.hasOwnProperty(mIconField)) {
				icon = o[mIconField];
			}
			
			if(icon != null) {
				if(mIcon == null) {
					mIcon = new ImageHolder(height, height, icon);
					mIcon.mouseChildren = mIcon.mouseEnabled = false;
					addChild(mIcon);
				} else {
					mIcon.source = icon;
				}
			} else if(mIcon != null) {
				removeChild(mIcon);
				mIcon = null;
			}
			
			if(label != null) {
				if(mLabel == null) {
					mLabel = new Label(label);
					mLabel.mouseChildren = mLabel.mouseEnabled = false;
					addChild(mLabel);
				} else mLabel.text = label;
			} else if(mLabel != null) {
				removeChild(mLabel);
				mLabel = null;
			} 
			
			onResize();
		}
			
		private function onResize(e:CanvasEvent = null):void {
			if(mIcon != null) {
				mIcon.width = mIcon.height = height;
			}
			
			if(mLabel != null) {
				mLabel.move(mIcon == null ? 0: mIcon.width + 1); 
				mLabel.resize(width - mLabel.x, height);
			}
		}
	}
}