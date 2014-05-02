/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-02
 * Time: 14:20
 * To change this template use File | Settings | File Templates.
 */
package deluxe {
import com.adobe.osflash.signals.Signal;

public class GameSignals {
	public static const GESTURE_DRAW:Signal = new Signal();
	public static const ELLIPSE_CANCEL:Signal = new Signal();
	public static const ELLIPSE_EXPLODE:Signal = new Signal();
	public static const LEVEL_START:Signal = new Signal();
	public static const LEVEL_SELECT:Signal = new Signal();
	public static const GAME_OVER:Signal = new Signal();
	public static const GAME_START:Signal = new Signal();
	public static const GAME_PAUSE:Signal = new Signal();
	public static const MAIN_MENU:Signal = new Signal();
	public static const BACK_TO_SELECT:Signal = new Signal();
	public static const NEXT_LEVEL:Signal = new Signal();
	public static const RESTART_LEVEL:Signal = new Signal();
	public static const AD_COMPLETE:Signal = new Signal();
	public static const OPTIONS_MENU:Signal = new Signal();
	public static const CHANGE_LANG:Signal = new Signal();
	public static const CHANGE_MUSIC:Signal = new Signal();
	public static const CHANGE_SFX:Signal = new Signal();
	public static const LANG_CHANGED:Signal = new Signal();
	public static const COMBO_UPDATE:Signal = new Signal();
	public static const COMBO_BROKEN:Signal = new Signal();
	public static const PERFECT_CIRCLE:Signal = new Signal();
	//TUTORIAL
	public static const TUT_STEP_1_START:Signal = new Signal();
	public static const TUT_STEP_1_COMPLETE:Signal = new Signal();
	public static const TUT_STEP_2_COMPLETE:Signal = new Signal();
	public static const TUT_STEP_3_COMPLETE:Signal = new Signal();
	public static const TUTORIAL_COMPLETE:Signal = new Signal();
}
}
