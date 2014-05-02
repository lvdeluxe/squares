/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-24
 * Time: 19:03
 * To change this template use File | Settings | File Templates.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.SoundsManager;

public class GButton extends GNode{

	public var height:Number;
	public var width:Number;
	private var _text:GTextureText;

	public function GButton(pTexture:String, pTxt:String, pTextAtlas:String) {

		var gSprite:GSprite = addComponent(GSprite) as GSprite;
		gSprite.textureId = pTexture;
		_text = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_text.textureAtlasId = pTextAtlas;
		_text.text = pTxt;
		_text.tracking = 0;
		_text.align = GTextureTextAlignType.MIDDLE;
		if(_text.width % 2 != 0){
			_text.node.transform.x += 0.5;
		}
		if(_text.height % 2 != 0){
			_text.node.transform.y += 0.5;
		}
		addChild(_text.node);
		height = gSprite.getBounds().height;
		width = gSprite.getBounds().width;
		mouseEnabled = true;
		onMouseDown.add(onDown);
		onMouseUp.add(onUp);
		onMouseClick.add(onClick);
	}

	private function onClick(sig:GNodeMouseSignal):void {
		SoundsManager.playClickSfx();
	}

	private function onUp(sig:GNodeMouseSignal):void {
		sig.dispatcher.transform.scaleX = 1;
		sig.dispatcher.transform.scaleY = 1;

	}
	private function onDown(sig:GNodeMouseSignal):void {
		sig.dispatcher.transform.scaleX = 1.05;
		sig.dispatcher.transform.scaleY = 1.05;
	}

	public function setText(txt:String):void{
		_text.text = txt;
		if(_text.width % 2 != 0){
			_text.node.transform.x += 0.5;
		}
		if(_text.height % 2 != 0){
			_text.node.transform.y += 0.5;
		}
	}

	public function removeListeners():void{
		onMouseDown.remove(onDown);
		onMouseUp.remove(onUp);
		onMouseClick.remove(onClick);
	}
}
}
