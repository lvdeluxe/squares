/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-23
 * Time: 17:37
 * To change this template use File | Settings | File Templates.
 */
package {
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;

import deluxe.AdManager;
import deluxe.AssetsManager;
import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Level;
import deluxe.Localization;
import deluxe.SoundsManager;
import deluxe.squares.ScoreData;
import deluxe.squares.SquaresManager;
import deluxe.ui.GameHUD;
import deluxe.ui.GameLostPopup;
import deluxe.ui.GameWonPopup;
import deluxe.ui.LevelDescription;
import deluxe.ui.LevelSelection;
import deluxe.ui.MainMenu;
import deluxe.ui.OptionsMenu;
import deluxe.ui.PausePopup;
import deluxe.ui.tutorial.Tutorial;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import deluxe.gesture.GestureController;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.system.System;
import flash.utils.ByteArray;

import net.onthewings.stk.Flute;

[SWF(width='960', height='640', backgroundColor='#000000', frameRate='60')]
public class Main extends Sprite{

	[Embed(source="/assets/ui/splash.jpg")]
	private static const Splash:Class;

	private var _gestureController:GestureController;
	private var _squaresManager:SquaresManager;
	private var _genome:Genome2D;
	private var _mainMenu:MainMenu;
	private var _optionsMenu:OptionsMenu;
	private var _gameWonPopup:GameWonPopup;
	private var _gameLostPopup:GameLostPopup;
	private var _pausePopup:PausePopup;
	private var _levelSelection:LevelSelection;
	private var _levelDesc:LevelDescription;
	private var _tutorial:Tutorial;
	private var _gameHUD:GameHUD;
	private var _levels:Vector.<Level> = new Vector.<Level>();
	public static var CURRENT_LEVEL:Level;
	private var _unlockedLevels:Array = [];
	private var _levelStarted:Boolean = false;
	private var _levelId:uint = 0;
	private var _localData:SharedObject;

	DEPLOY::DEVICE{
		private var _adManager:AdManager;
	}

	private var _onAdExit:String;

	private var _splash:Bitmap;

	public function Main() {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addEventListener(Event.DEACTIVATE, deactivate);
		GameData.STAGE_HEIGHT = stage.fullScreenHeight;
		GameData.STAGE_WIDTH = stage.fullScreenWidth;
		setSplashScreen();
		GameData.MAX_PIXELS = GameData.STAGE_HEIGHT * GameData.STAGE_WIDTH;
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		getLevelData();
	}

	private function setSplashScreen():void {
		_splash = new Splash();
		addChild(_splash);
		_splash.x = -(_splash.width - GameData.STAGE_WIDTH) / 2;
		_splash.y = -(_splash.height - GameData.STAGE_HEIGHT) / 2;
	}

	private function getLevelData():void {
		_localData = SharedObject.getLocal("squared_data");

		var isNewUser:Boolean = true;
		for(var prop:String in _localData.data){
			SoundsManager.playLoops = _localData.data.playLoop;
			SoundsManager.playSfx = _localData.data.playSfx;
			_unlockedLevels = _localData.data.unlockedLevels;
			isNewUser = false;
		}
		if(isNewUser){
			_localData.data.unlockedLevels = [0];
			_localData.data.playLoop = true;
			_localData.data.playSfx = true;
			_localData.flush();
			_unlockedLevels = [0];
		}
		switch(Capabilities.language){
			case "fr":
				Localization.init(Localization.FRENCH);
				break;
			default:
				Localization.init(Localization.ENGLISH);
				break;
		}


		var config:GContextConfig = new GContextConfig(new Rectangle(0,0,GameData.STAGE_WIDTH,GameData.STAGE_HEIGHT), stage);
		GStats.visible = true;
		_genome = Genome2D.getInstance();
		_genome.onInitialized.addOnce(onContext);
		_genome.init(config);
	}

	private function onContext():void {
		parseLevels();
		DEPLOY::DEVICE{
			_adManager = new AdManager();
		}
		new AssetsManager();
		SoundsManager.init();
		GameSignals.GAME_START.add(onGameStart);
		GameSignals.GAME_PAUSE.add(onGamePause);
		GameSignals.LEVEL_SELECT.add(onLevelSelected);
		GameSignals.LEVEL_START.add(onLevelStart);
		GameSignals.MAIN_MENU.add(onMainMenu);
		GameSignals.GAME_OVER.add(onGameOver);
		GameSignals.NEXT_LEVEL.add(onNextLevel);
		GameSignals.RESTART_LEVEL.add(onRestartLevel);
		GameSignals.AD_COMPLETE.add(onAdComplete);
		GameSignals.OPTIONS_MENU.add(onOptionsMenu);
		GameSignals.CHANGE_LANG.add(onChangeLang);
		GameSignals.CHANGE_MUSIC.add(onChangeSound);
		GameSignals.CHANGE_SFX.add(onChangeSfx);
		GameSignals.BACK_TO_SELECT.add(onBackToSelect);
		GameSignals.TUTORIAL_COMPLETE.add(onTutorialComplete);
		_gameHUD = new GameHUD();
		_genome.root.addChild(_gameHUD);
		_gameHUD.setActive(false);
		_gestureController = new GestureController(stage);
		_squaresManager = new SquaresManager(_gameHUD);
		_mainMenu = new MainMenu();
		_mainMenu.startAnimation();
		_genome.root.addChild(_mainMenu);
		_genome.onPreRender.add(render);
		removeChild(_splash);
//		saveScore();
	}

	private function onTutorialComplete():void {
		_genome.root.removeChild(_tutorial);
		_tutorial = null;
	}


	private function onChangeSfx(playSfx:uint):void {
		_localData.data.playSfx = playSfx == 0;
		_localData.flush();
		SoundsManager.playSfx = playSfx == 0;
	}
	private function onChangeSound(playLoop:uint):void {
		_localData.data.playLoop = playLoop == 0;
		_localData.flush();
		SoundsManager.mute(playLoop == 1);
	}

	private function onChangeLang(lang:uint):void {
		switch(lang){
			case 0:
				Localization.init(Localization.FRENCH);
				break;
			case 1:
				Localization.init(Localization.ENGLISH);
				break;
		}
		GameSignals.LANG_CHANGED.dispatch();
	}

	private function onBackToSelect():void {
		_genome.root.removeChild(_levelDesc);
		_levelDesc = null;
		_levelSelection = new LevelSelection(_levels);
		_genome.root.addChild(_levelSelection);
	}
	private function onOptionsMenu():void {
		_genome.root.removeChild(_mainMenu);
		_mainMenu = null;
		_optionsMenu = new OptionsMenu();
		_genome.root.addChild(_optionsMenu);
	}

	private function onAdComplete(adClicked:Boolean):void{
		DEPLOY::DEVICE{
			switch(_onAdExit){
				case AdManager.NEXT_LEVEL:
				case AdManager.RESTART_LEVEL:
					onLevelSelected(_levelId, adClicked);
					break;
				case AdManager.MAIN_MENU:
					mainMenu();
					break;
			}
		}
	}

	private function startLevel():void{
		onLevelSelected(_levelId);
	}

	private function onRestartLevel():void{
		_genome.root.removeChild(_gameLostPopup);
		_gameLostPopup = null;
		_squaresManager.cleanup();
		_gestureController.cleanup();
		System.gc();
		DEPLOY::DEVICE{
			_onAdExit = AdManager.RESTART_LEVEL;
			_adManager.showInterstitial();
		}
		DEPLOY::EMUL{
			startLevel();
		}

	}

	private function onNextLevel():void{
		_genome.root.removeChild(_gameWonPopup);
		_gameWonPopup = null;
		_squaresManager.cleanup();
		_gestureController.cleanup();
		System.gc();
		DEPLOY::DEVICE{
			_onAdExit = AdManager.NEXT_LEVEL;
			_adManager.showInterstitial();
		}
		DEPLOY::EMUL{
			startLevel();
		}
	}

	private function saveLevelUnlocked():void{
		_levelId++;
		_levels[_levelId].unlocked = true;
		if(_unlockedLevels.indexOf(_levelId) == -1){
			_unlockedLevels.push(_levelId);
			_localData.data.unlockedLevels = _unlockedLevels;
			_localData.flush();
		}
	}

	private function onGameOver(success:Boolean, pScoreData:ScoreData = null):void{
		if(success){
			_gameWonPopup = new GameWonPopup(pScoreData);
			_genome.root.addChild(_gameWonPopup);
			saveLevelUnlocked();
			SoundsManager.playGameWonLoop();
			DEPLOY::DEVICE{
				saveScore(pScoreData);
			}
		}else{
			_gameLostPopup = new GameLostPopup();
			_genome.root.addChild(_gameLostPopup);
			SoundsManager.playGameLostLoop();
		}
		_squaresManager.setGameOverState();
		_gestureController.setGameOverState();
	}

	private function saveScore(pScoreData:ScoreData):void {
		var currentScore:uint = pScoreData.getTotalScore();
		var savedScores:File = File.documentsDirectory.resolvePath("scores.txt");
		var stream:FileStream = new FileStream();
		stream.open(savedScores, FileMode.UPDATE);
		var scores:Object;
		var id:String = CURRENT_LEVEL.levelIndex.toString();
		if(stream.bytesAvailable != 0){
			scores = stream.readObject();
			var scoreData:Object = scores[id];
			if(scoreData != null){
				if(scoreData.score < currentScore){
					scoreData.score = currentScore;
				}
			}else{
				scores[id] = {score:currentScore};
			}
		}else{
			scores = {};
			scores[id] = {score:currentScore};
		}
//		for(var prop:* in scores)
//			trace(prop, scores[prop].score);
		stream.position = 0;
		stream.truncate();
		stream.writeObject(scores);
		stream.close();
	}

	private function mainMenu():void{
		_mainMenu = new MainMenu();
		_genome.root.addChild(_mainMenu);
		SoundsManager.playMenuLoop();
	}

	private function onMainMenu(from:String):void{
		_levelStarted = false;
		switch(from){
			case GameData.MAIN_MENU_FROM_PAUSE:
				_genome.root.removeChild(_pausePopup);
				_pausePopup  = null;
				break;
			case GameData.MAIN_MENU_FROM_GAME_WON:
				_genome.root.removeChild(_gameWonPopup);
				_gameWonPopup = null;
				break;
			case GameData.MAIN_MENU_FROM_GAME_LOST:
				_genome.root.removeChild(_gameLostPopup);
				_gameLostPopup = null;
				break;
			case GameData.MAIN_MENU_FROM_OPTIONS:
				_genome.root.removeChild(_optionsMenu);
				_optionsMenu = null;
				break;
			case GameData.MAIN_MENU_FROM_SELECT:
				_genome.root.removeChild(_levelSelection);
				_levelSelection = null;
				break;
		}
		if(_gameHUD)
			_gameHUD.setActive(false);
		if(_squaresManager)
			_squaresManager.cleanup();
		if(_gestureController)
			_gestureController.cleanup();
		System.gc();
		DEPLOY::DEVICE{
			if(from == GameData.MAIN_MENU_FROM_OPTIONS || from == GameData.MAIN_MENU_FROM_SELECT){
				mainMenu();
			}else{
				_onAdExit = AdManager.MAIN_MENU;
				_adManager.showInterstitial();
			}
		}
		DEPLOY::EMUL{
			mainMenu();
		}
	}

	private function onLevelSelected(levelId:uint, adClicked:Boolean = false):void{
		_levelId = levelId;
		CURRENT_LEVEL = _levels[_levelId];
		if(_levelSelection)
			_genome.root.removeChild(_levelSelection);
		_levelSelection = null;
		if(CURRENT_LEVEL.description != ""){
			_levelDesc = new LevelDescription(CURRENT_LEVEL);
			_genome.root.addChild(_levelDesc);
		}else{
			onLevelStart();
			if(adClicked){
				GameSignals.GAME_PAUSE.dispatch(true);
			}
		}
		if(_gameHUD)
			_gameHUD.setActive(false);
		SoundsManager.playMenuLoop();
	}

	private function parseLevels():void {
		var levels:Object = JSON.parse(new AssetsManager.Levels());
		for(var i:uint = 0 ; i < levels.levels.length; i++){
			var level:Level = new Level();
			if(i < _unlockedLevels.length)
				level.unlocked = true;
			level.levelIndex = i;
			level.name = levels.levels[i].name;
			level.description = levels.levels[i].description;
			level.squaresSpeed = levels.levels[i].squaresSpeed;
			level.numSquaresSpawned = levels.levels[i].numSquaresSpawned;
			level.tickSpeed = levels.levels[i].tickSpeed;
			level.numSquaresToCatch = levels.levels[i].numSquaresToCatch;
			level.gestureExplosionSpeed = levels.levels[i].gestureExplosionSpeed;
			level.gestureExplosionSpeedMilli = level.gestureExplosionSpeed / 1000;
			level.squaresGameOver = levels.levels[i].squaresGameOver;
			_levels.push(level);
		}
	}

	private function onGamePause(paused:Boolean, showPopup:Boolean = true):void{
		if(paused){
			if(showPopup){
				_pausePopup = new PausePopup();
				_genome.root.addChild(_pausePopup);
			}
			_squaresManager.pause();
			_gestureController.pause();
		}else{
			if(showPopup){
				_genome.root.removeChild(_pausePopup);
				_pausePopup  = null;
			}
			_squaresManager.resume();
			_gestureController.resume();
		}
	}

	private function onGameStart():void{

		_genome.root.removeChild(_mainMenu);
		_mainMenu = null;
		_levelSelection = new LevelSelection(_levels);
		_genome.root.addChild(_levelSelection);

	}


	private function onLevelStart():void{
		DEPLOY::DEVICE{
			_adManager.prepareInterstitial();
		}
		if(_levelDesc){
			_genome.root.removeChild(_levelDesc);
			_levelDesc = null;
		}else if(_levelSelection){
			_genome.root.removeChild(_levelSelection);
			_levelSelection = null;
		}

		_levelStarted = true;
		_gameHUD.setActive(true);
		_squaresManager.startLevel();
		_gestureController.startLevel();

		if(CURRENT_LEVEL.levelIndex == 0){
			_tutorial = new Tutorial();
			_genome.root.addChild(_tutorial);
		}

		SoundsManager.playGamePlayLoop();
	}

	private function render():void {
		if(_squaresManager && _levelStarted)
			_squaresManager.update();
	}

	private function deactivate(e:Event):void
	{
		// make sure the app behaves well (or exits) when in background
		//NativeApplication.nativeApplication.exit();
	}
}
}
