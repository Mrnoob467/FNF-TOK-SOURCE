package;

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

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';
	var curAnim:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];


	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	var cutsceneImage:FlxSprite;

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
			case 'picnicroad':
				FlxG.sound.playMusic(Paths.music('1-1', 'chapter1'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		cutsceneImage = new FlxSprite(0, 0);
		cutsceneImage.visible = false;
		add(cutsceneImage);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'picnicroad':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('cutscenes/dialoguebox-paper', 'shared');
				box.animation.addByPrefix('normalOpen', 'dialoguebox-paper', 24, false);
				box.animation.addByIndices('normal', 'dialoguebox-paper', [6], "", 24);
				box.setGraphicSize(Std.int(box.width * 0.67));
				box.y += 230;

			case 'redstreamerbattle':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('cutscenes/dialoguebox-paper', 'shared');
				box.animation.addByPrefix('normalOpen', 'dialoguebox-paper', 24, false);
				box.animation.addByIndices('normal', 'dialoguebox-paper', [6], "", 24);
				box.setGraphicSize(Std.int(box.width * 0.67));
				box.y += 230;

			case 'missilemaestro':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('cutscenes/dialoguebox-paper', 'shared');
				box.animation.addByPrefix('normalOpen', 'dialoguebox-paper', 24, false);
				box.animation.addByIndices('normal', 'dialoguebox-paper', [6], "", 24);
				box.setGraphicSize(Std.int(box.width * 0.67));
				box.y += 230;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
	
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
		}


		
		box.animation.play('normalOpen');
		box.updateHitbox();
		box.screenCenter(X);
		add(box);

		icons = new HealthIcon('bf', false);
		add(icons);
		icons.visible = false;


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(282, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'FOT-PopJoy Std B';
		dropText.color = 0xFFFFFFFF;
		add(dropText);

		swagDialogue = new FlxTypeText(280, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'FOT-PopJoy Std B';
		swagDialogue.color = 0xFF000000;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
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

	override function update(elapsed:Float)
	{

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

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'picnicroad')
						FlxG.sound.music.fadeOut(2.2, 0);

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
				}


					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						FlxTween.tween(box, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(cutsceneImage, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(swagDialogue, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(icons, {alpha: 0}, 2, {ease: FlxEase.circOut});
						FlxTween.tween(dropText, {alpha: 0}, 2, {ease: FlxEase.circOut});
					}, 5);

					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
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
		}
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
	var fadingimage:Bool = false;

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
					default:
						cutsceneImage.visible = true;
						cutsceneImage.loadGraphic(BitmapData.fromFile("assets/dialogue/images/bg/" + curAnim + ".png"));
				}
				
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



			case "bf":
				remove(icons);
				icons = new HealthIcon('bf', false);
				changeposition();
				add(icons);

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
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
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
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
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
}
