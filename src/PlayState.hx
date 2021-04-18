package;

import display.Banner;
import actors.Player;
import actors.Enemy;
import data.Enemies;
import data.Game;
import data.Structures;
import data.Waves;
import data.Weapons;
import display.Background;
import display.Explosion;
import display.HUD;
import display.Store;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Projectile;
import objects.Powerup;

enum GameState {
    Playing;
    MainMenu;
    StoreState;
    GameOver;
}

class PlayState extends FlxState {
    static inline final ENEMY_POOL_SIZE = 100;
    static inline final PROJ_POOL_SIZE = 1000;
    static inline final EXPLOSION_POOL_SIZE = 20;
    public static inline final PLAYER_START_X = 77;
    static inline final PLAYER_START_Y = 200;
    static inline final PLAYER_RESPAWN_Y = 300;
    static inline final TRANSITION_TIME = 3.0;
    static inline final POWERUP_MIDDLE = 6;

    public var gameState:GameState;
    var gameData:Game;

    var background:Background;
    public var player:Null<Player>;
    var enemies:FlxTypedGroup<Enemy>;
    var projectiles:FlxTypedGroup<Projectile>;
    var enemyProjectiles:FlxTypedGroup<Projectile>;
    var explosions:FlxTypedGroup<Explosion>;
    public var powerups:FlxTypedGroup<Powerup>;

    public var worldIndex:Int;
    var waveIndex:Int;
    var subwaveIndex:Int;
    var gameTime:Float;
    public var points:Int;

    public var livingEnemies:Int;
    var subwavesDone:Bool;
    var levelComplete:Bool;

    var ambientSound:FlxSound;
    var waveSound:FlxSound;
    var loopTime:Float = 0.0;

    var hud:HUD;
    var banner:Banner;

    var store:Store;

    override public function create() {
        super.create();

        // PROD: remove this vvv
        // requires `-debug` flag
        FlxG.debugger.visible = true;
        FlxG.debugger.drawDebug = true;

        FlxG.mouse.visible = false;

        camera.pixelPerfectRender = true;
        FlxG.scaleMode = new PixelPerfectScaleMode();

        bgColor = 0xff151515;

        background = new Background(this);
        add(background);

        store = new Store(this);
        store.visible = false;
        add(store);

        player = new Player(PLAYER_START_X, PLAYER_START_Y, this);
        add(player);
        add(player.horizontalFlames);
        add(player.verticalFlames);

        enemies = new FlxTypedGroup<Enemy>(ENEMY_POOL_SIZE);
        for (_ in 0...ENEMY_POOL_SIZE) {
            var enemy = new Enemy(this);
            enemy.kill();
            enemies.add(enemy);
        }
        add(enemies);

        projectiles = new FlxTypedGroup<Projectile>(PROJ_POOL_SIZE);
        for (_ in 0...PROJ_POOL_SIZE) {
            var proj = new Projectile();
            proj.kill();
            projectiles.add(proj);
        }
        add(projectiles);

        enemyProjectiles = new FlxTypedGroup<Projectile>(PROJ_POOL_SIZE);
        var proj = new Projectile();
        for (_ in 0...PROJ_POOL_SIZE) {
            proj.kill();
            enemyProjectiles.add(proj);
        }
        add(enemyProjectiles);

        explosions = new FlxTypedGroup<Explosion>(EXPLOSION_POOL_SIZE);
        for (_ in 0...EXPLOSION_POOL_SIZE) {
            var explo = new Explosion();
            explo.kill();
            explosions.add(explo);
        }
        add(explosions);

        hud = new HUD(this);
        hud.visible = false;
        add(hud);

        powerups = new FlxTypedGroup<Powerup>();
        add(powerups);

        banner = new Banner();
        add(banner);

        gameState = MainMenu;
        ambientSound = FlxG.sound.play(AssetPaths.amb1__wav, 1.0, true);

        gameData = new Game(this);

        worldIndex = 0;
        points = 0;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        var anyKey:Bool = false;
        if (FlxG.keys.anyJustPressed([SPACE, TAB, Z, X])) {
            anyKey = true;
        }

        if (gameState == Playing) {
            FlxG.overlap(enemies, player, overlapPlayerWithEnemy);
            FlxG.overlap(projectiles, enemies, overlapProjectileWithEnemy);
            FlxG.overlap(enemyProjectiles, player, overlapEnemyProjectileWithPlayer);

            loopTime += elapsed;

            handleEnemySpawn(elapsed);

            handlePoints();
        } else if (gameState == MainMenu) {
            if (anyKey) {
                startLevel();
            }
        } else if (gameState == StoreState) {
            FlxG.overlap(powerups, player, overlapPowerup);
        } else if (gameState == GameOver) {
            if (anyKey) {
                FlxG.switchState(new PlayState());
            }
        }
    }

    function startLevel () {
        waveIndex = 0;
        subwaveIndex = 0;
        gameTime = -TRANSITION_TIME;

        livingEnemies = 0;
        subwavesDone = false;

        gameState = Playing;

        tweenPlayerToCenter();

        FlxTween.tween(ambientSound, { volume: 0.0 }, TRANSITION_TIME);
        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            // TODO: play song from the level
            waveSound = FlxG.sound.play(AssetPaths.int1__wav, 1, true);
            waveSound.onComplete = () -> loopTime = 0;
        });
        hud.visible = true;
        store.visible = false;
        powerups.visible = false;
    }

    function winLevel () {
        banner.display('L E V E L  C O M P L E T E', TRANSITION_TIME);

        worldIndex++;

        // TODO: check if world index is over the level list.
        // If so, win the game

        FlxTween.tween(waveSound, { volume: 0.0 }, TRANSITION_TIME);

        tweenPlayerToCenter();

        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            ambientSound.volume = 1.0;
        });
    }

    public function gameOver () {
        player = null;
        waveSound.stop();
        FlxTween.tween(waveSound, { volume: 0.0 }, TRANSITION_TIME);
        banner.display('G A M E  O V E R');

        new FlxTimer().start(1.5, (_:FlxTimer) -> {
            // show score
            // TODO: check high score?
            hud.visible = false;
        });

        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            gameState = GameOver;
            // TODO: game over music? or silence?
        });
    }

    function handleEnemySpawn (elapsed:Float) {
        gameTime += elapsed;

        var world = Waves.data[worldIndex];
        // if we haven't released all the subwaves, we check times here
        if (subwavesDone) {
            // start the next wave if there's no enemies left.
            // we have a negative gametime to start the next wave at the exact time the music loops.
            if (livingEnemies == 0) {
                subwavesDone = false;
                waveIndex++;
                subwaveIndex = 0;

                var loopLength = waveSound.length / 1000;
                gameTime = -(loopLength - loopTime);
                // if it's too short (less than a beat) we add a new loop.
                // WARN: Not 100% tested so a potential problem area.
                if (gameTime > -(Waves.convertBeatsToSeconds(1, world.bpm))) {
                    gameTime -= loopTime;
                }

                if (waveIndex == world.waves.length) {
                    gameState = StoreState;
                    winLevel();
                }
            }
        } else {
            var subwaveItem = world.waves[waveIndex][subwaveIndex];
            if (gameTime > Waves.convertBeatsToSeconds(subwaveItem.beats - 1, world.bpm)) {
                var enemyShape:Array<Int> = Structures.getStructure(subwaveItem.shape, subwaveItem.quantity);

                for (xPos in enemyShape) {
                    var yVel = Enemies.data[subwaveItem.type].yVel;
                    createEnemy(xPos, -(Waves.convertBeatsToSeconds(1, world.bpm) * yVel) + HUD.HEIGHT, subwaveItem.type);
                }

                subwaveIndex++;

                // check to see enemyCount if we should go to the next subWave
                if (subwaveIndex == world.waves[waveIndex].length) {
                    subwavesDone = true;
                }
            }
        }
    }

    function handlePoints () {
        if (points < 0) {
            points = 0;
        }
    }

    function createEnemy (x:Int, y:Float, type:EnemyType) {
        livingEnemies++;
        var enemy = enemies.recycle(Enemy);
        enemy.start(x, y, type);
    }

    function overlapPlayerWithEnemy (enemy:Enemy, player:Player) {
        createExplosion(Utils.getSpriteCenter(enemy), enemy.explosionType);
        enemy.kill();
        livingEnemies--;

        // when overlapping an enemy, there are no iFrames
        player.damage(enemy.collisionDamage, BodyDamage);
    }

    function overlapProjectileWithEnemy (proj:Projectile, enemy:Enemy) {
        enemy.damage(proj.damage);
        proj.kill();
    }

    function overlapEnemyProjectileWithPlayer (proj:Projectile, player:Player) {
        // hurt iFrames
        if (!player.isHurt) {
            player.damage(proj.damage, ShieldDamage);
        }
        proj.kill();
    }

    public function destroyEnemy (enemy:Enemy) {
        var position = Utils.getSpriteCenter(enemy);
        createExplosion(position, enemy.explosionType);
        points += enemy.points;
        livingEnemies--;

        var results = gameData.checkPoints(points);
        if (results != null) {
            // add powerup, auto select() it, add sparkle explosion

            var displayPowerup = new Powerup(position.x - POWERUP_MIDDLE, position.y - POWERUP_MIDDLE, results);
            add(displayPowerup);
            displayPowerup.select();

            doPowerup(results);
        }
    }

    public function shoot (x:Float, y:Float, weapon:WeaponType) {
        var bullet = Weapons.data[weapon];

        var proj = projectiles.recycle(Projectile);
        proj.shoot(x, y, bullet);

        // TODO: add a bullet duplicate type
        if (bullet.style == PlayerTwoShots) {
            var proj = projectiles.recycle(Projectile);
            proj.shoot(x, y, bullet, { flipXVel: true });        
        }
    }

    public function enemyShoot (x:Float, y:Float, weapon:WeaponType) {
        var bullet = Weapons.data[weapon];

        var proj = enemyProjectiles.recycle(Projectile);
        proj.shoot(x, y, bullet);

        if (bullet.style == PlayerTwoShots) {
            var proj = enemyProjectiles.recycle(Projectile);
            proj.shoot(x, y, bullet, { flipXVel: true });
        }
    }

    public function createExplosion (point:FlxPoint, type:String) {
        explosions.recycle(Explosion)
            .explode(point.x, point.y, type);
    }

    function tweenPlayerToCenter () {
        background.scrollTween(20);

        // TODO: transition sound

        player.inControl = false;
        FlxTween.tween(player, { x: PLAYER_START_X }, TRANSITION_TIME, { ease: FlxEase.cubeOut });
        FlxTween.tween(player, { y: PLAYER_START_Y }, TRANSITION_TIME, { ease: FlxEase.cubeInOut, onComplete:
            (_:FlxTween) -> {
                player.inControl = true;

                // TODO: only create store after level is complete
                if (gameState == StoreState) {
                    store.createStore();
                }
            }
        });
    }

    function overlapPowerup (powerup:Powerup, _:Player) {
        // buy what we overlap, subtract points.
        // anything we can't buy after the purchase disappears.
        // if it's go, we start the next level.
        if (!powerup.selected) {
            powerup.select();
            doPowerup(powerup.type);
        }
    }

    function doPowerup(type:PowerupTypes) {
        switch (type) {
            case Go:
                new FlxTimer().start(1, (_:FlxTimer) -> startLevel());
                return;
            case Double:
                for (wep in player.weapons) {
                    wep.reloadTime = wep.reloadTime / 2;
                }
                return;
            case Clear:
                return;
            case Shield:
                player.shieldPoints += 10;
                if (player.shieldPoints > 100) {
                    player.shieldPoints = 100;
                }
                return;
            case Repair:
                player.hitPoints += 25;
                if (player.hitPoints > 100) {
                    player.hitPoints = 100;
                }
                return;
            case ForwardTrips:
                player.weapons.push({ type: PlayerBall, shootTime: 0, reloadTime: 2 });
                return;
            case MidTrips:
                return;
            case SideTrips:
                return;
            case Backshoot:
                return;
        }
    }
}
