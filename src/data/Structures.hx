package data;

import data.Constants as Const;

enum EnemyStructure {
    OneMiddle;
    TwoMiddle;
    TwoWide;
    ThreeMiddle;
    FiveWide;
}

class Structures {
    static final structureMap = [
        OneMiddle => [.5],
        TwoMiddle => [.45, .55],
        TwoWide => [.125, .875],
        ThreeMiddle => [.35, .5, .65],
        FiveWide => [0, .25, .5, .75, 1]
    ];

    public static function getStructure (structure:EnemyStructure, quantity:Int):Array<Int> {
        var arrayStruct = structureMap[structure];
        
        var a = arrayStruct.copy();
        var items = [];
        for (_ in 0...quantity) {
            var selection = a.splice(Math.floor(Math.random() * a.length), 1);

            items.push(Structures.formulateDistance(selection[0]));
        }

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
