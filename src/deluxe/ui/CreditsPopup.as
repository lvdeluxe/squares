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

public class CreditsPopup extends PopupBase{

	private var _backBtn:GButton;

	public function CreditsPopup() {
		super(Localization.getString("CREDITS_ID"));
		this.onRemovedFromStage.add(onRemove);
		_backBtn = new GButton("btnBackground", Localization.getString("BACK_ID"), "Kubus");
		_backBtn.transform.setPosition(0, int((_height / 2) - GSprite(_backBtn.getComponent(GSprite)).getBounds().height));
		_backBtn.onMouseClick.add(onClickBack);
		addChild(_backBtn);

		var lines:Array = Localization.getString("CREDITS_TXT_ID").split("\n");
		var yStart:Number = -(lines.length * 24 / 2);
		for(var i:uint = 0 ; i < lines.length ; i++){
			var desc:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			desc.textureAtlasId = "Kubus24";
			desc.text = lines[i];
			desc.tracking = 0;
			desc.align = GTextureTextAlignType.MIDDLE;
			desc.node.transform.setPosition(0, yStart);
			addChild(desc.node);
			if(desc.width % 2 != 0){
				desc.node.transform.x += 0.5;
			}
			if(desc.height % 2 != 0){
				desc.node.transform.y += 0.5;
			}
			yStart += 24;
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
