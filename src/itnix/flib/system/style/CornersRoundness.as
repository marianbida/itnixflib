package itnix.flib.system.style {
	
	public final class CornersRoundness {
		
		public var topLeft:Number;
		public var topRight:Number;
		public var bottomLeft:Number;
		public var bottomRight:Number;
		
		public function CornersRoundness(
											topLeft:Number = 0,
											topRight:Number = 0,
											bottomLeft:Number = 0,
											bottomRight:Number = 0
										) {
			this.topLeft = topLeft;
			this.topRight = topRight;
			this.bottomLeft = bottomLeft;
			this.bottomRight = bottomRight;
		}
		
		public function clone():CornersRoundness {
			return new CornersRoundness(topLeft, topRight, bottomLeft, bottomRight);
		}
		
		public function isZero():Boolean {
			return	topLeft == 0 && topRight == 0 && bottomLeft == 0 && bottomRight == 0;
		}
	}
}