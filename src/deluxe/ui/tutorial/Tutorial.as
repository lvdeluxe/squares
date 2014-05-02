/**
 * Created by lvdeluxe on 14-04-27.
 */
package deluxe.ui.tutorial {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;
import com.greensock.easing.Quad;
import com.greensock.motionPaths.CirclePath2D;
import com.greensock.motionPaths.Direction;
import com.greensock.plugins.CirclePath2DPlugin;
import com.greensock.plugins.TweenPlugin;

import deluxe.ExtendedTimer;
import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.Localization;
import deluxe.gesture.DrawTarget;
import deluxe.particles.GestureParticles;

import flash.events.TimerEvent;
import flash.geom.Point;

public class Tutorial extends GNode{

	private var _hand:TutorialHand;
	private var _target:GNode;
	private var _tut_0:TutorialText;
	private var _tut_1:TutorialText;
	private var _tut_2:TutorialText;
	private var _tut_3:TutorialText;
	private var _tut_4:TutorialText;
	private var _particles:GestureParticles;

	private var _timer:ExtendedTimer;

	public function Tutorial() {

		TweenPlugin.activate([CirclePath2DPlugin]);

		GameSignals.TUT_STEP_1_COMPLETE.add(onTutStep1Complete);

		_timer = new ExtendedTimer(4000,1);

		_hand = new TutorialHand();

		_tut_0 = new TutorialText(Localization.getString("TUT_STEP_0_ID"), new Point(GameData.STAGE_WIDTH / 4, GameData.STAGE_HEIGHT * 0.6));
		addChild(_tut_0);

		_hand.transform.setPosition(_tut_0.transform.x, _tut_0.transform.y - _hand.getBounds(_hand).height - (_tut_0.getBounds(_tut_0).height / 2));
		addChild(_hand);
		GameSignals.TUT_STEP_1_START.dispatch(new Point(_hand.transform.x,_hand.transform.y - _hand.getBounds(_hand).height));

		var target:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		target.textureId = "tutorial_target";
		_target = target.node;
		addChild(_target);
		_target.transform.setPosition(_hand.transform.x, _hand.transform.y - _target.getBounds(_target).height);
	}

	private function onTutStep1Complete():void {
		removeChild(_tut_0);
		_tut_1 = new TutorialText(Localization.getString("TUT_STEP_1_ID"), new Point(GameData.STAGE_WIDTH / 4, GameData.STAGE_HEIGHT * 0.6));
		addChild(_tut_1);
		_hand.pauseTween();
		tweenCircle();
		_particles = GNodeFactory.createNodeWithComponent(GestureParticles) as GestureParticles;
		_particles.emit = true;
		GameSignals.TUT_STEP_2_COMPLETE.add(OnTutStep2Complete);
	}


	private function OnTutStep2Complete(target:DrawTarget):void {
		TweenLite.killTweensOf(_hand.transform);
		_hand.setActive(false);
		Genome2D.getInstance().root.removeChild(_particles.node);
		_particles = null;
		GameSignals.TUT_STEP_2_COMPLETE.remove(OnTutStep2Complete);
		removeChild(_tut_1);

		var position:Point = new Point(target.data.position.x,  target.data.position.y + (target.data.height / 2));
		if(target.data.position.y - (GameData.STAGE_HEIGHT / 2) + (target.data.height / 2) >= GameData.STAGE_HEIGHT / 2){
			position.y = int(GameData.STAGE_HEIGHT * 0.9);
		}

		_tut_2 = new TutorialText(Localization.getString("TUT_STEP_2_ID"), position);
		addChild(_tut_2);
		GameSignals.TUT_STEP_3_COMPLETE.add(onTutStep3Complete);
		removeChild(_target);
	}

	private function onTutStep3Complete():void {
		removeChild(_tut_2);
		GameSignals.TUT_STEP_3_COMPLETE.remove(onTutStep3Complete);
		GameSignals.GAME_PAUSE.dispatch(true, false);
		var position:Point = new Point(int(GameData.STAGE_WIDTH * 5 / 7), int(GameData.STAGE_HEIGHT * 0.1));
		_tut_3 = new TutorialText(Localization.getString("TUT_STEP_3_ID"), position);
		addChild(_tut_3);
		_hand.startTween();
		_hand.transform.rotation = 90 * GameData.DEG_TO_RAD;
		_hand.setActive(true);
		_hand.transform.setPosition(GameData.STAGE_WIDTH * 0.9, GameData.STAGE_HEIGHT * 0.05);
		_timer.addEventListener(TimerEvent.TIMER, onTimerStep4);
		_timer.start();
	}

	private function onTimerStep5(event:TimerEvent):void {
		_timer.removeEventListener(TimerEvent.TIMER, onTimerStep5);
		removeChild(_tut_4);
		_hand.pauseTween();
		removeChild(_hand);
		GameSignals.GAME_PAUSE.dispatch(false, false);
		GameSignals.TUTORIAL_COMPLETE.dispatch();
	}

	private function onTimerStep4(event:TimerEvent):void {
		_timer.removeEventListener(TimerEvent.TIMER, onTimerStep4);
		_timer.reset();
		removeChild(_tut_3);
		var position:Point = new Point(int(GameData.STAGE_WIDTH * 3 / 11), int(GameData.STAGE_HEIGHT * 0.93));
		_tut_4 = new TutorialText(Localization.getString("TUT_STEP_4_ID"), position);
		addChild(_tut_4);
		_hand.transform.scaleY = -1;
		_hand.transform.setPosition(GameData.STAGE_WIDTH * 0.075, GameData.STAGE_HEIGHT * 0.96);
		_timer.addEventListener(TimerEvent.TIMER, onTimerStep5);
		_timer.start();
	}

	private function tweenCircle():void
	{
		var n:CirclePath2D = new CirclePath2D(GameData.STAGE_WIDTH / 2, GameData.STAGE_HEIGHT / 2,GameData.STAGE_HEIGHT / 4);
		n.width = 2 * n.height;
		TweenLite.to(_hand.transform, 5, {ease:Quad.easeOut, circlePath2D:{path:n, startAngle:200, endAngle:200, autoRotate:false, direction:Direction.CLOCKWISE, extraRevolutions:1}, onComplete:tweenCircle, onUpdate:updateParticles});
	}

	private function updateParticles():void{
		_particles.node.transform.setPosition(_hand.transform.x,_hand.transform.y);
	}
}
}
