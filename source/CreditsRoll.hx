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

class CreditsRoll extends MusicBeatState
{
	var OrigamiLogo:FlxSprite;
	var credtxt:FlxText;

	override function create()
	{
		super.create();
		
		OrigamiLogo = new FlxSprite(-1100, 0).loadGraphic(Paths.image('TheOrigamiKingLogo'));
		OrigamiLogo.setGraphicSize(Std.int(OrigamiLogo.width * 0.3));
		//OrigamiLogo.screenCenter(X);
		add(OrigamiLogo);

		credtxt = new FlxText(0, 800, FlxG.width,
			"DEV TEAM\n\nNinKey - Artist/Animator/Director\nArtPanz - Cutscene Artist/Trailer Maker\n200thSnak - Storywriter/Musician/Charter\nProgrammer - LemonKing\n\n\nSUPPORT TEAM\n\nDoodlz - Additional Artist\nFruitsy - Modcharts\nXyle - Trailer Music\nSoulegal - Portuguese Translator\nAizakku - Portuguese Translator\n\n\nBETA TESTERS\n\n\n'Paper Mario The Origami King' by Nintendo\n\n'Friday Night Funkin' by Ninjamuffin99 & crew\n\nKade Engie by KadeDeveloper\n\n\nSPECIAL THANKS\n\nSound Effects - Freesounds.org & TobyFox\n\nHostKal\nYuno\n\n\nAnd you :)",
			64);
		credtxt.setFormat(Paths.font("mario.ttf"), 50, CENTER);
		credtxt.borderColor = FlxColor.BLACK;
		credtxt.borderSize = 3;
		credtxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(credtxt);

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
						FlxTween.tween(credtxt, {y: -5000}, 45, {
					onComplete: function(twn:FlxTween)
					{
						FlxG.switchState(new MainMenuState());
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
