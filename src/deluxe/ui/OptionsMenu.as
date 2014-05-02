/**
 * Created by lvdeluxe on 14-04-13.
 */
package deluxe.ui {
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;
import deluxe.SoundsManager;

public class OptionsMenu extends ScreenBase{

	private var _langGroup:GSelection;
	private var _musicGroup:GSelection;
	private var _sfxGroup:GSelection;
	private var _howToBtn:GButton;
	private var _mainMenuBtn:GButton;
	private var creditsBtn:GButton;

	public function OptionsMenu() {
		super(Localization.getString("OPTIONS_ID"));
		this.onRemovedFromStage.add(onRemove);
		GameSignals.LANG_CHANGED.add(onLangChanged);

		_langGroup = new GSelection("LANG_SELECT_ID", "FRENCH_ID", "ENGLISH_ID", Localization.CURENT_LANG == Localization.FRENCH ? 0 : 1, GameSignals.CHANGE_LANG);
		_langGroup.transform.setPosition(int(GameData.STAGE_WIDTH / 4),int(GameData.STAGE_HEIGHT / 3));
		addChild(_langGroup);

		_musicGroup = new GSelection("LOOP_SELECT_ID", "ON_ID", "OFF_ID", SoundsManager.playLoops ? 0 : 1, GameSignals.CHANGE_MUSIC);
		_musicGroup.transform.setPosition(int(GameData.STAGE_WIDTH / 2),int(GameData.STAGE_HEIGHT / 3));
		addChild(_musicGroup);

		_sfxGroup = new GSelection("SFX_SELECT_ID", "ON_ID", "OFF_ID", SoundsManager.playSfx ? 0 : 1, GameSignals.CHANGE_SFX);
		_sfxGroup.transform.setPosition(int(GameData.STAGE_WIDTH * 3 / 4),int(GameData.STAGE_HEIGHT / 3));
		addChild(_sfxGroup);

		_howToBtn = new GButton("btnBackgroundLarge", Localization.getString("HOW_TO_ID"), "Kubus24");
		_howToBtn.onMouseClick.add(onHowToClick);
		_howToBtn.transform.setPosition(int(GameData.STAGE_WIDTH * 0.25), int(GameData.STAGE_HEIGHT * 0.85));
		addChild(_howToBtn);

		_mainMenuBtn = new GButton("btnBackgroundLarge", Localization.getString("MAIN_MENU_ID"), "Kubus24");
		_mainMenuBtn.onMouseClick.add(onMainMenuClick);
		_mainMenuBtn.transform.setPosition(int(GameData.STAGE_WIDTH * 0.75), int(GameData.STAGE_HEIGHT * 0.85));
		addChild(_mainMenuBtn);

		creditsBtn = new GButton("btnBackgroundLarge", Localization.getString("CREDITS_ID"), "Kubus24");
		creditsBtn.onMouseClick.add(onCreditsClick);
		creditsBtn.transform.setPosition(int(GameData.STAGE_WIDTH * 0.5), int(GameData.STAGE_HEIGHT * 0.85));
		addChild(creditsBtn);
	}

	private function onCreditsClick(sig:GNodeMouseSignal):void{
		addChild(new CreditsPopup());
	}
	private function onMainMenuClick(sig:GNodeMouseSignal):void{
		GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_OPTIONS);
	}
	private function onHowToClick(sig:GNodeMouseSignal):void{
		addChild(new HowToPopup());
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_howToBtn.onMouseClick.remove(onHowToClick);
		_howToBtn.removeListeners();
		_mainMenuBtn.onMouseClick.remove(onMainMenuClick);
		_mainMenuBtn.removeListeners();
	}

	private function onLangChanged():void {
		super.setTitle(Localization.getString("OPTIONS_ID"));
		_langGroup.setTexts();
		_musicGroup.setTexts();
		_sfxGroup.setTexts();
		_howToBtn.setText(Localization.getString("HOW_TO_ID"));
		_mainMenuBtn.setText(Localization.getString("MAIN_MENU_ID"));
	}
}
}
