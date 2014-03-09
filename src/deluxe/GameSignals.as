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
	public static const ELLIPSE_DRAW:Signal = new Signal();
	public static const ELLIPSE_CANCEL:Signal = new Signal();
	public static const ELLIPSE_EXPLODE:Signal = new Signal();
}
}
