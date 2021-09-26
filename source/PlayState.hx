package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import flixel.effects.FlxFlicker;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var resultsscreen:Bool = false;

	var halloweenLevel:Bool = false;

	var isanendingcutscene = false;

	var tween:FlxTween;

	var cranes:FlxSprite;
	var yapeboppers:FlxSprite;
	var MountainWall:FlxSprite;
	var MountainWallClone:FlxSprite;
	var water:FlxSprite;
	var topstage:FlxSprite;
	var heroesdance:FlxSprite;
	var toadpunchbop:FlxSprite;
	var DiscoLight:FlxSprite;
	var darken:FlxSprite;
	var boat:FlxSprite;
	var trees:FlxSprite;
	var trees2:FlxSprite;
	var directions:FlxSprite;
	var rock:FlxSprite;
	var log:FlxSprite;
	var boatY:Int;
	var uppath:Bool;
	var spaceriver:Bool;
	var yapetxt:FlxText;

	var light:FlxSprite;

	var balloon1:FlxSprite;
	var balloon2:FlxSprite;
	var balloon3:FlxSprite;
	var balloon4:FlxSprite;
	var balloon5:FlxSprite;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
	public static var preloadbfhole:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	public var camDialogue:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var dialogueend:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	var doof:DialogueBox;
	var doof2:DialogueBox;

	var chapterload:FlxSprite;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var flowers:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	var hasendingdialog:Bool = false;
	public static var continuetext:Bool = false;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	var coin:FlxSprite;
	var coin2:FlxSprite;
	var coin3:FlxSprite;
	var coin4:FlxSprite;
	var coin5:FlxSprite;
	var coin6:FlxSprite;
	var coin7:FlxSprite;
	var coin8:FlxSprite;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;

		if (isStoryMode)
		{
			transIn = null;
		}
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		//DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camDialogue = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit

		switch (songLowercase)
		{
			case 'missilemaestro', 'elasticentertainer', 'discodevil':
			hasendingdialog = true;
		}

		if (SONG.song.toLowerCase() != 'thealmightyyape')
		{
			if (FlxG.save.data.english)
				if (FlxG.save.data.language)
				dialogue = CoolUtil.coolTextFile("assets/data/" + SONG.song.toLowerCase() + "/dialogspanish.txt");
				else
				dialogue = CoolUtil.coolTextFile("assets/data/" + SONG.song.toLowerCase() + "/dialogbrazil.txt");
			else
				dialogue = CoolUtil.coolTextFile("assets/data/" + SONG.song.toLowerCase() + "/dialog.txt");
			
			if (hasendingdialog == true)
			dialogueend = CoolUtil.coolTextFile("assets/data/" + SONG.song.toLowerCase() + "/dialogend.txt");
		}

		darken = new FlxSprite(-250, 0).makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
		darken.screenCenter();
		darken.alpha = 1;

		switch(SONG.stage)
		{
			case 'picnicstage':
			{	
				defaultCamZoom = 0.7;
				curStage = 'picnicstage';
					
					var sky:FlxSprite = new FlxSprite(-390, -100).loadGraphic(Paths.image('background/pr/picnicroadsky', 'chapter1'));
					sky.antialiasing = true;
					sky.scrollFactor.set(0.9, 0.9);
					sky.active = false;
					sky.updateHitbox();
					add(sky);	

					var road:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/pr/picnicroadbg', 'chapter1'));
					road.antialiasing = true;
					road.active = false;
					road.updateHitbox();
					add(road);

					var topflowers:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/pr/topdoopaflowashoopa-its3am', 'chapter1'));
					topflowers.antialiasing = true;
					topflowers.active = false;
					topflowers.updateHitbox();
					add(topflowers);

					flowers = new FlxSprite(-400, -150);
					flowers.frames = Paths.getSparrowAtlas('background/pr/flowers','chapter1');
					flowers.animation.addByPrefix('flowerbop', "flowerbop", 24, false);
					flowers.antialiasing = true;
					flowers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(flowers);
					}
			}

			case 'teleferic':
			{
				defaultCamZoom = 0.75;
				curStage = 'teleferic';

				var sky:FlxSprite = new FlxSprite(-400, -550).loadGraphic(Paths.image('background/tele/sky', 'chapter1'));
					sky.antialiasing = true;
					sky.scrollFactor.set(0.9, 0.9);
					sky.active = false;
					sky.updateHitbox();
					add(sky);

				balloon3 = new FlxSprite(3000, 300).loadGraphic(Paths.image('background/tele/balloon3', 'chapter1'));
					balloon3.antialiasing = true;
					balloon3.updateHitbox();
					add(balloon3);

				balloon2 = new FlxSprite(3000, 300).loadGraphic(Paths.image('background/tele/OHGODTHEVOICESINMYHEADTURNTHEMOFF', 'chapter1'));
					balloon2.antialiasing = true;
					balloon2.updateHitbox();
					add(balloon2);

				balloon4 = new FlxSprite(3000, 300).loadGraphic(Paths.image('background/tele/balloon4', 'chapter1'));
					balloon4.antialiasing = true;
					balloon4.updateHitbox();
					add(balloon4);

				balloon1 = new FlxSprite(3000, 300).loadGraphic(Paths.image('background/tele/balloon1', 'chapter1'));
					balloon1.antialiasing = true;
					balloon1.updateHitbox();
					add(balloon1);

				balloon5 = new FlxSprite(3000, 300).loadGraphic(Paths.image('background/tele/balloon5', 'chapter1'));
					balloon5.antialiasing = true;
					balloon5.updateHitbox();
					add(balloon5);

				var road:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/tele/ground', 'chapter1'));
					road.antialiasing = true;
					//road.scrollFactor.set(0.9, 0.9);
					road.active = false;
					road.updateHitbox();
					add(road);
			}

			case 'studio':
			{
				curStage = 'studio';

				defaultCamZoom = 0.60;

				var sky:FlxSprite = new FlxSprite(-400, -550).loadGraphic(Paths.image('background/std/sky', 'chapter2'));
					sky.antialiasing = true;
					sky.scrollFactor.set(0.9, 0.9);
					sky.active = false;
					sky.updateHitbox();
					add(sky);

				var stage:FlxSprite = new FlxSprite(-400, -550).loadGraphic(Paths.image('background/std/stage', 'chapter2'));
					stage.antialiasing = true;
					//stage.scrollFactor.set(0.9, 0.9);
					stage.active = false;
					stage.updateHitbox();
					add(stage);

					add(darken);

				light = new FlxSprite(0, -550).loadGraphic(Paths.image('background/std/light', 'chapter2'));
					light.antialiasing = true;
					light.active = false;
					light.updateHitbox();
					light.alpha = 0;
			}

			case 'desert':
			{
					curStage = 'desert';

					defaultCamZoom = 0.80;

					var dunes:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('background/desert/dunes','chapter3'));
					dunes.antialiasing = true;
					dunes.scrollFactor.set(0.2, 0.2);
					dunes.active = false;
					dunes.setGraphicSize(Std.int(dunes.width * 0.8));
					dunes.updateHitbox();
					add(dunes);


					cranes = new FlxSprite(-300, 140);
					cranes.frames = Paths.getSparrowAtlas('background/desert/whatevertfthesearelol','chapter3');
					cranes.animation.addByPrefix('bop', 'Crane Boppers', 24, false);
					cranes.antialiasing = true;
					cranes.scrollFactor.set(0.9, 0.9);
					cranes.setGraphicSize(Std.int(cranes.width * 1));
					cranes.updateHitbox();
					if(FlxG.save.data.distractions){
						add(cranes);
					}


					var ground:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('background/desert/ground','chapter3'));
					ground.active = false;
					ground.antialiasing = true;
					add(ground);

			}

			case 'river':
			{
					curStage = 'river';

					defaultCamZoom = 0.40;

					water = new FlxSprite(-1350, 370);
					water.frames = Paths.getSparrowAtlas('background/riverway/wo_a','chapter2');
					water.animation.addByPrefix('rushing', "water_", 6);
					water.antialiasing = true;
					water.setGraphicSize(Std.int(water.width * 3));
					water.updateHitbox();
					water.animation.play('rushing');
					add(water);

					MountainWallClone = new FlxSprite(-10184, -570).loadGraphic(Paths.image('background/riverway/MountainWall','chapter2'));
					MountainWallClone.active = false;
					MountainWallClone.antialiasing = true;
					MountainWallClone.setGraphicSize(Std.int(MountainWallClone.width * 2));
					MountainWallClone.updateHitbox();
					add(MountainWallClone);

					MountainWall = new FlxSprite(-13380, -570).loadGraphic(Paths.image('background/riverway/MountainWall','chapter2'));
					MountainWall.active = false;
					MountainWall.antialiasing = true;
					MountainWall.setGraphicSize(Std.int(MountainWall.width * 2));
					MountainWall.updateHitbox();
					add(MountainWall);
					
					rock = new FlxSprite(-1900, 470);
					rock.frames = Paths.getSparrowAtlas('background/riverway/rock','chapter2');
					rock.animation.addByPrefix('rockanimate', "animate2", 12);
					//rock.active = false;
					rock.antialiasing = true;
					rock.setGraphicSize(Std.int(rock.width * 0.7));
					rock.updateHitbox();
					rock.animation.play('rockanimate');
					add(rock);

					log = new FlxSprite(-2100, 970);
					log.frames = Paths.getSparrowAtlas('background/riverway/log','chapter2');
					log.animation.addByPrefix('loganimate', "animate", 12);
					//log.active = false;
					log.antialiasing = true;
					log.setGraphicSize(Std.int(log.width * 0.7));
					log.updateHitbox();
					log.animation.play('loganimate');
					add(log);

					boat = new FlxSprite(300, 500);
					boatY = 500;
					uppath = true;
					boat.frames = Paths.getSparrowAtlas('background/riverway/boat','chapter2');
					boat.animation.addByPrefix('water', 'boat', 24);
					boat.antialiasing = true;
					boat.setGraphicSize(Std.int(boat.width * 0.8));
					boat.animation.play('water');
					boat.updateHitbox();
					add(boat);

					directions = new FlxSprite(2000, 950).loadGraphic(Paths.image('background/riverway/directions', 'chapter2'));
					directions.active = false;
					directions.antialiasing = true;
					directions.setGraphicSize(Std.int(directions.width * 0.3));
					directions.updateHitbox();
					add(directions);
					
				
			}

			case 'disco':
			{
				curStage = 'disco';

				defaultCamZoom = 0.70;

				topstage = new FlxSprite(-400, -150);
				topstage.frames = Paths.getSparrowAtlas('background/disco/changingstuff','chapter3');
				topstage.animation.addByPrefix('closed', 'doorclosed', 24, false);
				topstage.animation.addByPrefix('open', 'dooropen', 24, false);
				topstage.antialiasing = true;
				topstage.scrollFactor.set(0.9, 0.9);
				topstage.updateHitbox();
				
				if (PlayState.SONG.song.toLowerCase() == 'thrillsatnight')
				topstage.animation.play('closed');	
				else
				topstage.animation.play('open');

				add(topstage);

				var middlestage:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/disco/DiscoSecondBack', 'chapter3'));
					middlestage.antialiasing = true;
					middlestage.scrollFactor.set(0.9, 0.9);
					middlestage.active = false;
					middlestage.updateHitbox();
					add(middlestage);

				heroesdance = new FlxSprite(-400, -150);
				heroesdance.frames = Paths.getSparrowAtlas('background/disco/changingstuff','chapter3');
				
				if (PlayState.SONG.song.toLowerCase() == 'thrillsatnight')
				heroesdance.animation.addByPrefix('normal', 'heroesbop', 24, false);
				else
				heroesdance.animation.addByPrefix('normal', 'boomheroesbop', 24, false);

				heroesdance.antialiasing = true;
				heroesdance.scrollFactor.set(0.9, 0.9);
				heroesdance.updateHitbox();
				heroesdance.animation.play('normal');
				if(FlxG.save.data.distractions){
					add(heroesdance);
				}

				var discofloor:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/disco/DiscoStage', 'chapter3'));
					discofloor.antialiasing = true;
					//discofloor.scrollFactor.set(0.9, 0.9);
					discofloor.active = false;
					discofloor.updateHitbox();
					add(discofloor);
					

				toadpunchbop = new FlxSprite(-380, 760);
				toadpunchbop.frames = Paths.getSparrowAtlas('background/disco/changingstuff','chapter3');
				toadpunchbop.animation.addByPrefix('holepunchbop', 'frontbop', 24, false);
				toadpunchbop.antialiasing = true;
				toadpunchbop.scrollFactor.set(0.9, 0.9);
				toadpunchbop.updateHitbox();
				toadpunchbop.animation.play('holepunchbop');
				if(FlxG.save.data.distractions){
					add(toadpunchbop);
				}

				
					DiscoLight = new FlxSprite(-800, -150).loadGraphic(Paths.image('background/disco/DiscoLight', 'chapter3'));
					DiscoLight.antialiasing = true;
					DiscoLight.active = true;
					DiscoLight.screenCenter();
					DiscoLight.updateHitbox();
					DiscoLight.alpha = 0.6;				

			}

			case 'mountain':
			{
					curStage = 'mountain';

					defaultCamZoom = 0.6;

					var background:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('background/mountain/background','chapter2'));
					background.antialiasing = true;
					background.active = false;
					background.setGraphicSize(Std.int(background.width * 0.7));
					background.updateHitbox();
					add(background);

					var ground:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('background/mountain/ground','chapter2'));
					ground.active = false;
					ground.antialiasing = true;
					ground.setGraphicSize(Std.int(ground.width * 0.7));
					ground.updateHitbox();
					add(ground);

			}

			case 'yapestage':
			{
				curStage = 'yapestage';

				defaultCamZoom = 0.7;

				FlxG.save.data.yape = true;

				var background:FlxSprite = new FlxSprite(-1017, 0).loadGraphic(Paths.image('yapebg','shared'));
					background.antialiasing = true;
					background.active = false;
					//background.setGraphicSize(Std.int(background.width * 0.7));
					//background.updateHitbox();
					add(background);

				yapeboppers = new FlxSprite(985, 400);
					yapeboppers.frames = Paths.getSparrowAtlas('yapeboppers','shared');
					yapeboppers.animation.addByPrefix('scaredbop', 'wtf', 24, false);
					yapeboppers.antialiasing = true;
					//yapeboppers.setGraphicSize(Std.int(cranes.width * 1));
					//yapeboppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(yapeboppers);
					}

			}

			default:
			{
					defaultCamZoom = 0.7;
					
					var sky:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/pr/picnicroadsky', 'chapter1'));
					sky.antialiasing = true;
					sky.scrollFactor.set(0.9, 0.9);
					sky.active = false;
					sky.updateHitbox();
					add(sky);	

					var road:FlxSprite = new FlxSprite(-400, -150).loadGraphic(Paths.image('background/pr/picnicroadbg', 'chapter1'));
					road.antialiasing = true;
					road.scrollFactor.set(0.9, 0.9);
					road.active = false;
					road.updateHitbox();
					add(road);	
			}
		}

		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-origami':
				gfVersion = 'gf-origami';
			case 'gf-less':
				gfVersion = 'gf-less';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		//gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "olivia":
				dad.x += 100;
				dad.y += 50;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'toad':
				dad.x -= 120;
				dad.y += 30;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);
			case 'picnic':
				dad.x -= 750;
				dad.y -= 475;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'colors':
				dad.x -= 200;
				dad.y -= 90;
			case 'rubber':
				dad.x += 250;
				dad.y -= 45;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'boogie':
				dad.y += 70;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'devil':
				dad.x -= 260;
				dad.y += 210;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);
			case 'autumn':
				dad.x -= 750;
				dad.y -= 150;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'gondol':
				dad.x += 200;
				dad.y -= 420;
				//camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'yape':
				dad.x += 0;
				dad.y += 550;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}


		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'picnicstage':
			boyfriend.x = 920;
			gf.x = 180;
			gf.y = -130;

			case 'teleferic':
			boyfriend.x = 1120;
			boyfriend.y = 600; 
			gf.x = 420;
			gf.y = 30;	

			case 'studio':
			boyfriend.x = 2020;
			boyfriend.y = 870; 
			gf.x = 970;	
			gf.y = 315;

			case 'disco':
			gf.x = 140;
			gf.y = -130;
			if (SONG.player2 == 'devil')
			{
			boyfriend.x = 1090; 
			gf.x = 340;	
			}

			case 'desert':
			boyfriend.x = 850;
			boyfriend.y = 450;
			gf.x = 200;
			gf.y = -100;

			case 'mountain':
			boyfriend.y = 450;
			boyfriend.x = 550;
			gf.y = -150;
			gf.x = -200;

			case 'river':
			boyfriend.y = 230;
			boyfriend.x = 1050;
			gf.y = -330;
			gf.x = 350;

			case 'yapestage':
			boyfriend.x = 1500;
			boyfriend.y = 950;
			gf.y = -1000;
			
		}

		add(gf);

		coin = new FlxSprite(200, -150);
			coin.frames = Paths.getSparrowAtlas('coin');
			coin.setGraphicSize(Std.int(coin.width * 0.15));
			coin.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin);
			coin.visible = false;

		coin2 = new FlxSprite(200, -150);
			coin2.frames = Paths.getSparrowAtlas('coin');
			coin2.setGraphicSize(Std.int(coin2.width * 0.15));
			coin2.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin2);
			coin2.visible = false;

		coin3 = new FlxSprite(200, -150);
			coin3.frames = Paths.getSparrowAtlas('coin');
			coin3.setGraphicSize(Std.int(coin3.width * 0.15));
			coin3.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin3);
			coin3.visible = false;

		coin4 = new FlxSprite(200, -150);
			coin4.frames = Paths.getSparrowAtlas('coin');
			coin4.setGraphicSize(Std.int(coin4.width * 0.15));
			coin4.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin4);
			coin4.visible = false;

		coin5 = new FlxSprite(200, -150);
			coin5.frames = Paths.getSparrowAtlas('coin');
			coin5.setGraphicSize(Std.int(coin5.width * 0.15));
			coin5.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin5);
			coin5.visible = false;

		coin6 = new FlxSprite(200, -150);
			coin6.frames = Paths.getSparrowAtlas('coin');
			coin6.setGraphicSize(Std.int(coin6.width * 0.15));
			coin6.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin6);
			coin6.visible = false;

		coin7 = new FlxSprite(200, -150);
			coin7.frames = Paths.getSparrowAtlas('coin');
			coin7.setGraphicSize(Std.int(coin7.width * 0.15));
			coin7.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin7);
			coin7.visible = false;

		coin8 = new FlxSprite(200, -150);
			coin8.frames = Paths.getSparrowAtlas('coin');
			coin8.setGraphicSize(Std.int(coin8.width * 0.15));
			coin8.animation.addByPrefix('spin', 'youspinmerightroundbabyrightround', 24, false);
			add(coin8);
			coin8.visible = false;

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		if (curStage == 'river')
		{
			trees = new FlxSprite(-4000, 1100).loadGraphic(Paths.image('background/riverway/tree','chapter2'));
					trees.active = false;
					trees.setGraphicSize(Std.int(trees.width * 2));
					trees.antialiasing = true;
					trees.updateHitbox();
					add(trees);

			trees2 = new FlxSprite(-4000, 1100).loadGraphic(Paths.image('background/riverway/tree2','chapter2'));
					trees2.active = false;
					trees2.setGraphicSize(Std.int(trees2.width * 2));
					trees2.antialiasing = true;
					trees2.updateHitbox();
					add(trees2);
		}

		if (curStage == 'yapestage')
		{
			yapetxt = new FlxText(2000, 1600, FlxG.width,
			"Side effects of YAPE use may include: \n\n\n\n Dizziness\nVomiting\nFever\nHeadaches\nBackaches\nHeartaches\nKidney Damage\nLiver Damage\nDiarrhea\nConstipation\nDrowsiness\nFatigue\nRashes\nHives\nIrritation\nInflammation\nFear of Clowns\nChange in tastes for ice cream\nDesire to purchase a Lamborghini\n\nSubscription to Juno Songs\nSubscription to Man on the Internet\n\nPlease subscribe to both channels\nWe swear to god they aren't competing or anything\nIn fact Alex is the one singing this very song\n\nVomiting\nand Heart Palpatations.",
			64);
		
			yapetxt.setFormat(Paths.font("mario.ttf"), 64, CENTER);
			yapetxt.x = 120;
			yapetxt.borderColor = FlxColor.BLACK;
			yapetxt.borderSize = 3;
			yapetxt.borderStyle = FlxTextBorderStyle.OUTLINE;
			//yapetxt.screenCenter(X);
			add(yapetxt);
		}

		if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
		preloadbfhole = new Boyfriend(1090, 450, 'bf-hole');
		add(preloadbfhole);
		preloadbfhole.visible = false;
	}

		if (curStage == 'disco')
		{
			add(DiscoLight);
			darken.alpha = 0.4;
			add(darken);
		}

		if (curStage == 'studio')
		{
			light.alpha = 0;
			add(light);
			dad.alpha = 0;
			boyfriend.alpha = 0;
			gf.alpha = 0;
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		doof = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		doof2 = new DialogueBox(false, dialogueend);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof2.scrollFactor.set();
		doof2.finishThing = endSong;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		if (resultsscreen == false)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		}

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();

		switch (dad.curCharacter)

		{

		case 'toad':
		healthBar.createFilledBar(0xFFFF5442, 0xFF31B0D1);

		case 'picnic':
		healthBar.createFilledBar(0xFFA15F20, 0xFF31B0D1);

		case 'rubber':
		healthBar.createFilledBar(0xFF9F3EF2, 0xFF31B0D1);

		case 'colors':
		healthBar.createFilledBar(0xFFB3E9FF, 0xFF31B0D1);

		case 'olivia':
		healthBar.createFilledBar(0xFFFFDD24, 0xFF31B0D1);

		case 'boogie':
		healthBar.createFilledBar(0xFFE4CA5D, 0xFF31B0D1);

		case 'devil':
		healthBar.createFilledBar(0xFF525252, 0xFF31B0D1);

		case 'autumn':
		healthBar.createFilledBar(0xFF2442FF, 0xFF31B0D1);

		case 'gondol':
		healthBar.createFilledBar(0xFF5BACE9, 0xFF31B0D1);

		case 'yape':
		healthBar.createFilledBar(0xFFFB414C, 0xFF31B0D1);

		}

		

		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - August 5 DEV BUILD " : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camDialogue];
		doof2.cameras = [camDialogue];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'picnicroad':
					isanendingcutscene = false;
					loadout(doof);
				case 'autumnmountainbattle':
					isanendingcutscene = false;
					loadout(doof);
				case 'yellowstreamerbattle':
					isanendingcutscene = false;
					loadout(doof);
				default:
					isanendingcutscene = false;
					schoolIntro(doof);
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	var cutscene:FlxSprite;

	function loadout(?dialogueBox:DialogueBox):Void
	{

		inCutscene = true;
		camHUD.visible = false;
		chapterload = new FlxSprite(0, 0);
			chapterload.frames = Paths.getSparrowAtlas('chapterload');
			chapterload.animation.addByPrefix('loadout', "loadout", 13);
			chapterload.antialiasing = true;
			chapterload.setGraphicSize(Std.int(chapterload.width * 1));
			chapterload.updateHitbox();

		switch (curSong.toLowerCase())
		{
			
			case 'picnicroad':
				chapterload.x = -250;

			case 'autumnmountainbattle':
				chapterload.x = -670;
				chapterload.y = -50;
				chapterload.setGraphicSize(Std.int(chapterload.width * 1.3));

			case 'yellowstreamerbattle':
				chapterload.x = -600;
				chapterload.y = -200;
		}

		var black:FlxSprite = new FlxSprite(-800, -515).makeGraphic(FlxG.width * 10, FlxG.height * 10, FlxColor.BLACK);
		black.width = 10;
		add(black);

		add(chapterload);
		chapterload.animation.play('loadout');
		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				add(dialogueBox);
				remove(chapterload);
				new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				remove(black);
				camHUD.visible = true;
			});
			});
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		camHUD.visible = false;

		var black:FlxSprite = new FlxSprite(-1100, -700).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		black.scrollFactor.set();
		black.width = 10;
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		// pre lowercasing the song name (schoolIntro)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		if (songLowercase == 'roses' || songLowercase == 'thorns')
		{
			remove(black);

			if (songLowercase == 'thorns')
			{
				add(red);
			}
		}


		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (songLowercase == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
						if (isanendingcutscene == false)
				{
						new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				remove(black);
				camHUD.visible = true;
			});
				}
					}
				}
				else
				{
					startCountdown();
				}

		});
	}

	function endCutscene(?dialogueBox:DialogueBox)
{
	trace("endCutscene");
	var black:FlxSprite = new FlxSprite(-256, -256).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set(0);
		inCutscene = true;
		black.alpha = 0;
		add(black);
		camHUD.visible = false;
		FlxTween.tween(black, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		vocals.stop();
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			add(dialogueBox);
		});
}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');
			if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
		preloadbfhole.playAnim('idle');
	}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					if (curStage == 'river')
					FlxTween.tween(directions, { x: -500 }, 1, {ease: FlxEase.quadInOut});
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
					if (curStage == 'river')
					FlxTween.tween(directions, { x: -3500 }, 1, {ease: FlxEase.quadInOut});
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	function endReturn(){
		if (PlayState.SONG.song.toLowerCase() == 'discodevil')
		{
			FlxG.switchState(new CreditsRoll());
		}
		else
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());	
		}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					switch (storyWeek)
					{
						case 0:
						FlxG.save.data.beatchapter1 = true;
						case 1:
						FlxG.save.data.beatchapter2 = true;
						case 2:
						FlxG.save.data.beatchapter3 = true;
					}


					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			if (FlxG.save.data.copyrightfree)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}
		else
		{
			FlxG.sound.playMusic(Paths.instCOPYFREE(PlayState.SONG.song), 1, false);
		}
		}

		FlxG.sound.music.onComplete = songOutro;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		//DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
		//	DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
		//		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
		//		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		//DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	var pencilsup:Bool = true;
	var pencilsmovement:Bool = true;
	var startscroll:Bool = true;
	var objectmoving:Bool = false;
	var objectrock:Bool = false;
	var objectlog:Bool = false;
	var objectpath:Bool = true;
	var death:Bool = false;

	function riverobject()
	{
		if (FlxG.random.bool(50) && objectmoving == false && objectrock == false)
		{
			objectrock = true;
			objectmoving = true;
			rock.x = -1900;
			if (FlxG.random.bool(50))
		{
			rock.y = 470;
			objectpath = true;
		}	
			else
		{	
			rock.y = 900;
			objectpath = false;
		}

			FlxTween.tween(rock, { x: 2300 }, 8, {
				onComplete: function(twn:FlxTween)
				{
					objectmoving = false;
					objectrock = false;
				}
			});
		}
		else if (FlxG.random.bool(50) && objectmoving == false && objectlog == false)
		{
			objectlog = true;
			objectmoving = true;
			log.x = -2300;
			if (FlxG.random.bool(50))
		{	
			log.y = 470;
			objectpath = true;
		}
			else
		{	
			log.y = 900;
			objectpath = false;
		}

			FlxTween.tween(log, { x: 2300}, 8, {
				onComplete: function(twn:FlxTween)
				{
					objectlog = false;
					objectmoving = false;
				}
			});
		}
				new FlxTimer().start(3.3, function(tmr:FlxTimer)
			{
				if (objectmoving == true && objectpath == true && uppath == true || objectmoving == true && objectpath == false && uppath == false )
				{
					trace('COLLIDED');
					health = 0;
				}
			});
	}

	override public function update(elapsed:Float)
	{
		if (resultsscreen == true)
		{
			coin.animation.play('spin');
			coin2.animation.play('spin');
			coin3.animation.play('spin');
			coin4.animation.play('spin');
			coin5.animation.play('spin');
			coin6.animation.play('spin');
			coin7.animation.play('spin');
			coin8.animation.play('spin');
		}

		#if !debug
		perfectMode = false;
		#end

		if (dad.curCharacter == 'colors')
		{
			if (pencilsup == true)
			{
				if (pencilsmovement == true)
				{
					pencilsmovement = false;
					FlxTween.tween(dad, {y: -200}, 2, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									pencilsup = false;
									pencilsmovement = true;
								}
							});
				}
			}

			if (pencilsup == false)
			{
				if (pencilsmovement == true)
				{
					pencilsmovement = false;
					FlxTween.tween(dad, {y: 0}, 2, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									pencilsup = true;
									pencilsmovement = true;
								}
							});
				}
			}
		}

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;

			case 'disco':
				DiscoLight.angle = DiscoLight.angle - 0.1;

			case 'river':
				if (startscroll == true)
				{
					startscroll = false;
					MountainWallClone.x = -10184;
					MountainWall.x = -13381;
					//MountainWall.visible = false;
					FlxTween.tween(MountainWallClone, {x: -1222}, 14, {
					onComplete: function(twn:FlxTween)
				{
					tween = FlxTween.tween(MountainWallClone, { x: 20368 }, 30);
					FlxTween.tween(MountainWall, {x: -10184}, 4.2, {
					onComplete: function(twn:FlxTween)
				{
					tween.cancel();
					startscroll = true;
				}
			});
				}
			});
				}

				spaceriver = true;

				if (FlxG.keys.justPressed.SPACE && spaceriver == true)
				{
					spaceriver = false;
					if (uppath == true)
					{
						boatY = 900;
						uppath = false;
					}
					else
					{
						boatY = 500;
						uppath = true;
					}

					FlxTween.tween(boyfriend, { y: boatY - 270 }, 1);
					FlxTween.tween(gf, { y: boatY - 830 }, 1);
					FlxTween.tween(dad, { y: boatY - 820 }, 1);
					FlxTween.tween(boat, {y: boatY}, 1, {
					onComplete: function(twn:FlxTween)
				{
					spaceriver = true;
				}
				});
				}
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			//DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (resultsscreen == false)
			{


			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				if (curStage != 'river')
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'colors':
						camFollow.y = dad.getMidpoint().y + 0;
						camFollow.x = dad.getMidpoint().x + 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}


			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				if (curStage != 'river')
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}


		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		}

	}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (curSong == 'DiscoDevil')
		{
			if (curStep == 335)
			{
				var white:FlxSprite = new FlxSprite(-300, -150).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
					white.scrollFactor.set();
					add(white);	

				remove(boyfriend);
				preloadbfhole.visible = true;

				remove(healthBarBG);
				healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBarhalf'));
				healthBarBG.y = 770;
				if (FlxG.save.data.downscroll)
				healthBarBG.y = -110;
				healthBarBG.screenCenter(X);
				healthBarBG.scrollFactor.set();
				add(healthBarBG);

				remove(healthBar);
				healthBar = new FlxBar(healthBarBG.x + 2, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 2), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
				healthBar.scrollFactor.set();
				healthBar.createFilledBar(0xFF525252, 0xFF31B0D1);
				add(healthBar);

					FlxTween.tween(white, {alpha: 0}, 0.5, {
				onComplete: function(twn:FlxTween)
				{
					FlxG.camera.shake(0.008, 1);
				}
			});
		}
		}

		if (curSong == 'ElasticEntertainer')
		{
			switch (curStep)
			{
				case 45:
				FlxTween.tween(dad, {alpha: 0.7}, 2);
				FlxTween.tween(light, {alpha: 0.3}, 2);

				case 65:
				FlxTween.tween(boyfriend, {alpha: 0.7}, 2);

				case 362:
				FlxTween.tween(gf, {alpha: 1}, 2);
				FlxTween.tween(boyfriend, {alpha: 1}, 2);
				FlxTween.tween(dad, {alpha: 1}, 2);
				FlxTween.tween(darken, {alpha: 0}, 2);
				FlxTween.tween(light, {alpha: 0}, 2, {
				onComplete: function(twn:FlxTween)
				{
					remove(darken);
					remove(light);
				}
			});
			}
		}

		if (curSong == 'TheAlmightyYape')
		{
			switch (curStep)
			{
				case 1305:
					FlxTween.tween(yapetxt, {y: -3000}, 17);
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			//DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					//DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
								if (curSong == 'EddyRiver')
								{
									riverobject();
								}
						}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			songOutro();
		#end
	}

	function songOutro():Void
		{
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			canPause = false;

			if (isStoryMode)
			{
				switch (curSong.toLowerCase())
				{
					case 'missilemaestro', 'elasticentertainer', 'discodevil':
						continuetext = true;
						victorysetup();
						new FlxTimer().start(8, function(tmr:FlxTimer)
					{
						isanendingcutscene = true;
						schoolIntro(doof2);
					});
	
					default:
						victorysetup();
						new FlxTimer().start(8, function(tmr:FlxTimer)
					{
						resultsscreen = false;
						endSong();
					});
				}
			}
			else
				{
					switch (curSong.toLowerCase())
					{
						default:
							endSong();
					}
				}
				
		}

	function endSong():Void
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
			
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (PlayState.SONG.song.toLowerCase() == 'discodevil')
				{
					FlxG.switchState(new CreditsRoll());
				}

				if (storyPlaylist.length <= 0)
				{
					if (PlayState.SONG.song.toLowerCase() == 'discodevil')
				{
					FlxG.switchState(new CreditsRoll());
				}
				else
				{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new MainMenuState());	
				}


					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					// pre lowercasing the next story song name
					var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
						switch (nextSongLowercase) {
							case 'dad-battle': nextSongLowercase = 'dadbattle';
							case 'philly-nice': nextSongLowercase = 'philly';
						}
					trace(nextSongLowercase + difficulty);

					// pre lowercasing the song name (endSong)
					var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}

					switch (PlayState.SONG.song.toLowerCase())
				{
					case 'eggnog':
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}


					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{

				victorysetup();


				//openSubState(new RankingSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				new FlxTimer().start(8, function(tmr:FlxTimer)
					{
						trace('WENT BACK TO FREEPLAY??');
						resultsscreen = false;
						FlxG.switchState(new FreeplayState());
					});

				//openSubState(new RankingSubstate());
			}
		}
	}

	var coinlevel:Int = 0;
	var coinstart:Int = -1000;

	function victorysetup():Void
	{

		resultsscreen = true;

		switch (curStage)
		{
				case 'picnicstage':
				coin.x = 0;
				coin2.x = 115;
				coin3.x = 230;
				coin4.x = 345;
				coin5.x = 460;
				coin6.x = 575;
				coin7.x = 690;
				coin8.x = 805;
				
				coinlevel = -150;
			
				FlxG.sound.play(Paths.sound('redvictory'), 1, false);

				case 'teleferic':
				coin.x = 100;
				coin2.x = 225;
				coin3.x = 300;
				coin4.x = 425;
				coin5.x = 550;
				coin6.x = 675;
				coin7.x = 750;
				coin8.x = 900;
				
				coinlevel = 0;
		
				FlxG.sound.play(Paths.sound('missilevictory'), 1, false);
				

				case 'studio':
				coin.x = 1075;
				coin2.x = 1250;
				coin3.x = 1350;
				coin4.x = 1450;
				coin5.x = 1550;
				coin6.x = 1650;
				coin7.x = 1750;
				coin8.x = 1925;
				
				coinlevel = 220;
				FlxG.sound.play(Paths.sound('elasticvictory'), 1, false);

				case 'river':
				coinlevel = boatY - 900;
				coin2.x = 220;
				coin3.x = 240;
				coin4.x = 260;
				coin5.x = 280;
				coin6.x = 300;
				coin7.x = 320;
				coin8.x = 340;

				FlxG.sound.play(Paths.sound('autumnvictory'), 1, false);

				case 'mountain':
				coinlevel = -200;
				coin.x = -300;
				coin2.x = -50;
				coin3.x = 0;
				coin4.x = 50;
				coin5.x = 150;
				coin6.x = 300;
				coin7.x = 500;

				FlxG.sound.play(Paths.sound('autumnvictory'), 1, false);
			

				case 'disco':
		
				coinlevel = -150;
				
				if (SONG.player2 == 'devil')
				{
					coin.x = 400;
					coin2.x = 555;
					coin3.x = 650;
					coin4.x = 700;
					coin5.x = 800;
					coin6.x = 925;
					coin7.x = 1050;
					coin8.x = 1175;
					FlxG.sound.play(Paths.sound('devilvictory'), 1, false);
				}
				else
				{
					coin.x = -200;
					coin2.x = -55;
					coin3.x = 50;
					coin4.x = 175;
					coin5.x = 200;
					coin6.x = 425;
					coin7.x = 550;
					coin8.x = 675;					
					
					FlxG.sound.play(Paths.sound('yellowvictory'), 1, false);
				}

				case 'desert':

				coin.x = -200;
				coin2.x = -100;
				coin3.x = 0;
				coin4.x = 175;
				coin5.x = 200;
				coin6.x = 325;
				coin7.x = 450;
				coin8.x = 535;
				
				coinlevel = -150;

				FlxG.sound.play(Paths.sound('yellowvictory'), 1, false);	

				case 'yapestage':

				coin.x = 400;
				coin2.x = 500;
				coin3.x = 600;
				coin4.x = 700;
				coin5.x = 800;
				coin6.x = 900;
				coin7.x = 1000;
				coin8.x = 1100;

				coinlevel = 300;

				FlxG.sound.play(Paths.sound('shadyvictory'), 1, false);			
		}

				coin.y = coinstart;
				coin2.y = coinstart;
				coin3.y = coinstart;
				coin4.y = coinstart;
				coin5.y = coinstart;
				coin6.y = coinstart;
				coin7.y = coinstart;
				coin8.y = coinstart;

		new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				camHUD.alpha -= 1 / 10;
			}, 10);

		var offsetX = 0;
		var offsetY = 0;
		#if windows
		if (luaModchart != null)
		{
			offsetX = luaModchart.getVar("followXOffset", "float");
			offsetY = luaModchart.getVar("followYOffset", "float");
		}
		#end

		if(PlayState.SONG.song.toLowerCase() == 'discodevil')
		camFollow.setPosition(preloadbfhole.getMidpoint().x + offsetX, preloadbfhole.getMidpoint().y + offsetY);
		else
		camFollow.setPosition(boyfriend.getMidpoint().x + offsetX, boyfriend.getMidpoint().y + offsetY);

		FlxTween.tween(FlxG.camera, {zoom: 1.1}, 1, {
			onComplete: function(twn:FlxTween)
			{
				new FlxTimer().start(0.87, function(tmr:FlxTimer)
			{
				if(PlayState.SONG.song.toLowerCase() == 'discodevil')
				preloadbfhole.playAnim('hey');
				else
				boyfriend.playAnim('hey');
			});

				new FlxTimer().start(2.5, function(tmr:FlxTimer)
			{
				coin.visible = true;
				coin2.visible = true;
				coin3.visible = true;
				coin4.visible = true;
				coin5.visible = true;
				coin6.visible = true;
				coin7.visible = true;
				coin8.visible = true;
				coindecider();	
			});
			}
			});	
	}

	function coindecider():Void
	{

		FlxTween.tween(coin, { y: coinlevel + FlxG.random.int(65, 70)}, 0.7, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin, { x: coin.x + FlxG.random.int(-200, 50)}, 0.5);	
			});

		FlxTween.tween(coin2, { y: coinlevel + FlxG.random.int(65, 70)}, 0.8, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin2, { x: coin2.x + FlxG.random.int(-200, 200)}, 0.5);	
			});

		FlxTween.tween(coin3, { y: coinlevel + FlxG.random.int(65, 70)}, 0.9, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin3, { x: coin3.x + FlxG.random.int(-200, 200)}, 0.5);	
			});

		FlxTween.tween(coin4, { y: coinlevel + FlxG.random.int(65, 70)}, 1, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin4, { x: coin4.x + FlxG.random.int(-200, 200)}, 0.5);	
			});

		FlxTween.tween(coin5, { y: coinlevel + FlxG.random.int(65, 70)}, 1.1, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.6, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin5, { x: coin5.x + FlxG.random.int(-200, 200)}, 0.5);	
			});

		FlxTween.tween(coin6, { y: coinlevel + FlxG.random.int(65, 70)}, 1.2, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin6, { x: coin6.x + FlxG.random.int(-200, 200)}, 0.5);	
			});

		FlxTween.tween(coin7, { y: coinlevel + FlxG.random.int(65, 70)}, 1.3, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin7, { x: coin7.x + FlxG.random.int(-200, 200)}, 0.5);	
			});

		FlxTween.tween(coin8, { y: coinlevel + FlxG.random.int(65, 70)}, 1.4, {ease: FlxEase.bounceOut});
		new FlxTimer().start(0.9, function(tmr:FlxTimer)
			{
				FlxTween.tween(coin8, { x: coin8.x + FlxG.random.int(-50, 200)}, 0.5);	
			});

		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxFlicker.flicker(coin, 2, 0.15, false);
				FlxFlicker.flicker(coin2, 2, 0.15, false);
				FlxFlicker.flicker(coin3, 2, 0.15, false);
				FlxFlicker.flicker(coin4, 2, 0.15, false);
				FlxFlicker.flicker(coin5, 2, 0.15, false);
				FlxFlicker.flicker(coin6, 2, 0.15, false);
				FlxFlicker.flicker(coin7, 2, 0.15, false);
				FlxFlicker.flicker(coin8, 2, 0.15, false);
				new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				coin.visible = false;
				coin2.visible = false;
				coin3.visible = false;
				coin4.visible = false;
				coin5.visible = false;
				coin6.visible = false;
				coin7.visible = false;
				coin8.visible = false;
			});
			});
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});

				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
						
						if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
						preloadbfhole.playAnim('idle');
	}
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
					if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
					preloadbfhole.playAnim('singLEFTmiss', true);
	}
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
					if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
					preloadbfhole.playAnim('singDOWNmiss', true);
	}
				case 2:
					boyfriend.playAnim('singUPmiss', true);
					if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
					preloadbfhole.playAnim('singUPmiss', true);
	}
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
					if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
					preloadbfhole.playAnim('singRIGHTmiss', true);
	}
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
							if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
							preloadbfhole.playAnim('singUP', true);
	}
						case 3:
							boyfriend.playAnim('singRIGHT', true);
							if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
							preloadbfhole.playAnim('singRIGHT', true);
	}
						case 1:
							boyfriend.playAnim('singDOWN', true);
							if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
							preloadbfhole.playAnim('singDOWN', true);
	}
						case 0:
							boyfriend.playAnim('singLEFT', true);
							if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
							preloadbfhole.playAnim('singLEFT', true);
	}
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	var balloonsnotdone = false;
	var treesnotdone = false;

	function balloonStart()
	{
		balloonsnotdone = true;

		balloon1.y = FlxG.random.int(250, 0);
		balloon2.y = FlxG.random.int(250, 200);
		balloon3.y = FlxG.random.int(250, 200);
		balloon4.y = FlxG.random.int(250, 0);
		balloon5.y = FlxG.random.int(250, 0);
		
			FlxTween.tween(balloon1, { x: -500 }, FlxG.random.int(20, 35)); 
			FlxTween.tween(balloon2, { x: -500 }, FlxG.random.int(20, 35));
			FlxTween.tween(balloon3, { x: -500 }, FlxG.random.int(20, 35));  
			FlxTween.tween(balloon4, { x: -500 }, FlxG.random.int(20, 35)); 
			FlxTween.tween(balloon5, { x: -500 }, FlxG.random.int(20, 35)); 

			new FlxTimer().start(FlxG.random.int(35, 40), function(tmr:FlxTimer)
			{
				balloon1.x = 3000;
				balloon2.x = 3000;
				balloon3.x = 3000;
				balloon4.x = 3000;
				balloon5.x = 3000;
				balloonStart();
			});
	}

	function treesStart()
	{
		treesnotdone = true;

		if (FlxG.random.bool(50))
		FlxTween.tween(trees, { x: 4000 }, 5); 
		else
		FlxTween.tween(trees2, { x: 4000 }, 5);	

		new FlxTimer().start(FlxG.random.int(6, 10), function(tmr:FlxTimer)
		{
			trees.x = -4000;
			trees2.x = -4000;
			treesStart();
		});
	}


	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end



		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
	//	DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (resultsscreen == false)
	{

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
				boyfriend.playAnim('idle');

			if (PlayState.SONG.song.toLowerCase() == 'discodevil')
	{
				preloadbfhole.playAnim('idle');
	}
		}

	}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'desert':
				if(FlxG.save.data.distractions){
					cranes.animation.play('bop', true);
				}

			case 'yapestage':
				if(FlxG.save.data.distractions){
						yapeboppers.animation.play('scaredbop', true);
					}

			case 'disco':
				if(FlxG.save.data.distractions){
					heroesdance.animation.play('normal', true);
					toadpunchbop.animation.play('holepunchbop', true);
				}

			case 'picnicstage':
				if(FlxG.save.data.distractions){
					flowers.animation.play('flowerbop', true);
				}

			case 'teleferic':
			if (balloonsnotdone == false)
				{
					if(FlxG.save.data.distractions){
						balloonStart();
					}
				}

			case 'river':
			if (treesnotdone == false)
				{
					treesStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
