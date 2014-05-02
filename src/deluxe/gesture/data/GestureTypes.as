/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-25
 * Time: 19:48
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture.data {
public class GestureTypes {
	public static const MOVE_LEFT:String = "moveLeft";
	public static const MOVE_RIGHT:String = "moveRight";
	public static const MOVE_UP:String = "moveUp";
	public static const MOVE_DOWN:String = "moveDown";
	public static const MOVE_LEFT_DOWN:String = "moveLeftDown";
	public static const MOVE_LEFT_UP:String = "moveLeftUp";
	public static const MOVE_RIGHT_DOWN:String = "moveRightDown";
	public static const MOVE_RIGHT_UP:String = "moveRightUp";

	public static const RECTANGLE_CLOCKWISE:Vector.<String> = 				Vector.<String>([MOVE_RIGHT, MOVE_DOWN, MOVE_LEFT, MOVE_UP]);
	public static const RECTANGLE_COUNTER_CLOCKWISE:Vector.<String> = 		Vector.<String>([MOVE_LEFT, MOVE_DOWN, MOVE_RIGHT, MOVE_UP]);
	public static const TRIANGLE_UP_CLOCKWISE:Vector.<String> = 			Vector.<String>([MOVE_RIGHT_UP, MOVE_RIGHT_DOWN, MOVE_LEFT ]);
	public static const TRIANGLE_UP_COUNTER_CLOCKWISE:Vector.<String> = 	Vector.<String>([MOVE_LEFT_UP, MOVE_LEFT_DOWN, MOVE_RIGHT ]);
	public static const TRIANGLE_DOWN_CLOCKWISE:Vector.<String> = 			Vector.<String>([MOVE_RIGHT, MOVE_LEFT_DOWN, MOVE_LEFT_UP ]);
	public static const TRIANGLE_DOWN_COUNTER_CLOCKWISE:Vector.<String> = 	Vector.<String>([MOVE_LEFT, MOVE_RIGHT_DOWN, MOVE_RIGHT_UP ]);
	public static const TRIANGLE_RIGHT_CLOCKWISE:Vector.<String> = 			Vector.<String>([MOVE_UP, MOVE_RIGHT_DOWN, MOVE_LEFT_DOWN ]);
	public static const TRIANGLE_RIGHT_COUNTER_CLOCKWISE:Vector.<String> = 	Vector.<String>([MOVE_DOWN, MOVE_RIGHT_UP, MOVE_LEFT_UP ]);
	public static const TRIANGLE_LEFT_CLOCKWISE:Vector.<String> = 			Vector.<String>([MOVE_DOWN, MOVE_LEFT_UP, MOVE_RIGHT_UP ]);
	public static const TRIANGLE_LEFT_COUNTER_CLOCKWISE:Vector.<String> = 	Vector.<String>([MOVE_UP, MOVE_LEFT_DOWN, MOVE_RIGHT_DOWN ]);
	public static const CIRCLE_CLOCKWISE:Vector.<String> = 					Vector.<String>([MOVE_RIGHT, MOVE_RIGHT_DOWN, MOVE_DOWN, MOVE_LEFT_DOWN, MOVE_LEFT, MOVE_LEFT_UP, MOVE_UP, MOVE_RIGHT_UP]);
	public static const CIRCLE_COUNTER_CLOCKWISE:Vector.<String> = 			Vector.<String>([MOVE_LEFT, MOVE_LEFT_DOWN, MOVE_DOWN, MOVE_RIGHT_DOWN, MOVE_RIGHT, MOVE_RIGHT_UP, MOVE_UP, MOVE_LEFT_UP]);
}
}
