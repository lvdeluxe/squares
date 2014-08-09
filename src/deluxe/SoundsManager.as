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

public class SoundsManager {

	[Embed(source='/assets/sounds/loops/bacterial_love.mp3')]
	public static const Loop1:Class;
	[Embed(source='/assets/sounds/loops/ants.mp3')]
	public static const Loop2:Class;
	[Embed(source='/assets/sounds/loops/a_ninja_among_culturachippers.mp3')]
	public static const Loop3:Class;
	[Embed(source='/assets/sounds/loops/if_pigs_could_sing.mp3')]
	public static const Loop4:Class;

	[Embed(source='/assets/sounds/sfx/click.mp3')]
	public static const Click:Class;
	[Embed(source='/assets/sounds/sfx/hit.mp3')]
	public static const Explode:Class;
	[Embed(source='/assets/sounds/sfx/pUp.mp3')]
	public static const PowerUp:Class;
	[Embed(source='/assets/sounds/sfx/happy.mp3')]
	public static const Woosh:Class;

	private static var MENU_PLAYING:String = "menu";
	private static var WIN_PLAYING:String = "win";
	private static var LOSE_PLAYING:String = "lose";
	private static var GAME_PLAYING:String = "game";

	private static var _currentlyPlaying:String;

	private static var _loopVolume:Number = 0.8;

	private static var _loopGamePlay:Sound;
	private static var _channelGamePlay:SoundChannel;
	private static var _tansformGamePlay:SoundTransform = new SoundTransform(_loopVolume);

	private static var _loopMenus:Sound;
	private static var _channelMenus:SoundChannel;
	private static var _transformMenus:SoundTransform = new SoundTransform(_loopVolume);

	private static var _loopWon:Sound;
	private static var _channelWon:SoundChannel;
	private static var _transformWon:SoundTransform = new SoundTransform(_loopVolume);

	private static var _loopLost:Sound;
	private static var _channelLost:SoundChannel;
	private static var _transformLost:SoundTransform = new SoundTransform(_loopVolume);

	private static var _powerUpSfx:Sound;
	private static var _clickSfx:Sound;
	private static var _explodeSfx:Sound;
	private static var _channelSfx:SoundChannel;

	private static var _transitionTime:Number = 0.3;
	public static var playLoops:Boolean = true;
	public static var playSfx:Boolean = true;

	private static var _muteFromMenu:Boolean = true;

	private static var _stretcher:MP3PlayerSound;
	private static var _stretcherDist:Number = 0;


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
			_transformMenus.volume = _loopVolume;
			_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
		}

		_stretcher = new MP3PlayerSound();
		_stretcher.audioFile = new Woosh();
		_stretcher.loop = true;
	}

	public static function startLooper():void{
		if(playSfx){
			if(!_stretcher.isPlaying){
				_stretcher.speed = 1;
				_stretcher.play();
			}
		}
	}

	public static function pitchLooper(dist:Number):void{
		if(playSfx){
			_stretcherDist += dist;
			_stretcher.speed = 1 + (Math.sqrt(_stretcherDist) / 500);
		}
	}
	public static function stopLooper():void{
		_stretcherDist = 0;
		_stretcher.hardStop();
	}

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
		_currentlyPlaying = MENU_PLAYING;
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
			_transformMenus.volume = _loopVolume;
			_channelMenus = _loopMenus.play(0,1,_transformMenus);
			_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
		}
	}

	public static function playGamePlayLoop():void{
		if(!playLoops)
			return;
		_currentlyPlaying = GAME_PLAYING;
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
		_tansformGamePlay.volume = _loopVolume;
		_channelGamePlay = _loopGamePlay.play(0,1,_tansformGamePlay);
		_channelGamePlay.addEventListener(Event.SOUND_COMPLETE, onLoopGamePlayComplete);
	}

	public static function playGameLostLoop():void{
		if(!playLoops)
			return;
		_currentlyPlaying = LOSE_PLAYING;
		if(_channelGamePlay){
			Tweener.addTween(_tansformGamePlay, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelGamePlay.stop();
				_channelGamePlay = null;
			}});
		}
		_transformLost.volume = _loopVolume;
		_channelLost = _loopLost.play(0,1,_transformLost);
		_channelLost.addEventListener(Event.SOUND_COMPLETE, onLoopLostComplete);
	}

	public static function playGameWonLoop():void{
		if(!playLoops)
			return;
		_currentlyPlaying = WIN_PLAYING;
		if(_channelGamePlay){
			Tweener.addTween(_tansformGamePlay, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
				_channelGamePlay.stop();
				_channelGamePlay = null;
			}});
		}
		_transformWon.volume = _loopVolume;
		_channelWon = _loopWon.play(0,1,_transformWon);
		_channelWon.addEventListener(Event.SOUND_COMPLETE, onLoopWonComplete);
	}

	public static function mute(pMuted:Boolean):void{
		if(pMuted){
			if(_channelMenus){
				Tweener.addTween(_transformMenus, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
					_muteFromMenu = true;
					_channelMenus.stop();
					_channelMenus.removeEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
					_channelMenus = null;
				}});
			}else if(_channelGamePlay){
				Tweener.addTween(_tansformGamePlay, {volume:0, time:_transitionTime, transition:"linear", onComplete:function():void{
					_muteFromMenu = false;
					_channelGamePlay.stop();
					_channelGamePlay.removeEventListener(Event.SOUND_COMPLETE, onLoopGamePlayComplete);
					_channelGamePlay = null;
				}});
			}
		}else{
			if(_muteFromMenu){
				if(_channelMenus == null){
					_transformMenus.volume = _loopVolume;
					_channelMenus = _loopMenus.play(0,1,_transformMenus);
					_channelMenus.addEventListener(Event.SOUND_COMPLETE, onLoopMenuComplete);
				}
			}else{
				if(_channelGamePlay == null){
					_tansformGamePlay.volume = _loopVolume;
					_channelGamePlay = _loopGamePlay.play(0,1,_tansformGamePlay);
					_channelGamePlay.addEventListener(Event.SOUND_COMPLETE, onLoopGamePlayComplete);
				}
			}
		}
		playLoops = !pMuted;
	}

	public static function resumeAllSounds():void {
		if(playLoops){
			switch(_currentlyPlaying){
				case MENU_PLAYING:
					_transformMenus.volume = _loopVolume;
					break;
				case GAME_PLAYING:
					_tansformGamePlay.volume = _loopVolume;
					break;
				case LOSE_PLAYING:
					_transformLost.volume = _loopVolume;
					break;
				case WIN_PLAYING:
					_transformWon.volume = _loopVolume;
					break;
			}
		}
	}
	public static function pauseAllSounds():void {
		if(playLoops){
			switch(_currentlyPlaying){
				case MENU_PLAYING:
					_transformMenus.volume = 0;
					break;
				case GAME_PLAYING:
					_tansformGamePlay.volume = 0;
					break;
				case LOSE_PLAYING:
					_transformLost.volume = 0;
					break;
				case WIN_PLAYING:
					_transformWon.volume = 0;
					break;
			}
		}
		if(playSfx){
			stopLooper();
		}
	}
}
}
