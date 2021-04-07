package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

enum PowerupTypes {
    Double;
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

    static inline powerupCosts:Map<PowerupTypes, Int> = {
        Clear => 5000,
        Shield => 10000,
        Repair => 20000,
        ForwardTrips => 50000,
        MidTrips => 50000,
        Backshoot => 75000,
        SideTrips => 100000,
        Double => 1000000
    }

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
