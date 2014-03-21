/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-23
 * Time: 17:37
 * To change this template use File | Settings | File Templates.
 */
package {
//import deluxe.StarlingController;
import deluxe.StarlingController;
import deluxe.b2dLite;
import deluxe.squares.SquaresManager;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import deluxe.gesture.GestureController;

import flash.geom.Rectangle;

import starling.core.Starling;

//import flash.text.TextField;
//import flash.utils.getTimer;
//
//import starling.core.Starling;
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

	private var _renderer:b2dLite;


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
//		_gestureController = new GestureController(stage);
//		_squaresManager = new SquaresManager(stage);
//		addEventListener(flash.events.Event.ENTER_FRAME, render);

//

		_starling = new Starling(StarlingController, stage);
		_starling.antiAliasing = 0;
		_starling.shareContext = true;
		_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContext);
		_starling.showStats = true;
	}

	private function onContext(event:starling.events.Event):void {

		_renderer = new b2dLite(0);
		_starling.start();
		_renderer.initializeFromContext(_starling.context,1136,640);

		_renderer.createTexture(new BitmapData(4,4,true, 0x40ffffff));
		_gestureController = new GestureController(stage);
		_squaresManager = new SquaresManager(_renderer);
		addEventListener(flash.events.Event.ENTER_FRAME, render);
	}

	private function render(event:flash.events.Event):void {
		_renderer.clear();
		_renderer.reset();
		_squaresManager.update();
		_renderer.flush();
		_starling.nextFrame();
		_renderer.present();
	}

	private function deactivate(e:flash.events.Event):void
	{
		// make sure the app behaves well (or exits) when in background
		//NativeApplication.nativeApplication.exit();
	}
}
}
