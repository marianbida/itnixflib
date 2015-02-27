package itnix.flib.data {
	
	public final class Version {
		
		private var mMajor:uint;
		private var mMinor:uint;
		private var mBuild:uint;
		
		public function get major():uint {
			return mMajor;
		}
		
		public function get minor():uint {
			return mMinor;
		}
		
		public function get build():uint {
			return mBuild;
		}
		
		public function Version(major:uint = 0, minor:uint = 0, build:uint = 0) {
			mMajor = major;
			mMinor = minor;
			mBuild = build;
		}
		
		public function toString():String {
			return "v" + mMajor + "." + mMinor + (mBuild > 0 ? "." + mBuild: "");
		}
	}
}