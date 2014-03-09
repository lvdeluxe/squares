/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-08
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package deluxe.squares {
import flash.geom.Rectangle;

import starling.textures.RenderTexture;

public interface ISquareRenderer {

	function clear():void;
	function prepare():void;
	function release():void;
	function draw(rect:Rectangle):void;
	function get renderTexture():RenderTexture;
}
}
