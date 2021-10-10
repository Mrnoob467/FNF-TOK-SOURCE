package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var kadeLogo:FlxSprite;
    var placeholder:FlxSprite;

	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        placeholder = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('KadeEngineLogo'));
        placeholder.x -= placeholder.width / 2;
        placeholder.y -= placeholder.height / 2 + 100;

        text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading...");
        text.setFormat(Paths.font("mario.ttf"), 40, CENTER);
        text.alpha = 0;

        kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('TheOrigamiKingLogo'));
        kadeLogo.x -= kadeLogo.width / 2;
        kadeLogo.y -= kadeLogo.height / 2 + 100;
        text.y -= placeholder.height / 2 - 125;
        text.x -= 170;
        kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.3));

        kadeLogo.alpha = 0;

        add(kadeLogo);
        add(text);

        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            cache();
        });


        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {

        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
            kadeLogo.alpha = alpha;
            text.alpha = alpha;
            text.text = "Loading... (" + done + "/" + toBeDone + ")";
        }

        super.update(elapsed);
    }


    function cache()
    {

        var characters = [];
        var cutscenes = [];
        var dialogue = [];
        var music = [];
        var other = [];

        trace("caching characters...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            characters.push(i);
        }

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/cutscenes")))
        {
            if (!i.endsWith(".png"))
                continue;
            cutscenes.push(i);
        }

        trace("cashing dialogue...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/dialogue/images/bg")))
        {
            if (!i.endsWith(".png"))
                continue;
            dialogue.push(i);
        }

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/other/images")))
        {
            if (!i.endsWith(".png"))
                continue;
            other.push(i);
        }

        trace("caching music...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }

        toBeDone = Lambda.count(characters) + Lambda.count(cutscenes) + Lambda.count(dialogue) + Lambda.count(music) + Lambda.count(other);

        trace("LOADING: " + toBeDone + " OBJECTS.");

        for (i in characters)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        for (i in cutscenes)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("cutscenes/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        for (i in dialogue)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("bg/" + replaced,"dialogue"));
            trace("cached " + replaced);
            done++;
        }

        for (i in other)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("images/" + replaced,"other"));
            trace("cached " + replaced);
            done++;
        }

        for (i in music)
        {
            FlxG.sound.cache(Paths.inst(i));
            FlxG.sound.cache(Paths.voices(i));
            trace("cached " + i);
            done++;
        }

        trace("Finished caching...");

        FlxG.switchState(new TitleState());
    }

}