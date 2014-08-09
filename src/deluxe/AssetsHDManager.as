/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-23
 * Time: 18:33
 * To change this template use File | Settings | File Templates.
 */
package deluxe {
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;

import flash.display.BitmapData;
import flash.media.Sound;

public class AssetsHDManager {

	[Embed(source="/assets/ui/fonts/hd/kubus_12.png")]
	private static var KubusScoreAtlas:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_12.xml", mimeType="application/octet-stream")]
	private static var KubusScoreXML:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_24.png")]
	private static var Kubus24Atlas:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_24.xml", mimeType="application/octet-stream")]
	private static var Kubus24XML:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_72.png")]
	private static var KubusTitleAtlas:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_72.xml", mimeType="application/octet-stream")]
	private static var KubusTitleXML:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_36_stroke.png")]
	private static var KubusStrokeAtlas:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_36_stroke.xml", mimeType="application/octet-stream")]
	private static var KubusStrokeXML:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_36.png")]
	private static var KubusAtlas:Class;
	[Embed(source="/assets/ui/fonts/hd/kubus_36.xml", mimeType="application/octet-stream")]
	private static var KubusXML:Class;
	[Embed(source="/assets/ui/hd/tutorial_hand.png")]
	private static var TutorialHand:Class;
	[Embed(source="/assets/ui/hd/tutorial_target.png")]
	private static var TutorialTarget:Class;
	[Embed(source="/assets/ui/hd/btn_background.png")]
	private static var ButtonBackground:Class;
	[Embed(source="/assets/ui/hd/btn_background_large.png")]
	private static var ButtonBackgroundLarge:Class;
	[Embed(source="/assets/ui/hd/checkbox.jpg")]
	private static var CheckBox:Class;
	[Embed(source="/assets/ui/hd/checkmark.png")]
	private static var CheckMark:Class;
	[Embed(source="/assets/ui/hd/header_en.png")]
	private static var HeaderEnglish:Class;
	[Embed(source="/assets/ui/hd/header_fr.png")]
	private static var HeaderFrench:Class;
	[Embed(source="/assets/ui/hd/logo.png")]
	private static var Logo:Class;
	[Embed(source="/assets/ui/hd/level_btn_bg.png")]
	private static var LevelButton:Class;
	[Embed(source="/assets/ui/hd/level_btn_bg_locked.png")]
	private static var LevelButtonLocked:Class;
	[Embed(source="/assets/ui/hd/pause_btn.png")]
	private static var PauseButton:Class;
	[Embed(source="/assets/ui/hd/popup_bg_corner.jpg")]
	private static var PopupBackgroundCorner:Class;
	[Embed(source="/assets/ui/hd/popup_bg_side.jpg")]
	private static var PopupBackgroundSide:Class;
	[Embed(source="/assets/gesture/hd/circle04.jpg")]
	private static var CircleGesture:Class;
	[Embed(source="/assets/particles/hd/particle2.png")]
	private static var Particle:Class;
	[Embed(source="/assets/particles/hd/bonus_particle.png")]
	private static var BonusParticle:Class;
	[Embed(source="/assets/ui/hd/splash.jpg")]
	public static var Splash:Class;

	public static var SquareTexture:GTexture;

	public function AssetsHDManager() {
		GameData.RESOLUTION_FACTOR = 2;
		//FONTS
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus36Stroke", new KubusStrokeAtlas().bitmapData,new XML(new KubusStrokeXML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus36", new KubusAtlas().bitmapData,new XML(new KubusXML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus72", new KubusTitleAtlas().bitmapData,new XML(new KubusTitleXML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus24", new Kubus24Atlas().bitmapData,new XML(new Kubus24XML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus12", new KubusScoreAtlas().bitmapData,new XML(new KubusScoreXML()));
		//UI
		GTextureFactory.createFromBitmapData("fullscreen_bg",new BitmapData(GameData.STAGE_WIDTH,GameData.STAGE_HEIGHT, true, 0x99000000));
		GTextureFactory.createFromBitmapData("popup_bg",new BitmapData(16,16, false, 0xff000000));
		GTextureFactory.createFromEmbedded("btnBackground",ButtonBackground);
		GTextureFactory.createFromEmbedded("btnBackgroundLarge",ButtonBackgroundLarge);
		GTextureFactory.createFromEmbedded("checkmark",CheckMark);
		GTextureFactory.createFromEmbedded("checkbox",CheckBox);
		GTextureFactory.createFromEmbedded("logo",Logo);
		GTextureFactory.createFromEmbedded("header_fr",HeaderFrench);
		GTextureFactory.createFromEmbedded("header_en",HeaderEnglish);
		GTextureFactory.createFromEmbedded("pause_btn",PauseButton);
		GTextureFactory.createFromEmbedded("popup_bg_corner",PopupBackgroundCorner);
		GTextureFactory.createFromEmbedded("popup_bg_side",PopupBackgroundSide);
		GTextureFactory.createFromEmbedded("level_btn_bg",LevelButton);
		GTextureFactory.createFromEmbedded("level_btn_bg_locked",LevelButtonLocked);
		for (var i:uint = 0 ; i < 100 ; i++ ) {
			var size:uint = 4 + (Math.round(Math.random() * 60));
			GTextureFactory.createFromBitmapData("test" + i.toString(),new BitmapData(size,size,true, 0x22ffffff));
		}
		//TUTORIAL
		GTextureFactory.createFromBitmapData("tutorial_bg",new BitmapData(2, 2, true, 0x7fffffff));
		GTextureFactory.createFromBitmapData("tutorial_stroke",new BitmapData(2, 2, false, 0xffffffff));
		GTextureFactory.createFromEmbedded("tutorial_hand",TutorialHand);
		GTextureFactory.createFromEmbedded("tutorial_target",TutorialTarget);
		//GAMESCENE
		GTextureFactory.createFromEmbedded("gesture_particle",Particle);
		GTextureFactory.createFromEmbedded("bonus_particle",BonusParticle);
		var cGestureTexture:GTexture = GTextureFactory.createFromEmbedded("circle_gesture",CircleGesture);
		cGestureTexture.g2d_filteringType = GTextureFilteringType.LINEAR;
		SquareTexture = GTextureFactory.createFromBitmapData("squareTexture", new BitmapData(4,4,true,0x99ffffff));
		SquareTexture.g2d_filteringType = GTextureFilteringType.LINEAR;
	}


	public static function nullify():void {
		KubusScoreAtlas = null;
		KubusScoreXML = null;
		Kubus24Atlas = null;
		Kubus24XML = null;
		KubusTitleAtlas = null;
		KubusTitleXML = null;
		KubusStrokeAtlas = null;
		KubusStrokeXML = null;
		KubusAtlas = null;
		KubusXML = null;
		TutorialHand = null;
		TutorialTarget = null;
		ButtonBackground = null;
		ButtonBackgroundLarge = null;
		CheckBox = null;
		CheckMark = null;
		HeaderEnglish = null;
		HeaderFrench = null;
		Logo = null;
		LevelButton = null;
		LevelButtonLocked = null;
		PauseButton = null;
		PopupBackgroundCorner = null;
		PopupBackgroundSide = null;
		CircleGesture = null;
		Particle = null;
		BonusParticle = null;
	}
}
}
