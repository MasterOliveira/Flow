package org.flowplayer.menu.ui{
	
	import fb.VolumeBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flowplayer.model.PlayerEvent;
	import org.flowplayer.ui.buttons.AbstractButton;
	import org.flowplayer.view.Flowplayer;

	public class VolumeBarContainer extends MovieClip{
		
		public var _volumeBarClip:VolumeBar;
		
		private var _draggerButton:MovieClip;
		private var _bar:MovieClip;
		
		private var _mouseDown:Boolean;
		private var _minDraggerButtonY:Number;
		private var _maxDraggerButtonY:Number;
		private var _player:Flowplayer;
		
		private var _hideTimer:Timer;
		
		public function VolumeBarContainer(player:Flowplayer){
			_volumeBarClip = new VolumeBar();
			addChild(_volumeBarClip);
			
			_bar = _volumeBarClip.bar;
			_player = player;
			_draggerButton = _volumeBarClip.dragger;
			_maxDraggerButtonY = _draggerButton.y;
			_minDraggerButtonY = _volumeBarClip.minY.y;
			
			updateVolumeBarWithPlayerVolume();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown, false, 100);
		}
		
		private function _onMouseDown(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 100);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp, false, 100);
			updateVolumeBar();
		}
		
		private function _onMouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		private function _onMouseMove(event:MouseEvent):void {
			updateVolumeBar();
		}
		
		private function updateDraggerButtonPosition(volume:Number):void {			
			_draggerButton.y =  _minDraggerButtonY+draggerRailSize*(1-volume/100);
		}
		
		private function updateBarScale(volume:Number):void {
			_bar.scaleY = volume/100;
		}
		
		private function updateVolumeBarWithPlayerVolume(){
			updateBarScale(_player.volume);
			updateDraggerButtonPosition(_player.volume);
		}
		
		private function updateVolumeBar():void {
			updateDraggerButtonPosition(calcVolume());
			updateBarScale(calcVolume());
			
			setPlayerVolume(calcVolume());
		}
		
		private function mouseBoundedRelativeY():Number {
			if (mouseY < _minDraggerButtonY) { return 0;				} 
			if (mouseY > _maxDraggerButtonY) { return draggerRailSize;	}
			return mouseY - _minDraggerButtonY;
		}
		
		//In range [0,100]
		private function calcVolume():Number{
			return (1-mouseBoundedRelativeY()/draggerRailSize)*100;
		}
		
		private function get draggerRailSize():Number{
			return _maxDraggerButtonY-_minDraggerButtonY;
		}
		
		private function setPlayerVolume(value:Number){
			_player.volume = value;
		}
	}
}