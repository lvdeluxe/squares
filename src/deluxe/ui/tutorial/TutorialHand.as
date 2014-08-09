/**
 * Created by lvdeluxe on 14-04-27.
 */
package deluxe.ui.tutorial {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.greensock.TweenLite;
import com.greensock.easing.Quad;

public class TutorialHand extends GNode{

	private var _hand:GSprite;
	private var _offset:Number = 10;

	public function TutorialHand() {
		_hand = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_hand.textureId = "tutorial_hand";
		addChild(_hand.node);
		startTween();
	}

	public function startTween():void{
		TweenLite.to(_hand.node.transform, 0.2, {roundProps:["y"],y:-_offset, ease:Quad.easeIn, onComplete:tweenUp});
	}

	private function tweenUp():void
	{
		TweenLite.to(_hand.node.transform, 0.4, {roundProps:["y"], y:_offset, ease:Quad.easeIn, onComplete:tweenDown});
	}

	private function tweenDown():void
	{
		TweenLite.to(_hand.node.transform, 0.4, {roundProps:["y"],y:-_offset, ease:Quad.easeOut, onComplete:tweenUp});
	}

	public function pauseTween():void {
		_hand.node.transform.setPosition(0,0);
		TweenLite.killTweensOf(_hand.node.transform);
	}
}
}
