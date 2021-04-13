package data;

import objects.Powerup;

class Game {
    var scene:PlayState;

    static var pointPowerups = [
        { points: 1000, type: Double },
        { points: 5000, type: Shield },
        { points: 10000, type: Double },
        { points: 25000, type: MidTrips },
        { points: 50000, type: Clear },
        { points: 100000, type: Double },
        { points: 1000000, type: Double }
    ];

    public function new (scene:PlayState) {
        this.scene = scene;
    }

    public function checkPoints (points:Int): Null<PowerupTypes> {
        var currentPowerup = pointPowerups[0];
        if (currentPowerup != null && points > currentPowerup.points) {
            return currentPowerup.type;
        }

        return null;
    }
}
