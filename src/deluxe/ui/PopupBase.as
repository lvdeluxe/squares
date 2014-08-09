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
	protected var _titleHeight:uint ;

	public function PopupBase(pTitle:String, pWidth:int = -1, pHeight:int = -1) {
		transform.setPosition(GameData.STAGE_WIDTH / 2, GameData.STAGE_HEIGHT / 2);

		if(pWidth >= 0)
			_width = pWidth;

		if(pHeight >= 0)
			_height = pHeight;

		var bg:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		bg.textureId = "fullscreen_bg";
		bg.node.mouseEnabled = true;
		addChild(bg.node);

		addChild(new PopupBackground(_width, _height));

		var lines:Array = pTitle.split("\n");
//		var yStart:Number = -(lines.length * 24 / 2);
		_titleHeight = 0;
		for(var i:uint = 0 ; i < lines.length ; i++){
			var line:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			line.textureAtlasId = "Kubus72";
			line.text = lines[i];
			line.tracking = 0;
			line.align = GTextureTextAlignType.MIDDLE;
			line.node.transform.setPosition(0, -(_height / 2) + (line.height / 2) + _titleHeight);
			addChild(line.node);
			if(line.width % 2 != 0){
				line.node.transform.x += 0.5;
			}
			if(line.height % 2 != 0){
				line.node.transform.y += 0.5;
			}
			_titleHeight += 52 * GameData.RESOLUTION_FACTOR;
		}
	}
}
}
