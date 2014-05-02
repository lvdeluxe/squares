/**
 * Created by lvdeluxe on 14-04-14.
 */
package deluxe {
import caurina.transitions.Tweener;

import com.sonoport.AudioStretch;
import com.sonoport.Looper;
import com.sonoport.MP3PlayerSound;
import com.sonoport.SciFiSweep;
import com.sonoport.SheikPerry;
import com.sonoport.Whoosh;

import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.ByteArray;
import flash.utils.Timer;

import net.onthewings.stk.Flute;

public class SoundsManager {

	[Embed(source='/assets/sounds/loops/fame.mp3')]
	public static const Loop1:Class;
	[Embed(source='/assets/sounds/loops/cruisin.mp3')]
	public static const Loop2:Class;
	[Embed(source='/assets/sounds/loops/magical_shower_outrun.mp3')]
	public static const Loop3:Class;
	[Embed(source='/assets/sounds/loops/blondie.mp3')]
	public static const Loop4:Class;
	[Embed(source='/assets/sounds/sfx/click.mp3')]
	public static const Click:Class;
	[Embed(source='/assets/sounds/sfx/hit.mp3')]
	public static const Explode:Class;
	[Embed(source='/assets/sounds/sfx/pUp.mp3')]
	public static const PowerUp:Class;
	[Embed(source='/assets/sounds/sfx/happy.mp3')]
	public static const Woosh:Class;

	private static var _loopGamePlay:Sound;
	private static var _channelGamePlay:SoundChannel;
	private static var _tansformGamePlay:SoundTransform = new SoundTransform();

	private static var _loopMenus:Sound;
	private static var _channelMenus:SoundChannel;
	private static var _transformMenus:SoundTransform = new SoundTransform();

	private static var _loopWon:Sound;
	private static var _channelWon:SoundChannel;
	private static var _transformWon:SoundTransform = new SoundTransform();

	private static var _loopLost:Sound;
	private static var _channelLost:SoundChannel;
	private static var _transformLost:SoundTransform = new SoundTransform();

	private static var _powerUpSfx:Sound;
	private static var _clickSfx:Sound;
	private static var _explodeSfx:Sound;
	private static var _channelSfx:SoundChannel;

	private static var _transitionTime:Number = 0.3;
	public static var playLoops:Boolean = true;
	public static var playSfx:Boolean = true;

	private static var _pitch:Number = 1;

	private static var _soundChannel:SoundChannel;
	private static var _morphedSound:Sound;


	private static var _stretcher:MP3PlayerSound;



	public static function init():void{
		_clickSfx = new Click();
		_powerUpSfx = new PowerUp();
		_explodeSfx = new Explode();
		_loopMenus = new Loop4();
		_loopGamePlay = new Loop1();
		_loopWon = new Loop3();
		_loopLost = new Loop2();
		if(playLoops){
			_channelMenus = _loopMenus.play(0,1,_transformMenus);
			_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
		}

		_stretcher = new MP3PlayerSound();
		_stretcher.audioFile = new Woosh();
		_stretcher.loop = true;
//		_stretcher.speed = 2;
//		_stretcher.pitchShift = 12;
//		_stretcher.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
	}
//
//	private static function onSoundComplete(event:Event):void {
////		_stretcher.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
////		_stretcher.play();
////		_stretcher.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
//	}

	public static function startLooper():void{
//		_stretcher.play();
		if(!_stretcher.isPlaying){
			_stretcher.speed = 1;
//			_stretcher.pitchShift = -12;
			_stretcher.play();
		}

	}

	public static function pitchLooper(pRate:Number):void{
//		_looper.pan = pRate;
//		_looper.gain = pRate;
//		trace(pRate);
		pRate = Math.max(1, pRate)
		_stretcher.speed = 1 + pRate;
//		_looper.rate = pRate;
	}
	public static function stopLooper():void{
		_stretcher.hardStop();
	}

//	private static function soundCompleteHandler(event:Event):void
//	{
//		position = 0;
//		_soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
//		_soundChannel = _morphedSound.play();
//		_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
//		trace("complete")
//	}
	/**
	 * Provides sample data to the output Sound object. The Sound object dispatches a
	 * sampleData event when it needs sample data. This event handler function provides
	 * that data. The method calls the shiftBytes() method to shift the pitch of the
	 * audio data.
	 */
//	private static function sampleDataHandler(event:SampleDataEvent):void
//	{
//		var bytes:ByteArray = new ByteArray();
//		position += _testSound.extract(bytes, 4096, position);
//		event.data.writeBytes(shiftBytes(bytes));
//	}
//
//	private static function shiftBytes(bytes:ByteArray):ByteArray
//	{
//		var skipCount:Number = 0;
//		var skipRate:Number = 1 + (1 / (1.5 - 1));
//		var returnBytes:ByteArray = new ByteArray();
//		bytes.position = 0;
//		while(bytes.bytesAvailable > 0)
//		{
//			skipCount++;
//			if (skipCount <= skipRate)
//			{
//				returnBytes.writeFloat(bytes.readFloat());
//				returnBytes.writeFloat(bytes.readFloat());
//			}
//			else
//			{
//				bytes.position += 8;
//				skipCount = skipCount - skipRate;
//			}
//		}
//		return returnBytes;
//	}

//	private static function onTimer(event:TimerEvent):void
//	{
//		_pitch -= 0.01;
//	}
//
//	private static function onSampleData(event:SampleDataEvent):void {
//		var $lev:Number;
//		for (var i:uint = 0; i < 8192; i++)
//		{
//			$lev = 0;
//			$lev += Math.sin((i + event.position) * Math.PI / (44100 / 440 * _pitch));
//			$lev /= 2;
//			event.data.writeFloat($lev);
//			event.data.writeFloat($lev);
//		}
//
//	}

	public static function playPowerUpSfx():void{
		if(playSfx)
			_channelSfx = _powerUpSfx.play();
	}

	public static function playExplodeSfx():void{
		if(playSfx)
			_channelSfx = _explodeSfx.play();
	}

	public static function playClickSfx():void{
		if(playSfx)
			_channelSfx = _clickSfx.play();
	}

	private static function onLoopWonComplete(event:Event):void {
		_channelWon.removeEventListener(Event.SOUND_COMPLETE, onLoopWonComplete);
		_channelWon = _loopWon.play(0,1,_transformWon);
		_channelWon.addEventListener(Event.SOUND_COMPLETE, onLoopWonComplete);
	}

	private static function onLoopLostComplete(event:Event):void {
		_channelLost.removeEventListener(Event.SOUND_COMPLETE, onLoopLostComplete);
		_channelLost = _loopLost.play(0,1,_transformLost);
		_channelLost.addEventListener(Event.SOUND_COMPLETE, onLoopLostComplete);
	}

	private static function onLoopMenuComplete(event:Event):void {
		_channelMenus.removeEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
		_channelMenus = _loopMenus.play(0,1,_transformMenus);
		_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
	}

	private static function onLoopGamePlayComplete(event:Event):void {
		_channelGamePlay.removeEventListener(Event.SOUND_COMPLETE, onLoopGamePlayComplete);
		_channelGamePlay = _loopGamePlay.play(0,1,_tansformGamePlay);
		_channelGamePlay.addEventListener(Event.SOUND_COMPLETE, onLoopGamePlayComplete);
	}


	public static function playMenuLoop():void{
		if(!playLoops)
			return;
		if(_channelGamePlay){
			Tweener.addTween(_tansformGamePlay, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelGamePlay.stop();
				_channelGamePlay = null;
			}});
		}
		if(_channelWon){
			Tweener.addTween(_transformWon, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelWon.stop();
				_channelWon = null;
			}});
		}
		if(_channelLost){
			Tweener.addTween(_transformLost, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelLost.stop();
				_channelLost = null;
			}});
		}
		if(_channelMenus == null){
			_transformMenus.volume = 1;
			_channelMenus = _loopMenus.play(0,1,_transformMenus);
			_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
		}
	}

	public static function playGamePlayLoop():void{
		if(!playLoops)
			return;
		if(_channelMenus){
			Tweener.addTween(_transformMenus, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelMenus.stop();
				_channelMenus = null;
			}});
		}
		if(_channelWon){
			Tweener.addTween(_transformWon, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelWon.stop();
				_channelWon = null;
			}});
		}
		if(_channelLost){
			Tweener.addTween(_transformLost, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelLost.stop();
				_channelLost = null;
			}});
		}
		_tansformGamePlay.volume = 1;
		_channelGamePlay = _loopGamePlay.play(0,1,_tansformGamePlay);
		_channelGamePlay.addEventListener(Event.SOUND_COMPLETE, onLoopGamePlayComplete);
	}

	public static function playGameLostLoop():void{
		if(!playLoops)
			return;
		if(_channelGamePlay){
			Tweener.addTween(_tansformGamePlay, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelGamePlay.stop();
				_channelGamePlay = null;
			}});
		}
		_transformLost.volume = 1;
		_channelLost = _loopLost.play(0,1,_transformLost);
		_channelLost.addEventListener(Event.SOUND_COMPLETE, onLoopLostComplete);
	}

	public static function playGameWonLoop():void{
		if(!playLoops)
			return;
		if(_channelGamePlay){
			Tweener.addTween(_tansformGamePlay, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelGamePlay.stop();
				_channelGamePlay = null;
			}});
		}
		_transformWon.volume = 1;
		_channelWon = _loopWon.play(0,1,_transformWon);
		_channelWon.addEventListener(Event.SOUND_COMPLETE, onLoopWonComplete);
	}

	public static function mute(pMuted:Boolean):void{
		if(pMuted){
			if(_channelMenus){
				Tweener.addTween(_transformMenus, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
					_channelMenus.stop();
					_channelMenus = null;
				}});
			}
		}else{
			if(_channelMenus == null){
				_transformMenus.volume = 1;
				_channelMenus = _loopMenus.play(0,1,_transformMenus);
				_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
			}
		}
		playLoops = !pMuted;
	}

}
}
