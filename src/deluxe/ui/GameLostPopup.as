/**
 * Created by lvdeluxe on 14-04-07.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;
import deluxe.Utils;
import deluxe.squares.ScoreData;

public class GameLostPopup extends PopupBase{

	private var _mainMenuBtn:GButton;
	private var _restartBtn:GButton;
	private var _time:GTextureText;
	private var _squares:GTextureText;
	private var _msg:GTextureText;

	public function GameLostPopup(pScoreData:ScoreData) {
		var width:int = int(GameData.STAGE_WIDTH / 2);
		switch(GameData.STAGE_WIDTH){
			case 960:
				width = GameData.STAGE_WIDTH * 4 / 7;
				break;
			case 1024:
			case 2048:
				width = GameData.STAGE_WIDTH * 4 / 7;
				break;
		}
		var height:int = -1;
		switch(GameData.STAGE_WIDTH){
			case 960:
				height = -1;
				break;
			case 1024:
			case 2048:
				height = GameData.STAGE_HEIGHT / 2;
				break;
		}
		super(Localization.getString("LEVEL_LOST_ID"),width, height);
		this.onRemovedFromStage.add(onRemove);
		_restartBtn = new GButton("btnBackground", Localization.getString("RESTART_ID"), "Kubus36");
		_restartBtn.onMouseClick.add(onClickRestart);
		_restartBtn.transform.setPosition( (_width / 2) - (_restartBtn.width / 2) - (30 * GameData.RESOLUTION_FACTOR), (_height / 2) - _restartBtn.height);
		addChild(_restartBtn);

		_mainMenuBtn = new GButton("btnBackground", Localization.getString("MAIN_MENU_ID"), "Kubus36");
		_mainMenuBtn.onMouseClick.add(onClickMain);
		_mainMenuBtn.transform.setPosition( (-_width / 2) + (_mainMenuBtn.width / 2) + (30 * GameData.RESOLUTION_FACTOR), (_height / 2) - _mainMenuBtn.height);
		addChild(_mainMenuBtn);

		var bar:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		bar.textureId = "popup_bg_side";
		bar.node.transform.scaleX = _width / 2 / bar.getBounds().width ;
		bar.node.transform.setPosition(0,0);
		addChild(bar.node);

		_time = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_time.textureAtlasId = "Kubus24";
		_time.text = Localization.getString("TIME_ID") + " : " + Utils.milliSecondsToTime(pScoreData.time);
		_time.align = GTextureTextAlignType.MIDDLE;
		_time.node.transform.setPosition(0, int(-(_height / 2 / 3.5)));
		if(_time.width % 2 != 0){
			_time.node.transform.x += 0.5;
		}
		if(_time.height % 2 != 0){
			_time.node.transform.y += 0.5;
		}
		addChild(_time.node);

		_squares = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_squares.textureAtlasId = "Kubus24";
		_squares.text = Localization.getString("DESTROYED_ID") + " : " + pScoreData.destroyed.toString() + "/" + Main.CURRENT_LEVEL.numSquaresToCatch;
		_squares.align = GTextureTextAlignType.MIDDLE;
		_squares.node.transform.setPosition(0, int(-(_height / 2 / 7.5)));
		if(_squares.width % 2 != 0){
			_squares.node.transform.x += 0.5;
		}
		if(_squares.height % 2 != 0){
			_squares.node.transform.y += 0.5;
		}
		addChild(_squares.node);

		_msg = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_msg.textureAtlasId = "Kubus24";
		_msg.text = Localization.getString("FAILED_ID");
		_msg.align = GTextureTextAlignType.MIDDLE;
		_msg.node.transform.setPosition(0, int(_height / 2 / 7.5));
		if(_msg.width % 2 != 0){
			_msg.node.transform.x += 0.5;
		}
		if(_msg.height % 2 != 0){
			_msg.node.transform.y += 0.5;
		}
		addChild(_msg.node);
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
