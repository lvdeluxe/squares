/**
 * Created by lvdeluxe on 14-04-07.
 */
package deluxe.ui {
import com.genome2d.node.GNode;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;

public class GameLostPopup extends PopupBase{

	private var _mainMenuBtn:GButton;
	private var _restartBtn:GButton;

	public function GameLostPopup() {
		super(Localization.getString("LEVEL_LOST_ID"));
		this.onRemovedFromStage.add(onRemove);
		_restartBtn = new GButton("btnBackground", Localization.getString("RESTART_ID"), "Kubus");
		_restartBtn.onMouseClick.add(onClickRestart);
		_restartBtn.transform.setPosition( (- _width / 2) + (_restartBtn.width / 2) + 30, (_height / 2) - _restartBtn.height);
		addChild(_restartBtn);

		_mainMenuBtn = new GButton("btnBackground", Localization.getString("MAIN_MENU_ID"), "Kubus");
		_mainMenuBtn.onMouseClick.add(onClickMain);
		_mainMenuBtn.transform.setPosition( (_width / 2) - (_restartBtn.width / 2) - 30, (_height / 2) - _restartBtn.height);
		addChild(_mainMenuBtn);
	}

	private function onClickRestart(sig:GNodeMouseSignal):void {
		GameSignals.RESTART_LEVEL.dispatch();
	}

	private function onClickMain(sig:GNodeMouseSignal):void {
		GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_GAME_LOST);
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_restartBtn.onMouseClick.remove(onClickRestart);
		_restartBtn.removeListeners();
		_mainMenuBtn.onMouseClick.remove(onClickMain);
		_mainMenuBtn.removeListeners();
	}
}
}
