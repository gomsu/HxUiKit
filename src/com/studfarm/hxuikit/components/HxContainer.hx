package com.studfarm.hxuikit.components;

class HxContainer extends HxComponent {
	
	private var _topLevel:Bool;
	
	public function new (params:Dynamic) {
		super(params);
		init();
	}
	
	override public function init () {
		super.init();
		_topLevel = false;
		
		// TODO: Don't check toplevel container like this
		if (_asset != null && _asset.parent != null && _asset.parent.parent == null)
			_topLevel = true;
	}
	
	override public function resize () {
		super.resize();
		
		//trace(_asset + ", "+ _asset.parent + ", " + _asset.parent.parent);
		/*
		if (_topLevel) {
			//trace("resizing container to: " + nme.Lib.current.stage.stageWidth + ", " + nme.Lib.current.stage.stageHeight);
			_asset.width = nme.Lib.current.stage.stageWidth;
			_asset.height = nme.Lib.current.stage.stageHeight;
		}*/
		
		_asset.getChildByName("background").width = getCurrentDimensions().width;
		_asset.getChildByName("background").height = getCurrentDimensions().height;		
	}
}
