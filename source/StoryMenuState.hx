package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{	
	var props:FlxSprite;
	var toads:FlxSprite;
	var lock:FlxSprite;
	var streamers:FlxSprite;
	var lockedstreamers:FlxSprite;
	var chapterselectbox:FlxSprite;
	var chaptertext:FlxSprite;
	var greychaptertext:FlxSprite;
	var scoreText:FlxText;
	var chapterload:FlxSprite;

	var weekData:Array<Dynamic> = [
		//add picnic road back
		['PicnicRoad', 'RedStreamerBattle', 'MissileMaestro'],
		['Bopeebo', 'Fresh', 'Dad Battle'],
		['YellowStreamerBattle', 'ThrillsAtNight', 'DiscoDevil'],
		['Pico', 'Philly Nice', "Blammed"],
		['Satin Panties', "High", "Milf"],
		['Cocoa', 'Eggnog', 'Winter Horrorland']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, false, false, false, false, false];
	

	var weekCharacters:Array<Dynamic> = [
		['colors', 'bf', 'gf'],
		['', 'bf', 'gf'],
		['', 'bf', 'gf'],
		['', 'bf', 'gf'],
		['', 'bf', 'gf'],
		['', 'bf', 'gf']
	];


	// This is legit fucking spagetti code. I am so sorry ninjamuffin I have failed you. I must now pray to my new lord and savior of spagetti code, Yandare Dev - LK
	
	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	// var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var ChapterSelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var upArrow:FlxSprite;
	var downArrow:FlxSprite;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		//DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(610, 195, 0, "SCORE: 49324858", 30);
		scoreText.setFormat("New Super Mario Font U", 30, FlxTextAlign.CENTER);
		scoreText.screenCenter(X);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		var stagebg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stagebackground'));
			stagebg.setGraphicSize(Std.int(stagebg.width * 0.55));
			stagebg.updateHitbox();
			stagebg.antialiasing = true;
			stagebg.active = false;
			add(stagebg);

		props = new FlxSprite(-60, -20);
					props.frames = Paths.getSparrowAtlas('stageprops');
					props.animation.addByPrefix('propboplol', "propboplol", 24);
					props.antialiasing = true;
					props.setGraphicSize(Std.int(props.width * 0.55));
					props.updateHitbox();
					add(props);
					props.animation.play('propboplol');
		
		var campaignstage:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('stagefloor'));
			campaignstage.setGraphicSize(Std.int(campaignstage.width * 0.55));
			campaignstage.updateHitbox();
			campaignstage.antialiasing = true;
			campaignstage.active = false;
			add(campaignstage);

		lockedstreamers = new FlxSprite(0, 0);
			lockedstreamers.frames = Paths.getSparrowAtlas('streamer');
			lockedstreamers.animation.addByPrefix('locked', "lockedstreamer", 24);
			lockedstreamers.antialiasing = true;
			lockedstreamers.setGraphicSize(Std.int(props.width * 0.9));
			lockedstreamers.updateHitbox();
			add(lockedstreamers);
			lockedstreamers.animation.play('locked');

		streamers = new FlxSprite(0, 0);
			streamers.frames = Paths.getSparrowAtlas('streamer');
			streamers.animation.addByPrefix('red', "redstreamer", 24);
			streamers.animation.addByPrefix('blue', "bluestreamer", 24);
			streamers.animation.addByPrefix('yellow', "yellowstreamer", 24);
			streamers.animation.addByPrefix('purple', "purplestreamer", 24);
			streamers.animation.addByPrefix('green', "greenstreamer", 24);
			streamers.antialiasing = true;
			streamers.setGraphicSize(Std.int(props.width * 0.9));
			streamers.updateHitbox();
			add(streamers);
			streamers.animation.play('red');

		chapterload = new FlxSprite(0, 0);
			chapterload.frames = Paths.getSparrowAtlas('chapterload');
			chapterload.animation.addByPrefix('loadin', "loadin", 13);
			chapterload.antialiasing = true;
			chapterload.setGraphicSize(Std.int(chapterload.width * 0.65));
			chapterload.updateHitbox();

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));
		add(grpWeekCharacters);

		var stagecurtains:FlxSprite = new FlxSprite(0, -300).loadGraphic(Paths.image('stagecurtains'));
			stagecurtains.setGraphicSize(Std.int(stagecurtains.width * 0.5));
			stagecurtains.updateHitbox();
			stagecurtains.antialiasing = true;
			stagecurtains.active = false;
			add(stagecurtains);

		var curtainabove:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('curtainabove'));
			curtainabove.setGraphicSize(Std.int(curtainabove.width * 0.55));
			curtainabove.updateHitbox();
			curtainabove.antialiasing = true;
			curtainabove.active = false;
			add(curtainabove);

		toads = new FlxSprite(0, 15);
					toads.frames = Paths.getSparrowAtlas('tods');
					toads.animation.addByPrefix('todbop', "todbop", 24);
					toads.antialiasing = true;
					toads.setGraphicSize(Std.int(toads.width * 0.505));
					toads.updateHitbox();
					add(toads);
					toads.animation.play('todbop');

		var layeringbox:FlxSprite = new FlxSprite(425, -300).loadGraphic(Paths.image('chapterselect'));
			layeringbox.setGraphicSize(Std.int(layeringbox.width * 0.55));
			layeringbox.updateHitbox();
			layeringbox.antialiasing = true;
			layeringbox.active = true;
			add(layeringbox);

		greychaptertext = new FlxSprite(450, -235);
			greychaptertext.frames = Paths.getSparrowAtlas('storymenu/greychapters');
			greychaptertext.animation.addByPrefix('chapter1', "chapter0000", 24);
			greychaptertext.animation.addByPrefix('chapter2', "chapter0001", 24);
			greychaptertext.animation.addByPrefix('chapter3', "chapter0002", 24);
			greychaptertext.animation.addByPrefix('chapter4', "chapter0003", 24);
			greychaptertext.animation.addByPrefix('chapter5', "chapter0004", 24);
			greychaptertext.animation.addByPrefix('chapter6', "chapter0005", 24);
			greychaptertext.antialiasing = true;
			greychaptertext.setGraphicSize(Std.int(greychaptertext.width * 0.55));
			greychaptertext.updateHitbox();
			greychaptertext.animation.play('chapter1');

		lock = new FlxSprite(425, -300);
		lock.frames = ui_tex;
		lock.setGraphicSize(Std.int(lock.width * 0.55));
		lock.updateHitbox();
		lock.animation.addByPrefix('lock', "lock");
		lock.animation.play('lock');

		chapterselectbox = new FlxSprite(425, -300).loadGraphic(Paths.image('chapterselect'));
			chapterselectbox.setGraphicSize(Std.int(chapterselectbox.width * 0.55));
			chapterselectbox.updateHitbox();
			chapterselectbox.antialiasing = true;
			chapterselectbox.active = true;
			add(chapterselectbox);
			
		chaptertext = new FlxSprite(450, -235);
			chaptertext.frames = Paths.getSparrowAtlas('storymenu/chapters');
			chaptertext.animation.addByPrefix('chapter1', "chapter0000", 24);
			chaptertext.animation.addByPrefix('chapter2', "chapter0001", 24);
			chaptertext.animation.addByPrefix('chapter3', "chapter0002", 24);
			chaptertext.animation.addByPrefix('chapter4', "chapter0003", 24);
			chaptertext.animation.addByPrefix('chapter5', "chapter0004", 24);
			chaptertext.animation.addByPrefix('chapter6', "chapter0005", 24);
			chaptertext.antialiasing = true;
			chaptertext.setGraphicSize(Std.int(chaptertext.width * 0.55));
			chaptertext.updateHitbox();
			chaptertext.animation.play('chapter1');

		var scorebox:FlxSprite = new FlxSprite(540, 190).loadGraphic(Paths.image('score'));
			scorebox.setGraphicSize(Std.int(scorebox.width * 0.5));
			scorebox.updateHitbox();
			scorebox.antialiasing = true;
			scorebox.active = false;
			add(scorebox);

		var trackbox:FlxSprite = new FlxSprite(43, 535).loadGraphic(Paths.image('track'));
			trackbox.setGraphicSize(Std.int(trackbox.width * 0.5));
			trackbox.updateHitbox();
			trackbox.antialiasing = true;
			trackbox.active = true;
			add(trackbox);

		var tracktext:FlxSprite = new FlxSprite(60, 545).loadGraphic(Paths.image('tracktext'));
			tracktext.setGraphicSize(Std.int(trackbox.width * 0.25));
			tracktext.updateHitbox();
			tracktext.antialiasing = true;
			tracktext.active = true;
			add(tracktext);

			add(greychaptertext);
			add(chaptertext);

			// FlxTween.tween(scorebox, { x: 0, y: 0 }, 1); 
			FlxTween.tween(chapterselectbox, { y: 0 }, 1); 
			FlxTween.tween(layeringbox, { y: 0 }, 1);
			FlxTween.tween(lock, { y: 0 }, 1);
			FlxTween.tween(chaptertext, { y: 35 }, 1);
			FlxTween.tween(greychaptertext, { y: 35 }, 1); 
			FlxTween.tween(stagecurtains, { y: -17 }, 1); 

		// grpWeekText  = new FlxTypedGroup<MenuItem>();
		// add(grpWeekText);

		// var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		// add(blackBarThingie);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			// var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			//weekThing.y += ((weekThing.height + 20) * i);
			//weekThing.targetY = i;
			// grpWeekText.add(weekThing);

			// weekThing.screenCenter(X);
			// weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
	}

		trace("Line 96");

		ChapterSelectors = new FlxGroup();
		add(ChapterSelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(340, 50);
		leftArrow.frames = ui_tex;
		leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.45));
		leftArrow.updateHitbox();
		leftArrow.animation.addByPrefix('idle', "leftarrowidle");
		leftArrow.animation.addByPrefix('press', "leftarrowpress");
		leftArrow.animation.play('idle');
		ChapterSelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(1070, 700);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.setGraphicSize(Std.int(chapterselectbox.width * 0.35));
		sprDifficulty.updateHitbox();
		sprDifficulty.animation.addByPrefix('easy', 'Easy');
		sprDifficulty.animation.addByPrefix('normal', 'Normal');
		sprDifficulty.animation.addByPrefix('hard', 'Hard');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		add(sprDifficulty);

		rightArrow = new FlxSprite(chapterselectbox.x + 480, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.setGraphicSize(Std.int(leftArrow.width));
		rightArrow.updateHitbox();
		rightArrow.animation.addByPrefix('idle', 'rightarrowidle');
		rightArrow.animation.addByPrefix('press', "rightarrowpress", 24, false);
		rightArrow.animation.play('idle');
		ChapterSelectors.add(rightArrow);

		upArrow = new FlxSprite(1137, 420);
		upArrow.frames = ui_tex;
		upArrow.setGraphicSize(Std.int(leftArrow.width));
		upArrow.updateHitbox();
		upArrow.animation.addByPrefix('idle', 'uparrowidle');
		upArrow.animation.addByPrefix('press', "uparrowpress", 24, false);
		upArrow.animation.play('idle');
		add(upArrow);

		downArrow = new FlxSprite(upArrow.x, upArrow.y + 225);
		downArrow.frames = ui_tex;
		downArrow.setGraphicSize(Std.int(leftArrow.width));
		downArrow.updateHitbox();
		downArrow.animation.addByPrefix('idle', 'downarrowidle');
		downArrow.animation.addByPrefix('press', "downarrowpress", 24, false);
		downArrow.animation.play('idle');
		add(downArrow);

		trace("Line 150");

		// add(yellowBG);

		txtTracklist = new FlxText(60, 520, Std.int(FlxG.width * 0.6), "", 30);
		txtTracklist.font = 'New Super Mario Font U';
		txtTracklist.color = 0xFFFFFFFF;
		add(txtTracklist);
		
		add(scoreText);

		updateText();

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		var ui_tex = Paths.getSparrowAtlas('UI_assets');
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "" + lerpScore;
		scoreText.screenCenter(X);

		// FlxG.watch.addQuick('font', scoreText.font);

		    streamers.visible = weekUnlocked[curWeek];
			chaptertext.visible = weekUnlocked[curWeek];
			chapterselectbox.visible = weekUnlocked[curWeek];

		if (weekUnlocked[curWeek])
		{
			remove(lock);
		}
		else{
			add(lock);
		}

		//grpLocks.forEach(function(lock:FlxSprite)
		//{
		//	remove(streamers);
		//		streamers.animation.play('locked');
		//		add(streamers);
			//lock.y = grpWeekText.members[lock.ID].y;
		// });

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.LEFT_P)
				{
					if(curWeek == 0)
					{
				
					}
					else
					{
						changeWeek(-1);
					}
	
					
				}

				if (controls.RIGHT_P)
				{
					if(curWeek == 5)
					{
						
					}
					else
					{
						changeWeek(1);
					}
					
				}

				if (controls.UP_P)
				{
					changeDifficulty(1);
				}

				if (controls.DOWN_P)
				{
					changeDifficulty(-1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.UP)
					upArrow.animation.play('press');
				else
					upArrow.animation.play('idle');
				if (controls.DOWN)
					downArrow.animation.play('press');
				else
					downArrow.animation.play('idle');
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;

			add(chapterload);
				chapterload.animation.play('loadin');

			new FlxTimer().start(0.95, function(tmr:FlxTimer)
			{
				chapterload.animation.pause();
				transOut = null;
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 70;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
			case 1:
				sprDifficulty.animation.play('normal');
			case 2:
				sprDifficulty.animation.play('hard');
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		   sprDifficulty.y = leftArrow.y + 400;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		   FlxTween.tween(sprDifficulty, {y: leftArrow.y + 430, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		// i'm not good enough at coding to understand how tf you properly switch week images - LK

			switch (curWeek)
		{
			case 0:
				chaptertext.animation.play('chapter1');
				chaptertext.offset.x = 180;
				greychaptertext.animation.play('chapter1');
				greychaptertext.offset.x = 180;
				remove(streamers);
				streamers.animation.play('red');
				add(streamers);
			case 1:
				chaptertext.animation.play('chapter2');
				chaptertext.offset.x = 190;
				greychaptertext.animation.play('chapter2');
				greychaptertext.offset.x = 190;
				remove(streamers);
				streamers.animation.play('blue');
				add(streamers);
			case 2:
				chaptertext.animation.play('chapter3');
				chaptertext.offset.x = 189;
				greychaptertext.animation.play('chapter3');
				greychaptertext.offset.x = 189;
				remove(streamers);
				streamers.animation.play('yellow');
				add(streamers);
			case 3:
				chaptertext.animation.play('chapter4');
				chaptertext.offset.x = 193;
				greychaptertext.animation.play('chapter4');
				greychaptertext.offset.x = 193;
				remove(streamers);
				streamers.animation.play('purple');
				add(streamers);
			case 4:
				chaptertext.animation.play('chapter5');
				chaptertext.offset.x = 186;
				greychaptertext.animation.play('chapter5');
				greychaptertext.offset.x = 186;
				remove(streamers);
				streamers.animation.play('green');
				add(streamers);	
			case 5:
				chaptertext.animation.play('chapter6');
				chaptertext.offset.x = 167;
				greychaptertext.animation.play('chapter6');
				greychaptertext.offset.x = 167;
				remove(streamers);
		}


		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
