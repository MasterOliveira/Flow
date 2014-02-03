package org.flowplayer.menu.ui {
	import fb.VolumeBar;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import org.flowplayer.config.ConfigParser;
	import org.flowplayer.controller.ResourceLoader;
	import org.flowplayer.flow_internal;
	import org.flowplayer.menu.*;
	import org.flowplayer.model.DisplayPluginModel;
	import org.flowplayer.model.PlayerEvent;
	import org.flowplayer.model.Plugin;
	import org.flowplayer.model.PluginModel;
	import org.flowplayer.ui.containers.WidgetContainer;
	import org.flowplayer.ui.containers.WidgetContainerEvent;
	import org.flowplayer.ui.dock.Dock;
	import org.flowplayer.ui.dock.DockConfig;
	import org.flowplayer.util.Arrange;
	import org.flowplayer.util.PropertyBinder;
	import org.flowplayer.view.AbstractSprite;
	import org.flowplayer.view.Flowplayer;
	import org.flowplayer.view.Styleable;
	
	
	use namespace flow_internal;
	
	public class VerticalVolume extends AbstractSprite implements Plugin {
		private var _config:VolumeConfig;
		private var _dock:Dock;
		private var _player:Flowplayer;
		private var _name:String;
		private var _volumeViewController:VolumeViewController;
		private var _volumeButtonContainer:WidgetContainer;
		private var _model:PluginModel;

		private function addSlider():void {
			var container:VolumeBarContainer = new VolumeBarContainer(_player);
			_dock.addIcon(container);
		}
		
		private function createDock():void {
			log.debug("createDock()");
			var dockConfig:DockConfig = new DockConfig();
			dockConfig.model = DisplayPluginModel(model.clone());
			dockConfig.model.display = "block";
			dockConfig.gap = 0;
			dockConfig.setButtons(_config.scrollButtons);
			
			if (_config.button.dockedOrControls) {
				updateModelProp("display", "none");
				updateModelProp("alpha", 0);
			}
			dockConfig.scrollable = _config.scrollable;
			
			_dock = new Dock(_player, dockConfig);
			addChild(_dock);
			
		}
		
		private function get model():DisplayPluginModel {
			return DisplayPluginModel(_player.pluginRegistry.getPlugin(_name));
		}
		
		public function onConfig(model:PluginModel):void {
			_model = model;
			_name = model.name;
			_config = new PropertyBinder(new VolumeConfig()).copyProperties(model.config) as VolumeConfig;
			log.debug("config", _config.items);
		}
		
		public function onLoad(player:Flowplayer):void {
			_player = player;
			
			createDock();
			addSlider();
			
			updateModelHeight();
			_model.dispatchOnLoad();
			
			setUpFullScreenEventHandlers();
			
			createVolumeButton(player);
		}
		
		private function setUpFullScreenEventHandlers():void {
			_player.onFullscreen(function(event:PlayerEvent):void {
				adjustDockPosition();
			});
			
			_player.onFullscreenExit(function(event:PlayerEvent):void {
				adjustDockPosition();
			});
		}
		
		private function updateModelHeight():void {
			updateModelProp("height", _dock.height);
		}
		
		internal function updateModelProp(prop:String, value:Object):void {
			var myModel:DisplayPluginModel = model;
			myModel[prop] = value;
			_player.pluginRegistry.updateDisplayProperties(myModel);
		}
		
		private function get horizontalPosConfigured():Boolean {
			var confObj:Object = _player.config.getObject("plugins")[_name];
			return confObj && (confObj.hasOwnProperty("left") || confObj.hasOwnProperty("right"));
		}
		
		private function get verticalPosConfigured():Boolean {
			var confObj:Object = _player.config.getObject("plugins")[_name];
			return confObj && (confObj.hasOwnProperty("top") || confObj.hasOwnProperty("bottom"));
		}
		
		override protected function onResize():void {
			_dock.setSize(width, height);
			updateModelHeight();
		}
		
		public function getDefaultConfig():Object {
			return { width: 30, height: 200 };
		}
		
		private function createVolumeButton(player:Flowplayer):void {
			if (! _config.button.dockedOrControls) return;
			
			if (_config.button.controls) {
				var controlbar:* = player.pluginRegistry.plugins[_config.controlsPlugin];
				controlbar.pluginObject.addEventListener(WidgetContainerEvent.CONTAINER_READY, addControlsVolumeButton);
			}
		}
		
		public function get volumeViewController():VolumeViewController {
			return _volumeViewController;
		}
		
		private function addControlsVolumeButton(event:WidgetContainerEvent):void {
			_volumeButtonContainer = event.container;
			_volumeViewController = new VolumeViewController(_player,  model);
			_volumeButtonContainer.addWidget(_volumeViewController, "time", false);
			
			if (this.stage) {
				adjustDockPosition();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, adjustDockOnStage);
			}
		}
		
		private function adjustDockPosition():void {
			if (horizontalPosConfigured && verticalPosConfigured) return;
			var myModel:DisplayPluginModel = model;
			

			
			if (! horizontalPosConfigured) {
				myModel.left = _volumeViewController.view.x;
			}
			if (! verticalPosConfigured) {
				
				if ( stage) {
					myModel.bottom = stage.stageHeight - DisplayObject(_volumeButtonContainer).y;
				} else {
					this.addEventListener(Event.ADDED_TO_STAGE, adjustDockOnStage);
					return;
				}
			}
			_player.animationEngine.animate(this, myModel, 0);
		}
		
		private function adjustDockOnStage(event:Event):void
		{
			adjustDockPosition();
			this.removeEventListener(Event.ADDED_TO_STAGE, adjustDockOnStage);
		}
		
		private function moveDockToNewHeight():void {
			var model:DisplayPluginModel = model;
			log.debug("moveDockToNewHeight(), plugin visible? " + model.visible);
			if (model.visible) {
				_player.animationEngine.animate(this, model);
			}
		}
	}
}
