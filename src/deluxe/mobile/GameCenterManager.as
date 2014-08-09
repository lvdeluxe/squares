/**
 * Created by lvdeluxe on 14-05-03.
 */
package deluxe.mobile {
import com.adobe.ane.gameCenter.GameCenterAchievementEvent;
import com.adobe.ane.gameCenter.GameCenterAuthenticationEvent;
import com.adobe.ane.gameCenter.GameCenterController;
import com.adobe.ane.gameCenter.GameCenterLeaderboardEvent;

import deluxe.AssetsSDManager;
import deluxe.level.UserLevelData;

public class GameCenterManager {

	private var _gameCenterData:Array;
	private var _gameCenterCallback:Function;
	private var _gameCenterCallbackParams:Array = [];
	private var _achievementCallback:Function;
	private var _leaderboardCallback:Function;
	private var _gcController:GameCenterController;

	private var _stageOrientation:String;

	public function GameCenterManager(pCallback:Function) {
		_gameCenterCallback = pCallback;

		if(GameCenterController.isSupported){
			_gcController = new GameCenterController();
			_gcController.resetAchievements();
			var gcData:Object = JSON.parse(new Main.GameCenterData());
			_gameCenterData = gcData.game_center;
			authenticate();
		}else{
			_gameCenterCallback(false);
		}
	}

	private function authenticate():void {
		try
		{
			_gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, localPlayerAuthenticated);
			_gcController.addEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED, localPlayerNotAuthenticated);
			_gameCenterCallbackParams = [true];
			_gcController.authenticate();
			trace(_gcController.localPlayer);
		}
		catch( error : Error )
		{
			_gcController.removeEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, localPlayerAuthenticated);
			_gcController.removeEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED, localPlayerNotAuthenticated);
			_gameCenterCallback(false);
			trace("error authentication");
		}
	}

	private function localPlayerAuthenticated(event:GameCenterAuthenticationEvent) : void
	{
		_gcController.removeEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, localPlayerAuthenticated);
		_gcController.removeEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED, localPlayerNotAuthenticated);
		trace( "localPlayerAuthenticated" );
		_gameCenterCallback(_gameCenterCallbackParams);
	}

	private function localPlayerNotAuthenticated(event:GameCenterAuthenticationEvent) : void
	{
		_gcController.removeEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, localPlayerAuthenticated);
		_gcController.removeEventListener(GameCenterAuthenticationEvent.PLAYER_NOT_AUTHENTICATED, localPlayerNotAuthenticated);
		trace( "localPlayerNotAuthenticated" );
		_gameCenterCallback(false);
	}

	public function showAchievements():void {
		if(GameCenterController.isSupported){
			if(_gcController.authenticated){
				try
				{
					_gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_VIEW_FINISHED, onAchievementsRemoved);
					_gcController.showAchievementsView();
				}
				catch( error : Error )
				{
					_gcController.removeEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_VIEW_FINISHED, onAchievementsRemoved);
					trace(error.message);
				}
			}else{
				_gameCenterCallback = showAchievements;
				authenticate();
			}
		}
	}
	public function showLeaderboard(levelId:int = -1):void {
		if(GameCenterController.isSupported){
			if(_gcController.authenticated){
				try
				{
					_gcController.addEventListener(GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED, onLeaderboardRemoved);
					if(levelId < 0)
						_gcController.showLeaderboardView("lvl_0");
					else
						_gcController.showLeaderboardView(_gameCenterData[levelId].leaderboard_id);
				}
				catch( error : Error )
				{
					_gcController.removeEventListener(GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED, onLeaderboardRemoved);
					trace(error.message);
				}
			}else{
				_gameCenterCallback = showLeaderboard;
				authenticate();
			}
		}
	}

	private function onAchievementsRemoved(event:GameCenterAchievementEvent):void{
		_gcController.addEventListener(GameCenterAchievementEvent.ACHIEVEMENTS_VIEW_FINISHED, onAchievementsRemoved);
		trace("onAchievmentsRemoved")
	}
	private function onLeaderboardRemoved(event:GameCenterLeaderboardEvent):void{
		//-useLegacyAOT no
		_gcController.removeEventListener(GameCenterLeaderboardEvent.LEADERBOARD_VIEW_FINISHED, onLeaderboardRemoved);
		trace("onLeaderboardRemoved");
	}

	public function postAchievement(pLevelId:uint, pCallback:Function):void {
		if(GameCenterController.isSupported){
			if(_gcController.authenticated){
				_achievementCallback = pCallback;
				try
				{
					if(!_gameCenterData[pLevelId].achievement_complete){
						_gameCenterData[pLevelId].achievement_complete = true;
						_gcController.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED,achievementReportFailed );
						_gcController.addEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED,achievementReportSuccess );
						_gcController.submitAchievement(_gameCenterData[pLevelId].achievement_id,100);
					}else{
						_achievementCallback(false);
					}
				}
				catch( error : Error )
				{
					if(_gcController.hasEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED))
						_gcController.removeEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED,achievementReportFailed );
					if(_gcController.hasEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED))
						_gcController.removeEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED,achievementReportSuccess );
					_achievementCallback(false);
					trace( error.message );
				}
			}else{
				_gameCenterCallbackParams = [pLevelId, pCallback];
				_gameCenterCallback = postAchievement;
				authenticate();
			}
		}
	}

	private function achievementReportFailed(event:GameCenterAchievementEvent) : void
	{
		_gcController.removeEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED,achievementReportFailed );
		_gcController.removeEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED,achievementReportSuccess );
		_achievementCallback(false);
		trace( "localPlayerAchievementReportFailed" );
	}

	private function achievementReportSuccess(event:GameCenterAchievementEvent) : void
	{
		_gcController.removeEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_FAILED,achievementReportFailed );
		_gcController.removeEventListener(GameCenterAchievementEvent.SUBMIT_ACHIEVEMENT_SUCCEEDED,achievementReportSuccess );
		_achievementCallback(true);
		trace( "localPlayerAchievementReported" );
	}

	public function postLeaderboard(pLevelId:uint, pScore:int, pCallback:Function):void {
		if(GameCenterController.isSupported){
			if(_gcController.authenticated){
				_leaderboardCallback = pCallback;
				try
				{

					_gcController.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED, scoreReportFailed);
					_gcController.addEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED, scoreReportSuccess);
					_gcController.submitScore(pScore, _gameCenterData[pLevelId].leaderboard_id);
				}
				catch( error : Error )
				{
					_gcController.removeEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED, scoreReportFailed);
					_gcController.removeEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED, scoreReportSuccess);
					trace( error.message );
					_leaderboardCallback(false);
				}
			}else{
				_gameCenterCallbackParams = [pLevelId, pScore, pCallback];
				_gameCenterCallback = postLeaderboard;
				authenticate();
			}
		}
	}

	private function scoreReportFailed(event:GameCenterLeaderboardEvent) : void
	{
		_gcController.removeEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED, scoreReportFailed);
		_gcController.removeEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED, scoreReportSuccess);
		_leaderboardCallback(false);
		trace( "localPlayerScoreReportFailed" );
	}

	private function scoreReportSuccess(event:GameCenterLeaderboardEvent) : void
	{
		_gcController.removeEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_FAILED, scoreReportFailed);
		_gcController.removeEventListener(GameCenterLeaderboardEvent.SUBMIT_SCORE_SUCCEEDED, scoreReportSuccess);
		_leaderboardCallback(true);
		trace( "localPlayerScoreReported" );
	}

	public function checkForAchievements(userData:Vector.<UserLevelData>):void {
		if(GameCenterController.isSupported){
			if(_gcController.authenticated){
				for(var i:uint = 0 ; i < userData.length ; i ++ ){
					if(userData[i].achievementComplete){
						var ach:String = _gameCenterData[userData[i].id].achievement_id;
						_gcController.submitAchievement(ach,100);
					}
				}
			}
		}
	}
}
}
