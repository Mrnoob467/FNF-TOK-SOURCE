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
		var bg:FlxSprite = new FlxSprite(0, -700).loadGraphic(Paths.image('conceptsketch3', 'preload'));
		bg.setGraphicSize(Std.int(bg.width * 0.15));
		bg.screenCenter(X);
		add(bg);
		
		var txt:FlxText = new FlxText(0, 200, FlxG.width,
			"'Friday Night Funkin': The Origami King' contains multiple language options!\nLanguages include English, Spanish, and Portuguese!\nAccess them from settings!\n\n'Friday Night Funkin' The Origami King' está disponible en múltiples idiomas\n (Inglés, español y portugués)\n Para cambiarlos, accede al menú de opciones.\n\n'Friday Night Funkin': The Origami King' contém várias opções de idioma! \nIdiomas incluem Inglês, Espanhol e Português!\n Acesse elas pelas configurações!",
			32);
		
		txt.setFormat("VCR OSD Mono", 32, CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter(X);
		txt.y += 100;
		add(txt);		
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ANY)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
