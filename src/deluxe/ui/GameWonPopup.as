/**
 * Created by lvdeluxe on 14-04-07.
 */
package deluxe.ui {
import caurina.transitions.Tweener;

import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;
import deluxe.Utils;
import deluxe.squares.ScoreData;

import flash.geom.Point;
import flash.utils.setTimeout;

public class GameWonPopup extends PopupBase{

	public static const DEFAULT:String = "default";
	public static const ACHIEVEMENT:String = "achievement";
	public static const HIGH_SCORE:String = "highScore";

	private var _achievementsBtn:GButton;
	private var _leaderboardBtn:GButton;
	private var _mainMenuBtn:GButton;
	private var _nextLevelBtn:GButton;
	private var _scoreContainer:GNode;
	private var _time:GTextureText;
	private var _squares:GTextureText;
	private var _combos:GTextureText;
	private var _perfects:GTextureText;
	private var _tweenComplete:Boolean = false;
	private var _isLastLevel:Boolean = false;
	private var _type:String;

	//UI stuff
	private var _btnPosition:Point;

	public function GameWonPopup(pScoreData:ScoreData, pType:String) {
		_type = pType;
		super(Localization.getString(getTitle()), getWidth(), getHeight());
		_isLastLevel = Main.CURRENT_LEVEL.levelIndex >= GameData.NUM_LEVELS - 1;
		if(pType == DEFAULT){
			_btnPosition =  new Point(_width / 4, (_height / 2));
			setDefaultLayout(pScoreData);
		}else if(pType == HIGH_SCORE){
			_btnPosition =  new Point(_width / 3, (_height / 2));
			setHighScoreLayout(pScoreData);
		}else if(pType == ACHIEVEMENT){
			_btnPosition = new Point(_width / 3, (_height / 2));
			setAchievementLayout(pScoreData);
		}
		this.onRemovedFromStage.add(onRemove);
	}

	private function getHeight():int {
		switch(_type){
			default:
			case DEFAULT:
				switch(GameData.STAGE_WIDTH){
					case 960:
						return -1;
						break;
					case 1024:
					case 2048:
						return GameData.STAGE_HEIGHT / 2;
						break;
				}
				return -1;
				break;
			case HIGH_SCORE:
				switch(GameData.STAGE_WIDTH){
					case 960:
						return GameData.STAGE_HEIGHT * 3 / 4;
						break;
					case 1024:
					case 2048:
						return GameData.STAGE_HEIGHT * 2 / 3;
						break;
				}
				return uint(GameData.STAGE_HEIGHT * 3 / 4);
				break;
			case ACHIEVEMENT:
				switch(GameData.STAGE_WIDTH){
					case 960:
						return GameData.STAGE_HEIGHT * 4 / 5;
						break;
					case 1024:
					case 2048:
						return GameData.STAGE_HEIGHT * 2 / 3;
						break;
				}
				return uint(GameData.STAGE_HEIGHT * 4 / 5);
				break;
		}
	}

	private function getWidth():int {
		switch(_type){
			default:
			case DEFAULT:
				switch(GameData.STAGE_WIDTH){
					case 960:
						return GameData.STAGE_WIDTH * 2 / 3;
						break;
					case 1024:
					case 2048:
						return GameData.STAGE_WIDTH / 2;
						break;
				}
				return -1;
				break;
			case HIGH_SCORE:
				switch(GameData.STAGE_WIDTH){
					case 960:
						return GameData.STAGE_WIDTH * 4 / 5;
						break;
					case 1024:
					case 2048:
						return GameData.STAGE_WIDTH * 4 / 5;
						break;
				}
				return uint(GameData.STAGE_WIDTH * 2 / 3);
				break;
			case ACHIEVEMENT:
				switch(GameData.STAGE_WIDTH){
					case 960:
						return GameData.STAGE_WIDTH * 4 / 5;
						break;
					case 1024:
					case 2048:
						return GameData.STAGE_WIDTH * 4 / 5;
						break;
				}
				return uint(GameData.STAGE_WIDTH * 3 / 4);
				break;
		}
	}

	private function getTitle():String{
		switch(_type){
			default:
			case DEFAULT:
				return "LEVEL_WON_ID";
				break;
			case HIGH_SCORE:
				return "LEVEL_WON_HIGHSCORE_ID";
				break;
			case ACHIEVEMENT:
				return "LEVEL_WON_ACHIEVEMENT_ID";
				break;
		}
	}

	private function setAchievementLayout(pScoreData:ScoreData):void{
		setDefaultLayout(pScoreData);
		_achievementsBtn = new GButton("btnBackground", Localization.getString("ACHIEVEMENTS_BTN_ID"), "Kubus24",-1);
		_achievementsBtn.onMouseClick.add(onClickAchievements);
		_achievementsBtn.transform.setPosition( _isLastLevel ? _btnPosition.x : 0, (_height / 2) - _achievementsBtn.height);
		addChild(_achievementsBtn);
	}

	private function setHighScoreLayout(pScoreData:ScoreData):void{
		setDefaultLayout(pScoreData);
		_leaderboardBtn = new GButton("btnBackground", Localization.getString("LEADERBOARD_ID"), "Kubus24",-1);
		_leaderboardBtn.onMouseClick.add(onClickLeaderboard);
		_leaderboardBtn.transform.setPosition( _isLastLevel ? _btnPosition.x : 0, (_height / 2) - _leaderboardBtn.height);
		addChild(_leaderboardBtn);
	}

	private function setDefaultLayout(pScoreData:ScoreData):void{
		if(!_isLastLevel){
			_nextLevelBtn = new GButton("btnBackground", Localization.getString("NEXT_ID"), "Kubus36");
			_nextLevelBtn.onMouseClick.add(onClickNext);
			_nextLevelBtn.transform.setPosition( _btnPosition.x, _btnPosition.y - _nextLevelBtn.height);
			addChild(_nextLevelBtn);
		}

		var xPos:Number = _isLastLevel ? (_type == DEFAULT ? 0 : -_btnPosition.x) : -_btnPosition.x;

		_mainMenuBtn = new GButton("btnBackground", Localization.getString("MAIN_MENU_ID"), "Kubus36");
		_mainMenuBtn.onMouseClick.add(onClickMain);
		_mainMenuBtn.transform.setPosition( xPos, _btnPosition.y - _mainMenuBtn.height);
		addChild(_mainMenuBtn);

		var bar:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		bar.textureId = "popup_bg_side";
		bar.node.transform.scaleX = (_width * 2 / 3) / bar.getBounds().width ;
		bar.node.transform.setPosition(0,20 * GameData.RESOLUTION_FACTOR);
		addChild(bar.node);

		_scoreContainer = GNodeFactory.createNode("container");
		_scoreContainer.transform.setPosition(0, 60 * GameData.RESOLUTION_FACTOR);
		_scoreContainer.transform.setScale(0, 0);
		addChild(_scoreContainer);

		var score:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		score.textureAtlasId = "Kubus36";
		score.text = Localization.getString("SCORE_ID") + " = " + pScoreData.getTotalScore().toString();
		score.align = GTextureTextAlignType.MIDDLE;
		if(score.width % 2 != 0){
			score.node.transform.x += 0.5;
		}
		if(score.height % 2 != 0){
			score.node.transform.y += 0.5;
		}
		_scoreContainer.addChild(score.node);

		var pts:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		pts.textureAtlasId = "Kubus24";
		pts.text = Localization.getString("POINTS_ID");
		pts.align = GTextureTextAlignType.MIDDLE;
		pts.node.transform.setPosition((score.width / 2) + (pts.width / 2), (score.height / 2) - (pts.height / 2));
		if(pts.width % 2 != 0){
			pts.node.transform.x += 0.5;
		}
		if(pts.height % 2 != 0){
			pts.node.transform.y += 0.5;
		}
		_scoreContainer.addChild(pts.node);
		_scoreContainer.transform.x -= int(pts.width / 2);

		_time = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_time.textureAtlasId = "Kubus24";
		_time.text = Localization.getString("TIME_ID") + " : " + Utils.milliSecondsToTime(pScoreData.time);
		_time.align = GTextureTextAlignType.MIDDLE;
		_time.node.transform.setPosition(0, -105 * GameData.RESOLUTION_FACTOR);
		_time.node.transform.alpha = 0;
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
		_squares.node.transform.setPosition(0, -75 * GameData.RESOLUTION_FACTOR);
		_squares.node.transform.alpha = 0;
		if(_squares.width % 2 != 0){
			_squares.node.transform.x += 0.5;
		}
		if(_squares.height % 2 != 0){
			_squares.node.transform.y += 0.5;
		}
		addChild(_squares.node);

		_combos = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_combos.textureAtlasId = "Kubus24";
		_combos.text = Localization.getString("COMBOS_ID") + " : " + pScoreData.combos.toString();
		_combos.align = GTextureTextAlignType.MIDDLE;
		_combos.node.transform.setPosition(0, -45 * GameData.RESOLUTION_FACTOR);
		_combos.node.transform.alpha = 0;
		if(_combos.width % 2 != 0){
			_combos.node.transform.x += 0.5;
		}
		if(_combos.height % 2 != 0){
			_combos.node.transform.y += 0.5;
		}
		addChild(_combos.node);

		_perfects = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_perfects.textureAtlasId = "Kubus24";
		_perfects.text = Localization.getString("PERFECT_ID") + " : " + pScoreData.perfectCircles.toString();
		_perfects.align = GTextureTextAlignType.MIDDLE;
		_perfects.node.transform.setPosition(0, -15 * GameData.RESOLUTION_FACTOR);
		_perfects.node.transform.alpha = 0;
		if(_perfects.width % 2 != 0){
			_perfects.node.transform.x += 0.5;
		}
		if(_perfects.height % 2 != 0){
			_perfects.node.transform.y += 0.5;
		}
		addChild(_perfects.node);

		Tweener.addTween(_time.node.transform, {alpha:1, time:0.3, delay:0.3,transition:"easeoutquad"});
		Tweener.addTween(_squares.node.transform, {alpha:1, time:0.3, delay:0.6, transition:"easeoutquad"});
		Tweener.addTween(_combos.node.transform, {alpha:1, time:0.3, delay: 0.9, transition:"easeoutquad"});
		Tweener.addTween(_perfects.node.transform, {alpha:1, time:0.3, delay: 1.2, transition:"easeoutquad"});
		Tweener.addTween(_scoreContainer.transform, {scaleX:1, scaleY:1, time:0.5, delay: 1.5, transition:"easeoutbounce", onComplete:function():void{
			_tweenComplete = true;
		}});
	}

	private function onClickAchievements(sig:GNodeMouseSignal):void {
		if(_tweenComplete){
			GameSignals.SHOW_ACHIEVEMENTS.dispatch();
		}else{
			setTimeout(function():void{
				GameSignals.SHOW_ACHIEVEMENTS.dispatch();
			}, 1000);
			cancelTweens();
		}
	}

	private function onClickLeaderboard(sig:GNodeMouseSignal):void {
		if(_tweenComplete){
			GameSignals.SHOW_LEADERBOARD.dispatch(Main.CURRENT_LEVEL.levelIndex);
		}else{
			setTimeout(function():void{
				GameSignals.SHOW_LEADERBOARD.dispatch(Main.CURRENT_LEVEL.levelIndex);
			}, 1000);
			cancelTweens();
		}
	}

	private function onClickNext(sig:GNodeMouseSignal):void {
		if(_tweenComplete){
			GameSignals.NEXT_LEVEL.dispatch();
		}else{
			setTimeout(function():void{
				GameSignals.NEXT_LEVEL.dispatch();
			}, 1000);
			cancelTweens();
		}
	}

	private function onClickMain(sig:GNodeMouseSignal):void {
		if(_tweenComplete){
			GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_GAME_WON);
		}else{
			setTimeout(function():void{
				GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_GAME_WON);
			}, 1000);
		cancelTweens();
		}
	}

	private function cancelTweens():void{
		Tweener.removeAllTweens();
		_time.node.transform.alpha = 1;
		_squares.node.transform.alpha = 1;
		_combos.node.transform.alpha = 1;
		_scoreContainer.transform.setScale(1,1);
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		if(_nextLevelBtn){
			_nextLevelBtn.onMouseClick.remove(onClickNext);
			_nextLevelBtn.removeListeners();
		}
		_mainMenuBtn.onMouseClick.remove(onClickMain);
		_mainMenuBtn.removeListeners();
		if(_leaderboardBtn){
			_leaderboardBtn.onMouseClick.remove(onClickLeaderboard);
			_leaderboardBtn.removeListeners();
		}
		if(_achievementsBtn){
			_achievementsBtn.onMouseClick.remove(onClickAchievements);
			_achievementsBtn.removeListeners();
		}
	}

}
}
