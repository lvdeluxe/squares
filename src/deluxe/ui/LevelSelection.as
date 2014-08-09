/**
 * Created by lvdeluxe on 14-04-06.
 */
package deluxe.ui {
import com.genome2d.components.renderables.GSprite;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.signals.GNodeMouseSignal;

import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.level.Level;
import deluxe.Localization;
import deluxe.level.UserLevelData;
import deluxe.particles.sd.SDBonusParticles;
import deluxe.particles.sd.SDGestureParticles;

public class LevelSelection extends ScreenBase{

	private var _levels:Vector.<UserLevelData>;
	private var _btns:Vector.<GButton> = new Vector.<GButton>();
	private var _backBtn:GButton;

	public function LevelSelection(pLevels:Vector.<UserLevelData>) {

		super(Localization.getString("LEVEL_SELECT_ID"));
		_levels = pLevels;
		this.onRemovedFromStage.add(onRemove);

		_backBtn = new GButton("btnBackgroundLarge", Localization.getString("BACK_ID"), "Kubus24");
		_backBtn.onMouseClick.add(onClickBack);
		_backBtn.transform.setPosition(int(GameData.STAGE_WIDTH * 0.5), int(GameData.STAGE_HEIGHT * 0.9));
		addChild(_backBtn);

		setLevelButtons();
	}

	private function onClickBack(sig:GNodeMouseSignal):void{
		GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_SELECT);
	}

	private function setLevelButtons():void {
		var itemSize:uint = 64 * GameData.RESOLUTION_FACTOR;
		var columns:uint = 6;
		var rows:uint = 4;

		var offset:uint = itemSize * 1.5;
		var index:uint = 0;

		var gridWidth:uint = (columns * itemSize) + ((offset - itemSize) * (columns - 1));
		var posX:uint = ((GameData.STAGE_WIDTH - gridWidth) / 2) + (itemSize / 2);
		var gridHeight:uint = (rows * itemSize) + ((offset - itemSize) * (rows - 1));
		var posY:uint = ((GameData.STAGE_HEIGHT - gridHeight) / 2) + (itemSize / 2);

		for(var i:uint = 0 ; i < rows ; i++){
			for(var j:uint = 0 ; j < columns ; j++){
				var isUnlocked:Boolean = !_levels[index].locked;
				var btn:GButton = new GButton(isUnlocked ? "level_btn_bg" : "level_btn_bg_locked", (_levels[index].id + 1).toString(), "Kubus36");
				if(!isUnlocked){
					btn.removeListeners();
				}else{
					btn.onMouseClick.add(onClickLevel);
					_btns.push(btn);
					var score:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
					score.textureAtlasId = "Kubus12";
					score.text = _levels[index].bestScore.toString() + "PTS";
					score.tracking = -2;
					score.align = GTextureTextAlignType.MIDDLE;
					score.node.transform.setPosition(int(posX),int(posY + (btn.height / 2) + (score.height / 2)));

					if(score.width % 2 != 0){
						score.node.transform.x += 0.5;
					}
					if(score.height % 2 != 0){
						score.node.transform.y += 0.5;
					}
					addChild(score.node);
					if(_levels[index].achievementComplete){
						var numberOne:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
						numberOne.textureAtlasId = "Kubus12";
						numberOne.text = "#1";
						numberOne.tracking = -2;
						numberOne.align = GTextureTextAlignType.MIDDLE;
						numberOne.node.transform.setPosition(int(posX + (btn.width / 2) - (numberOne.width)),int(posY - (btn.height / 2) + (numberOne.height / 2)));

						if(numberOne.width % 2 != 0){
							numberOne.node.transform.x += 0.5;
						}
						if(numberOne.height % 2 != 0){
							numberOne.node.transform.y += 0.5;
						}
						addChild(numberOne.node);
					}
				}

				btn.transform.setPosition(posX,posY);
				addChild(btn);

				posX += offset;
				index++;
			}
			posY += offset;
			posX = ((GameData.STAGE_WIDTH - gridWidth) / 2) + (itemSize / 2);
		}
	}


	private function onClickLevel(sig:GNodeMouseSignal):void {
		var btn:GButton = sig.dispatcher as GButton;
		GameSignals.LEVEL_SELECT.dispatch(_btns.indexOf(btn));
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		for(var i:uint = 0 ; i < _btns.length ; i++){
			_btns[i].removeListeners();
			_btns[i].onMouseClick.remove(onClickLevel);
		}
	}
}
}
