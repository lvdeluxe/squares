/**
 * Created by lvdeluxe on 14-04-13.
 */
package deluxe.ui {
import com.adobe.osflash.signals.Signal;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.Localization;
import deluxe.SoundsManager;

public class GSelection extends GNode{


	private var _checkBoxA:GCheckbox;
	private var _checkBoxB:GCheckbox;
	private var _signal:Signal;
	private var _title_txt:GTextureText;
	private var _titleId:String;
	private var _checkAtitleId:String;
	private var _checkBtitleId:String;

	public function GSelection(pTitleId:String, pCheckTitleAId:String, pCheckTitleBId:String, selected:uint, sig:Signal) {
		_signal = sig;
		_titleId = pTitleId;
		_checkAtitleId = pCheckTitleAId;
		_checkBtitleId = pCheckTitleBId;
		_title_txt = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_title_txt.textureAtlasId = "Kubus";
		_title_txt.text = Localization.getString(pTitleId);
		_title_txt.tracking = 0;
		_title_txt.align = GTextureTextAlignType.TOP_LEFT;
		addChild(_title_txt.node);

		_checkBoxA = new GCheckbox(Localization.getString(pCheckTitleAId), selected == 0);
//		_checkBoxA.transform.x = int(_checkBoxA.width * 1.5);
		_checkBoxA.transform.y = int(_title_txt.height + (_checkBoxA.height));
		addChild(_checkBoxA);

		_checkBoxB = new GCheckbox(Localization.getString(pCheckTitleBId), selected == 1);
//		_checkBoxB.transform.x = int(_checkBoxB.width * 1.5);
		_checkBoxB.transform.y = int(_checkBoxA.transform.y + (_checkBoxA.height * 1.5));
		addChild(_checkBoxB);

		_title_txt.node.transform.x -= _checkBoxB.width;

		mouseEnabled = true;
		mouseChildren = true;
		onMouseClick.add(onClickLang);
	}

	private function onClickLang(sig:GNodeMouseSignal):void {
		if(sig.dispatcher == _checkBoxA.dispatcher){
			if(!_checkBoxA.isSelected()){
				_checkBoxA.setSelected(true);
				_checkBoxB.setSelected(false);
				_signal.dispatch(0);
				SoundsManager.playClickSfx();
			}
		}else if(sig.dispatcher == _checkBoxB.dispatcher){
			if(!_checkBoxB.isSelected()){
				_checkBoxA.setSelected(false);
				_checkBoxB.setSelected(true);
				_signal.dispatch(1);
				SoundsManager.playClickSfx();
			}
		}
	}

	public function setTexts():void {
		_title_txt.text = Localization.getString(_titleId);
		_checkBoxA.setText(Localization.getString(_checkAtitleId));
		_checkBoxB.setText(Localization.getString(_checkBtitleId));
	}
}
}
