package itnix.flib.utils {
	
	public final class ixgeom {
		
		public static function fitRects(holderW:Number, holderH:Number, contentW:Number, contentH:Number):Number {
			if(isNaN(holderW) || isNaN(holderH) || isNaN(contentW) || isNaN(contentH))
				return NaN;
			return holderW / holderH <= contentW / contentH ?
					holderW / contentW: holderH / contentH;
		}
		
		
		
		
		
		
		
		
		public function ixgeom() {
			throw 'oh yeah... lol :D';
		}
	}
}