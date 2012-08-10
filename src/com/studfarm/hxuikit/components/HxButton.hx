package com.studfarm.hxuikit.components;

import com.studfarm.hxuikit.HxUiKit;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.IOErrorEvent;

import nme.Assets;

class HxButton extends HxComponent {
	inline public static var CLICK:String = "buttonClick";
		
	private var _label:HxLabel;
	
	public function new (params:Dynamic) {
		super(params);
		init();
	}
	
	override public function init () {
		super.init();
		
		_asset.getChildByName("background").stop();
		_parameters.set("width", _asset.width);
		_parameters.set("height", _asset.height);
		
		_label = new HxLabel(_parameters);
		
		_asset.addChild(_label);
		_asset.addEventListener(MouseEvent.CLICK, onClick);
		_asset.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		_asset.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		_asset.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_asset.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	override public function resize () {
		super.resize();
		
		_parameters.set("width", _currentRect.width);
		_parameters.set("height", _currentRect.height);
		_label.getParameters().set("width", _currentRect.width);
		_label.getParameters().set("height", _currentRect.height);
		_label.resize();
	}
	
	private function onMouseOver (evt:MouseEvent) : Void {
		if (evt.buttonDown)
			_asset.getChildByName("background").gotoAndStop(3);
		else
			_asset.getChildByName("background").gotoAndStop(2);
			
		_asset.addChild(_label);
	}

	private function onMouseOut (evt:MouseEvent) : Void {
		_asset.getChildByName("background").gotoAndStop(1);
		_asset.addChild(_label);
	}

	private function onMouseUp (evt:MouseEvent) : Void {
		_asset.getChildByName("background").gotoAndStop(2);
		_asset.addChild(_label);
	}

	private function onMouseDown (evt:MouseEvent) : Void {
		_asset.getChildByName("background").gotoAndStop(3);
		_asset.addChild(_label);
	}
	
	private function onClick (evt:MouseEvent) : Void {
		dispatchEvent(new Event(CLICK, false, true));
	}
}
