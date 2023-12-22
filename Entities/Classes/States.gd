extends Node
class_name NodeStates

enum list { SPAWN, MOVING, IDLE, ATTACK, DIED, BUILD }
var current = list.SPAWN
