package com.studfarm.hxuikit;

import flash.display.MovieClip;
import nme.display.Loader;
import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.net.URLRequest;
import nme.net.URLLoader;
import nme.errors.Error;
import nme.events.MouseEvent;

class HxUiKit {
	
	public static var LOG_PREFIX:String = "HxUiKit: ";
	public static var DEFAULT_SKIN_FILE:String = "assets_hxuikit_skin_swf.swf";
	public static var DEFAULT_DEFINITION_FILE:String = "assets_hxuikit_ui_xml.xml";
	
	private var _skin:MovieClip;
	private var _skinLoader:Loader;
	private var _skinFileName:String;
	private var _definitionLoader:URLLoader;
	private var _uiDefinitionName:String;
	
	public function new (uiDefinition:String, skinFile:String) {
		if (uiDefinition == null)
			uiDefinition = DEFAULT_DEFINITION_FILE;
		if (skinFile == null)
			skinFile = DEFAULT_SKIN_FILE;
		
		_uiDefinitionName = uiDefinition;
		_skinFileName = skinFile;
		
		loadDefinition();
	}
	
	private function onClick (evt:MouseEvent) : Void {
		trace("bällä");
	}
	
	private function loadDefinition () : Void {
		_definitionLoader = new URLLoader();
		_definitionLoader.addEventListener(Event.COMPLETE, onDefinitionLoaded);
		_definitionLoader.addEventListener(IOErrorEvent.IO_ERROR, onDefinitionLoadError);
		_definitionLoader.load(new URLRequest(_uiDefinitionName));
	}
	
	private function onDefinitionLoaded (evt:Event) {
		trace(LOG_PREFIX + "UI definition loaded");
		loadTheme();
	}
	
	private function onDefinitionLoadError (evt:Event) {
		trace(LOG_PREFIX + "UI definition load error");
	}	
	
	private function loadTheme () {
		_skinLoader = new Loader();
		_skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSkinLoaded);
		_skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onSkinLoadError);
		_skinLoader.load(new URLRequest(_skinFileName));
	}
	
	private function onSkinLoaded (evt:Event) {
		trace(LOG_PREFIX + "UI skin loaded");
	}
	
	private function onSkinLoadError (evt:Event) {
		trace(LOG_PREFIX + "UI skin load error");
	}
}
