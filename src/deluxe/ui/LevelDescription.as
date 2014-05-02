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

import flash.system.System;

public class LevelDescription extends ScreenBase{

	private var _startBtn:GButton;
	private var _backBtn:GButton;

	public function LevelDescription(level:Level) {
		super(Localization.getString("LEVEL_ID")+ "   " + (level.levelIndex + 1).toString());
		this.onRemovedFromStage.add(onRemove);


		var ids:Array = ["LEVEL_OBJ_ID","LEVEL_GAMEOVER_ID","LEVEL_HIGHSCORE_ID"];
		var yStart:Number = (GameData.STAGE_HEIGHT / 2) - ((ids.length * 24) / 2);
		var replace:Array = [{"numSquaresToCatch":Main.CURRENT_LEVEL.numSquaresToCatch}, {"squaresGameOver":Main.CURRENT_LEVEL.squaresGameOver}, {"highscore":3700}];
		for(var i:uint = 0 ; i < 3 ; i++){
			var line:String = Localization.getString(ids[i], replace[i]);
			var desc:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
			desc.textureAtlasId = "Kubus24";
			desc.text = line;
			desc.tracking = 0;
			desc.align = GTextureTextAlignType.MIDDLE;
			desc.node.transform.setPosition(GameData.STAGE_WIDTH / 2, yStart);
			addChild(desc.node);

			if(i == 2){
				var pts:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
				pts.textureAtlasId = "KubusScore";
				pts.text = Localization.getString("POINTS_ID");
				pts.align = GTextureTextAlignType.MIDDLE;
				pts.tracking = -2;
				pts.node.transform.setPosition(int(desc.node.transform.x + (desc.width / 2) + (pts.width / 2)), int(desc.node.transform.y + (desc.height / 2) - (pts.height / 1.5)));
				if(pts.width % 2 != 0){
					pts.node.transform.x += 0.5;
				}
				if(pts.height % 2 != 0){
					pts.node.transform.y += 0.5;
				}
				addChild(pts.node);
			}

			yStart += 24;
			if(desc.width % 2 != 0){
				desc.node.transform.x += 0.5;
			}
			if(desc.height % 2 != 0){
				desc.node.transform.y += 0.5;
			}
		}

		_startBtn = new GButton("btnBackground", Localization.getString("START_LEVEL_ID"), "Kubus");
		_startBtn.onMouseClick.add(onClickStart);
		_startBtn.transform.setPosition(int((GameData.STAGE_WIDTH / 2) + (_startBtn.width / 2 * 1.15)), GameData.STAGE_HEIGHT * 0.85);
		addChild(_startBtn);

		_backBtn = new GButton("btnBackground", Localization.getString("BACK_ID"), "Kubus");
		_backBtn.onMouseClick.add(onClickBack);
		_backBtn.transform.setPosition(int((GameData.STAGE_WIDTH / 2) - (_backBtn.width / 2 * 1.15)), GameData.STAGE_HEIGHT * 0.85);
		addChild(_backBtn);

	}

	private function onClickBack(sig:GNodeMouseSignal):void {
		GameSignals.BACK_TO_SELECT.dispatch();
	}

	private function onClickStart(sig:GNodeMouseSignal):void {
		GameSignals.LEVEL_START.dispatch();
	}

	private function onRemove():void {
		this.onRemovedFromStage.remove(onRemove);
		_startBtn.onMouseClick.remove(onClickStart);
		_startBtn.removeListeners();
		_backBtn.onMouseClick.remove(onClickBack);
		_backBtn.removeListeners();
		System.gc();
	}
}
}
