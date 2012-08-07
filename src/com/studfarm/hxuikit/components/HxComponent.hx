package com.studfarm.hxuikit.components;

import nme.display.Sprite;

class HxComponent extends Sprite {
	
	private var _xpos:Float;
	private var _ypos:Float;
	private var _parameters:Dynamic;
	
	public function new (params:Dynamic) {
		super();
		_parameters = params;
		_xpos = 0;
		_ypos = 0;
	}
	
	public function init () {
	}
	
	public function getParameters () : Dynamic {
		return _parameters;
	}
}
