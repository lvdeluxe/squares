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
		var width:int = int(GameData.STAGE_WIDTH / 2);
		switch(GameData.STAGE_WIDTH){
			case 960:
				width = GameData.STAGE_WIDTH / 2;
				break;
			case 1024:
			case 2048:
				width = GameData.STAGE_WIDTH / 2;
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
		super(Localization.getString("CREDITS_ID"), width, height);
		this.onRemovedFromStage.add(onRemove);
		_backBtn = new GButton("btnBackground", Localization.getString("BACK_ID"), "Kubus36");
		_backBtn.transform.setPosition(0, int((_height / 2) - GSprite(_backBtn.getComponent(GSprite)).getBounds().height));
		_backBtn.onMouseClick.add(onClickBack);
		addChild(_backBtn);

		var lines:Array = Localization.getString("CREDITS_TXT_ID").split("\n");
		var yStart:Number = -(lines.length * 24 / 2 * GameData.RESOLUTION_FACTOR);
		for(var i:uint = 0 ; i < lines.length ; i++){
			var desc:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			var isTuneName:Boolean = lines[i].indexOf("- ") != -1;
			if(isTuneName)
				desc.textureAtlasId = "Kubus12";
			else
				desc.textureAtlasId = "Kubus24";
			desc.text = lines[i].toUpperCase();
			if(isTuneName)
				desc.tracking = -3;
			else
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
			yStart += 24 * GameData.RESOLUTION_FACTOR;
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
