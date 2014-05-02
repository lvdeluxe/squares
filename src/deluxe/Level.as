/**
 * Created by lvdeluxe on 14-03-30.
 */
package deluxe {
public class Level {

	public var squaresSpeed:Number;
	public var numSquaresSpawned:uint;
	public var tickSpeed:uint;
	public var numSquaresToCatch:uint;
	public var gestureExplosionSpeed:uint;
	public var gestureExplosionSpeedMilli:Number;
	public var squaresGameOver:uint;
	public var levelIndex:uint;
	public var name:String;
	public var description:String;
	public var unlocked:Boolean = false;

	public function Level() {
	}
}
}
