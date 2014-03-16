/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-23
 * Time: 17:37
 * To change this template use File | Settings | File Templates.
 */
package {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.context.stats.IStats;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureFactory;

import deluxe.StarlingController;
import deluxe.squares.SquaresManager;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import deluxe.gesture.GestureController;

import flash.geom.Rectangle;
import flash.text.TextField;
import flash.utils.getTimer;

import starling.core.Starling;
import starling.events.Event;

[SWF(width='1136', height='640', backgroundColor='#000000', frameRate='60')]
public class Main extends Sprite{

	[Embed(source="/assets/Kubus-Bold.ttf", embedAsCFF="false", fontFamily="Kubus")]
	private static const Kubus:Class;

//	private var _starling:Starling;
//	private const UPDATE_INTERVAL:Number = 0.5;
	private var _gestureController:GestureController;
	private var _squaresManager:SquaresManager;
//	private var _lastTime:Number;
//	private var mFrameCount:int = 0;
//	private var mTotalTime:Number = 0;
//	private var mFps:Number = 0;
//
//	private var fpsTf:TextField;

	private var _genome:Genome2D;
	private var _stats:GStats;

	private var _lastTime:int;


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

		_lastTime = getTimer();

//		_starling = new Starling(StarlingController, stage);
//		_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, onContext);
//		_starling.showStats = true;
		var config:GContextConfig = new GContextConfig(new Rectangle(0,0,1136,640), stage);
//		_stats = new GStats();
		GStats.visible = true;
//		GStats.y = 500;

//		GStats.visible = true;
//		addChild(_stats)
//		config.enableStats = true;
//		var stats:IStats = new GStats()
// 		addChild(stats as DisplayObject)
//		config.statsClass = GStats;

// Initialize Genome2D
		_genome = Genome2D.getInstance();
		_genome.onInitialized.addOnce(onContext);
		_genome.init(config);
//		_genome.autoUpdateAndRender = false;
	}

	private function onContext():void {
//		_starling.start();
		_gestureController = new GestureController(stage);
		_squaresManager = new SquaresManager(stage, _genome.root);
		_genome.onPreRender.add(render);

		var texture:GTexture = GTextureFactory.createFromBitmapData("test",new BitmapData(100,100,true, 0xffcc0000));
		var sprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite, "sprite") as GSprite;
//		sprite.setTexture(texture);
		sprite.textureId = "test"
		sprite.node.transform.x = stage.stageWidth/2;
		sprite.node.transform.y = stage.stageHeight/2;
		_genome.root.addChild(sprite.node);
//		addEventListener(flash.events.Event.ENTER_FRAME, render);

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



	private function render():void {
//		fps();
//		var time:int = getTimer();
//		trace(time - _lastTime)
//		_genome.g2d_currentFrameId++;
//		_genome.update(time - _lastTime);
		_squaresManager.update();
//		_genome.ren
//		_genome.render();
//		_genome.endRender();
//		_genome.update(time - _lastTime)
//		_genome.render();
//		trace(time - _lastTime);
//		_starling.nextFrame();
//		trace(_stats.g2d_initialized)
//		_stats.render(_genome.getContext())
//		_lastTime = time;

//		trace(_currentPixels, "/", _totalPixels, _currentPixels/_totalPixels);
	}

	private function deactivate(e:flash.events.Event):void
	{
		// make sure the app behaves well (or exits) when in background
		//NativeApplication.nativeApplication.exit();
	}
}
}
