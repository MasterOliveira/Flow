package org.flowplayer.menu{
    import flash.display.Sprite;
    
    import org.flowplayer.menu.ui.VerticalVolume;
    import org.flowplayer.model.PluginFactory;

    public class VerticalVolumePluginFactory extends Sprite implements PluginFactory{

        public function newPlugin():Object{
            return new VerticalVolume();
        }
    }
}