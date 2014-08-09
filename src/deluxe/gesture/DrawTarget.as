/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-05
 * Time: 20:05
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GBlendMode;
import com.genome2d.context.filters.GDesaturateFilter;
import com.genome2d.context.filters.GFilter;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.ExtendedTimer;
import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.gesture.data.EllipseData;
import deluxe.gesture.data.IGeometryData;
import deluxe.gesture.data.TriangleData;
import deluxe.particles.hd.HDExplodeParticles;
import deluxe.particles.sd.SDExplodeParticles;

import flash.events.TimerEvent;
import flash.filters.BlurFilter;

public class DrawTarget extends GNode{

	private static var INC:uint = 0;
	private var _timer:ExtendedTimer;
	public var data:EllipseData;
	private var _name:String;
	public var toBeDestoyed:Boolean = false;
	private var _controller:GestureController;
	private var _textureSize:uint = 128;
	private var _explodeParticleClass:Class;

	public function DrawTarget(controller:GestureController, pTextureId:String) {
		if(GameData.STAGE_WIDTH == 2048)
			_explodeParticleClass = HDExplodeParticles;
		else
			_explodeParticleClass = SDExplodeParticles;
		var gSprite:GSprite = addComponent(GSprite) as GSprite;
		gSprite.textureId = pTextureId;
//		gSprite.node.transform.alpha = 0.5;
		gSprite.blendMode = GBlendMode.ADD;
		_textureSize = gSprite.getBounds().width;
		_controller = controller;
		_timer = new ExtendedTimer(Main.CURRENT_LEVEL.gestureExplosionSpeed,1);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onEllipseExplode);
		mouseEnabled = true;
		onMouseMove.add(onMove);
		_name = "drawTarget_" + (++INC).toString();
	}

	public function pauseTimer():void{
		_timer.pause();
	}
	public function resumeTimer():void{
		_timer.resume();
	}

	private function onMove(sig:GNodeMouseSignal):void {
		if(_controller.isMouseDown)
			toBeDestoyed = true;
	}

	private function onEllipseExplode(event:TimerEvent):void {
		GameSignals.ELLIPSE_EXPLODE.dispatch(this);
		_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onEllipseExplode);
		onMouseMove.remove(onMove);
		parent.removeChild(this);
		var particles:GSimpleParticleSystem = GNodeFactory.createNodeWithComponent(_explodeParticleClass) as GSimpleParticleSystem;
		particles.node.transform.setPosition(data.position.x, data.position.y);
		Genome2D.getInstance().root.addChild(particles.node);
	}

	public function clear():void{
		onMouseMove.remove(onMove);
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onEllipseExplode);
		parent.removeChild(this);
	}

	public function drawShape():void{
		var inverseScale:Boolean = false;
		transform.setPosition(data.position.x, data.position.y);

		if(data is TriangleData){
			var triangleData:TriangleData = data as TriangleData;
			if(triangleData.orientation == TriangleData.DOWN)
				transform.rotation = 180 * GameData.DEG_TO_RAD;
			else if(triangleData.orientation == TriangleData.LEFT){
				inverseScale = true;
				transform.rotation = -90 * GameData.DEG_TO_RAD;
			}else if(triangleData.orientation == TriangleData.RIGHT){
				inverseScale = true;
				transform.rotation = 90 * GameData.DEG_TO_RAD;
			}
		}
		if(inverseScale)
			transform.setScale(data.height / _textureSize, data.width / _textureSize);
		else
			transform.setScale(data.width / _textureSize, data.height / _textureSize);
	}

	public function setData(pData:EllipseData):void{
		data = pData;
		_timer.start();
		drawShape();
	}
}
}
