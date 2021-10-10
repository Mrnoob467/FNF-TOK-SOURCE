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

class LanguageMenu extends FlxSubState
{

    var ENGLISH:FlxText;
    var SPANISH:FlxText;
    var PORTU:FlxText;
    var ARROWS1:FlxText;
    var englishtruth:Bool;
    var spanishtruth:Bool;
    var portutruth:Bool;
    var curSelected:Int = 0;

    var blackBox:FlxSprite;
    var infoText:FlxText;

    var state:String = "select";

	override function create()
	{	
		//FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);

		persistentUpdate = persistentDraw = true;

        ENGLISH = new FlxText(-10, 400, 1280, "English", 72);
		ENGLISH.scrollFactor.set(0, 0);
		ENGLISH.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ENGLISH.borderSize = 2;
		ENGLISH.borderQuality = 3;

        SPANISH = new FlxText(-10, 400, 1280, "Español", 72);
		SPANISH.scrollFactor.set(0, 0);
		SPANISH.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		SPANISH.borderSize = 2;
		SPANISH.borderQuality = 3;
        SPANISH.visible = false;

        PORTU = new FlxText(-10, 400, 1280, "Português", 72);
		PORTU.scrollFactor.set(0, 0);
		PORTU.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		PORTU.borderSize = 2;
		PORTU.borderQuality = 3;
        PORTU.visible = false;

        ARROWS1 = new FlxText(400, 400, 1280, "<                >", 72);
		ARROWS1.scrollFactor.set(0, 0);
		ARROWS1.setFormat("VCR OSD Mono", 42, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ARROWS1.borderSize = 2;
		ARROWS1.borderQuality = 3;

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);

        infoText = new FlxText(-10, 580, 1280, "(Enter to save!)", 72);
		infoText.scrollFactor.set(0, 0);
		infoText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 2;
		infoText.borderQuality = 3;
        infoText.alpha = 0;
        infoText.screenCenter(FlxAxes.X);
        add(infoText);
        add(ENGLISH);
        add(SPANISH);
        add(PORTU);
        add(ARROWS1);

        blackBox.alpha = 0;
        ENGLISH.alpha = 0;
        SPANISH.alpha = 0;
        PORTU.alpha = 0;
        ARROWS1.alpha = 0;

        FlxTween.tween(ENGLISH, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(SPANISH, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(PORTU, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(ARROWS1, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(infoText, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

        //OptionsMenu.instance.acceptInput = false;

		super.create();
	}

	override function update(elapsed:Float)
	{

        switch(state){

            case "select":
                if (FlxG.keys.justPressed.LEFT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected -= 1;
                    if (curSelected == -1)
                    curSelected = 2;
                   
                    changeItem();
				}

				if (FlxG.keys.justPressed.RIGHT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected += 1;
                    if (curSelected == 3)
                    curSelected = 0;
                    
                    changeItem();
				}

                else if(FlxG.keys.justPressed.ENTER){
                    quit();
                }
            case "exiting":


            default:
                state = "select";

        }

        if(FlxG.keys.justPressed.ANY)

		super.update(elapsed);
		
	}

    function save(){

        FlxG.save.data.english = englishtruth;
        FlxG.save.data.spanish = spanishtruth;
        FlxG.save.data.portu = portutruth;

        FlxG.save.flush();
    }

    function quit(){

        state = "exiting";

        save();

        close();

        //OptionsMenu.instance.acceptInput = true;

        FlxTween.tween(ENGLISH, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(SPANISH, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(PORTU, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(ARROWS1, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
    }

    function changeItem()
    {
        switch (curSelected)
        {
            case 0:
            ENGLISH.visible = true;
            SPANISH.visible = false;
            PORTU.visible = false;
            englishtruth = true;
            spanishtruth = false;
            portutruth = false;

            case 1:
            ENGLISH.visible = false;
            SPANISH.visible = true;
            PORTU.visible = false;
            englishtruth = false;
            spanishtruth = true;
            portutruth = false;

            case 2:
            ENGLISH.visible = false;
            SPANISH.visible = false;
            PORTU.visible = true;
            englishtruth = false;
            spanishtruth = false;
            portutruth = true;
        }   
    }
}
