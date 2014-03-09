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

import starling.core.Starling;
import starling.display.Image;
import starling.textures.RenderTexture;
import starling.textures.Texture;

public class StarlingSquaresRenderer implements ISquareRenderer{

	private var _bmd_4:Image = new Image(Texture.fromBitmapData(new BitmapData(4,4,true, 0x40ffffff)));
	private var _bmd_6:Image = new Image(Texture.fromBitmapData(new BitmapData(6,6,true, 0x40ffffff)));
	private var _bmd_8:Image = new Image(Texture.fromBitmapData(new BitmapData(8,8,true, 0x40ffffff)));
	private var _bmd_10:Image = new Image(Texture.fromBitmapData(new BitmapData(10,10,true, 0x40ffffff)));
	private var _bmd_12:Image = new Image(Texture.fromBitmapData(new BitmapData(12,12,true, 0x40ffffff)));
	private var _bmd_14:Image = new Image(Texture.fromBitmapData(new BitmapData(14,14,true, 0x40ffffff)));
	private var _bmd_16:Image = new Image(Texture.fromBitmapData(new BitmapData(16,16,true, 0x40ffffff)));
	private var _bmd_18:Image = new Image(Texture.fromBitmapData(new BitmapData(18,18,true, 0x40ffffff)));
	private var _bmd_20:Image = new Image(Texture.fromBitmapData(new BitmapData(20,20,true, 0x40ffffff)));
	private var _bmd_22:Image = new Image(Texture.fromBitmapData(new BitmapData(22,22,true, 0x40ffffff)));
	private var _bmd_24:Image = new Image(Texture.fromBitmapData(new BitmapData(24,24,true, 0x40ffffff)));
	private var _bmd_26:Image = new Image(Texture.fromBitmapData(new BitmapData(26,26,true, 0x40ffffff)));
	private var _bmd_28:Image = new Image(Texture.fromBitmapData(new BitmapData(28,28,true, 0x40ffffff)));
	private var _bmd_30:Image = new Image(Texture.fromBitmapData(new BitmapData(30,30,true, 0x40ffffff)));
	private var _bmd_32:Image = new Image(Texture.fromBitmapData(new BitmapData(32,32,true, 0x40ffffff)));
	private var _bmd_34:Image = new Image(Texture.fromBitmapData(new BitmapData(34,34,true, 0x40ffffff)));
	private var _bmd_36:Image = new Image(Texture.fromBitmapData(new BitmapData(36,36,true, 0x40ffffff)));
	private var _bmd_38:Image = new Image(Texture.fromBitmapData(new BitmapData(38,38,true, 0x40ffffff)));
	private var _bmd_40:Image = new Image(Texture.fromBitmapData(new BitmapData(40,40,true, 0x40ffffff)));

//	private var _targetBitmapData:BitmapData;
//	private var _canvasRect:Rectangle = new Rectangle(0,0,1136, 640);

	private var _bitmapDataDictionary:Dictionary;

//	private var _point:Point = new Point();

	private var _renderTexture:RenderTexture;

	public function StarlingSquaresRenderer(pStage:Stage) {
//		_targetBitmapData = new BitmapData(1136, 640, true, 0x00000000);
//		pStage.addChild(new Bitmap(_targetBitmapData));
		_bmd_4 = new Image(Texture.fromBitmapData(new BitmapData(4,4,true, 0x40ffffff)));
		_bmd_6 = new Image(Texture.fromBitmapData(new BitmapData(6,6,true, 0x40ffffff)));
		_bmd_8 = new Image(Texture.fromBitmapData(new BitmapData(8,8,true, 0x40ffffff)));
		_bmd_10 = new Image(Texture.fromBitmapData(new BitmapData(10,10,true, 0x40ffffff)));
		_bmd_12 = new Image(Texture.fromBitmapData(new BitmapData(12,12,true, 0x40ffffff)));
		_bmd_14 = new Image(Texture.fromBitmapData(new BitmapData(14,14,true, 0x40ffffff)));
		_bmd_16 = new Image(Texture.fromBitmapData(new BitmapData(16,16,true, 0x40ffffff)));
		_bmd_18 = new Image(Texture.fromBitmapData(new BitmapData(18,18,true, 0x40ffffff)));
		_bmd_20 = new Image(Texture.fromBitmapData(new BitmapData(20,20,true, 0x40ffffff)));
		_bmd_22 = new Image(Texture.fromBitmapData(new BitmapData(22,22,true, 0x40ffffff)));
		_bmd_24 = new Image(Texture.fromBitmapData(new BitmapData(24,24,true, 0x40ffffff)));
		_bmd_26 = new Image(Texture.fromBitmapData(new BitmapData(26,26,true, 0x40ffffff)));
		_bmd_28 = new Image(Texture.fromBitmapData(new BitmapData(28,28,true, 0x40ffffff)));
		_bmd_30 = new Image(Texture.fromBitmapData(new BitmapData(30,30,true, 0x40ffffff)));
		_bmd_32 = new Image(Texture.fromBitmapData(new BitmapData(32,32,true, 0x40ffffff)));
		_bmd_34 = new Image(Texture.fromBitmapData(new BitmapData(34,34,true, 0x40ffffff)));
		_bmd_36 = new Image(Texture.fromBitmapData(new BitmapData(36,36,true, 0x40ffffff)));
		_bmd_38 = new Image(Texture.fromBitmapData(new BitmapData(38,38,true, 0x40ffffff)));
		_bmd_40 = new Image(Texture.fromBitmapData(new BitmapData(40,40,true, 0x40ffffff)));
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

		_renderTexture = new RenderTexture(1136, 640, true);
		var img:Image = new Image(_renderTexture);
		Starling.current.stage.addChild(img);
	}

	public function get renderTexture():RenderTexture{
		return _renderTexture;
	}


	public function clear():void{
		_renderTexture.clear();
//		_renderTexture
//		_targetBitmapData.fillRect(_canvasRect, 0x00000000);
	}
	public function prepare():void{
//		_targetBitmapData.lock();
	}
	public function release():void{
//		_targetBitmapData.unlock();
	}
	public function draw(rect:Rectangle):void{
		var img:Image = _bitmapDataDictionary[rect.width];
		img.x = rect.x;
		img.y = rect.y;
		_renderTexture.draw(img);
//		_renderTexture.drawBundled(drawBundled);
//		_point.x = rect.x;
//		_point.y = rect.y;
//		_targetBitmapData.copyPixels(_bitmapDataDictionary[rect.width],_canvasRect, _point, null,null, true);
	}

	private function drawBundled():void{

	}
}
}
