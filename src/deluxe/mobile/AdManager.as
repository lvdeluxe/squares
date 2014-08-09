/**
 * Created by lvdeluxe on 14-04-11.
 */
package deluxe.mobile {
import deluxe.*;

import com.revmob.airextension.RevMob;
import com.revmob.airextension.events.RevMobAdsEvent;

import flash.events.TimerEvent;
import flash.utils.Timer;

public class AdManager {

	public static var MAIN_MENU:String = "mainMenu";
	public static var RESTART_LEVEL:String = "restart";
	public static var NEXT_LEVEL:String = "restart";
	private var _appId:String = "534740d70f3d1f3c246bfd8f";
	private var _revMob:RevMob;
	public var adReady:Boolean = false;
	private var _timer:Timer;
	private var _adDelay:Number = 7000;

	public function AdManager() {
		_revMob = new RevMob(_appId);
		_revMob.addEventListener( RevMobAdsEvent.AD_RECEIVED, onAdReceived );
		_revMob.addEventListener( RevMobAdsEvent.AD_NOT_RECEIVED, onAdTimeout );
		_revMob.addEventListener( RevMobAdsEvent.AD_DISMISS, onAdDismiss );
		_revMob.addEventListener( RevMobAdsEvent.AD_CLICKED, onAdClicked );
		_revMob.setTestingMode(false);
		_timer = new Timer(_adDelay, 1);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onAddEnd);

	}

	private function onAdClicked(event:RevMobAdsEvent):void {
		_timer.stop();
		_timer.reset();
		GameSignals.AD_COMPLETE.dispatch(true);
	}

	private function onAddEnd(event:TimerEvent):void {
		removeInterstitial();
		GameSignals.AD_COMPLETE.dispatch(false);
	}

	private function onAdDismiss(event:RevMobAdsEvent):void {
		_timer.stop();
		_timer.reset();
		GameSignals.AD_COMPLETE.dispatch(false);
	}

	private function onAdTimeout(event:RevMobAdsEvent):void {
		adReady = false;
	}

	private function onAdReceived(event:RevMobAdsEvent):void {
		adReady = true;
	}

	public function prepareInterstitial():void{
		_revMob.createFullscreen();
	}

	public function showInterstitial():void{
		if(adReady){
			_revMob.showFullscreen();
			_timer.start();
		}else{
			GameSignals.AD_COMPLETE.dispatch(false);
		}
	}

	private function removeInterstitial():void{
		_timer.stop();
		_timer.reset();
		_revMob.hideFullscreen();
		_revMob.releaseFullscreen();
	}
}
}
