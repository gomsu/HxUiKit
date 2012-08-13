package com.studfarm.hxuikit.components;

import nme.display.Sprite;
import nme.geom.Point;
import nme.geom.Point;
import nme.geom.Rectangle;

import com.studfarm.hxuikit.HxUiKit;

class HxComponent extends Sprite {
	
	private var _originalCaps:Point;
	private var _originalRect:Rectangle;
	private var _currentRect:Rectangle;
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
			_originalRect = new Rectangle(_asset.x, _asset.y, _asset.width, _asset.height);
			_currentRect = new Rectangle(_originalRect.x, _originalRect.y, _originalRect.width, _originalRect.height);
			_originalCaps = new Point(_asset.width, _asset.height);
			var parent:HxComponent = getParent();
			if (parent != null)
				_originalCaps = new Point(parent.getOriginalDimensions().width, parent.getOriginalDimensions().height);
		}
	}
	
	public function resize() {
		var left:Float = 0;
		var right:Float = 0;
		var top:Float = 0;
		var bottom:Float = 0;
		var center:Float = 0;
		
		var parent:HxComponent = getParent();
		var caps:Point = new Point(nme.Lib.current.stage.stageWidth, nme.Lib.current.stage.stageHeight);

		var anchorLeftValue:Int = _parameters.exists("anchor_left") ? 0 : -1;
		var anchorRightValue:Int = _parameters.exists("anchor_right") && (!_parameters.exists("anchor_left") || _parameters.exists("stretch_horizontal")) ? 1 : -1;
		var anchorTopValue:Int = _parameters.exists("anchor_top") ? 0 : -1;
		var anchorBottomValue:Int = _parameters.exists("anchor_bottom") && (!_parameters.exists("anchor_top") || _parameters.exists("stretch_vertical")) ? 1 : -1;
		var anchors:Rectangle = new Rectangle(anchorLeftValue, anchorTopValue, anchorRightValue, anchorBottomValue);		
		var values:Array<Float>;
		
		if (parent != null)
			caps = new Point(parent.getCurrentDimensions().width, parent.getCurrentDimensions().height);
			
		left = calcPointPosOnLine(caps.x, _originalCaps.x, _originalRect.x, cast(anchors.x, Int));
		right = calcPointPosOnLine(caps.x, _originalCaps.x, _originalRect.x + _originalRect.width, cast(anchors.width, Int));
		values = calcMinMax(caps.x, _originalCaps.x, _originalRect.x, _originalRect.width, left, right, cast(anchors.x, Int), cast(anchors.width, Int), _parameters.exists("stretch_horizontal"), _parameters.exists("minWidth") ? Std.parseInt(_parameters.get("minWidth")) : -1);
		left = values[0];
		right = values[1];
		
		top = calcPointPosOnLine(caps.y, _originalCaps.y, _originalRect.y, cast(anchors.y, Int));
		bottom = calcPointPosOnLine(caps.y, _originalCaps.y, _originalRect.y + _originalRect.height, cast(anchors.height, Int));
		values = calcMinMax(caps.y, _originalCaps.y, _originalRect.y, _originalRect.height, top, bottom, cast(anchors.y, Int), cast(anchors.height, Int), _parameters.exists("stretch_vertical"), _parameters.exists("minHeight") ? Std.parseInt(_parameters.get("minHeight")) : -1);
		top = values[0];
		bottom = values[1];
		
		_currentRect = new Rectangle(left, top, right - left, bottom - top);
		trace(_currentRect.x + ", " + _currentRect.y + ", " + _currentRect.width + ", " + _currentRect.height);
		
		// Set new position
		_asset.x = _currentRect.x;
		_asset.y = _currentRect.y;
		
		// Set new size
		if (_asset.getChildByName("background") != null) {			
			_asset.getChildByName("background").width = _currentRect.width;
			_asset.getChildByName("background").height = _currentRect.height;
		}
	}
	
	private function calcMinMax (maxCap:Float, originalCap:Float, originalPos:Float, originalLength:Float, minVal:Float, maxVal:Float, minAnchor:Int, maxAnchor:Int, stretching:Bool = false, minLength:Float = -1) : Array<Float> {
		var newMaxVal:Float = maxVal;
		var newMinVal:Float = minVal;
		var center:Float = 0;
		
		if (minLength == -1)
			minLength = originalLength;
		
		if ((stretching && minLength > (maxVal - minVal)) || !stretching) {
			if (minAnchor == 0)			
				newMaxVal = minVal + minLength;
			else if (maxAnchor == 1)
				newMinVal = maxVal - minLength;
			else {
				center = calcPointPosOnLine(maxCap, originalCap, originalPos + (minLength / 2), -1);
				newMinVal = center - (minLength / 2);
				newMaxVal = center + (minLength / 2);
			}
		}

		return [newMinVal, newMaxVal];
	}
	
	private function calcPointPosOnLine (newCap:Float, originalCap:Float, originalValue:Float, anchorRef:Int) : Float {
		var newValue:Float = originalValue;
		
		if (anchorRef > -1) {
			var originalDistanceFromCap:Float = originalCap - originalValue;
			switch (anchorRef) {
				case 0:
					newValue = originalValue;
				case 1:
					newValue = newCap - originalDistanceFromCap;
			}
		}
		else {
			newValue = (newCap / originalCap) * originalValue;
		}
		
		return newValue;
	}
	
	public function getParameters () : Dynamic {
		return _parameters;
	}
	
	public function getOriginalDimensions () : Rectangle {
		return _originalRect;
	}
	
	public function getCurrentDimensions () : Rectangle {
		return _currentRect;
	}
	
	public function getParent () : HxComponent {
		if (_parameters.exists("parent"))
			return HxUiKit.getComponentById(_parameters.get("parent"))
		else
			return null;
	}
}
