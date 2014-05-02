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

public class AssetsManager {

	[Embed(source="/assets/fonts/kubus_score.png")]
	private static const KubusScoreAtlas:Class;
	[Embed(source="/assets/fonts/kubus_score.xml", mimeType="application/octet-stream")]
	private static const KubusScoreXML:Class;
	[Embed(source="/assets/fonts/kubus_24.png")]
	private static const Kubus24Atlas:Class;
	[Embed(source="/assets/fonts/kubus_24.xml", mimeType="application/octet-stream")]
	private static const Kubus24XML:Class;
	[Embed(source="/assets/fonts/kubus_title.png")]
	private static const KubusTitleAtlas:Class;
	[Embed(source="/assets/fonts/kubus_title.xml", mimeType="application/octet-stream")]
	private static const KubusTitleXML:Class;
	[Embed(source="/assets/fonts/kubus_stroke.png")]
	private static const KubusStrokeAtlas:Class;
	[Embed(source="/assets/fonts/kubus_stroke.xml", mimeType="application/octet-stream")]
	private static const KubusStrokeXML:Class;
	[Embed(source="/assets/fonts/kubus.png")]
	private static const KubusAtlas:Class;
	[Embed(source="/assets/fonts/kubus.xml", mimeType="application/octet-stream")]
	private static const KubusXML:Class;
	[Embed(source="/assets/ui/tutorial_hand.png")]
	private static const TutorialHand:Class;
	[Embed(source="/assets/ui/tutorial_target.png")]
	private static const TutorialTarget:Class;
	[Embed(source="/assets/ui/btn_background.png")]
	private static const ButtonBackground:Class;
	[Embed(source="/assets/ui/btn_background_large.png")]
	private static const ButtonBackgroundLarge:Class;
	[Embed(source="/assets/ui/checkbox.jpg")]
	private static const CheckBox:Class;
	[Embed(source="/assets/ui/checkmark.png")]
	private static const CheckMark:Class;
	[Embed(source="/assets/ui/header_en.png")]
	private static const HeaderEnglish:Class;
	[Embed(source="/assets/ui/header_fr.png")]
	private static const HeaderFrench:Class;
	[Embed(source="/assets/ui/logo.png")]
	private static const Logo:Class;
	[Embed(source="/assets/ui/level_btn_bg.png")]
	private static const LevelButton:Class;
	[Embed(source="/assets/ui/level_btn_bg_locked.png")]
	private static const LevelButtonLocked:Class;
	[Embed(source="/assets/ui/pause_btn.png")]
	private static const PauseButton:Class;
	[Embed(source="/assets/ui/popup_bg_corner.jpg")]
	private static const PopupBackgroundCorner:Class;
	[Embed(source="/assets/ui/popup_bg_side.jpg")]
	private static const PopupBackgroundSide:Class;
	[Embed(source="/assets/gesture/circle04.jpg")]
	private static const CircleGesture:Class;
	[Embed(source="/assets/gesture/triangle_gesture.png")]
	private static const TriangleGesture:Class;
	[Embed(source="/assets/particles/particle2.png")]
	private static const Particle:Class;
	[Embed(source="/assets/particles/bonus_particle.png")]
	private static const BonusParticle:Class;
	[Embed(source="/assets/data/levels.json", mimeType='application/octet-stream')]
	public static const Levels:Class;



	public static var SquareTexture:GTexture;

	public function AssetsManager() {
		GTextureAtlasFactory.createFromBitmapDataAndXml("KubusStroke", new KubusStrokeAtlas().bitmapData,new XML(new KubusStrokeXML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus", new KubusAtlas().bitmapData,new XML(new KubusXML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("KubusTitle", new KubusTitleAtlas().bitmapData,new XML(new KubusTitleXML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("Kubus24", new Kubus24Atlas().bitmapData,new XML(new Kubus24XML()));
		GTextureAtlasFactory.createFromBitmapDataAndXml("KubusScore", new KubusScoreAtlas().bitmapData,new XML(new KubusScoreXML()));
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
		GTextureFactory.createFromEmbedded("gesture_particle",Particle);
		GTextureFactory.createFromEmbedded("bonus_particle",BonusParticle);
		var cGestureTexture:GTexture = GTextureFactory.createFromEmbedded("circle_gesture",CircleGesture);
		cGestureTexture.g2d_filteringType = GTextureFilteringType.LINEAR;
		GTextureFactory.createFromEmbedded("triangle_gesture",TriangleGesture);
		GTextureFactory.createFromEmbedded("level_btn_bg",LevelButton);
		GTextureFactory.createFromEmbedded("level_btn_bg_locked",LevelButtonLocked);
		GTextureFactory.createFromBitmapData("rectangle_gesture",new BitmapData(1024, 1024, true, 0x7fffffff));
		for (var i:uint = 0 ; i < 100 ; i++ ) {
			var size:uint = 4 + (Math.round(Math.random() * 60));
			GTextureFactory.createFromBitmapData("test" + i.toString(),new BitmapData(size,size,true, 0x22ffffff));
		}

		SquareTexture = GTextureFactory.createFromBitmapData("squareTexture", new BitmapData(4,4,true,0x99ffffff));
//		_textureCaught = GTextureFactory.createFromBitmapData("texture_caught", new BitmapData(4,4,true,0x99ffffff));
		SquareTexture.g2d_filteringType = GTextureFilteringType.LINEAR;
//		_textureCaught.g2d_filteringType = GTextureFilteringType.LINEAR;


		GTextureFactory.createFromBitmapData("tutorial_bg",new BitmapData(2, 2, true, 0x7fffffff));
		GTextureFactory.createFromBitmapData("tutorial_stroke",new BitmapData(2, 2, false, 0xffffffff));
		GTextureFactory.createFromEmbedded("tutorial_hand",TutorialHand);
		GTextureFactory.createFromEmbedded("tutorial_target",TutorialTarget);

	}
}
}
