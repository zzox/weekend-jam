package data;

import objects.Powerup;

class Game {
    var scene:PlayState;

    static var pointPowerups = [
        { points: 1000, type: Double },
        { points: 5000, type: ForwardTrips },
        { points: 10000, type: Double },
        { points: 50000, type: MidTrips },
        { points: 100000, type: Double },
        { points: 500000, type: SideTrips },
        { points: 1000000, type: Double },
        { points: 5000000, type: Backshoot },
        { points: 10000000, type: Double }
    ];

    public function new (scene:PlayState) {
        // get high score from storage
        this.scene = scene;
    }

    public function checkPoints (points:Int): Null<PowerupTypes> {
        var currentPowerup = pointPowerups[0];
        if (currentPowerup != null && points >= currentPowerup.points) {
            pointPowerups.shift();
            return currentPowerup.type;
        }

        return null;
    }
}
