package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.media.Sound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var curAnim:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var skipText:FlxText;
	var tbctxt:FlxText;


	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	var endingText:FlxTypeText;

	var dropText:FlxText;
	var cutsceneImage:FlxSprite;
	var fadeImage:FlxSprite;
	var sound:FlxSound;

	public var finishThing:Void->Void;
	private var curSong:String = "";

	var iconangle:Int = 0;
	var holdtime:Int = 0;

	var icons:FlxSprite;

	var bf6:FlxSprite;
	var pausanpiker:FlxSprite;
	var black6:FlxSprite;
	var enemies6:FlxSprite;
	var flash6:FlxSprite;
	var gf6:FlxSprite;
	var jojo16:FlxSprite;
	var jojo26:FlxSprite;
	var ohduck6:FlxSprite;
	var surprise6:FlxSprite;
	var bg6:FlxSprite;

	var bf10:FlxSprite;
	var gf10:FlxSprite;
	var bg10:FlxSprite;
	var pencils10:FlxSprite; // make these a low opacity
	var light10:FlxSprite; // make this 30% opacity
	var lines10:FlxSprite;
	var ohduck10:FlxSprite;
	var jojo102:FlxSprite;
	var jojo10:FlxSprite;

	var bf16happy:FlxSprite;
	var bf16scared:FlxSprite;
	var smoke16:FlxSprite;
	var bg16:FlxSprite;
	var holepuncher:FlxSprite;
	var people16:FlxSprite;
	var microphone16:FlxSprite;
	var shocked16:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		cutsceneImage = new FlxSprite(0, 0);
		cutsceneImage.visible = false;
		add(cutsceneImage);

		fadeImage = new FlxSprite(0, 0);
		fadeImage.visible = false;
		add(fadeImage);

		box = new FlxSprite(-20, 45);
		
		box.frames = Paths.getSparrowAtlas('cutscenes/dialoguebox-paper', 'shared');
		box.animation.addByPrefix('normalOpen', 'dialoguebox-paper', 24, false);
		box.animation.addByIndices('normal', 'dialoguebox-paper', [6], "", 24);
		box.setGraphicSize(Std.int(box.width * 0.67));
		box.y += 230;

		this.dialogueList = dialogueList;

		switch (PlayState.SONG.song.toLowerCase())
		{


		case 'redstreamerbattle':

		pausanpiker = new FlxSprite(-150, 0).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
		add(pausanpiker);
		pausanpiker.visible = false;

		bg6 = new FlxSprite(-320, -180).loadGraphic(Paths.image('cutscenes/cutscene6parts/bg'));
		bg6.setGraphicSize(Std.int(bg6.width * 0.67));
		add(bg6);	
		bg6.visible = false;

		bf6 = new FlxSprite(-770, -177).loadGraphic(Paths.image('cutscenes/cutscene6parts/bf1'));
		bf6.setGraphicSize(Std.int(bg6.width * 0.33));
		add(bf6);	
		bf6.visible = false;

		enemies6 = new FlxSprite(780, -110).loadGraphic(Paths.image('cutscenes/cutscene6parts/enemies'));
		enemies6.setGraphicSize(Std.int(enemies6.width * 0.65));
		add(enemies6);	
		enemies6.visible = false;

		ohduck6 = new FlxSprite(20, -30).loadGraphic(Paths.image('cutscenes/cutscene6parts/ohDuck'));
		ohduck6.setGraphicSize(Std.int(ohduck6.width * 0.67));
		add(ohduck6);	
		ohduck6.visible = false;

		gf6 = new FlxSprite(-450, 800).loadGraphic(Paths.image('cutscenes/cutscene6parts/gf'));
		gf6.setGraphicSize(Std.int(gf6.width * 0.67));
		add(gf6);	
		gf6.visible = false;

		black6 = new FlxSprite(-320, -180).loadGraphic(Paths.image('cutscenes/cutscene6parts/black'));
		black6.setGraphicSize(Std.int(black6.width * 0.67));
		add(black6);	
		black6.visible = false;

		flash6 = new FlxSprite(340, -179).loadGraphic(Paths.image('cutscenes/cutscene6parts/flash'));
		flash6.setGraphicSize(Std.int(flash6.width * 0.67));
		add(flash6);	
		flash6.visible = false;

		jojo16 = new FlxSprite(1150, 570).loadGraphic(Paths.image('cutscenes/cutscene6parts/jojo1'));
		jojo16.setGraphicSize(Std.int(jojo16.width * 0.67));
		add(jojo16);	
		jojo16.visible = false;

		jojo26 = new FlxSprite(-50, -50).loadGraphic(Paths.image('cutscenes/cutscene6parts/jojo2'));
		jojo26.setGraphicSize(Std.int(jojo26.width * 0.67));
		add(jojo26);	
		jojo26.visible = false;

		case 'missilemaestro':

		bg10 = new FlxSprite(-320, -180).loadGraphic(Paths.image('cutscenes/cutscene10parts/bg10'));
		bg10.setGraphicSize(Std.int(bg10.width * 0.67));
		add(bg10);	
		bg10.visible = false;

		light10 = new FlxSprite(-320, -180).loadGraphic(Paths.image('cutscenes/cutscene10parts/light'));
		light10.setGraphicSize(Std.int(light10.width * 0.67));
		add(light10);	
		light10.alpha = 0.37;
		light10.visible = false;

		pencils10 = new FlxSprite(-320, -150).loadGraphic(Paths.image('cutscenes/cutscene10parts/pencils'));
		pencils10.setGraphicSize(Std.int(pencils10.width * 0.67));
		pencils10.alpha = 0;
		add(pencils10);	
		pencils10.visible = false;

		gf10 = new FlxSprite(700, 800).loadGraphic(Paths.image('cutscenes/cutscene10parts/GF'));
		gf10.setGraphicSize(Std.int(gf10.width * 0.67));
		add(gf10);	
		gf10.visible = false;

		ohduck10 = new FlxSprite(525, 870).loadGraphic(Paths.image('cutscenes/cutscene10parts/OhDuck10'));
		ohduck10.setGraphicSize(Std.int(ohduck10.width * 0.67));
		add(ohduck10);	
		ohduck10.visible = false;

		bf10 = new FlxSprite(270, 700).loadGraphic(Paths.image('cutscenes/cutscene10parts/BF'));
		bf10.setGraphicSize(Std.int(bf10.width * 0.67));
		add(bf10);	
		bf10.visible = false;

		lines10 = new FlxSprite(-350, -210).loadGraphic(Paths.image('cutscenes/cutscene10parts/lines'));
		lines10.setGraphicSize(Std.int(lines10.width * 0.67));
		add(lines10);	
		lines10.visible = false;

		jojo102 = new FlxSprite(1020, 430).loadGraphic(Paths.image('cutscenes/cutscene10parts/jojo102'));
		jojo102.setGraphicSize(Std.int(jojo102.width * 0.67));
		add(jojo102);	
		jojo102.visible = false;

		jojo10 = new FlxSprite(-10, 0).loadGraphic(Paths.image('cutscenes/cutscene10parts/jojo10'));
		jojo10.setGraphicSize(Std.int(jojo10.width * 0.67));
		add(jojo10);	
		jojo10.visible = false;

		case 'discodevil':

		bg16 = new FlxSprite(-320, -180).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_BG'));
		bg16.setGraphicSize(Std.int(bg16.width * 0.68));
		add(bg16);	
		bg16.visible = false;

		people16 = new FlxSprite(-300, 500).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_people'));
		people16.setGraphicSize(Std.int(people16.width * 0.67));
		add(people16);	
		people16.visible = false;

		holepuncher = new FlxSprite(100, -550).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_holepunch'));
		holepuncher.setGraphicSize(Std.int(holepuncher.width * 0.27));
		add(holepuncher);	
		holepuncher.visible = false;

		smoke16 = new FlxSprite(-320, 200).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_smoke'));
		smoke16.setGraphicSize(Std.int(smoke16.width * 0.67));
		smoke16.alpha = 0;
		add(smoke16);

		bf16happy = new FlxSprite(-70, -10).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_BF_HAPPY'));
		bf16happy.setGraphicSize(Std.int(bf16happy.width * 0.67));
		add(bf16happy);	
		bf16happy.visible = false;

		bf16scared = new FlxSprite(-70, 50).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_BF_SCARED'));
		bf16scared.setGraphicSize(Std.int(bf16scared.width * 0.67));
		add(bf16scared);	
		bf16scared.visible = false;

		microphone16 = new FlxSprite(300, 400).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_mic'));
		microphone16.setGraphicSize(Std.int(microphone16.width * 0.67));
		add(microphone16);	
		microphone16.visible = false;

		shocked16 = new FlxSprite(150, 300).loadGraphic(Paths.image('cutscenes/cutscene16parts/16_WA'));
		shocked16.setGraphicSize(Std.int(shocked16.width * 0.67));
		add(shocked16);	
		shocked16.visible = false;

		jojo102 = new FlxSprite(1000, 390).loadGraphic(Paths.image('cutscenes/cutscene10parts/jojo102'));
		jojo102.setGraphicSize(Std.int(jojo102.width * 0.67));
		jojo102.angle = 10;
		add(jojo102);	
		jojo102.visible = false;

		jojo10 = new FlxSprite(-25, 100).loadGraphic(Paths.image('cutscenes/cutscene10parts/jojo10'));
		jojo10.setGraphicSize(Std.int(jojo10.width * 0.34));
		jojo10.angle = -10;
		add(jojo10);	
		jojo10.visible = false;

		jojo16 = new FlxSprite(1060, 210).loadGraphic(Paths.image('cutscenes/cutscene6parts/jojo1'));
		jojo16.setGraphicSize(Std.int(jojo16.width * 0.50));
		jojo16.angle = 15;
		add(jojo16);	
		jojo16.visible = false;
		}


		
		box.animation.play('normalOpen');
		box.updateHitbox();
		box.screenCenter(X);
		box.alpha = 0.8;
		add(box);

		icons = new HealthIcon('bf', false);
		add(icons);
		icons.visible = false;


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		skipText = new FlxText(5, 695, 640, "Press SPACE to skip.\n", 40);
		skipText.scrollFactor.set(0, 0);
		skipText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skipText.borderSize = 2;
		skipText.borderQuality = 1;
		add(skipText);

		dropText = new FlxText(282, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'FOT-PopJoy Std B';
		dropText.color = 0xFFFFFFFF;
		add(dropText);

		swagDialogue = new FlxTypeText(280, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'FOT-PopJoy Std B';
		swagDialogue.color = 0xFF000000;
		//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	function resetangle()
	{
	new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			icons.angle = -5;
			new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			icons.angle = 10;
			resetangle();
		});
		});
	}

	var onetime:Bool = true;
	var shake:Bool = false;
	var okflippinstopdashake:Bool = false;

	override function update(elapsed:Float)
	{

		if (zoosh == true)
		{
			cutsceneImage.x = FlxG.random.int(-20, 20);
			cutsceneImage.y = FlxG.random.int(-20, 20);
		}

		if (shake == true)
		{
			shake = false;
			bg16.x = FlxG.random.int(-326, -314);
			bg16.y = FlxG.random.int(-173, -186);
			bf16happy.x = FlxG.random.int(-76, -64);
			bf16happy.y = FlxG.random.int(-4, -16);
			bf16scared.x = FlxG.random.int(-76, -64);
			bf16scared.y = FlxG.random.int(56, 44);
			holepuncher.x = FlxG.random.int(74, 85);
			holepuncher.y = FlxG.random.int(-94, -106);

		new FlxTimer().start(0.005, function(tmr:FlxTimer)
			{
				if (okflippinstopdashake == false)
				shake = true;
			});
		}

		if (onetime == true)
		{
		resetangle();
		onetime = false;	
		}
		else
		{

		}

		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')

		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(FlxG.keys.justPressed.SPACE && !isEnding){

			isEnding = true;
			endDialogue();

		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
					endDialogue();
					
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	function jojoanimate()
	{
		switch (PlayState.SONG.song.toLowerCase())
		{

		case 'redstreamerbattle':
		jojo16.x = FlxG.random.int(1149, 1151);
		jojo16.y = FlxG.random.int(569, 571);
		jojo26.x = FlxG.random.int(-51, -49);
		jojo26.y = FlxG.random.int(-51, -49);
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				jojoanimate();
			});

		case 'missilemaestro':
		jojo102.x = FlxG.random.int(1019, 1021);
		jojo102.y = FlxG.random.int(429, 431);
		jojo10.x = FlxG.random.int(-9, -11);
		jojo10.y = FlxG.random.int(-1, 1);
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				jojoanimate();
			});

		case 'discodevil':
		jojo102.x = FlxG.random.int(1000, 1002);
		jojo102.y = FlxG.random.int(389, 391);
		jojo10.x = FlxG.random.int(-26, -24);
		jojo10.y = FlxG.random.int(99, 101);
		jojo16.x = FlxG.random.int(1059, 1061);
		jojo16.y = FlxG.random.int(209, 211);
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				jojoanimate();
			});

		}
	}

	function shakescreen()
	{
		
	}

	function gfshake()
	{
		switch (PlayState.SONG.song.toLowerCase())
	{
		case 'redstreamerbattle':
		gf6.x = FlxG.random.int(-101, -99);
		gf6.y = FlxG.random.int(349, 351);
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				gfshake();
			});

		case 'missilemaestro':
		bf10.x = FlxG.random.int(269, 271);
		bf10.y = FlxG.random.int(369, 371);
		new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				gfshake();
			});
	}
	}

	var isEnding:Bool = false;
	var animatedCutscene:Bool = false;
	var firstimage:Bool = true;

	function endDialogue()
	{
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'picnicroad')
						FlxG.sound.music.fadeOut(2.2, 0);

				if (this.sound != null) this.sound.stop();

				FlxG.sound.music.fadeOut(2, 0);

					switch (PlayState.SONG.song.toLowerCase())
				{
					case 'redstreamerbattle':
					FlxTween.tween(bg6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(pausanpiker, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(flash6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(black6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(bf6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(enemies6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(ohduck6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(gf6, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo26, {alpha: 0}, 2, {ease: FlxEase.circOut});

					case 'missilemaestro':
					FlxTween.tween(bg10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(light10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(pencils10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(gf10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(ohduck10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(bf10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(lines10, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo102, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo10, {alpha: 0}, 2, {ease: FlxEase.circOut});

					case 'discodevil':
					FlxTween.tween(bg16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(bf16scared, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(holepuncher, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(bf16happy, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(smoke16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(people16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(microphone16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(shocked16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo102, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo16, {alpha: 0}, 2, {ease: FlxEase.circOut});
					FlxTween.tween(jojo10, {alpha: 0}, 2, {ease: FlxEase.circOut});
				}


					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						FlxTween.tween(box, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(cutsceneImage, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(swagDialogue, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(icons, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(dropText, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(skipText, {alpha: 0}, 2, {ease: FlxEase.circOut});
					}, 5);

					if (PlayState.continuetext == true)
					{
						switch(PlayState.PlayState.SONG.song.toLowerCase())
						{
							case 'missilemaestro':
							tbctxt = new FlxText(0, 0, FlxG.width,
							"To be continued in chapter 2...",
							64);
							case 'elasticentertainer':
							tbctxt = new FlxText(0, 0, FlxG.width,
							"To be continued in chapter 3...",
							64);
							case 'discodevil':
							tbctxt = new FlxText(0, 0, FlxG.width,
							"To be continued in chapter 4...",
							64);


						}

					tbctxt.setFormat(Paths.font("mario.ttf"), 64, CENTER);
					tbctxt.borderColor = FlxColor.BLACK;
					tbctxt.borderSize = 3;
					tbctxt.borderStyle = FlxTextBorderStyle.OUTLINE;
					tbctxt.screenCenter();
					tbctxt.alpha = 0;
					add(tbctxt);
					FlxTween.tween(tbctxt, {alpha: 1}, 6, {ease: FlxEase.circOut});

					new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						FlxTween.tween(tbctxt, {alpha: 0}, 4, {
				onComplete: function(twn:FlxTween)
				{
					finishThing();
					kill();
					FlxG.sound.music.stop();
				}
				});
					});
					}
					else
					{
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
					finishThing();
					kill();
					FlxG.sound.music.stop();
					});
					}
	}

	var zoosh = false;

	function startDialogue():Void
	{
		var setDialogue = false;
		var skipDialogue = false;
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case "bg":
				skipDialogue = true;
				switch(curAnim){
					case "hide":
						cutsceneImage.visible = false;
						cutsceneImage.alpha = 0;
					case "flash":
						var white:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
					white.scrollFactor.set();
					add(white);	
					FlxTween.tween(white, {alpha: 0}, 0.5, {
				onComplete: function(twn:FlxTween)
				{
					remove(white);
				}
				});
					case "tear":
						cutsceneImage.width = 1.2;
						zoosh = true;
						new FlxTimer().start(0.25, function(tmr:FlxTimer)
					{
					zoosh = false;
					cutsceneImage.width = 1;
					cutsceneImage.x = 0;
					cutsceneImage.y = 0;
					}); 
					default:
					if (firstimage == true)
				{
					firstimage = false;
					cutsceneImage.visible = true;
					cutsceneImage.alpha = 0;
					cutsceneImage.loadGraphic(BitmapData.fromFile("assets/dialogue/images/bg/" + curAnim + ".png"));
					FlxTween.tween(cutsceneImage, {alpha: 1}, 1, {ease: FlxEase.circOut});
				}
				else
				{
					cutsceneImage.visible = true;
					cutsceneImage.loadGraphic(BitmapData.fromFile("assets/dialogue/images/bg/" + curAnim + ".png"));
					FlxTween.tween(cutsceneImage, {alpha: 1}, 1, {ease: FlxEase.circOut});
				}
				}

			case "fade":
				skipDialogue = true;
				fadeImage.visible = true;
				fadeImage.loadGraphic(BitmapData.fromFile("assets/dialogue/images/bg/" + curAnim + ".png"));
				FlxTween.tween(fadeImage, {alpha: 0}, 1, {
				onComplete: function(twn:FlxTween)
				{
					fadeImage.visible = false;
					fadeImage.alpha = 1;
				}
				});

			case "music":
				skipDialogue = true;
				switch(curAnim){
					case "stop":
						FlxG.sound.music.stop();
					case "fadeIn":
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					default:
						FlxG.sound.playMusic(Sound.fromFile("assets/dialogue/music/" + curAnim + ".ogg"), Std.parseFloat(dialogueList[0]));
						FlxG.sound.music.volume = 0;
				}

			case "sound":
				skipDialogue = true;
				if (this.sound != null) this.sound.stop();
				sound = new FlxSound().loadEmbedded(Sound.fromFile("assets/dialogue/sounds/" + curAnim + ".ogg"));
				sound.play();
				
			case "cutscenesix":
				holdtime = 2;
				animatedCutscene = true;
				skipDialogue = true;
				if (!bg6.visible)
				{
					pausanpiker.visible = true;
					bg6.visible = true;
					flash6.visible = true;
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
					var white:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
					white.scrollFactor.set();
					add(white);	
					FlxTween.tween(white, {alpha: 0}, 0.5, {
				onComplete: function(twn:FlxTween)
				{
					remove(white);
				}
				});
					FlxG.camera.shake();
					black6.visible = true;
					bf6.visible = true;
					enemies6.visible = true;
					ohduck6.visible = true;
					gf6.visible = true;
					jojo16.visible = true;
					jojo26.visible = true;
					jojoanimate();
					FlxTween.tween(bf6, { x: -40 }, 0.25); 
					FlxTween.tween(enemies6, { x: 340 }, 0.25); 
					FlxTween.tween(ohduck6, { x: 520 }, 0.2); 

					new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
					FlxTween.tween(bf6, { x: -100 }, 0.2); 
					FlxTween.tween(enemies6, { x: 410 }, 0.2);
			}); 
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
					FlxTween.tween(bf6, { x: -70 }, 0.2); 
					FlxTween.tween(enemies6, { x: 380 }, 0.2); 
			}); 
					new FlxTimer().start(1, function(tmr:FlxTimer)
			{
					FlxTween.tween(gf6, { x: -100, y: 350}, 0.5); 
					new FlxTimer().start(0.6, function(tmr:FlxTimer)
			{
					gfshake();
			}); 
			}); 
			}); 
			}

			case "cutsceneten":
				holdtime = 1;
				animatedCutscene = true;
				skipDialogue = true;
				if (!bg10.visible)
				{
					bg10.visible = true;
					light10.visible = true;
					pencils10.visible = true;
					pencilrepeat();
					gf10.visible = true;
					ohduck10.visible = true;
					bf10.visible = true;
					lines10.visible = true;
					jojo102.visible = true;
					jojo10.visible = true;

					FlxTween.tween(pencils10, { alpha: 0.8}, 1); 
					jojoanimate();
					var white:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
					white.scrollFactor.set();
					add(white);	
					FlxTween.tween(white, {alpha: 0}, 0.5, {
					onComplete: function(twn:FlxTween)
					{
		
					}
					});
					FlxTween.tween(bf10, { y: 370}, 0.5); 
					FlxTween.tween(ohduck10, { x: 500 }, 0.5); 
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
					gfshake();
					FlxTween.tween(gf10, { y: 470}, 0.5); 
			}); 
				}

			case "cutscenesixteen":
				holdtime = 2;
				animatedCutscene = true;
				skipDialogue = true;
				if (!bg16.visible)
				{
					bg16.visible = true;
					bf16happy.visible = true;
					new FlxTimer().start(1, function(tmr:FlxTimer)
			{
					holepuncher.visible = true;
					FlxTween.tween(holepuncher.scale, {x:0.67, y:0.67}, 0.5);
					//FlxTween.tween(holepuncher, {scale: x:1, y:1}, 0.5);
					FlxTween.tween(holepuncher, { y: -100}, 0.5, {ease: FlxEase.quadOut}); 
					FlxTween.tween(holepuncher, {x: 80}, 0.5, {
					onComplete: function(twn:FlxTween)
					{
						shake = true;
						jojoanimate();
						jojo16.visible = true;
						jojo102.visible = true;
						jojo10.visible = true;
						people16.visible = true;
						shocked16.visible = true;
						microphone16.visible = true;
						FlxTween.tween(smoke16, {alpha: 1}, 0.5);
						FlxTween.tween(smoke16, {y: 100}, 0.5);
						FlxTween.tween(people16, {y: -50}, 0.7, {ease: FlxEase.quadOut});
						FlxTween.tween(microphone16, {angle: -3}, 0.5);
						FlxTween.tween(microphone16, {x: 180}, 0.5);
						FlxTween.tween(shocked16, {x: 100}, 0.5);
						FlxTween.tween(microphone16, {y: 450}, 0.5);
						bf16happy.visible = false;
						bf16scared.visible = true;
						var white:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
						white.scrollFactor.set();
						add(white);	
						FlxTween.tween(white, {alpha: 0}, 0.5, {
						onComplete: function(twn:FlxTween)
					{
						okflippinstopdashake = true;
						bf16scared.x = -70;
						bf16scared.y = 50;
						bg16.x = -320;
						bg16.y = -180;
						bg16.width = 0.67;
					}
						});
					}
					});
			}); 
				}



			case "bf":
				remove(icons);
				icons = new HealthIcon('bf', false);
				changeposition();
				add(icons);
				changeSound('bftext',0.6);

			case "gf":
				remove(icons);
				icons = new HealthIcon('gf', false);
				changeposition();
				add(icons);

			case "toad":
				remove(icons);
				icons = new HealthIcon('toad', false);
				changeposition();
				add(icons);

			case "picnic":
			if (animatedCutscene == true)
			{
				animatedCutscene = false;
				remove(icons);
				icons = new HealthIcon('picnic', false);
				changeposition();
				remove(box);
				remove(swagDialogue);
				remove(dropText);
				new FlxTimer().start(holdtime, function(tmr:FlxTimer)
			{
				box.animation.play('normalOpen');
				add(box);	
				add(icons);	
				add(dropText);
				add(swagDialogue);
			}); 
			}
			else
			{
				remove(icons);
				icons = new HealthIcon('picnic', false);
				changeposition();
				add(icons);
			}

			case "colors":
			if (animatedCutscene == true)
			{
				animatedCutscene = false;
				remove(icons);
				icons = new HealthIcon('colors', false);
				changeposition();
				remove(box);
				remove(swagDialogue);
				remove(dropText);
				new FlxTimer().start(holdtime, function(tmr:FlxTimer)
			{
				box.animation.play('normalOpen');
				add(box);	
				add(icons);	
				add(dropText);
				add(swagDialogue);
			}); 
			}
			else
			{
				remove(icons);
				icons = new HealthIcon('colors', false);
				changeposition();
				add(icons);
			}

			case "narrator":
				remove(icons);
				changeposition();
				changeSound('pixelText',0.6);

			case "yellowtoad":
				remove(icons);
				icons = new HealthIcon('yellowtoad', false);
				changeposition();
				add(icons);

			case "prof":
			remove(icons);
				icons = new HealthIcon('prof', false);
				changeposition();
				add(icons);

			case "dj":
			remove(icons);
				icons = new HealthIcon('dj', false);
				changeposition();
				add(icons);
			
			case "olivia":
				remove(icons);
				icons = new HealthIcon('olivia', false);
				changeposition();
				add(icons);

			case "autumn":
			remove(icons);
				icons = new HealthIcon('autumn', false);
				changeposition();
				add(icons);

			case "gondol":

			remove(icons);
				icons = new HealthIcon('gondol', false);
				changeposition();
				add(icons);

			case "rubber":
				remove(icons);
				icons = new HealthIcon('rubber', false);
				changeposition();
				add(icons);

			case "devil":
			if (animatedCutscene == true)
			{
				animatedCutscene = false;
				remove(icons);
				icons = new HealthIcon('devil', false);
				changeposition();
				remove(box);
				remove(swagDialogue);
				remove(dropText);
				new FlxTimer().start(holdtime, function(tmr:FlxTimer)
			{
				box.animation.play('normalOpen');
				add(box);	
				add(icons);	
				add(dropText);
				add(swagDialogue);
			}); 
			}
			else
			{
				remove(icons);
				icons = new HealthIcon('devil', false);
				changeposition();
				add(icons);
			}
		}

		if(!skipDialogue){
			if(!setDialogue){
				swagDialogue.resetText(dialogueList[0]);
			}

			swagDialogue.start(0.04, true);
		}
		else{

			dialogueList.remove(dialogueList[0]);
			startDialogue();
			
		}
	}

	function pencilrepeat()
	{
		FlxTween.tween(pencils10, {y: -180}, 1, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(pencils10, {y: -150}, 1, {
				ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween)
				{
					pencilrepeat();
				}
			});
		}
	});
	}

	function changeposition():Void
	{
		remove(swagDialogue);
		remove(dropText);
		switch (curCharacter)
	{
		case "narrator":
		
		dropText = new FlxText(202, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'FOT-PopJoy Std B';
		dropText.color = 0xFFFFFFFF;
		add(dropText);

		swagDialogue = new FlxTypeText(200, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'FOT-PopJoy Std B';
		swagDialogue.color = 0xFF000000;
		//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		default:

		icons.x = 130;
		icons.y = 480;

		dropText = new FlxText(282, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'FOT-PopJoy Std B';
		dropText.color = 0xFFFFFFFF;
		add(dropText);

		swagDialogue = new FlxTypeText(280, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'FOT-PopJoy Std B';
		swagDialogue.color = 0xFF000000;
		//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
	}

	}

	function cleanDialog():Void
	{
		while(dialogueList[0] == ""){
			dialogueList.remove(dialogueList[0]);
		}

		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curAnim = splitName[2];
	
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length  + 3).trim();
		
		
	}

	function changeSound(sound:String, volume:Float){
	swagDialogue.sounds = [FlxG.sound.load(Paths.sound(sound, 'dialogue'), volume)];
	
	}
}
