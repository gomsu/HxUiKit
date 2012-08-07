package com.studfarm.hxuikit;

import nme.display.MovieClip;
import com.studfarm.hxuikit.HxUiKit;
import flash.events.Event;
import com.studfarm.hxuikit.components.HxButton;

class Main {	
	
	private var _main:MovieClip;
	private var _uikit:HxUiKit;
	//private var _testButton:HxButton;
	
	// constructor
	public function new() {
		_main = nme.Lib.current;
		_uikit = new HxUiKit(null, null);
		_uikit.getComponentById("TeppoButton").addEventListener(HxButton.CLICK, testSomething);
	}
	
	private function testSomething (evt:Event) {
		trace("teppo");
	}
	
	// entry point
	public static function main() {
		new Main();		
	}
}
