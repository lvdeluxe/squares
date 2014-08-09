/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-23
 * Time: 18:26
 * To change this template use File | Settings | File Templates.
 */
package deluxe.ui {
import caurina.transitions.Tweener;

import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureFactory;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;

import flash.display.BitmapData;
import flash.utils.setTimeout;

public class MainMenu extends ScreenBase{

	private var _logo:GSprite;
	private var _header:GSprite;
	private var _btnStart:GButton;
	private var _btnOptions:GButton;
	private var _btnLeaderboard:GButton;

	public function MainMenu() {

		super("");

		this.onRemovedFromStage.add(onRemove);

		_logo = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_logo.textureId = "logo";
		_logo.node.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(GameData.STAGE_HEIGHT * 0.2));
		addChild(_logo.node);

		_btnStart = new GButton("btnBackground", Localization.getString("PLAY_ID"), "Kubus36");
		_btnStart.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(GameData.STAGE_HEIGHT * 0.45));
		_btnStart.onMouseClick.add(onClickStart);
		addChild(_btnStart);

		_btnOptions = new GButton("btnBackground", Localization.getString("OPTIONS_ID"),  "Kubus36");
		_btnOptions.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(GameData.STAGE_HEIGHT * 0.58));
		_btnOptions.onMouseClick.add(onClickOptions);
		addChild(_btnOptions);

		_btnLeaderboard = new GButton("btnBackground", Localization.getString("LEADERBOARD_ID"),  "Kubus24");
		_btnLeaderboard.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(GameData.STAGE_HEIGHT * 0.71));
		_btnLeaderboard.onMouseClick.add(onClickLeaderboard);
		addChild(_btnLeaderboard);

		_header = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_header.textureId = Localization.CURENT_LANG == Localization.ENGLISH ? "header_en" : "header_fr";
		_header.node.transform.setPosition(int(GameData.STAGE_WIDTH / 2),int( GameData.STAGE_HEIGHT - _header.getBounds().height));
		addChild(_header.node);
	}

	public function startAnimation():void {
		_logo.node.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(GameData.STAGE_HEIGHT / 2));
		_btnStart.transform.alpha = 0;
		_btnOptions.transform.alpha = 0;
		_btnLeaderboard.transform.alpha = 0;
		Tweener.addTween(_logo.node.transform, {time:0.3, transition:"easeoutquad", y:int(GameData.STAGE_HEIGHT * 0.2), delay:1});
		Tweener.addTween(_btnStart.transform, {time:0.3, transition:"easeoutquad", alpha:1, delay:1.2});
		Tweener.addTween(_btnOptions.transform, {time:0.3, transition:"easeoutquad", alpha:1, delay:1.4});
		Tweener.addTween(_btnLeaderboard.transform, {time:0.3, transition:"easeoutquad", alpha:1, delay:1.6});
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_btnOptions.onMouseClick.remove(onClickOptions);
		_btnOptions.removeListeners();
		_btnStart.onMouseClick.remove(onClickStart);
		_btnStart.removeListeners();
		_btnLeaderboard.onMouseClick.remove(onClickLeaderboard);
		_btnLeaderboard.removeListeners();
	}

	private function onClickLeaderboard(sig:GNodeMouseSignal):void {
		GameSignals.SHOW_LEADERBOARD.dispatch();
	}
	private function onClickOptions(sig:GNodeMouseSignal):void {
		GameSignals.OPTIONS_MENU.dispatch();
	}
	private function onClickStart(sig:GNodeMouseSignal):void {
		GameSignals.GAME_START.dispatch();
	}
}
}
