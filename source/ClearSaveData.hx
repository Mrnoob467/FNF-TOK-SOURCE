package;

/// Code created by Rozebud for FPS Plus (thanks rozebud)
// modified by KadeDev for use in Kade Engine/Tricky

import flixel.util.FlxAxes;
import flixel.FlxSubState;
import Options.Option;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
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
import io.newgrounds.NG;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;


using StringTools;

class ClearSaveData extends FlxSubState
{

    var warning:FlxText;

    var blackBox:FlxSprite;
    var infoText:FlxText;

    var state:String = "select";

	override function create()
	{	
		//FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);

		persistentUpdate = persistentDraw = true;

        warning = new FlxText(-10, 400, 1280, "WARNING: CLEARING YOUR SAVE DATA WILL REMOVE ALL OF YOUR PROGRESS. PRESS ESCAPE IF YOU WISH TO KEEP YOUR DATA.", 72);
		warning.scrollFactor.set(0, 0);
		warning.setFormat("VCR OSD Mono", 42, FlxColor.RED, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warning.borderSize = 2;
		warning.borderQuality = 3;
        warning.screenCenter();

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        infoText = new FlxText(-10, 580, 1280, "(Press enter to continue.)", 72);
		infoText.scrollFactor.set(0, 0);
		infoText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 2;
		infoText.borderQuality = 3;
        infoText.alpha = 0;
        infoText.screenCenter(FlxAxes.X);
        add(infoText);
        add(warning);

        blackBox.alpha = 0;
        warning.alpha = 0;

        FlxTween.tween(warning, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(infoText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

		super.create();
	}

	override function update(elapsed:Float)
	{

        if(FlxG.keys.justPressed.ENTER)
        {
            FlxG.save.data.beatchapter1 = false;
            FlxG.save.data.beatchapter2 = false;
            FlxG.save.data.beatchapter3 = false;
            FlxG.save.data.yape = false;
            FlxG.save.data.english = true;
            FlxG.save.data.spanish = false;
            FlxG.save.data.portu = false;
            FlxG.save.data.healthbar = false;

            close();
        }

        if (FlxG.keys.justPressed.ESCAPE)
        close();

		super.update(elapsed);
		
	}

    function quit(){

        close();
    }
}
