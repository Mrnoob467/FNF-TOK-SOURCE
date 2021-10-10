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

#if windows
import Discord.DiscordClient;
#end

class CreditsRoll extends MusicBeatState
{
	var OrigamiLogo:FlxSprite;
	var credtxt:FlxText;
	var unlocktxt:FlxText;

	override function create()
	{
		super.create();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Watching The Credits", null);
		#end
		
		OrigamiLogo = new FlxSprite(-1100, 0).loadGraphic(Paths.image('TheOrigamiKingLogo'));
		OrigamiLogo.setGraphicSize(Std.int(OrigamiLogo.width * 0.3));
		//OrigamiLogo.screenCenter(X);
		add(OrigamiLogo);

		credtxt = new FlxText(0, 800, FlxG.width,
			"DEV TEAM\n\nNinKey - Artist/Animator/Director\nArtPanz - Cutscene Artist/Trailer Maker\n200thSnak - Storywriter/Musician/Charter\nLemonKing - Programmer\n\n\nSUPPORT TEAM\n\nDoodlz - Additional Artist\nDiscWraith - Additional Charting Help\nFruitsy - Modcharts\nXyle - Trailer Music\nSoulegal - Portuguese Translator\nAizakku - Portuguese Translator\n\n\nBETA TESTERS\n\nClowfoe\nDiscWraith\nMattheenstra\nDubSkuad\n\n\n'Paper Mario The Origami King' by Nintendo\n\n\n'Friday Night Funkin' by Ninjamuffin99 & crew\n\n\nKade Engine by KadeDeveloper\n\n\nSPECIAL THANKS\n\nSound Effects - Freesounds.org & TobyFox\nHostKal - Additional Art\nJuno Songs - Yape\nMan on the Internet - Yape\n\n\nAnd you :)",
			64);
		credtxt.setFormat(Paths.font("mario.ttf"), 50, CENTER);
		credtxt.borderColor = FlxColor.BLACK;
		credtxt.borderSize = 3;
		credtxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(credtxt);

		unlocktxt = new FlxText(0, 400, FlxG.width,
			"Shop + 'Origami Korigami' = special surprise ;)",
			64);
		unlocktxt.setFormat(Paths.font("mario.ttf"), 50, CENTER);
		unlocktxt.borderColor = FlxColor.BLACK;
		unlocktxt.borderSize = 3;
		unlocktxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		unlocktxt.alpha = 0;
		add(unlocktxt);

		var entertxt:FlxText = new FlxText(450, 650, FlxG.width,
			"Press Enter To Skip! ",
			32);
		entertxt.setFormat(Paths.font("mario.ttf"), 32, CENTER);
		entertxt.borderColor = FlxColor.BLACK;
		entertxt.borderSize = 3;
		entertxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(entertxt);

		begincredits();
	}

	var lolspin = false;

	function begincredits():Void
	{
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		FlxTween.tween(OrigamiLogo, {y: -900}, 1.5, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				lolspin = true;
				spin();
				new FlxTimer().start(8, function(tmr:FlxTimer)
			{
				lolspin = false;
				OrigamiLogo.angle = 0;
				FlxTween.tween(OrigamiLogo, {y: -1700}, 4, {
					onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(credtxt, {y: -2500}, 45, {
					onComplete: function(twn:FlxTween)
					{
				FlxTween.tween(unlocktxt, {alpha: 1 }, 1); 
				new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
			});
					}
					});
					}
					});
			});
			}
			});
	}

	function spin():Void
	{

		FlxTween.tween(OrigamiLogo, {angle: 3}, 1.5, {
					onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(OrigamiLogo, {angle: -3}, 1.5, {
					onComplete: function(twn:FlxTween)
					{
						if(lolspin == true)
						spin();
						else
						OrigamiLogo.angle = 0;
					}
					});
					}
					});
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
