package org.flowplayer.menu {
    import org.flowplayer.ui.buttons.ButtonConfig;

    public class VolumeButtonConfig extends ButtonConfig {
        private static const PLACE_BOTH:String = "both";
        private static const PLACE_DOCK:String = "dock";
        private static const PLACE_CONTROLS:String = "controls";

        private var _place:Object = PLACE_CONTROLS;

        public function set place(value:*):void {
            _place = value == true ? PLACE_CONTROLS : value;
        }

		public function get docked():Boolean {
			return _place == PLACE_BOTH || _place == PLACE_DOCK;
		}

		public function get controls():Boolean {
			return _place == PLACE_BOTH || _place == PLACE_CONTROLS;
		}

        public function get dockedOrControls():Boolean {
            return docked || controls;
        }
    }
}
