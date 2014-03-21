/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-08
 * Time: 16:39
 * To change this template use File | Settings | File Templates.
 */
package deluxe.squares {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import starling.textures.RenderTexture;

public class BitmapSquaresRenderer implements ISquareRenderer{

	private var _targetBitmapData:BitmapData;
	private var _canvasRect:Rectangle = new Rectangle(0,0,1136, 640);

	public function BitmapSquaresRenderer(pStage:Stage) {
		_targetBitmapData = new BitmapData(1136, 640, true, 0xffff0000);
		pStage.addChild(new Bitmap(_targetBitmapData));
	}

	public function get renderTexture():RenderTexture{
		return null;
	}

	public function clear():void{
		_targetBitmapData.fillRect(_canvasRect, 0xffcc0000);
	}
	public function prepare():void{
		_targetBitmapData.lock();
	}
	public function release():void{
		_targetBitmapData.unlock();
	}
	public function draw(rect:Rectangle):void{
		_targetBitmapData.fillRect(rect, 0x00ff00);
//		_point.x = rect.x;
//		_point.y = rect.y;
//		_bitmapDataDictionary[rect.width].x = rect.x;
//		_bitmapDataDictionary[rect.width].y = rect.y;
//		_targetBitmapData.copyPixels(_bitmapDataDictionary[rect.width],_canvasRect, _point, null,null, true);
	}
}
}
