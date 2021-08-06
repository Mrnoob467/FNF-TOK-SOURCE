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
	var rightscroll:FlxSprite;
	var rightclonescroll:FlxSprite;
	var leftscroll:FlxSprite;
	var leftclonescroll:FlxSprite;
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'credits', 'settings'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
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

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		//bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		rightscroll = new FlxSprite(871, -1623).loadGraphic(Paths.image('rightscroll'));
		rightscroll.setGraphicSize(Std.int(rightscroll.width * 0.65));
		rightscroll.updateHitbox();
		rightscroll.antialiasing = true;

		rightclonescroll = new FlxSprite(rightscroll.x, rightscroll.y).loadGraphic(Paths.image('rightscroll'));
		rightclonescroll.setGraphicSize(Std.int(rightscroll.width));
		rightclonescroll.updateHitbox();
		rightclonescroll.antialiasing = true;

		var blackbackright:FlxSprite = new FlxSprite(rightscroll.x, 0).loadGraphic(Paths.image('blackback'));
		blackbackright.setGraphicSize(Std.int(rightscroll.width));
		blackbackright.updateHitbox();
		blackbackright.antialiasing = true;
		add(blackbackright);

		leftscroll = new FlxSprite(0, 0).loadGraphic(Paths.image('leftscroll'));
		leftscroll.setGraphicSize(Std.int(rightscroll.width));
		leftscroll.updateHitbox();
		leftscroll.antialiasing = true;

		leftclonescroll = new FlxSprite(leftscroll.x, leftscroll.y).loadGraphic(Paths.image('leftscroll'));
		leftclonescroll.setGraphicSize(Std.int(rightscroll.width));
		leftclonescroll.updateHitbox();
		leftclonescroll.antialiasing = true;

		var blackbackleft:FlxSprite = new FlxSprite(-98, 0).loadGraphic(Paths.image('blackback'));
		blackbackleft.setGraphicSize(Std.int(rightscroll.width));
		blackbackleft.updateHitbox();
		blackbackleft.antialiasing = true;
		add(blackbackleft);

		gorightscroll();

		add(rightscroll);
		add(rightclonescroll);

		add(leftscroll);
		add(leftclonescroll);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);
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
	var rightcango:Bool = false;
	var clonecango:Bool = false;
	
	function gorightscroll()
	{	
		if (firsttime == true)
		{
			leftscroll.y = 0;
			rightscroll.y = 0;
			clonecango = true;
			firsttime = false;
			FlxTween.tween(rightscroll, { y: 720 }, 10.6469500924); // school is over yet i still had to do algebra smh
			FlxTween.tween(leftscroll, { y: 720 }, 10.6469500924);
		}
		else
		{
		FlxTween.tween(rightscroll, { y: 0 }, 24); 
		FlxTween.tween(leftscroll, { y: 0 }, 24); 
		new FlxTimer().start(24, function(tmr:FlxTimer)
		{
			clonecango = true;
			FlxTween.tween(rightscroll, { y: 720 }, 10.6469500924); 
			FlxTween.tween(leftscroll, { y: 720 }, 10.6469500924); 
		});
		}
	}

	function goclonerightscroll()
	{
		FlxTween.tween(rightclonescroll, { y: 0 }, 24); 
		FlxTween.tween(leftclonescroll, { y: 0 }, 24);
			new FlxTimer().start(24, function(tmr:FlxTimer)
		{
			rightcango = true;
			FlxTween.tween(rightclonescroll, { y: 720 }, 10.6469500924);
			FlxTween.tween(leftclonescroll, { y: 720 }, 10.6469500924);  
		});
	}



	override function update(elapsed:Float)
	{

		if (clonecango == true)
		{
			rightclonescroll.y = -1623;
			leftclonescroll.y = -1623;
			clonecango = false;
			goclonerightscroll();
		}

		if (rightcango == true)
		{
			rightscroll.y = -1623;
			leftscroll.y = -1623;
			rightcango = false;
			gorightscroll();
		}

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
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
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

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
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
