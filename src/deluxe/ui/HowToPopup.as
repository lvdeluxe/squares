/**
 * Created by lvdeluxe on 14-04-14.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.Localization;

public class HowToPopup extends PopupBase{

	private var _backBtn:GButton;

	public function HowToPopup() {
		var width:int = -1;
		switch(GameData.STAGE_WIDTH){
			case 960:
				width = GameData.STAGE_WIDTH * 2 / 3;
				break;
			case 1024:
			case 2048:
				width = GameData.STAGE_WIDTH * 3 / 5;
				break;
		}
		var height:int = -1;
		switch(GameData.STAGE_WIDTH){
			case 960:
				height = -1;
				break;
			case 1024:
			case 2048:
				height = GameData.STAGE_HEIGHT * 5 / 9;
				break;
		}
		super(Localization.getString("HOW_TO_ID"), width, height);
		this.onRemovedFromStage.add(onRemove);
		_backBtn = new GButton("btnBackground", Localization.getString("BACK_ID"), "Kubus36");
		_backBtn.transform.setPosition(0, int((_height / 2) - GSprite(_backBtn.getComponent(GSprite)).getBounds().height));
		_backBtn.onMouseClick.add(onClickBack);
		addChild(_backBtn);

		var txt:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		txt.textureAtlasId = "Kubus24";
		txt.maxWidth = _width * 0.85;
		txt.text = Localization.getString("HOW_TO_DESC_ID");
		txt.align = GTextureTextAlignType.TOP_LEFT;
		txt.node.transform.setPosition(int(-txt.width / 2), int((-_height / 2) + (_titleHeight * 1.4)));
		addChild(txt.node);

		if(txt.width % 2 != 0){
			txt.node.transform.x += 0.5;
		}
		if(txt.height % 2 != 0){
			txt.node.transform.y += 0.5;
		}
	}

	private function onClickBack(sig:GNodeMouseSignal):void{
		this.parent.removeChild(this);
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_backBtn.removeListeners();
		_backBtn.onMouseClick.remove(onClickBack);
	}

}
}
