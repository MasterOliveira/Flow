package org.flowplayer.menu.ui{

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import fp.VolumeButton;
    
    import org.flowplayer.model.DisplayPluginModel;
    import org.flowplayer.model.PlayerEvent;
    import org.flowplayer.ui.buttons.ButtonEvent;
    import org.flowplayer.ui.buttons.GenericTooltipButton;
    import org.flowplayer.ui.controllers.AbstractButtonController;
    import org.flowplayer.ui.dock.Dock;
    import org.flowplayer.view.AnimationEngine;
    import org.flowplayer.view.Flowplayer;

    public class VolumeViewController extends AbstractButtonController{
        private var _volumeBar:VerticalVolume;
        private var _model:DisplayPluginModel;
		private var _hideTimer:Timer;

		public function VolumeViewController(player:Flowplayer,  menuModel:DisplayPluginModel){
            _player = player;
            _volumeBar = menuModel.getDisplayObject() as VerticalVolume;
            _model = menuModel;
			
			_hideTimer = new Timer(2000,1);
			_hideTimer.addEventListener(TimerEvent.TIMER, hideVolumeBar);
			
			setListeners();
		}
		
		protected function onPlayerVolumeEvent(event:PlayerEvent):void{
			animateVolumeButton(event.info as Number)
		}
		
		override protected function onButtonClicked(event:ButtonEvent):void{
            var model:DisplayPluginModel = DisplayPluginModel(_player.pluginRegistry.getPlugin(_model.name));

            var show:Boolean = _volumeBar.alpha == 0 || ! _volumeBar.visible || ! _volumeBar.parent;
            if (show) {
				showVolumeBar()
            } else {
				hideVolumeBar()
            }
		}
		
		private function animateVolumeButton(volume:Number):void{
			var buttonIcon:MovieClip = (_widget as GenericTooltipButton).getface() as MovieClip;
			buttonIcon.icon.gotoAndStop("f" + Math.ceil((volume-3)/25));
		}
		
		private function setListeners():void{
			_player.onVolume(onPlayerVolumeEvent);
			_volumeBar.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		public function showVolumeBar():void{
			_volumeBar.updateModelProp("display", "block");
			_volumeBar.alpha = 0;
			_player.animationEngine.fadeIn(_volumeBar);
			
			_hideTimer.start();
			_volumeBar.addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			_volumeBar.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		public function hideVolumeBar(event:Event = null):void{
			_volumeBar.removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			_volumeBar.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_player.animationEngine.fadeOut(_volumeBar);
		}
		
		private function _onRollOut(event:MouseEvent):void{
			_hideTimer.start();
		}
		
		private function _onMouseMove(event:MouseEvent):void{
			_hideTimer.reset();
			_volumeBar.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		private function _onMouseDown(event:MouseEvent):void{
			_player.panel.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_volumeBar.removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
		}
		
		private function _onMouseUp(event:MouseEvent):void{
			_volumeBar.addEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			_volumeBar.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_hideTimer.start();
		}
		
		override public function get name():String{
			return "volume";
		}
		
		override public function get defaults():Object{
			return {
				tooltipEnabled: true,
				tooltipLabel: "Volume",
				visible: true,
				enabled: true
			};
		}
		
		override protected function get faceClass():Class {
			return VolumeButton;
		}
	}
}

