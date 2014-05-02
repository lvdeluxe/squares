/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-23
 * Time: 18:56
 * To change this template use File | Settings | File Templates.
 */
package deluxe {
public class GameData {

	public static var STAGE_WIDTH:uint = 0;
	public static var STAGE_HEIGHT:uint = 0;
	public static var MAX_PIXELS:uint = 0;
	public static var DEG_TO_RAD:Number = Math.PI / 180;
	public static var RAD_TO_DEG:Number = 180 / Math.PI;
	public static var MAIN_MENU_FROM_PAUSE:String = "fromPause";
	public static var MAIN_MENU_FROM_GAME_WON:String = "fromGameWon";
	public static var MAIN_MENU_FROM_GAME_LOST:String = "fromGameLost";
	public static var MAIN_MENU_FROM_OPTIONS:String = "fromOptions";
	public static var MAIN_MENU_FROM_SELECT:String = "fromSelect";

	public function GameData() {
	}
}
}
