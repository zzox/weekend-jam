package data;

import objects.Powerup;

class Game {
    var scene:PlayState;

    static inline pointPowerups = [
        { points: 1000, powerups: [Double] },
        { points: 5000, powerups: [ForwardTrips, Shield] },
        { points: 10000, powerups: [Double] },
        { points: 25000, powerups: [MidTrips, Shield] },
        { points: 50000, powerups: [Clear] },
        { points: 100000, powerups: [Double] }
    ]

    public function new (scene:PlayState) {
        this.scene = scene;
    }

    public function checkPoints:Null<PowerupTypes> (points:Int) {
        var currentPowerup = pointPowerups[0]
        if (currentPowerup && points > currentPowerup.points) {

            // TODO: create a function that only gives out powerups that aren't owned
            return currentPowerup.powerups[
                Math.floor(MathMath.random() * currentPowerup.length)
            ]
        }
    }
}
