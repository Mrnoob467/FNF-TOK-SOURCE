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

class MainMenuState extends MusicBeatState
{
	var Checkerboard:FlxSprite;
	var FadeStuff:FlxSprite;
	var Image:FlxSprite;
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'shop', 'settings', 'credits', 'settings'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay', 'shop'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		//DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		Image = new FlxSprite(-13.5, -10.8);
		Image.frames = Paths.getSparrowAtlas('fadestuff');
		Image.setGraphicSize(Std.int(Image.width * 0.38));
		Image.animation.addByPrefix('story', 'story', 24);
		Image.animation.addByPrefix('freeplay', 'freeplay', 24);
		Image.animation.addByPrefix('credits', 'credits', 24);
		Image.animation.addByPrefix('shop', 'shop', 24);
		Image.animation.addByPrefix('settings', 'settings', 24);
		Image.animation.play('story');
		Image.updateHitbox();
		add(Image);


		FadeStuff = new FlxSprite(-13.5, -10.8);
		FadeStuff.frames = Paths.getSparrowAtlas('fadestuff');
		FadeStuff.setGraphicSize(Std.int(Image.width));
		FadeStuff.animation.addByPrefix('story', 'story', 24);
		FadeStuff.animation.addByPrefix('freeplay', 'freeplay', 24);
		FadeStuff.animation.addByPrefix('credits', 'credits', 24);
		FadeStuff.animation.addByPrefix('shop', 'shop', 24);
		FadeStuff.animation.addByPrefix('settings', 'settings', 24);
		FadeStuff.alpha = 0;
		FadeStuff.animation.play('story');
		FadeStuff.updateHitbox();
		add(FadeStuff);

		Checkerboard = new FlxSprite(-100).loadGraphic(Paths.image('Pp'));
		Checkerboard.setGraphicSize(Std.int(Image.width));
		Checkerboard.updateHitbox();
		Checkerboard.screenCenter();
		Checkerboard.antialiasing = true;
		add(Checkerboard);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-1000, 30 + (i * 185));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.23));
			menuItem.ID = i;
			switch (menuItem.ID)
			{
				case 2:
				menuItem.y -= 90;
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.2));

				case 3:
				menuItem.y -= 120;

				case 4:
				menuItem.y -= 190;
			}
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{x: 70},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
			{
				menuItem.y = 30 + (i * 185);
				menuItem.x = 70;

				switch (menuItem.ID)
			{
				case 2:
				menuItem.y -= 90;
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.2));

				case 3:
				menuItem.y -= 120;

				case 4:
				menuItem.y -= 190;
			}
			}
		}

		firstStart = false;

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " - August 5 DEV BUILD " : ""), 12);
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
	var firsttime = true;
	var canfade = true;

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (canfade == true)
	{
		canfade = false;

		switch (curSelected)
		{
			case 0:
			FadeStuff.animation.play('story');
			FlxTween.tween(FadeStuff, {alpha: 1}, 0.15, {
					//ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						Image.animation.play('story');
						FadeStuff.alpha = 0;
					}
					});

			case 1:
			FadeStuff.animation.play('freeplay');
			FlxTween.tween(FadeStuff, {alpha: 1}, 0.15, {
					//ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						Image.animation.play('freeplay');
						FadeStuff.alpha = 0;
					}
					});
			case 2:
			FadeStuff.animation.play('shop');
			FlxTween.tween(FadeStuff, {alpha: 1}, 0.15, {
					//ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						Image.animation.play('shop');
						FadeStuff.alpha = 0;
					}
					});
			case 3:
			FadeStuff.animation.play('settings');
			FlxTween.tween(FadeStuff, {alpha: 1}, 0.15, {
					//ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						Image.animation.play('settings');
						FadeStuff.alpha = 0;
					}
					});
			case 4:
			FadeStuff.animation.play('credits');
			FlxTween.tween(FadeStuff, {alpha: 1}, 0.15, {
					//ease: FlxEase.expoInOut,
					onComplete: function(twn:FlxTween)
					{
						Image.animation.play('credits');
						FadeStuff.alpha = 0;
					}
					});
		}
	}


		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
				canfade = true;
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
				canfade = true;
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
							FlxTween.tween(spr, {x: -1000}, 1.3, {
								ease: FlxEase.expoInOut,
								onComplete: function(twn:FlxTween)
								{
									goToState();
								}
							});
					});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");
			case 'shop':
				FlxG.switchState(new ShopState());
			case 'credits':
				FlxG.switchState(new CreditsState());
			case 'settings':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= 5)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = 4;
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
