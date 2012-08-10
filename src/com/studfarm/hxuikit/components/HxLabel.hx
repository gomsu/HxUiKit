package com.studfarm.hxuikit.components;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.Font;
import nme.Assets;
import nme.geom.Rectangle;

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
		
		_tf.x = 0;
		_tf.y = 0;	
		_tf.width = _currentRect.width;
		_tf.height = _currentRect.height;
	}
}
