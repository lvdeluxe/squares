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

import deluxe.GameData;
import deluxe.Localization;

public class ScreenBase extends GNode{

	private var _title:GTextureText;

	public function ScreenBase(pTitle:String) {
		var offset:uint = 50;
		for (var i:uint = 0 ; i < 100 ; i++ ) {
			var sprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite, "sprite"+ i.toString()) as GSprite;
			sprite.textureId = "test" + i.toString();
			sprite.node.transform.x = offset + Math.round(Math.random() * (GameData.STAGE_WIDTH - (offset * 2)));
			sprite.node.transform.y = offset + Math.round(Math.random() * (GameData.STAGE_HEIGHT - (offset * 2)));
			sprite.node.transform.setScale(0,0);
			addChild(sprite.node);
			Tweener.addTween(sprite.node.transform, {time:0.3, transition:"easeoutquad", scaleX:1, scaleY:1, delay:i / 100});
		}

		if(pTitle != ""){
			_title = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			_title.textureAtlasId = "Kubus72";
			_title.text = pTitle;
			_title.tracking = 0;
			_title.align = GTextureTextAlignType.MIDDLE;
			_title.node.transform.setPosition(GameData.STAGE_WIDTH / 2, (_title.height));
			addChild(_title.node);
		}
	}

	public function setTitle(pTitle:String):void{
		if(_title){
			_title.text = pTitle;
		}
	}
}
}
