package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

enum PowerupTypes {
    Go;
    Double;
    ForwardTrips;
    MidTrips;
    SideTrips;
    Backshoot;
    Clear;
    Shield;
    Repair;
}

typedef PowerupData = {
    var ?cost:Int;
    var animation:String;
}

class Powerup extends FlxSprite {
    public var type:PowerupTypes;
    public var selected:Bool;

    public static final dict:Map<PowerupTypes, PowerupData> = [
        Go => { animation: 'go' },
        Clear => { cost: 5000, animation: 'clear' },
        Shield => { cost: 10000, animation: 'shield' },
        Repair => { cost: 50000, animation: 'repair' },
        ForwardTrips => { cost: 50000, animation: 'forward-trips' },
        MidTrips => { cost: 50000, animation: 'mid-trips' },
        Backshoot => { cost: 75000, animation: 'back-shoot' },
        SideTrips => { cost: 100000, animation: 'side-trips' },
        Double => { animation: 'double' }
    ];

    public function new (x:Float, y:Float, type:PowerupTypes) {
        super(x, y);
        this.type = type;
        loadGraphic(AssetPaths.powerups__png, true, 16, 16);
        offset.set(2, 2);
        setSize(12, 12);
        animation.add('go', [0]);
        animation.add('double', [1]);
        animation.add('forward-trips', [2]);
        animation.add('mid-trips', [3]);
        animation.add('side-trips', [4]);
        animation.add('back-shoot', [5]);
        animation.add('shield', [6]);
        animation.add('clear', [7]);
        animation.add('repair', [8]);
        animation.play(dict[type].animation);

        selected = false;
    }

    public function select ():PowerupTypes {
        selected = true;
        FlxTween.tween(scale, { x: 0 }, 0.5, { onComplete: (_:FlxTween) -> this.kill(), ease: FlxEase.cubeIn });
        return type;
    }
}
