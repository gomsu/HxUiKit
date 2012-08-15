package com.studfarm.hxuikit.components;

import nme.geom.Point;
import nme.geom.Rectangle;

class HxImage extends HxComponent {
	private var _originalAspectRatio:Float;
	private var _originalImageSize:Point;
	private var _currentImageRect:Rectangle;
	
	public function new (params:Dynamic) {
		super(params);
		init();
	}
	
	override public function init () {
		super.init();
		_originalAspectRatio = _asset.getChildByName("image").width / _asset.getChildByName("image").height;
		_originalImageSize = new Point (_asset.getChildByName("image").width, _asset.getChildByName("image").height);
	}
	
	override public function resize () {
		super.resize();
		
		calcImageSize();
		calcImagePos();
		
		_asset.getChildByName("image").x = _currentImageRect.x;
		_asset.getChildByName("image").y = _currentImageRect.y;
		
		_asset.getChildByName("image").width = _currentImageRect.width;
		_asset.getChildByName("image").height = _currentImageRect.height;
	}
	
	private function calcImagePos () {
		var horizontalAlign:String = "left";
		var verticalAlign:String = "top";
		
		if (_parameters.exists("imageAlignHorizontal"))
			horizontalAlign = _parameters.get("imageAlignHorizontal");
		if (_parameters.exists("imageAlignVertical"))
			verticalAlign = _parameters.get("imageAlignVertical");
		
		_currentImageRect.x = calcPos(horizontalAlign, _currentImageRect.width, _currentRect.width);
		_currentImageRect.y = calcPos(verticalAlign, _currentImageRect.height, _currentRect.height);
	}
	
	private function calcPos (align:String, length:Float, maxLength:Float) : Float {
		var pos:Float = 0;
		
		switch (align) {
			case "left", "top":				
			case "center":
				pos = (maxLength - length) / 2;
			case "right", "bottom":
				pos = maxLength - length;
		}
		
		return pos;
	}
	
	private function calcImageSize () {
		if (_currentImageRect == null)
			_currentImageRect = new Rectangle(0, 0, 0, 0);
			
		if (!_parameters.exists("allowImageScaling") || (_parameters.exists("allowImageScaling") && _parameters.get("allowImageScaling") == "false")) {
			_currentImageRect.width = _asset.getChildByName("image").width;
			_currentImageRect.height = _asset.getChildByName("image").height;
		}
		else {
			if (!_parameters.exists("keepImageAspectRatio") || (_parameters.exists("keepImageAspectRatio") && _parameters.get("keepImageAspectRatio") == "true")) {
				var multiplier:Float = _currentRect.width / _originalImageSize.x;
				if (_originalImageSize.y * multiplier > _currentRect.height)
					multiplier =  _currentRect.height / _originalImageSize.y;
				
				_currentImageRect.width = _originalImageSize.x * multiplier;
				_currentImageRect.height = _originalImageSize.y * multiplier;
			}
			else {
				_currentImageRect.width = _currentRect.width;
				_currentImageRect.height = _currentRect.height;				
			}
		}
	}
}
