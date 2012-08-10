package com.studfarm.hxuikit.components;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.Font;
import nme.Assets;
import nme.geom.Rectangle;
import nme.text.TextFormatAlign;

class HxLabel extends HxComponent {
	
	private var _labelWidth:Int;
	private var _labelHeight:Int;
	private var _tf:TextField;
	
	public function new (params:Dynamic) {
		super(params);
		init();
	}
	
	override public function init () {
		super.init();
		
		var font:Font = Assets.getFont(_parameters.get("labelFont"));
		var targetTF:TextFormat = new TextFormat(font.fontName);
		
		_tf = new TextField();
		_tf.name = "textfield";
		_tf.defaultTextFormat = targetTF;
		_tf.htmlText = "<font color=\"#" + _parameters.get("labelColor") + "\" size=\"" + _parameters.get("fontSize") + "\">" + _parameters.get("label") + "</font>";
		_tf.embedFonts = true;
		_tf.selectable = false;
		_tf.mouseEnabled = false;

		mouseEnabled = false;
		
		_asset.addChild(_tf);
	}
	
	override public function resize () {
		super.resize();
		
		var dft:TextFormat = _tf.defaultTextFormat;
		
		_tf.width = _tf.textWidth + 4;
		if (_tf.width > _currentRect.width)
			_tf.width = _currentRect.width;
			
		_tf.height = _tf.textHeight + 4;
		if (_tf.height > _currentRect.height)
			_tf.height = _currentRect.height;
				
		if (_parameters.exists("textAlignHorizontal")) {
			switch (_parameters.get("textAlignHorizontal")) {
				case "center":
					_tf.x = (_currentRect.width - _tf.width) / 2;
					dft.align =  TextFormatAlign.CENTER;
				case "left":
					_tf.x = 0;
					dft.align =  TextFormatAlign.LEFT;
				case "right":
					_tf.x = _currentRect.width - _tf.width;
					dft.align =  TextFormatAlign.RIGHT; 
				case "justify":
					_tf.width = _currentRect.width;
					dft.align =  TextFormatAlign.JUSTIFY;
			}
		}
		if (_parameters.exists("textAlignVertical")) {
			switch (_parameters.get("textAlignVertical")) {
				case "center":
					_tf.y = (_currentRect.height - _tf.height) / 2 - 1;	
				case "top":
					_tf.y = 0;
				case "bottom":
					_tf.y = _currentRect.height - _tf.height;
			}
		}
				
		_tf.defaultTextFormat = dft;
	}
}
