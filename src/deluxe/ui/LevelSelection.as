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
import deluxe.Level;
import deluxe.Localization;
import deluxe.particles.BonusParticles;
import deluxe.particles.GestureParticles;

public class LevelSelection extends ScreenBase{

	private var _levels:Vector.<Level>;
	private var _btns:Vector.<GButton> = new Vector.<GButton>();
	private var _backBtn:GButton;

	public function LevelSelection(pLevels:Vector.<Level>) {

		super(Localization.getString("LEVEL_SELECT_ID"));
		_levels = pLevels;
		this.onRemovedFromStage.add(onRemove);

		_backBtn = new GButton("btnBackgroundLarge", Localization.getString("BACK_ID"), "Kubus24");
		_backBtn.onMouseClick.add(onClickBack);
		_backBtn.transform.setPosition(int(GameData.STAGE_WIDTH * 0.5), int(GameData.STAGE_HEIGHT * 0.9));
		addChild(_backBtn);

		setLevelButtons();

//		var particles:BonusParticles = GNodeFactory.createNodeWithComponent(BonusParticles) as BonusParticles;
//		particles.emit = true;
//		particles.burst = true;
//		particles.node.setActive(true);
	}

	private function onClickBack(sig:GNodeMouseSignal):void{
		GameSignals.MAIN_MENU.dispatch(GameData.MAIN_MENU_FROM_SELECT);
	}

	private function setLevelButtons():void {
		var itemSize:uint = 64;
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
				var isUnlocked:Boolean = _levels[index].unlocked;
				var btn:GButton = new GButton(isUnlocked ? "level_btn_bg" : "level_btn_bg_locked", (_levels[index].levelIndex + 1).toString(), "Kubus");
				if(!isUnlocked){
					btn.removeListeners();
				}else{
					btn.onMouseClick.add(onClickLevel);
					_btns.push(btn);
					var score:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
					score.textureAtlasId = "KubusScore";
					score.text = "1280/3700";
					score.tracking = -2;
					score.align = GTextureTextAlignType.MIDDLE;
					score.node.transform.setPosition(posX,posY + (btn.height / 2) + (score.height / 2));
					addChild(score.node);
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
