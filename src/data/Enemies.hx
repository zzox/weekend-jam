package data;

import flixel.math.FlxPoint;

enum EnemyType {
    SmallRedTwin;
    SmallGreenTwin;
    SmallBlueSquid;
}

enum EnemyPattern {
    Direct;
    DirectXY;
}

typedef EnemyInfo = {
    var name:String;
    var points:Int;
    var offset:FlxPoint;
    var size:FlxPoint;
    var pattern:EnemyPattern;
    var ?xVel:Int;
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
            points: 100,
            offset: new FlxPoint(8, 9),
            size: new FlxPoint(8, 4),
            pattern: Direct,
            yVel: 30
        },
        SmallGreenTwin => {
            name: "small-green-twin",
            points: 200,
            offset: new FlxPoint(8, 9),
            size: new FlxPoint(8, 4),
            pattern: Direct,
            yVel: 60
        },
        SmallBlueSquid => {
            name: "small-blue-squid",
            points: 500,
            offset: new FlxPoint(9, 10),
            size: new FlxPoint(7, 6),
            pattern: DirectXY,
            xVel: 30,
            yVel: 30,
        }
    ];
}

