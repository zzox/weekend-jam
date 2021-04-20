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

    public static final data = [{
        bpm: 128,
        song: AssetPaths.int1__wav,
        visibleStars: ['far-star'],
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
            // TODO: have squids from random directions in both of these
            { type: SmallBlueSquid, quantity: 1, shape: OneMiddleWideRight, beats: 14 },
            { type: SmallGreenTwin, quantity: 2, shape: TwoWide, beats: 16 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 20 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 22 }
        ]]
    }, {
        bpm: 140,
        song: AssetPaths.int1__wav,
        visibleStars: ['far-star', 'small-star', 'star-twinkle'],
        waves: [[
            { type: SmallGreenTwin, quantity: 2, shape: TwoMiddle, beats: 0 },
            { type: SmallRedTwin, quantity: 3, shape: FiveWide, beats: 1 },
            { type: SmallGreenTwin, quantity: 2, shape: TwoWide, beats: 2 },
            { type: SmallRedTwin, quantity: 4, shape: FiveWide, beats: 3 },
            { type: SmallGreenTwin, quantity: 2, shape: TwoMiddle, beats: 4 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 5 },
            { type: RedTwinShooter, quantity: 1, shape: OneMiddle, beats: 6 },
            { type: SmallGreenTwin, quantity: 5, shape: FiveWide, beats: 10 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 11 },
            { type: SmallGreenTwin, quantity: 2, shape: TwoMiddle, beats: 12 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 13 },
            { type: SmallGreenTwin, quantity: 2, shape: TwoMiddle, beats: 14 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 15 },
            { type: RedTwinShooter, quantity: 2, shape: TwoWide, beats: 16 }
        ], [
            { type: SmallGreenTwin, quantity: 3, shape: ThreeMiddle, beats: 0 },
            { type: SmallRedTwin, quantity: 3, shape: FiveWide, beats: 1 },
            { type: SmallGreenTwin, quantity: 3, shape: ThreeMiddle, beats: 2 },
            { type: SmallRedTwin, quantity: 4, shape: FiveWide, beats: 3 },
            { type: SmallGreenTwin, quantity: 3, shape: ThreeMiddle, beats: 4 },
            { type: RedTwinShooter, quantity: 1, shape: OneMiddle, beats: 5 },
            { type: SmallRedTwin, quantity: 5, shape: FiveWide, beats: 6 },
            { type: RedTwinShooter, quantity: 3, shape: ThreeMiddle, beats: 7 },
            { type: SmallGreenTwin, quantity: 5, shape: FiveWide, beats: 8 },
            { type: RedTwinShooter, quantity: 3, shape: FiveWide, beats: 9 },
            { type: SmallGreenTwin, quantity: 5, shape: TwoMiddle, beats: 10 },
            { type: RedTwinShooter, quantity: 3, shape: FiveWide, beats: 11 },
            { type: SmallGreenTwin, quantity: 5, shape: TwoMiddle, beats: 12 },
            { type: RedTwinShooter, quantity: 3, shape: ThreeMiddle, beats: 13 },
            { type: GreenTwinShooter, quantity: 5, shape: FiveWide, beats: 14 }
        ]]
    }];
}
