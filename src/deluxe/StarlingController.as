/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-24
 * Time: 21:59
 * To change this template use File | Settings | File Templates.
 */
package deluxe {
import flash.display.BitmapData;
import flash.events.MouseEvent;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.PDParticleSystem;
import starling.textures.Texture;

public class StarlingController extends Sprite{

	[Embed(source="../assets/particle.pex", mimeType="application/octet-stream")]
	private static const Config:Class;
	[Embed(source="../assets/texture.png")]
	private static const Particle:Class;

	private var ps:PDParticleSystem;

	public function StarlingController() {
//		addChild(new Image(Texture.fromBitmapData(new BitmapData(1136,640,false,0xff000000))))        ;
		var psConfig:XML = XML(new Config());
		var psTexture:Texture = Texture.fromBitmap(new Particle());
		ps = new PDParticleSystem(psConfig, psTexture);
		Starling.juggler.add(ps);
		addChild(ps);
		ps.emitterX = 560;
		ps.emitterY = 320;
		ps.start();
//		addEventListener(TouchEvent.TOUCH, onTouch)
		Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(stage);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			ps.emitterX = touch.globalX;
			ps.emitterY = touch.globalY;
		}
	}

	private function onMouseMove(event:MouseEvent):void {
		ps.emitterX = event.stageX;
		ps.emitterY = event.stageY;
	}
	private function onMouseUp(event:MouseEvent):void {
		Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}
	private function onMouseDown(event:MouseEvent):void {
		Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		ps.emitterX = event.stageX;
		ps.emitterY = event.stageY;

	}
}
}
