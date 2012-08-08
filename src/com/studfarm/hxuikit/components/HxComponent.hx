package com.studfarm.hxuikit.components;

import nme.display.Sprite;
import nme.geom.Point;
import com.studfarm.hxuikit.HxUiKit;

class HxComponent extends Sprite {
	
	// 0..1
	private var _originalPosition:Point;
	// 0..N
	private var _originalCoordinates:Point;
	private var _originalDimensions:Point;
	private var _currentPosition:Point;
	private var _currentDimensions:Point;
	private var _parameters:Dynamic;
	private var _asset:Dynamic;
	
	public function new (params:Dynamic) {
		super();
		_parameters = params;
	}
	
	public function init () {
		if (_parameters.exists("target")) {
			_asset = HxUiKit.getLayoutElementByName(_parameters.get("target"));
			_asset.stop();
			var posx:Float = _asset.x / _asset.parent.width;
			var posy:Float = _asset.y / _asset.parent.height;
			
			_originalPosition = new Point(posx, posy);
			_originalCoordinates = new Point(_asset.x, _asset.y);
			_originalDimensions = new Point(_asset.width, _asset.height);
			_currentPosition = _originalPosition;
			_currentDimensions = _originalDimensions;
		}
	}
	
	public function resize() {
		//trace("resize: " + _parameters.get("id"));
		var left:Float = 0;
		var right:Float = 0;
		var top:Float = 0;
		var bottom:Float = 0;
		var layoutOrigDimensions:Point = HxUiKit.getLayoutPropertiesByName(_parameters.get("target").split(".")[0]).get("dimensions");
		var parent:HxComponent = getParent();
		
		// TODO: Unsafe!
		if (parent == null)
			parent = this;
		
		// Left
		if (_parameters.exists("anchor_left"))
			left = _originalCoordinates.x;
			if (!_parameters.exists("stretch_horizontal"))
				right = left + _originalDimensions.x;			
		else
			left = _asset.parent.width * _originalPosition.x;
		
		
		// Right
		if (_parameters.exists("anchor_right")) {
			var parentCurrentWidth = parent.getCurrentDimensions().x;
			
			if (parent == this)
				parentCurrentWidth = nme.Lib.current.stage.stageWidth;
				
			right = parentCurrentWidth - (parent.getOriginalDimensions().x - (_originalCoordinates.x + _originalDimensions.x));
			
			if (!_parameters.exists("stretch_horizontal"))
				left = right - _originalDimensions.x;
		}
		else if (!_parameters.exists("anchor_left"))
			right = _asset.parent.width * ((_originalCoordinates.x + _originalDimensions.x) / parent.getOriginalDimensions().x);
		
		
		// Top
		if (_parameters.exists("anchor_top")) {			
			top = _originalCoordinates.y;
			if (!_parameters.exists("stretch_vertical"))				
				bottom = top + _originalDimensions.y;
		}
		else
			top = _asset.parent.height * _originalPosition.y;	
		
		
		// Bottom
		if (_parameters.exists("anchor_bottom")) {			
			var parentCurrentHeight = parent.getCurrentDimensions().y;
			
			if (parent == this)
				parentCurrentHeight = nme.Lib.current.stage.stageHeight;
			
			bottom = parentCurrentHeight - (parent.getOriginalDimensions().y - (_originalCoordinates.y + _originalDimensions.y));
			
			if (!_parameters.exists("stretch_vertical"))
				top = bottom - _originalDimensions.y;			
		}
		else if (!_parameters.exists("anchor_top"))
			bottom = _asset.parent.height * ((_originalCoordinates.y + _originalDimensions.y) / parent.getOriginalDimensions().y);


			
		trace(left + ", " + right + ", " + top + ", " + bottom);
		
		_currentPosition = new Point(left, top);
		_currentDimensions = new Point(right - left, bottom - top);
		_asset.x = _currentPosition.x;
		_asset.y = _currentPosition.y;		
	}
	
	public function getParameters () : Dynamic {
		return _parameters;
	}
	
	public function getOriginalDimensions () : Point {
		return _originalDimensions;
	}
	
	public function getCurrentDimensions () : Point {
		return _currentDimensions;
	}
	
	public function getParent () : HxComponent {
		if (_parameters.exists("parent"))
			return HxUiKit.getComponentById(_parameters.get("parent"))
		else
			return null;
	}
}
