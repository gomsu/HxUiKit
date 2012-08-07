package com.studfarm.hxuikit.components;

import com.studfarm.hxuikit.HxUiKit;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.IOErrorEvent;
import skins.ButtonSkin;

import nme.Assets;


class HxButton extends HxComponent {
	inline public static var CLICK:String = "buttonClick";
	
	private var _asset:Dynamic;
	private var _label:HxLabel;
	
	public function new (params:Dynamic) {
		super(params);
		init();
	}
	
	override public function init () {
		super.init();
		
		_asset = Type.createInstance(Type.resolveClass(getParameters().get("skin")), []);
		_asset.stop();
		
		getParameters().set("width", _asset.width);
		getParameters().set("height", _asset.height);
		
		_label = new HxLabel(getParameters());
		
		addChild(_asset);
		addChild(_label);
		
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
