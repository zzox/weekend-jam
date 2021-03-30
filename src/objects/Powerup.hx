package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

enum PowerupTypes {
    ForwardTrips;
    MidTrips;
    SideTrips;
    Backshoot;
    Clear;
    Shield;
    Repair;
}

class Powerup extends FlxSprite {
    public var type:PowerupTypes;
    public function new (x:Int, y:Int, type:PowerupTypes) {
        super(x, y);
        this.type = type;
        offset.set(2, 2);
        setSize(12, 12);
    }

    public function select ():PowerupTypes {
        FlxTween.tween(scale, { x: 0 }, 0.75, { onComplete: (_:FlxTween) -> this.kill() });
        return type;
    }
}
