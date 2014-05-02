/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-25
 * Time: 19:01
 * To change this template use File | Settings | File Templates.
 */
package deluxe {
public class Utils {
	public function Utils() {
	}
	public static function milliSecondsToTime(milliseconds:Number):String{
		var minutes:uint = Math.floor(milliseconds * 0.001 / 60);
		var seconds:uint = Math.floor(milliseconds * 0.001) % 60;
		var hours:uint = Math.floor(minutes / 60);
		minutes %= 60;
		var finalString:String;
		if(minutes > 0){
			finalString = String(minutes + ":" + String(seconds < 10 ? "0" + seconds : seconds) + "." + String(milliseconds).substr(-3,1));
		}else{
			finalString = String(String(seconds < 10 ? "0" + seconds : seconds) + "." + String(milliseconds).substr(-3,1));
		}
		return finalString;
	}
}
}
