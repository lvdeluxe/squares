/**
 * Created by lvdeluxe on 14-04-12.
 */
package deluxe {
import flash.utils.Dictionary;

public class Localization {

	public static var FRENCH:String = "french";
	public static var ENGLISH:String = "english";

	[Embed(source = "/assets/locales/fr.json", mimeType='application/octet-stream')]
	private static const French:Class;
	[Embed(source = "/assets/locales/en.json", mimeType='application/octet-stream')]
	private static const English:Class;
	private static var _strings:Dictionary = new Dictionary();
	public static var CURENT_LANG:String = FRENCH;

	public function Localization() {

	}

	public static function init(lang:String):void{
		CURENT_LANG = lang;
		setData();
	}

	private static function setData():void {
		var jsonStr:String;
		switch(CURENT_LANG){
			case ENGLISH:
				jsonStr = new English();
				break;
			case FRENCH:
				jsonStr = new French();
				break;
		}
		var json:Object = JSON.parse(jsonStr);
		parseObject(json.strings);

	}

	private static function parseObject(json:Object):void{
		for (var id:String in json){
			if(typeof(json[id]) == "string"){
				_strings[id] = json[id];
			}else if(typeof(json[id]) == "object"){
				parseObject(json[id]);
			}
		}
	}


	public static function getString(id:String, replace:Object = null):String{
		if(_strings[id] == undefined){
			return id;
		}
		var string:String = _strings[id];
		if(replace != null){
			var startReplace:int = string.indexOf("{");
			var endReplace:int = string.indexOf("}");
			for(var k:String in replace) {
				string = string.replace(new RegExp('{' + k + '}', 'g'), replace[k]);
			}
		}
		return string;
	}
}
}
