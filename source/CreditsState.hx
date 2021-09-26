package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var creditShit:Array<String> = ['ninkey', 'mol', 'snak', 'lemonking', 'doodlz', 'fruitsy', 'hostkal', 'soulegal', 'aizakku', 'xyle', 'juno'];

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Reading Credits", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGCredits'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.setGraphicSize(Std.int(bg.width * 1.35));
		bg.antialiasing = true;
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_credit_assets');

		for (i in 0...creditShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', creditShit[i] + " grey", 24);
			menuItem.animation.addByPrefix('selected', creditShit[i] + " color", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.3));
			menuItem.ID = i;
			switch (menuItem.ID)
			{
				case 0:
				menuItem.y = 0;

				case 1:
				menuItem.y += 180;

				case 2:
				menuItem.y += 360;

				case 3:
				menuItem.y += 540;

				case 4:
				menuItem.y = 0;
				menuItem.x += 700;

				case 5:
				menuItem.y += 100;
				menuItem.x += 700;

				case 6:
				menuItem.y += 200;
				menuItem.x += 700;

				case 7:
				menuItem.y += 310;
				menuItem.x += 700;

				case 8:
				menuItem.y = 400;
				menuItem.x += 700;

				case 9:
				menuItem.y += 500;
				menuItem.x += 700;

				case 10:
				menuItem.y += 600;
				menuItem.x += 700;
			}
			menuItem.updateHitbox();
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			finishedFunnyMove = true; 
			changeItem();
		}

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				if (curSelected != 10)
				changeItem(1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(4);
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				if (curSelected >= 8)
				{
				curSelected = 3;
				changeItem();
				}
				else
				changeItem(-4);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				switch (creditShit[curSelected])
				{
				case 'ninkey':
					fancyOpenURL("https://twitter.com/NinKey69");

				case 'lemonking':
					fancyOpenURL("https://twitter.com/1emonking");

				case 'mol':
					fancyOpenURL("https://twitter.com/ArtPanz");

				case 'doodlz':
					fancyOpenURL("https://twitter.com/xdoodlz");

				case 'snak':
					fancyOpenURL("https://twitter.com/200thSnak");

				case 'fruitsy':
					fancyOpenURL("https://twitter.com/FruitsyOG");

				case 'soulegal':
					fancyOpenURL("https://twitter.com/nickstwt");
				
				case 'juno':
					fancyOpenURL("https://twitter.com/JunoSongsYT");

				case 'xyle':
					fancyOpenURL("https://www.youtube.com/c/XyleGD");
				}
			}
			}

		super.update(elapsed);
	}


	var yourealreadyonthatmf:Bool = false;

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= 11)
				curSelected = 10;
			if (curSelected < 0)
				curSelected = 0;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}
