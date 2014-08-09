/**
 * Created by lvdeluxe on 14-04-27.
 */
package deluxe.ui.tutorial {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;

import deluxe.GameData;

import flash.geom.Point;

public class TutorialText extends GNode{

	private var _tf:GTextureText;
	private var _maxWidth:uint;


	public function TutorialText(txt:String, pos:Point) {
		transform.setPosition(pos.x, pos.y);
		var lines:Array = txt.split("\n");
		var linesNodes:Array = [];
		var yStart:Number = -(lines.length * 24 / 2 * GameData.RESOLUTION_FACTOR) + 12 * (GameData.RESOLUTION_FACTOR);
		var maxWidth:Number = 0;
		for(var i:uint = 0 ; i < lines.length ; i++){
			var desc:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			desc.textureAtlasId = "Kubus24";
			desc.text = lines[i];
			desc.tracking = 0;
			desc.align = GTextureTextAlignType.MIDDLE;
			desc.node.transform.setPosition(0, yStart);
			if(desc.width % 2 != 0){
				desc.node.transform.x += 0.5;
			}
			if(desc.height % 2 != 0){
				desc.node.transform.y += 0.5;
			}
			maxWidth = Math.max(maxWidth, desc.width);
			yStart += 24 * GameData.RESOLUTION_FACTOR;
			linesNodes.push(desc);
		}
		_maxWidth = uint(maxWidth);
		var w:uint = uint(lines.length * 24 * GameData.RESOLUTION_FACTOR * 1.3);
		if(w%2 != 0)
			w += 1;
		var h:uint = uint(maxWidth * 1.1);
		if(h%2 != 0)
			h += 1;

		setFrame(w, h);

		for(i = 0 ; i < linesNodes.length ; i++){
			addChild(linesNodes[i].node);
		}
	}

	private function setFrame(height:uint, width:uint):void {
		var container:GNode = GNodeFactory.createNode("tutorial_frame");

		var fill:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		fill.textureId = "tutorial_bg";

		var xScale:Number = width / fill.getBounds().width;
		var yScale:Number = height / fill.getBounds().height;

		fill.node.transform.setScale(xScale, yScale);
		container.addChild(fill.node);

		var up_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		up_side.textureId = "tutorial_stroke";
		up_side.node.transform.scaleX = width / up_side.getBounds().width;
		up_side.node.transform.y = int((-height / 2) + (up_side.getBounds().height / 2) );
		addChild(up_side.node);

		var down_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		down_side.textureId = "tutorial_stroke";
		down_side.node.transform.scaleX = width / down_side.getBounds().width;
		down_side.node.transform.scaleY = -1;
		down_side.node.transform.y = int((height / 2) - (down_side.getBounds().height / 2));
		addChild(down_side.node);
//
		var left_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		left_side.textureId = "tutorial_stroke";
		left_side.node.transform.scaleY = height / left_side.getBounds().height;
		left_side.node.transform.x = int(-width / 2);
		addChild(left_side.node);

		var right_side:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		right_side.textureId = "tutorial_stroke";
		right_side.node.transform.scaleY = height / right_side.getBounds().height;
		right_side.node.transform.x = int(width / 2);
		addChild(right_side.node);

		addChild(container);
	}

	public function positionFromHand(pX:Number, pPos:String):void {
		if(pPos == "left")
			transform.x = int(pX + ((_maxWidth / 2) * 1.4));
		else if(pPos == "right")
			transform.x = int(pX - ((_maxWidth / 2) * 1.4));
	}
}
}
