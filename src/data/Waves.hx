package data;

import data.Structures;
import data.Enemies;
/**
    Big Static Map with Arrays of waves and subwaves for each level
**/
class Waves {
    public static function convertBeatsToSeconds (beats:Float, bpm:Int) {
        return 60 / bpm * beats;
    }

    public static final data = [
        "space-1" => {
            bpm: 128,
            song: AssetPaths.int1__wav,
            waves: [[
                { type: SmallRedTwin, quantity: 1, shape: OneMiddle, beats: 0 },
                { type: SmallRedTwin, quantity: 1, shape: FiveWide, beats: 4 },
                { type: SmallRedTwin, quantity: 2, shape: FiveWide, beats: 8 },
                { type: SmallRedTwin, quantity: 1, shape: OneMiddle, beats: 12 },
                { type: SmallRedTwin, quantity: 1, shape: FiveWide, beats: 16 },
                { type: SmallRedTwin, quantity: 2, shape: FiveWide, beats: 20 },
                { type: SmallRedTwin, quantity: 3, shape: ThreeMiddle, beats: 24 }
            ], [
                { type: SmallRedTwin, quantity: 2, shape: TwoMiddle, beats: 0 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, beats: 4 },
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, beats: 8 },
                { type: SmallRedTwin, quantity: 2, shape: TwoMiddle, beats: 12 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, beats: 16 },
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, beats: 20 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 24 }
            ], [
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, beats: 0 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, beats: 4 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 8 },
                { type: SmallBlueSquid, quantity: 1, shape: OneMiddleWideLeft, beats: 10 },
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, beats: 12 },
                { type: SmallBlueSquid, quantity: 1, shape: OneMiddleWideRight, beats: 14 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, beats: 16 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 20 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 22 }
            ]]
        }
    ];
}
