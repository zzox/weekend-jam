package data;

import data.Structures;
import data.Enemies;
/**
    Big Static Map with Arrays of waves and subwaves for each level
**/
class Waves {
    // static inline final

    public static final data = [
        "space-1" => [
            [
                { type: SmallRedTwin, quantity: 1, shape: OneMiddle, time: 0 },
                { type: SmallRedTwin, quantity: 1, shape: FiveWide, time: 2 },
                { type: SmallRedTwin, quantity: 2, shape: FiveWide, time: 4 },
                { type: SmallRedTwin, quantity: 1, shape: OneMiddle, time: 6 },
                { type: SmallRedTwin, quantity: 1, shape: FiveWide, time: 8 },
                { type: SmallRedTwin, quantity: 2, shape: FiveWide, time: 10 },
                { type: SmallRedTwin, quantity: 3, shape: ThreeMiddle, time: 12 }
            ], [
                { type: SmallRedTwin, quantity: 2, shape: TwoMiddle, time: 0 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, time: 2 },
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, time: 4 },
                { type: SmallRedTwin, quantity: 2, shape: TwoMiddle, time: 6 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, time: 8 },
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, time: 10 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, time: 12 }
            ], [
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, time: 0 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, time: 2 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, time: 4 },
                { type: SmallBlueSquid, quantity: 1, shape: OneMiddleWideLeft, time: 5 },
                { type: SmallRedTwin, quantity: 3, shape: FiveWide, time: 6 },
                { type: SmallBlueSquid, quantity: 1, shape: OneMiddleWideRight, time: 7 },
                { type: SmallGreenTwin, quantity: 2, shape: TwoWide, time: 8 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, time: 10 },
                { type: SmallRedTwin, quantity: 5, shape: FiveWide, time: 11 }
            ]
        ]
    ];
}
