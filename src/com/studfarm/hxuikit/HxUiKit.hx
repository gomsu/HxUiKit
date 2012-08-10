package com.studfarm.hxuikit;

import nme.display.Loader;
import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.net.URLRequest;
import nme.net.URLLoader;
import nme.errors.Error;
import nme.events.MouseEvent;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.MovieClip;
import nme.display.Stage;
import nme.geom.Point;
import haxe.xml.Fast;

import com.studfarm.hxuikit.components.HxComponent;
import com.studfarm.hxuikit.components.HxButton;
import com.studfarm.hxuikit.components.HxContainer;

class HxUiKit {
	
	public static var LOG_PREFIX:String = "HxUiKit: ";
	public static var DEFAULT_SKIN_FILE:String = "assets_hxuikit_skin_swf.swf";
	public static var DEFAULT_DEFINITION_FILE:String = "assets_hxuikit_ui_xml.xml";
	
	private static var _skin:MovieClip;
	private static var _layoutMap:Hash<DisplayObjectContainer>;
	private static var _layoutPropertyMap:Hash<Hash<Dynamic>>;
	private static var _components:Array<HxComponent>;
	
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
		_components = new Array<HxComponent>();
		
		loadDefinition();
	}

	public function build () {
		iterateElement(_fastXml);
	}

	public function storeLayout (name:String, layout:DisplayObjectContainer) {
		if (_layoutMap == null)
			_layoutMap = new Hash<DisplayObjectContainer>();
		if (_layoutPropertyMap == null)
			_layoutPropertyMap = new Hash<Hash<Dynamic>>();
		
		var propertyMap:Hash<Dynamic> = new Hash<Dynamic>();
		propertyMap.set("dimensions", new Point(layout.width, layout.height));
		_layoutPropertyMap.set(name, propertyMap);
		_layoutMap.set(name, layout);	
	}

	public function showLayout (name:String) {
		nme.Lib.current.addChild(_layoutMap.get(name));
	}

	public static function getLayoutPropertiesByName (name:String) : Hash<Dynamic> {
		return _layoutPropertyMap.get(name);
	}

	public static function getLayoutElementByName (name:String) : Dynamic {
		
		var tree:Array<String> = name.split(".");
		var element:Dynamic = _layoutMap.get(tree[0]);
		var tmpElement:Dynamic;
		
		tree.shift();
		
		for (s in tree) {
			if (Std.is(element, DisplayObjectContainer)) {
				tmpElement = element.getChildByName(s);
				element = tmpElement;
			}
			else
				break;
		}
		
		return element;
	}

	public static function getComponentById (id:String) : HxComponent {
		for (component in _components) {
			if (component.getParameters().get("id") == id)
				return component; 
		}
		
		return null;
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
		
		loadTheme();
	}
	
	private function iterateElement (element:Fast) {
		for (e in element.elements) {
			switch (e.name) {
				case "Component":
					var properties = getProperties(e);
					var cmp:HxComponent = Type.createInstance(Type.resolveClass(properties.get("type")), [properties]);
					_components.push(cmp);
			}
		}
		
		onResize(new Event(Event.RESIZE));		
		nme.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
	}
	
	private function onResize (evt:Event) {
		for (cmp in _components) {
			cmp.resize();
		}
		trace("---------");
	}
	
	private function getProperties (element:Fast) : Dynamic {
		var ret = new Hash<String>();
		
		for (e in element.elements) {
			switch (e.name) {
				case "anchor":
					var anchors:Array<String> = e.innerData.split(",");
					for (a in anchors)						
						ret.set("anchor_" + a, "true");
				case "stretch":
					var stretches:Array<String> = e.innerData.split(",");
					for (s in stretches)
						ret.set("stretch_" + s, "true");
				default:
					ret.set(e.name, e.innerData);					
			}
			
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
