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
import nme.Assets;
import haxe.xml.Fast;

import com.studfarm.hxuikit.components.HxComponent;
import com.studfarm.hxuikit.components.HxButton;
import com.studfarm.hxuikit.components.HxContainer;

class HxUiKit {
	
	public static var DEFAULT_SKIN_FILE:String = "assets_hxuikit_skin_swf.swf";
	public static var DEFAULT_DEFINITION_FILE:String = "assets_hxuikit_ui_xml.xml";
	
	private static var _skin:MovieClip;
	private static var _layoutMap:Hash<DisplayObjectContainer>;
	private static var _layouts:Hash<Hash<Dynamic>>;
	private static var _componentMap:Hash<HxComponent>;
	private static var _templateMap:Hash<Hash<String>>;
	
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
		_componentMap = new Hash<HxComponent>();
		_layouts = new Hash<Hash<Dynamic>>();
		
		nme.Lib.current.stage.addEventListener(Event.RESIZE, onResize);
		
		loadDefinition();
	}

	public function build () {
		iterateComponentElement(_fastXml.node.ComponentTemplates, "", null);
		iterateLayoutElement(_fastXml.node.Layouts);
	}

	public function storeLayout (name:String, layout:DisplayObjectContainer) {
		 if (!_layouts.exists(name)) {			
		 	_layouts.set(name, new Hash<Dynamic>());
			_layouts.get(name).set("layoutskin", layout);
		 }
	}

	public function showLayout (name:String) {
		if (_layouts.exists(name) && (_layouts.get(name).exists("layoutskin"))) {			
			nme.Lib.current.addChild(_layouts.get(name).get("layoutskin"));
			_layouts.get(name).set("visible", true);
			onResize(new Event(Event.RESIZE));
		}
	}

	public static function getLayoutElementByName (layoutName:String, elementName:String) : Dynamic {
		var tree:Array<String> = elementName.split(".");
		var element:Dynamic = _layouts.get(layoutName).get("layoutskin").getChildByName(tree[0]);
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
		if (_componentMap.exists(id))
			return _componentMap.get(id);
		
		return null;
	}

	private function loadDefinition () : Void {
		 _definitionLoader = new URLLoader();
		 _definitionLoader.data = Assets.getBytes("assets/hxuikit/ui.xml");
		 onDefinitionLoaded(new Event(Event.COMPLETE));
	}
	
	private function onDefinitionLoaded (evt:Event) {		
		trace("UI definition loaded");
		var defData:Xml;
		defData = Xml.parse(_definitionLoader.data);
		_fastXml = new Fast(defData.firstElement());
		loadTheme();
	}
	
	private function iterateLayoutElement (element:Fast) {
		for (e in element.elements) {
			switch (e.name) {
				case "Layout":
					var layoutName:String = e.att.name;
					if (_layouts.exists(layoutName)) {
						_layouts.get(layoutName).set("components", new Array<HxComponent>());
						iterateComponentElement(e, layoutName);
					}
				default:
			}
		}
	}
	
	private function iterateComponentElement (element:Fast, layoutName:String, parentComponentId:String = null) {
		var properties:Hash<String>;
		
		for (e in element.elements) {
			switch (e.name) {
				case "Component":
					properties = new Hash<String>();
					var tmpProperties = getProperties(e);
					if (e.has.template) {
						var templateProperties:Hash<String> = _templateMap.get(e.att.template);
						for (prop in templateProperties.keys())
							properties.set(prop, templateProperties.get(prop));
						for (tmpProp in tmpProperties.keys())
							properties.set(tmpProp, tmpProperties.get(tmpProp));
					}
					else
						properties = getProperties(e);
						
					properties.set("layoutName", layoutName);
					properties.set("id", e.att.id);
					if (parentComponentId != null)
						properties.set("parent", parentComponentId);
					var cmp:HxComponent = Type.createInstance(Type.resolveClass(properties.get("type")), [properties]);
					_componentMap.set(properties.get("id"), cmp);
					_layouts.get(layoutName).get("components").push(cmp);
					var subComponentNode:Fast = getSubComponentNode(e);
					if (subComponentNode != null)
						iterateComponentElement(subComponentNode, layoutName, properties.get("id"));
				case "ComponentTemplate":
					properties = getProperties(e);
					if (_templateMap == null)
						_templateMap = new Hash<Hash<String>>();
					_templateMap.set(e.att.templateName, properties);
				default:
			}
		}
	}
	
	private function getSubComponentNode (element:Fast) : Fast {
		for (e in element.elements)
			if (e.name == "Components")
				return e;
				
		return null;
	}
	
	private function onResize (evt:Event) {
		for (layout in _layouts) {
			if (layout.exists("visible") && layout.get("visible") == true) {
				var components:Array<HxComponent> = layout.get("components");
				for (cmp in components) {
					cmp.resize();
				}
			}
		}
		
		trace("---------");
	}
	
	private function getProperties (element:Fast) : Hash<String> {
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
				case "Components":
				default:
					ret.set(e.name, e.innerData);					
			}			
		}
		
		return ret;
	}
	
	private function onDefinitionLoadError (evt:Event) {
		trace("UI definition load error");
	}	
	
	private function loadTheme () {
		_skinLoader = new Loader();
		_skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSkinLoaded);
		_skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onSkinLoadError);
		_skinLoader.load(new URLRequest(_skinFileName));
	}
	
	private function onSkinLoaded (evt:Event) {
		trace("UI skin loaded");
	}
	
	private function onSkinLoadError (evt:Event) {
		trace("UI skin load error");
	}
}
