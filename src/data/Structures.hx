package data;

import data.Constants as Const;

enum EnemyStructure {
    OneMiddle;
    TwoMiddle;
    ThreeMiddle;
    FiveWide;
}

class Structures {
    static final oneMiddle = [.5];
    static final twoMiddle = [.45, .55];
    static final threeMiddle = [.35, .5, .65];
    static final fiveWide = [0, .25, .5, .75, 1];

    public static function getStructure (structure:EnemyStructure, quantity:Int):Array<Int> {
        var arrayStruct = switch (structure:EnemyStructure) {
            case OneMiddle: oneMiddle;
            case TwoMiddle: twoMiddle;
            case ThreeMiddle: threeMiddle;
            case FiveWide: fiveWide;
        }
        
        var a = arrayStruct.copy();
        var items = [];
        for (_ in 0...quantity) {
            var selection = a.splice(Math.floor(Math.random() * a.length), 1);

            items.push(Structures.formulateDistance(selection[0]));
        }

        trace(items);

        return items;
    }

    /**
        take the percentage of the width from the structure and interpolate into a y position
    **/
    static function formulateDistance (value:Float):Int {
        return Math.floor(Const.LEFT_BUMPER + value * (
            Const.RIGHT_BUMPER - Const.LEFT_BUMPER
        ));
    }
}
