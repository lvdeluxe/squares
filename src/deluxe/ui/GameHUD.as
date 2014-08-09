/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-24
 * Time: 20:22
 * To change this template use File | Settings | File Templates.
 */
package deluxe.ui {
import caurina.transitions.Tweener;

import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;
import deluxe.SoundsManager;
import deluxe.Utils;
import deluxe.particles.hd.HDBonusParticles;
import deluxe.particles.sd.SDBonusParticles;
import deluxe.squares.ScoreData;

import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class GameHUD extends GNode{

	private var _timerTf:GTextureText;
	private var _prctTf:GTextureText;
	private var _numSquaresTf:GTextureText;
	private var _perfectTf:GTextureText;
	private var _comboTf:GTextureText;
	private var _pauseBtn:GNode;

	private var _perfectTimeout:int = -1;
	private var _comboTimeout:int = -1;

	private var _bonusParticleClass:Class;

	public function GameHUD() {

		if(GameData.STAGE_WIDTH == 2048)
			_bonusParticleClass = HDBonusParticles;
		else
			_bonusParticleClass = SDBonusParticles;

		GameSignals.COMBO_UPDATE.add(onComboUpdate);
		GameSignals.GAME_OVER.add(onGameOver);
		GameSignals.COMBO_BROKEN.add(onComboBroken);
		GameSignals.PERFECT_CIRCLE.add(onPerfectCircle);
		GameSignals.TUT_STEP_1_START.add(OnTutorialStart);
		GameSignals.TUTORIAL_COMPLETE.add(onTutorialComplete);

		_timerTf = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_timerTf.textureAtlasId = "Kubus36Stroke";
		_timerTf.text = "0:45.123";
		_timerTf.tracking = 0;
		_timerTf.align = GTextureTextAlignType.TOP_LEFT;
		_timerTf.node.transform.setPosition(0,-6);
		addChild(_timerTf.node);

		_numSquaresTf = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_numSquaresTf.textureAtlasId = "Kubus36Stroke";
		_numSquaresTf.text = "0/0";
		_numSquaresTf.tracking = 0;
		_numSquaresTf.align = GTextureTextAlignType.TOP_RIGHT;
		_numSquaresTf.node.transform.setPosition(GameData.STAGE_WIDTH,-6);
		addChild(_numSquaresTf.node);

		_prctTf = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_prctTf.textureAtlasId = "Kubus36Stroke";
		_prctTf.text = "0%";
		_prctTf.tracking = 0;
		_prctTf.align = GTextureTextAlignType.TOP_LEFT;
		addChild(_prctTf.node);
		_prctTf.node.transform.setPosition(0, int(GameData.STAGE_HEIGHT - (34 * GameData.RESOLUTION_FACTOR)));

		_comboTf = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_comboTf.textureAtlasId = "Kubus36Stroke";
		_comboTf.text = " ";
		_comboTf.tracking = 0;
		_comboTf.align = GTextureTextAlignType.MIDDLE;
		addChild(_comboTf.node);
		_comboTf.node.transform.setPosition(int(GameData.STAGE_WIDTH / 2), int(GameData.STAGE_HEIGHT - (_comboTf.height / 2)));

		_perfectTf = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_perfectTf.textureAtlasId = "Kubus36Stroke";
		_perfectTf.text = Localization.getString("PERFECT_BONUS_ID");
		_perfectTf.tracking = 0;
		_perfectTf.align = GTextureTextAlignType.MIDDLE;
		addChild(_perfectTf.node);
		_perfectTf.node.transform.setPosition(GameData.STAGE_WIDTH / 2, (_perfectTf.height / 2));
		if(_perfectTf.width % 2 != 0){
			_perfectTf.node.transform.x += 0.5;
		}
		if(_perfectTf.height % 2 != 0){
			_perfectTf.node.transform.y += 0.5;
		}
		_perfectTf.node.transform.setScale(0,0);

		var sprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		sprite.textureId = "pause_btn";
		_pauseBtn = sprite.node;
		_pauseBtn.transform.setPosition(GameData.STAGE_WIDTH  - (sprite.getBounds().width / 2) - 2, GameData.STAGE_HEIGHT  - (sprite.getBounds().height / 2) - 2);
		_pauseBtn.mouseEnabled = true;
		_pauseBtn.onMouseDown.add(onDown);
		_pauseBtn.onMouseUp.add(onUp);
		_pauseBtn.onMouseClick.add(onPause);
		addChild(_pauseBtn);
	}

	private function onGameOver(success:Boolean, pScoreData:ScoreData = null):void
	{
		if(_perfectTimeout > 0){
			clearTimeout(_perfectTimeout);
		}
		if(_comboTimeout > 0){
			clearTimeout(_comboTimeout);
		}
		Tweener.removeTweens(_perfectTf.node.transform);
		//_perfectTf.node.transform.setScale(0,0);
		_perfectTf.node.transform.scaleX = 0;
		_perfectTf.node.transform.scaleY = 0;
		Tweener.removeTweens(_comboTf.node.transform);
		_comboTf.node.transform.scaleX = 0;
		_comboTf.node.transform.scaleY = 0;
		//_comboTf.node.transform.setScale(0,0);
	}

	private function onTutorialComplete():void {
		_pauseBtn.setActive(true);
	}

	private function OnTutorialStart(pt:Point):void {
		_pauseBtn.setActive(false);
	}

	private function onPerfectCircle():void{
		SoundsManager.playPowerUpSfx();
		_perfectTf.text = Localization.getString("PERFECT_BONUS_ID");
		Tweener.removeTweens(_perfectTf.node.transform);
		_perfectTf.node.transform.setScale(0,0);
		Tweener.addTween(_perfectTf.node.transform, {time:0.3, transition:"easeoutbounce", scaleX:1, scaleY:1});
		var particles:SDBonusParticles = GNodeFactory.createNodeWithComponent(SDBonusParticles) as SDBonusParticles;
		particles.node.transform.setPosition(_perfectTf.node.transform.x,_perfectTf.node.transform.y);
		if(_perfectTimeout > 0){
			clearTimeout(_perfectTimeout);
		}
		_perfectTimeout = setTimeout(function():void{
			_perfectTimeout = -1;
			Tweener.addTween(_perfectTf.node.transform, {time:0.3, transition:"easeoutquad", scaleX:0, scaleY:0});
		}, 3000);
	}

	private function onComboBroken():void{
		//Tweener.removeTweens(_comboTf.node.transform);
		//_comboTf.node.setActive(false);
	}

	private function onComboUpdate(comboNum:uint):void{
		SoundsManager.playPowerUpSfx();
		_comboTf.node.setActive(true);
		_comboTf.text = Localization.CURENT_LANG == Localization.ENGLISH ? "X" + comboNum.toString() + " COMBO" : "COMBO X" + comboNum.toString();
		var particles:GSimpleParticleSystem = GNodeFactory.createNodeWithComponent(_bonusParticleClass) as _bonusParticleClass;
		particles.node.transform.setPosition(GameData.STAGE_WIDTH / 2, GameData.STAGE_HEIGHT - (_comboTf.height / 2));

		if(_comboTf.width % 2 != 0){
			_comboTf.node.transform.x += 0.5;
		}
		if(_comboTf.height % 2 != 0){
			_comboTf.node.transform.y += 0.5;
		}
		if(_comboTimeout > 0){
			clearTimeout(_comboTimeout);
		}
		Tweener.removeTweens(_comboTf.node.transform);
		_comboTf.node.transform.setScale(0,0);
		Tweener.addTween(_comboTf.node.transform, {time:0.3, transition:"easeoutbounce", scaleX:1, scaleY:1});
		_comboTimeout = setTimeout(function():void{
			_comboTimeout = -1;
			Tweener.addTween(_comboTf.node.transform, {time:0.3, transition:"easeoutquad", scaleX:0, scaleY:0});
		}, 3000);
	}

	private function onPause(sig:GNodeMouseSignal):void {
		GameSignals.GAME_PAUSE.dispatch(true);
	}

	private function onUp(sig:GNodeMouseSignal):void {
		sig.dispatcher.transform.scaleX = 1;
		sig.dispatcher.transform.scaleY = 1;

	}
	private function onDown(sig:GNodeMouseSignal):void {
		sig.dispatcher.transform.scaleX = 1.05;
		sig.dispatcher.transform.scaleY = 1.05;
	}

	public function updateNumSquares(num:uint):void{
		_numSquaresTf.text = num.toString() + "/" + Main.CURRENT_LEVEL.numSquaresToCatch.toString();
	}
	public function updatePercent(prct:uint):void{
		_prctTf.text = prct.toString() + "%"
	}
	public function updateTime(milliSec:uint):void{
		_timerTf.text = Utils.milliSecondsToTime(milliSec);
	}
}
}
