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

public class MainMenu extends ScreenBase{

	private var _logo:GSprite;
	private var _header:GSprite;
	private var _btnStart:GButton;
	private var _btnOptions:GButton;

	public function MainMenu() {

		super("");

		this.onRemovedFromStage.add(onRemove);

		_logo = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_logo.textureId = "logo";
		_logo.node.transform.setPosition(GameData.STAGE_WIDTH / 2, _logo.getBounds().height / 2 + 110);
		addChild(_logo.node);

		_btnStart = new GButton("btnBackground", Localization.getString("PLAY_ID"), "Kubus");
		_btnStart.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(_logo.getBounds().height / 2 + 270));
		_btnStart.onMouseClick.add(onClickStart);
		addChild(_btnStart);

		_btnOptions = new GButton("btnBackground", Localization.getString("OPTIONS_ID"),  "Kubus");
		_btnOptions.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(_logo.getBounds().height / 2 + 370));
		_btnOptions.onMouseClick.add(onClickOptions);
		addChild(_btnOptions);

		_header = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_header.textureId = Localization.CURENT_LANG == Localization.ENGLISH ? "header_en" : "header_fr";
		_header.node.transform.setPosition(int(GameData.STAGE_WIDTH / 2),int( GameData.STAGE_HEIGHT - _header.getBounds().height));
		addChild(_header.node);
	}

	public function startAnimation():void {
		_logo.node.transform.setPosition(GameData.STAGE_WIDTH / 2, GameData.STAGE_HEIGHT / 2);
		_btnStart.transform.alpha = 0;
		_btnOptions.transform.alpha = 0;
		Tweener.addTween(_logo.node.transform, {time:1, transition:"easeoutquad", y:_logo.getBounds().height / 2 + 110});
		Tweener.addTween(_btnStart.transform, {time:0.3, transition:"easeoutquad", alpha:1, delay:0.7});
		Tweener.addTween(_btnOptions.transform, {time:0.3, transition:"easeoutquad", alpha:1, delay:1});
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_btnOptions.onMouseClick.remove(onClickOptions);
		_btnOptions.removeListeners();
		_btnStart.onMouseClick.remove(onClickStart);
		_btnStart.removeListeners();
	}

	private function onClickOptions(sig:GNodeMouseSignal):void {
		GameSignals.OPTIONS_MENU.dispatch();
	}
	private function onClickStart(sig:GNodeMouseSignal):void {
		GameSignals.GAME_START.dispatch();
	}
}
}
