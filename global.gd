extends Node

var gameStart: bool


var playerBody: CharacterBody2D
var playerWeaponEquipped: bool

#damage vars towards bats
var playerDamageZone: Area2D
var playerDamageAmount: int
var PlayerAlive: bool
#damage vars towards players
var BatdamageZone: Area2D
var BatdamageAmount: int

var current_wave: int
var movingToNextWave: bool

var highScore = 0
var currentScore: int
var prevScore: int
