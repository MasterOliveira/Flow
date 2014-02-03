/*
 * This file is part of Flowplayer, http://flowplayer.org
 *
 * By: Anssi Piirainen, <api@iki.fi>
 *
 * Copyright (c) 2008-2011 Flowplayer Oy
 *
 * Released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.flowplayer.menu {
    import org.flowplayer.model.DisplayPluginModel;
    import org.flowplayer.util.PropertyBinder;

    public class VolumeConfig {
        private var _button:VolumeButtonConfig = new VolumeButtonConfig();
        private var _items:Array;
        private var _defaultItemConfig:Object;
        private var _scrollable:Boolean;
        private var _scrollButtons:Object;
        private var _itemsUrl:String;
        private var _controlsPlugin:String = "controls";

        public function VolumeConfig() {
            _items = new Array();

            _defaultItemConfig = {
//                color: "rgba(140,142,140,1)",
                color: "rgba(60,60,60,.7)",
                overColor: "rgba(1,95,213,1)",
                fontColor: "rgb(0,0,0)",
                disabledColor: "rgba(150,150,150,1)"
            };
        }

        public function get items():Array {
            return _items;
        }

        public function get button():VolumeButtonConfig {
            return _button;
        }

        public function setButton(value:Object):void {
            new PropertyBinder(_button).copyProperties(value);
        }

        public function get scrollable():Boolean {
            return _scrollable;
        }

        public function set scrollable(value:Boolean):void {
            _scrollable = value;
        }

        public function get scrollButtons():Object {
            return _scrollButtons;
        }

        public function set scrollButtons(value:Object):void {
            _scrollButtons = value;
        }

        public function get itemsUrl():String {
            return _itemsUrl;
        }

        public function set controlsPlugin(value:String):void {
            _controlsPlugin = value;
        }

        public function get controlsPlugin():String {
            return _controlsPlugin;
        }
    }
}
