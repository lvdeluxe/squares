/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-23
 * Time: 17:37
 * To change this template use File | Settings | File Templates.
 */
package {
import deluxe.StarlingController;
import deluxe.squares.SquaresManager;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import deluxe.gesture.GestureController;

import flash.text.TextField;
import flash.utils.getTimer;

import starling.core.Starling;
import starling.events.Event;

[SWF(width='1136', height='640', backgroundColor='#000000', frameRate='60')]
public class Main extends Sprite{

	private var _starling:Starling;
	private const UPDATE_INTERVAL:Number = 0.5;
	private var _gestureController:GestureController;
	private var _squaresManager:SquaresManager;
//	private var _lastTime:Number;
//	private var mFrameCount:int = 0;
//	private var mTotalTime:Number = 0;
//	private var mFps:Number = 0;
//
//	private var fpsTf:TextField;


	public function Main() {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
//		fpsTf = new TextField();
//		fpsTf.textColor = 0xffffff;
//		fpsTf.width = 50;
//		fpsTf.height = 18;
//		fpsTf.y = 50
//		addChild(fpsTf);
//		_lastTime = getTimer();



		_starling = new Starling(StarlingController, stage);
		_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContext);
		_starling.showStats = true;
	}

	private function onContext(event:starling.events.Event):void {
		_starling.start();
		_gestureController = new GestureController(stage);
		_squaresManager = new SquaresManager(stage);
		addEventListener(flash.events.Event.ENTER_FRAME, render);

	}

//	private function fps():void
//	{
//		var time:Number = getTimer();
//		mTotalTime += (time - _lastTime) / 1000;
//		mFrameCount++;
//
//		if (mTotalTime > UPDATE_INTERVAL)
//		{
////			update();
//			mFps = mTotalTime > 0 ? mFrameCount / mTotalTime : 0;
//
//			fpsTf.text = (mFps.toFixed(mFps < 100 ? 1 : 0));
//			mFrameCount = mTotalTime = 0;
//		}
//		_lastTime = time;
//	}



	private function render(event:flash.events.Event):void {
//		fps();
		_squaresManager.update();
		_starling.nextFrame();


//		trace(_currentPixels, "/", _totalPixels, _currentPixels/_totalPixels);
	}

	private function deactivate(e:flash.events.Event):void
	{
		// make sure the app behaves well (or exits) when in background
		//NativeApplication.nativeApplication.exit();
	}
}
}
