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
import flixel.input.keyboard.FlxKey;

#if windows
import Discord.DiscordClient;
#end

class ShopState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var currChanges:String = "dk";
	var yapehard:Int = 2;
	var current:Int = 0;
	var dontdoitagain:Bool = false;
	var konamicode:Array<String> = ['O', 'R', 'I', 'G', 'A', 'M', 'I', 'K', 'O', 'R', 'I', 'G', 'A', 'M', 'I'];
	var currentpress:String;

	override function create()
	{
		super.create();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In The Shop", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('shop/EmptyShop', 'preload'));
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.screenCenter();
		add(bg);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
	}

	function checkpress():Void
	{
		if (currentpress == konamicode[0])
		{
			FlxG.sound.play(Paths.sound('unlock'));
		konamicode.remove(konamicode[0]);
		if (konamicode.length == 0)
		{
		FlxG.save.data.yape = true;
			PlayState.isStoryMode = false;

			var poop:String = Highscore.formatSong('TheAlmightyYape', yapehard);

			PlayState.SONG = Song.loadFromJson(poop, 'thealmightyyape');
			PlayState.storyDifficulty = yapehard;
			PlayState.campaignScore = 0;
			LoadingState.loadAndSwitchState(new PlayState(), true);	
		}
		}
		else
		{
		konamicode = ['O', 'R', 'I', 'G', 'A', 'M', 'I', 'K', 'O', 'R', 'I', 'G', 'A', 'M', 'I'];	
		FlxG.sound.play(Paths.sound('lock'));
		}
	}

	override function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.O)
		{
			currentpress = O;
			checkpress();
		}

		if (FlxG.keys.justPressed.R)
		{
			currentpress = R;
			checkpress();
		}

		if (FlxG.keys.justPressed.I)
		{
			currentpress = I;
			checkpress();
		}

		if (FlxG.keys.justPressed.G)
		{
			currentpress = G;
			checkpress();
		}

		if (FlxG.keys.justPressed.A)
		{
			currentpress = A;
			checkpress();
		}

		if (FlxG.keys.justPressed.M)
		{
			currentpress = M;
			checkpress();
		}

		if (FlxG.keys.justPressed.K)
		{
			currentpress = K;
			checkpress();
		}

		if (controls.BACK)
		{
			leftState = true;
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}