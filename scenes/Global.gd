extends Node

var player_health = 20
var score = 0
var spawn_projectile = false
var on_spawn_timer = 1.0
signal laser_shot(projectile_scene, location)
var auto_cannon_ammo = 0
var big_space_gun_ammo = 0
var laser_ammo = 0
var game_over = false
