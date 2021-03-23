package data;

import flixel.math.FlxPoint;

enum EnemyType {
    SmallRedTwin;
    SmallGreenTwin;
}

enum EnemyPattern {
    Direct;
}

typedef EnemyInfo = {
    var name:String;
    var offset:FlxPoint;
    var size:FlxPoint;
    var pattern:EnemyPattern;
    var ?yVel:Int;
}

/**
    Big Static Map with Arrays of waves and subwaves for each level
**/
class Enemies {
    // static inline final

    public static final data:Map<EnemyType, EnemyInfo> = [
        SmallRedTwin => {
            name: "small-red-twin",
            offset: new FlxPoint(8, 9),
            size: new FlxPoint(8, 4),
            pattern: Direct,
            yVel: 30
        },
        SmallGreenTwin => {
            name: "small-green-twin",
            offset: new FlxPoint(8, 9),
            size: new FlxPoint(8, 4),
            pattern: Direct,
            yVel: 60
        },
    ];
}

