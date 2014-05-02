/**
 * Created by lvdeluxe on 14-04-13.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;

public class GCheckbox extends GNode{

	private var _mark:GNode;
	public var height:Number;
	public var width:Number;
	public var dispatcher:GNode;
	private var _title:GTextureText;
	private var _box:GSprite;

	public function GCheckbox(pTitle:String, isSelected:Boolean) {
		mouseEnabled = true;
		_box = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		_box.textureId = "checkbox";
		_box.node.mouseEnabled = true;
		dispatcher = _box.node;
		addChild(_box.node);

		var mark:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
		mark.textureId = "checkmark";
		_mark = mark.node;
		addChild(_mark);

		_title = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
		_title.textureAtlasId = "Kubus24";
		_title.text = pTitle;
		_title.align = GTextureTextAlignType.MIDDLE;
		_title.node.transform.y = 0;
		_title.node.transform.x = int((_title.width / 2) + (_box.getBounds().width));
		addChild(_title.node);

		if(_title.width % 2 != 0){
			_title.node.transform.x += 0.5;
		}
		if(_title.height % 2 != 0){
			_title.node.transform.y += 0.5;
		}

		_mark.setActive(isSelected);

		height = _box.getBounds().height;
		width = _box.getBounds().width;
	}

	public function setText(pText:String):void{
		_title.text = pText;
		_title.node.transform.y = 0;
		_title.node.transform.x = int((_title.width / 2) + (_box.getBounds().width));
		if(_title.width % 2 != 0){
			_title.node.transform.x += 0.5;
		}
		if(_title.height % 2 != 0){
			_title.node.transform.y += 0.5;
		}
	}

	public function setSelected(selected:Boolean):void{
		_mark.setActive(selected);
	}

	public function isSelected():Boolean{
		return _mark.isActive();
	}
}
}
