package com.studfarm.hxuikit;

import nme.display.MovieClip;
import nme.events.Event;
import nme.display.StageScaleMode;
import nme.display.StageAlign;

import com.studfarm.hxuikit.HxUiKit;
import com.studfarm.hxuikit.components.HxButton;
import layout.MainLayout;
import nme.Assets;
import nme.display.Bitmap;
import com.studfarm.hxuikit.components.HxImage;

class Main {	
	
	private var _main:MovieClip;
	private var _uikit:HxUiKit;
	//private var _testButton:HxButton;
	
	// constructor
	public function new() {
		nme.Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		nme.Lib.current.stage.align = StageAlign.TOP_LEFT;
		
		_main = nme.Lib.current;
		_uikit = new HxUiKit(null, null);
				
		_uikit.storeLayout("MainLayout", new MainLayout());
		_uikit.build();
		_uikit.showLayout("MainLayout");
		
		//var test:Bitmap = new Bitmap(Assets.getBitmapData("assets/hxuikit/testimage.jpg"));
		var testImage:HxImage = cast(HxUiKit.getComponentById("TestImage"), HxImage);
		//testImage.setImageAsset(test);
		testImage.setImageUrl("http://bluesun.kapsi.fi/aw/hyperion.png");
		
		HxUiKit.getComponentById("TeppoButton").addEventListener(HxButton.CLICK, testSomething);
	}
	
	private function testSomething (evt:Event) {
		trace("teppo");
	}
	
	// entry point
	public static function main() {
		new Main();		
	}
}
