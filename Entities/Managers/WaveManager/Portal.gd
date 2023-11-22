# • A wave can only spawn from a single spawn point    
# • Waves occur in serial for a given wave manager
	# cm - yes, it for loops through all the waves, once one is done it moves to the next. 
#     ◦ Contrary to expectation, I thought we'd be able to spawn a wave amongst various portals for some lane variety.
		# cm to create portal class / object that can be used to spawn enemies
#     ◦ Perhaps I"m just missing something, is there a way to at least have two EnemySpawnInfo groups spawning in parallel for one wave?
# • We're tracking enemy count as they spawn. This is used to do a completion check once waves are complete
#     ◦ My assumption was that we will have a rest time in between waves. If we make it so the rest cannot occur until all enemies are dead, we may not necessarily need to store enemy array data, which would rely on some other signal/otherwise to remove them from said array (didn't check how this is working). But either way, it is likely more simplie + optimized to poll every x seconds for 0 instances of enemy.
# • Wave complete check only happens after spawning is done. 
#     ◦ Minor nitpick, I would've expected us to not bother calling the check until after the fact, versus checking it within function. A bit of messy variable scope management/coupling.
class_name Portal
extends Node2D
