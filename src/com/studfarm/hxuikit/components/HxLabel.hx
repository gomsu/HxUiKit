package com.studfarm.hxuikit.components;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.Font;
import nme.Assets;

class HxLabel extends HxComponent {
	
	private var _labelWidth:Int;
	private var _labelHeight:Int;
	
	public function new (params:Dynamic) {
		super(params);
		init();
	}
	
	override public function init () {
		super.init();
		
		var font:Font = Assets.getFont(getParameters().get("labelFont"));
		var targetTextField:TextField = new TextField();
		var targetTF:TextFormat = new TextFormat(font.fontName);

		targetTextField.defaultTextFormat = targetTF;
		targetTextField.htmlText = "<font color=\"#" + getParameters().get("labelColor") + "\" size=\"" + getParameters().get("fontSize") + "\">" + getParameters().get("label") + "</font>";
		targetTextField.width = getParameters().get("width");
		targetTextField.height = getParameters().get("height");
		
		targetTextField.embedFonts = true;
		targetTextField.selectable = false;
		targetTextField.mouseEnabled = false;
		
		addChild(targetTextField);
		
		mouseEnabled = false;
	}
}
