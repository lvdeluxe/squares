/**
 * Created by lvdeluxe on 14-04-08.
 */
package deluxe.squares {
import deluxe.GameSignals;

public class ScoreData {

	public var time:uint;
	public var destroyed:uint = 0;
	public var combos:uint = 0;
	public var maxInOneGesture:uint = 0;
	public var numGesturesTotal:uint = 0;
	public var numGesturesOnce:uint = 0;
	public var numEllipses:uint = 0;
	public var numTriangles:uint = 0;
	public var numRectangles:uint = 0;

	private static const COMBOX2_VALUE:uint = 2;
	private static const COMBOX3_VALUE:uint = 3;
	private static const COMBOX4_VALUE:uint = 4;
	private static const COMBOX5_VALUE:uint = 5;
	private static const COMBOX6_VALUE:uint = 6;

	public var comboX2:uint = 0;
	public var comboX3:uint = 0;
	public var comboX4:uint = 0;
	public var comboX5:uint = 0;
	public var comboX6:uint = 0;

	private var _currentCombo:uint = 0;

	private var _totalScore:Number = -1;

	public var perfectCircles:uint = 0;

	public function ScoreData() {

	}

	public function setCombo(numGestures:uint):void{
		if(numGestures <= 1){
			_currentCombo = 0;
			GameSignals.COMBO_BROKEN.dispatch();
			return;
		}

		var prevCombo:uint = _currentCombo;
		_currentCombo = numGestures;
		if(prevCombo > _currentCombo){
			//combo broken
			_currentCombo = 0;
			GameSignals.COMBO_BROKEN.dispatch();
		}else if(prevCombo < _currentCombo){
			switch(_currentCombo){
				case COMBOX2_VALUE:
					comboX2++;
					break;
				case COMBOX3_VALUE:
					comboX3++;
					break;
				case COMBOX4_VALUE:
					comboX4++;
					break;
				case COMBOX5_VALUE:
					comboX5++;
					break;
				case COMBOX6_VALUE:
					comboX6++;
					break;
			}
			GameSignals.COMBO_UPDATE.dispatch(_currentCombo);
		}
	}

	public function getTotalScore():uint{
		if(_totalScore < 0){
			if(comboX3 > 0){
				comboX2 -= comboX3;
			}
			if(comboX4 > 0){
				comboX3 -= comboX4;

			}
			if(comboX5 > 0){
				comboX4 -= comboX5;

			}
			if(comboX6 > 0){
				comboX5 -= comboX6;
			}

			var comboMultiplier:Number = 1;
			comboMultiplier += 0.05 * comboX2;
			comboMultiplier += 0.1 * comboX3;
			comboMultiplier += 0.2 * comboX4;
			comboMultiplier += 0.35 * comboX5;
			comboMultiplier += 0.5 * comboX6;

			combos = comboX6 + comboX5 + comboX4 + comboX3 + comboX2;

			_totalScore = Main.CURRENT_LEVEL.numSquaresToCatch;

			var explodedBonus:Number = (destroyed - Main.CURRENT_LEVEL.numSquaresToCatch) * 0.1;

			var onceMultiplier:Number = 1;

			if(numGesturesOnce > 500)
				onceMultiplier += 0.5;
			else if(numGesturesOnce > 250)
				onceMultiplier += 0.2;
			else if(numGesturesOnce > 100)
				onceMultiplier += 0.1;
			else if(numGesturesOnce > 50)
				onceMultiplier += 0.05;

			var timeMultiplier:Number = 1;

			if(time < 10000)
				timeMultiplier = 1.5;
			else if(time < 30000)
				timeMultiplier = 1.25;
			else if(time < 60000)
				timeMultiplier = 1.1;

			var gesturesMultiplier:Number = 1;

			if(numGesturesTotal < 2)
				gesturesMultiplier += 0.2;
			else if(numGesturesTotal < 5)
				gesturesMultiplier += 0.1;
			else if(numGesturesTotal < 10)
				gesturesMultiplier += 0.05;

			var perfectMultiplier:Number = 1;
			for(var i:uint = 0 ; i < perfectCircles ; i++){
				perfectMultiplier += 0.05;
			}

			var totalMultiplier:Number = (timeMultiplier + comboMultiplier + gesturesMultiplier + onceMultiplier + perfectMultiplier) / 5;

			_totalScore += explodedBonus;
			_totalScore *= totalMultiplier;

			trace("totalMultiplier = ", totalMultiplier);
		}

		return uint(_totalScore);
	}

	public function toString():String{
		return 	"totalScore = " + getTotalScore().toString() + "\n" +
				"time = " + time.toString() + "\n" +
				"total destroyed = " + destroyed.toString() + "\n" +
				"combos = " + combos.toString() + "\n" +
				"maxInOneGesture = " + maxInOneGesture.toString() + "\n" +
				"numGesturesOnce = " + numGesturesOnce.toString() + "\n" +
				"numGesturesTotal = " + numGesturesTotal.toString() + "\n" +
				"numEllipses = " + numEllipses.toString() + "\n" +
				"numTriangles = " + numTriangles.toString() + "\n" +
				"numRectangles = " + numRectangles.toString() + "\n" +
				"////////////////////////////////";
	}
}
}
