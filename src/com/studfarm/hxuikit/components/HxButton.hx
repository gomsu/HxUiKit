package com.studfarm.hxuikit.components;

import com.studfarm.hxuikit.HxUiKit;
import nme.events.MouseEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.IOErrorEvent;
import skins.ButtonSkin;


class HxButton extends HxComponent {
	inline public static var CLICK:String = "buttonClick";
	
	private var _asset:Dynamic;
	
	public function new () {
		super();
		init();
	}
	
	private function init () {
		_asset = Type.createInstance(Type.resolveClass("skins.ButtonSkin"), []);
		_asset.stop();
		addChild(_asset);
		
		addEventListener(MouseEvent.CLICK, onClick);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	private function onMouseOver (evt:MouseEvent) : Void {
		if (evt.buttonDown)
			_asset.gotoAndStop(3);
		else
			_asset.gotoAndStop(2);
	}

	private function onMouseOut (evt:MouseEvent) : Void {
		_asset.gotoAndStop(1);
	}

	private function onMouseUp (evt:MouseEvent) : Void {
		_asset.gotoAndStop(2);
	}

	private function onMouseDown (evt:MouseEvent) : Void {
		_asset.gotoAndStop(3);
	}
	
	private function onClick (evt:MouseEvent) : Void {
		dispatchEvent(new Event(CLICK, false, true));
	}
}
