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
import deluxe.SoundsManager;

public class PausePopup  extends PopupBase{

	private var _btnResume:GButton;
	private var _btnBackToMain:GButton;
	private var _musicGroup:GSelection;
	private var _sfxGroup:GSelection;

	public function PausePopup() {
		var width:int = int(GameData.STAGE_WIDTH / 2);
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
		super("PAUSE", width, height);
		this.onRemovedFromStage.add(onRemove);

		_btnResume = new GButton("btnBackground", Localization.getString("RESUME_ID"), "Kubus36");
		_btnResume.transform.setPosition( (_width / 2) - (_btnResume.width / 2) - (30 * GameData.RESOLUTION_FACTOR), (_height / 2) - _btnResume.height);
		_btnResume.onMouseClick.add(onClickResume);
		addChild(_btnResume);

		_btnBackToMain = new GButton("btnBackground", Localization.getString("MAIN_MENU_ID"), "Kubus36");
		_btnBackToMain.transform.setPosition( (-_width / 2) + (_btnBackToMain.width / 2) + (30 * GameData.RESOLUTION_FACTOR), (_height / 2) - _btnBackToMain.height);
		_btnBackToMain.onMouseClick.add(onClickBack);
		addChild(_btnBackToMain);

		_musicGroup = new GSelection("LOOP_SELECT_ID", "ON_ID", "OFF_ID", SoundsManager.playLoops ? 0 : 1, GameSignals.UPDATE_MUSIC);
		_musicGroup.transform.setPosition(int(_btnBackToMain.transform.x),-(_width / 5));
		addChild(_musicGroup);

		_sfxGroup = new GSelection("SFX_SELECT_ID", "ON_ID", "OFF_ID", SoundsManager.playSfx ? 0 : 1, GameSignals.UPDATE_SFX);
		_sfxGroup.transform.setPosition(int(_btnResume.transform.x * 2 / 3),-(_width / 5));
		addChild(_sfxGroup);
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
