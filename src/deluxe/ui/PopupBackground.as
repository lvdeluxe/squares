/**
 * Created by lvdeluxe on 14-04-07.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;

import deluxe.GameData;

public class PopupBackground extends GNode{
	public function PopupBackground(pWidth:Number, pHeight:Number) {

		var fill:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		fill.textureId = "popup_bg";

		var xScale:Number = pWidth / fill.getBounds().width;
		var yScale:Number = pHeight / fill.getBounds().height;

		fill.node.transform.setScale(xScale, yScale);
		addChild(fill.node);

		var up_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		up_side.textureId = "popup_bg_side";
		up_side.node.transform.scaleX = pWidth / up_side.getBounds().width;
		up_side.node.transform.y = int(-pHeight / 2);
		addChild(up_side.node);

		var down_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		down_side.textureId = "popup_bg_side";
		down_side.node.transform.scaleX = pWidth / down_side.getBounds().width;
		down_side.node.transform.scaleY = -1;
		down_side.node.transform.y = int(pHeight / 2);
		addChild(down_side.node);

		var left_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		left_side.textureId = "popup_bg_side";
		left_side.node.transform.scaleX = pHeight / left_side.getBounds().width;
		left_side.node.transform.rotation = -90 * GameData.DEG_TO_RAD;
		left_side.node.transform.x = int(-pWidth / 2);
		addChild(left_side.node);

		var right_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		right_side.textureId = "popup_bg_side";
		right_side.node.transform.scaleX = pHeight / right_side.getBounds().width;
		right_side.node.transform.rotation = 90 * GameData.DEG_TO_RAD;
		right_side.node.transform.x = int(pWidth / 2);
		addChild(right_side.node);

		var up_left_corner:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		up_left_corner.textureId = "popup_bg_corner";
		up_left_corner.node.transform.x = int(-(up_side.getBounds().width * up_side.node.transform.scaleX / 2));
		up_left_corner.node.transform.y = int(-pHeight / 2);
		addChild(up_left_corner.node);

		var up_right_corner:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		up_right_corner.textureId = "popup_bg_corner";
		up_right_corner.node.transform.rotation = 90 * GameData.DEG_TO_RAD;
		up_right_corner.node.transform.x = int((up_side.getBounds().width * up_side.node.transform.scaleX / 2));
		up_right_corner.node.transform.y = -pHeight / 2;
		addChild(up_right_corner.node);

		var bottom_left_corner:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		bottom_left_corner.textureId = "popup_bg_corner";
		bottom_left_corner.node.transform.scaleY = -1;
		bottom_left_corner.node.transform.x = int(-(up_side.getBounds().width * up_side.node.transform.scaleX / 2));
		bottom_left_corner.node.transform.y = int(pHeight / 2);
		addChild(bottom_left_corner.node);

		var bottom_right_corner:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		bottom_right_corner.textureId = "popup_bg_corner";
		bottom_right_corner.node.transform.rotation = 180 * GameData.DEG_TO_RAD;
		bottom_right_corner.node.transform.x = int((up_side.getBounds().width * up_side.node.transform.scaleX / 2));
		bottom_right_corner.node.transform.y = int(pHeight / 2);
		addChild(bottom_right_corner.node);
	}
}
}
