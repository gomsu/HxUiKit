package com.studfarm.hxuikit;

import flash.display.MovieClip;
import nme.display.Loader;
import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.net.URLRequest;
import nme.net.URLLoader;
import nme.errors.Error;
import nme.events.MouseEvent;
import haxe.xml.Fast;

import com.studfarm.hxuikit.components.HxButton;
import flash.display.DisplayObject;

class HxUiKit {
	
	public static var LOG_PREFIX:String = "HxUiKit: ";
	public static var DEFAULT_SKIN_FILE:String = "assets_hxuikit_skin_swf.swf";
	public static var DEFAULT_DEFINITION_FILE:String = "assets_hxuikit_ui_xml.xml";
	
	private var _skin:MovieClip;
	private var _skinLoader:Loader;
	private var _skinFileName:String;
	private var _definitionLoader:URLLoader;
	private var _uiDefinitionName:String;
	private var _fastXml:Fast;
	
	public function new (uiDefinition:String, skinFile:String) {
		if (uiDefinition == null)
			uiDefinition = DEFAULT_DEFINITION_FILE;
		if (skinFile == null)
			skinFile = DEFAULT_SKIN_FILE;
		
		_uiDefinitionName = uiDefinition;
		_skinFileName = skinFile;
		
		loadDefinition();
	}

	private function loadDefinition () : Void {
		_definitionLoader = new URLLoader();
		_definitionLoader.addEventListener(Event.COMPLETE, onDefinitionLoaded);
		_definitionLoader.addEventListener(IOErrorEvent.IO_ERROR, onDefinitionLoadError);
		_definitionLoader.load(new URLRequest(_uiDefinitionName));
	}
	
	private function onDefinitionLoaded (evt:Event) {
		trace(LOG_PREFIX + "UI definition loaded");
		
		var xml:Dynamic = Xml.parse(_definitionLoader.data);
		_fastXml = new Fast(xml.firstElement());
		iterateElement(_fastXml);

		loadTheme();
	}
	
	private function iterateElement (element:Fast) {
		for (e in element.elements) {
			switch (e.name) {
				case "Component":
					var properties = getProperties(e);
					var cmp:DisplayObject = Type.createInstance(Type.resolveClass(properties.get("type")), [properties]);
					cmp.x = nme.Lib.current.stage.stageWidth * Std.parseFloat(properties.get("x"));
					cmp.y = nme.Lib.current.stage.stageHeight * Std.parseFloat(properties.get("y"));
					nme.Lib.current.addChild(cmp);
			}
		}
	}
	
	private function getProperties (element:Fast) : Dynamic {
		var ret = new Hash<String>();
		
		for (e in element.elements) {
			trace(e.name + ":" + e.innerData);
			ret.set(e.name, e.innerData);
		}
		
		return ret;
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
