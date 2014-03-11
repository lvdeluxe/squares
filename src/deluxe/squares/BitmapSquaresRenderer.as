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

	private var _bmd_4:BitmapData = new BitmapData(4,4,true, 0x40ffffff);
	private var _bmd_6:BitmapData = new BitmapData(6,6,true, 0x40ffffff);
	private var _bmd_8:BitmapData = new BitmapData(8,8,true, 0x40ffffff);
	private var _bmd_10:BitmapData = new BitmapData(10,10,true, 0x40ffffff);
	private var _bmd_12:BitmapData = new BitmapData(12,12,true, 0x40ffffff);
	private var _bmd_14:BitmapData = new BitmapData(14,14,true, 0x40ffffff);
	private var _bmd_16:BitmapData = new BitmapData(16,16,true, 0x40ffffff);
	private var _bmd_18:BitmapData = new BitmapData(18,18,true, 0x40ffffff);
	private var _bmd_20:BitmapData = new BitmapData(20,20,true, 0x40ffffff);
	private var _bmd_22:BitmapData = new BitmapData(22,22,true, 0x40ffffff);
	private var _bmd_24:BitmapData = new BitmapData(24,24,true, 0x40ffffff);
	private var _bmd_26:BitmapData = new BitmapData(26,26,true, 0x40ffffff);
	private var _bmd_28:BitmapData = new BitmapData(28,28,true, 0x40ffffff);
	private var _bmd_30:BitmapData = new BitmapData(30,30,true, 0x40ffffff);
	private var _bmd_32:BitmapData = new BitmapData(32,32,true, 0x40ffffff);
	private var _bmd_34:BitmapData = new BitmapData(34,34,true, 0x40ffffff);
	private var _bmd_36:BitmapData = new BitmapData(36,36,true, 0x40ffffff);
	private var _bmd_38:BitmapData = new BitmapData(38,38,true, 0x40ffffff);
	private var _bmd_40:BitmapData = new BitmapData(40,40,true, 0x40ffffff);

	private var _targetBitmapData:BitmapData;
	private var _canvasRect:Rectangle = new Rectangle(0,0,1136, 640);

	private var _bitmapDataDictionary:Dictionary;

	private var _point:Point = new Point();

	public function BitmapSquaresRenderer(pStage:Stage) {
		_targetBitmapData = new BitmapData(1136, 640, true, 0x00000000);
		pStage.addChild(new Bitmap(_targetBitmapData));
		_bitmapDataDictionary = new Dictionary();
		_bitmapDataDictionary[4] = _bmd_4;
		_bitmapDataDictionary[6] = _bmd_6;
		_bitmapDataDictionary[8] = _bmd_8;
		_bitmapDataDictionary[10] = _bmd_10;
		_bitmapDataDictionary[12] = _bmd_12;
		_bitmapDataDictionary[14] = _bmd_14;
		_bitmapDataDictionary[16] = _bmd_16;
		_bitmapDataDictionary[18] = _bmd_18;
		_bitmapDataDictionary[20] = _bmd_20;
		_bitmapDataDictionary[22] = _bmd_22;
		_bitmapDataDictionary[24] = _bmd_24;
		_bitmapDataDictionary[26] = _bmd_26;
		_bitmapDataDictionary[28] = _bmd_28;
		_bitmapDataDictionary[30] = _bmd_30;
		_bitmapDataDictionary[32] = _bmd_32;
		_bitmapDataDictionary[34] = _bmd_34;
		_bitmapDataDictionary[36] = _bmd_36;
		_bitmapDataDictionary[38] = _bmd_38;
		_bitmapDataDictionary[40] = _bmd_40;
	}

	public function get renderTexture():RenderTexture{
		return null;
	}

	public function clear():void{
		_targetBitmapData.fillRect(_canvasRect, 0x00000000);
	}
	public function prepare():void{
		_targetBitmapData.lock();
	}
	public function release():void{
		_targetBitmapData.unlock();
	}
	public function draw(rect:Rectangle):void{
		_targetBitmapData.fillRect(rect, 0xffffff);
//		_point.x = rect.x;
//		_point.y = rect.y;
//		_bitmapDataDictionary[rect.width].x = rect.x;
//		_bitmapDataDictionary[rect.width].y = rect.y;
//		_targetBitmapData.copyPixels(_bitmapDataDictionary[rect.width],_canvasRect, _point, null,null, true);
	}
}
}
