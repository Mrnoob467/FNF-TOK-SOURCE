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

class WarningSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var currChanges:String = "dk";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('conceptsketch3', 'preload'));
		bg.screenCenter();
		add(bg);
		
		var OrigamiLogo:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('TheOrigamiKingLogo'));
		OrigamiLogo.setGraphicSize(Std.int(OrigamiLogo.width * 0.3));
		//OrigamiLogo.x += 100;
		//OrigamiLogo.y -= 180;
		OrigamiLogo.alpha = 0.8;
		add(OrigamiLogo);
		
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"'Friday Night Funkin': The Origami King' contains\n a copyright free option!\nLook for it in the settings menu!\n\nIf you would like to switch the language of the game, please head to 'Languages' in settings!\nPress 'escape' to return to the story menu! 
			\n
			'Friday Night Funkin: The Origami King' contiene\n una opción para jugar las canciones sin copyright.\n Para activarla, ve al menú 'Settings'.\n\nSi quieres cambiar el idioma de los diálogos a español, ve a 'Settings' y 'Language'.\nPresiona 'esc' para volver al menú. ",
			32);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
		
		FlxTween.angle(OrigamiLogo, OrigamiLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(OrigamiLogo.angle == -10) FlxTween.angle(OrigamiLogo, OrigamiLogo.angle, 10, 2, {ease: FlxEase.quartInOut});
			else FlxTween.angle(OrigamiLogo, OrigamiLogo.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);
		
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if(OrigamiLogo.alpha == 0.8) FlxTween.tween(OrigamiLogo, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else FlxTween.tween(OrigamiLogo, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
