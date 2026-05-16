extends Node3D

"""     ##                                 
      ####                              
       #####                            
       #####                            
        ######                          
             ┌┐                         
             ││ ┌─────────┐             
           ┌╶┘└╶│Sikodem's│╶╶┐          
           ╎++++└─────────┘++╎          
           ╎+++++++++++++++++╎          
∧  ∧  ∧  ∧ ╎++++┌───┬───┐++++╎ ∧  ∧  ∧  
┼──┼──┼──┼ ╎++++│   │   │++++╎ ┼──┼──┼──
│  │  │  │ ╎++++│   ├┐  │++++╎ │  │  │  
┼──┼──┼──┼ ╎++++│   │   │++++╎ ┼──┼──┼──
│  │  │  │ └╶╶╶╶┴───┴───┴╶╶╶╶┘ │  │  │  
########################################
                                        
---  ---  ---  ---  ---  ---  ---  ---  
                                        
########################################"""
"""     ##                 ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ 
      ####              ▏==CHAPTER 1==▕ 
       #####            ▏▔▔▔▔▔▔▔▔▔▔▔▔▔▕ 
       #####            ▏The beginning▕ 
        ######          ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ 
             ┌┐                         
             ││ ┌─────────┐             
           ┌╶┘└╶│Sikodem's│╶╶┐          
           ╎++++└─────────┘++╎          
           ╎+++++++++++++++++╎          
∧  ∧  ∧  ∧ ╎++++┌───┬───┐++++╎ ∧  ∧  ∧  
┼──┼──┼──┼ ╎++++│   │   │++++╎ ┼──┼──┼──
│  │  │  │ ╎++++│   ├┐  │++++╎ │  │  │  
┼──┼──┼──┼ ╎++++│   │   │++++╎ ┼──┼──┼──
│  │  │  │ └╶╶╶╶┴───┴───┴╶╶╶╶┘ │  │  │  
########################################
                                        
---  ---  ---  ---  ---  ---  ---  ---  
                                        
########################################"""
@onready var animPlayer = $AnimationPlayer
@onready var animPlayer2 = $AnimationPlayer2
@onready var animPlayer3 = $AnimationPlayer3
@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer.play("RESET") # Replace with function body.
	animPlayer.play("intro")
	animPlayer2.play("smoke anim")
	#animPlayer3.play("scanline")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.visible = !animPlayer.is_playing()
