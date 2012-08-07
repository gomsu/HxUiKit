package com.studfarm.hxuikit;

import nme.display.MovieClip;
import com.studfarm.hxuikit.components.HxButton;
import com.studfarm.hxuikit.HxUiKit;
import flash.events.Event;

class Main {	
	
	private var _main:MovieClip;
	private var _uikit:HxUiKit;
	private var _testButton:HxButton;
	
	// constructor
	public function new() {
		_main = nme.Lib.current;
		_uikit = new HxUiKit(null, null);
		_testButton = new HxButton();
		_testButton.addEventListener(HxButton.CLICK, testSomething);
		_main.addChild(_testButton);
	}
	
	private function testSomething (evt:Event) {
		trace("teppo");
	}
	
	// entry point
	public static function main() {
		new Main();		
	}
}
