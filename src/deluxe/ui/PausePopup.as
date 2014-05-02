/**
 * Created by lvdeluxe on 14-03-29.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;

public class PausePopup  extends PopupBase{

	private var _btnResume:GButton;
	private var _btnBackToMain:GButton;

	public function PausePopup() {
		super("PAUSE");
		this.onRemovedFromStage.add(onRemove);

		_btnResume = new GButton("btnBackground", Localization.getString("RESUME_ID"), "Kubus");
		_btnResume.transform.setPosition(0, int((_height / 2) - GSprite(_btnResume.getComponent(GSprite)).getBounds().height));
		_btnResume.onMouseClick.add(onClickResume);
		addChild(_btnResume);

		_btnBackToMain = new GButton("btnBackground", Localization.getString("MAIN_MENU_ID"), "Kubus");
		_btnBackToMain.transform.setPosition(0, int(_btnResume.transform.y  -  GSprite(_btnResume.getComponent(GSprite)).getBounds().height * 1.3));
		_btnBackToMain.onMouseClick.add(onClickBack);
		addChild(_btnBackToMain);

	}

	private function onClickBack(sig:GNodeMouseSignal):void {
		GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_PAUSE);
	}
	private function onClickResume(sig:GNodeMouseSignal):void {
		GameSignals.GAME_PAUSE.dispatch(false);
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_btnResume.onMouseClick.remove(onClickResume);
		_btnResume.removeListeners();
		_btnBackToMain.onMouseClick.remove(onClickBack);
		_btnBackToMain.removeListeners();
	}
}
}
