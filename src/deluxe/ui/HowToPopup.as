/**
 * Created by lvdeluxe on 14-04-14.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.Localization;

public class HowToPopup extends PopupBase{

	private var _backBtn:GButton;

	public function HowToPopup() {
		super(Localization.getString("HOW_TO_ID"));
		this.onRemovedFromStage.add(onRemove);
		_backBtn = new GButton("btnBackground", Localization.getString("BACK_ID"), "Kubus");
		_backBtn.transform.setPosition(0, int((_height / 2) - GSprite(_backBtn.getComponent(GSprite)).getBounds().height));
		_backBtn.onMouseClick.add(onClickBack);
		addChild(_backBtn);

		var txt:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		txt.textureAtlasId = "Kubus24";
		txt.maxWidth = _width * 0.85;
		txt.text = Localization.getString("HOW_TO_DESC_ID");
		txt.align = GTextureTextAlignType.TOP_LEFT;
		txt.node.transform.setPosition(-txt.maxWidth / 2, _title.node.transform.y + (_title.height / 2));
		addChild(txt.node);
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
