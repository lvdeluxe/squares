/**
 * Created by lvdeluxe on 14-04-07.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;

import deluxe.GameData;

public class PopupBase extends GNode{

	protected var _width:uint = uint(GameData.STAGE_WIDTH / 2);
	protected var _height:uint = uint(GameData.STAGE_HEIGHT * 2 / 3);
	protected var _title:GTextureText;

	public function PopupBase(pTitle:String) {
		transform.setPosition(GameData.STAGE_WIDTH / 2, GameData.STAGE_HEIGHT / 2);
		var bg:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		bg.textureId = "fullscreen_bg";
		bg.node.mouseEnabled = true;
		addChild(bg.node);

		addChild(new PopupBackground(_width, _height));

		_title = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_title.textureAtlasId = "KubusTitle";
		_title.text = pTitle;
		_title.tracking = 0;
		_title.align = GTextureTextAlignType.MIDDLE;
		_title.node.transform.setPosition(0, -(_height / 2) + (_title.height / 2));
		addChild(_title.node);
	}
}
}
