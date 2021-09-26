package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class ShopState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var currChanges:String = "dk";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('shop/EmptyShop', 'preload'));
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.screenCenter();
		add(bg);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			leftState = true;
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
