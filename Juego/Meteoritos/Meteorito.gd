extends RigidBody2D
class_name Meteorito

##Atributos Export
export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float =3.0
export var hitpoints_base:float = 10.0

onready var impacto_sfx = $impacto_sfx
onready var animationMeteorito = $AnimationPlayer
#Atributos
var hitpoints:float


#Metodos
func _ready() -> void:
	##linear_velocity = vel_lineal_base
	angular_velocity = vel_ang_base

#Metodos Custom
func recibir_danio(danio:float)->void:
	hitpoints -= danio
	if hitpoints <= 0:
		destruir()
	animationMeteorito.play("impacto")	
	impacto_sfx.play()
	
func aleatorizar_velocidad()->float:
	randomize()
	return rand_range(1.1,1.4)
	
#Constructor
func crear(pos:Vector2, dir:Vector2, tamanio:float)->void:
	position=pos
	#Calcular Masa, tamaño de Sprite  y Colisionador
	mass*=tamanio
	linear_velocity = vel_lineal_base * dir
	$Sprite.scale = Vector2.ONE*tamanio
	#Radio = diametro/2
	var radio:int = int($Sprite.texture.get_size().x/2.3*tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#Calcular velocidades
	linear_velocity = (vel_lineal_base *dir /tamanio) * aleatorizar_velocidad()
	angular_velocity = (vel_ang_base / tamanio) * aleatorizar_velocidad()
	
	#Calcular hitpoints
	hitpoints = hitpoints_base *tamanio
	#Solo Debug
	print("hitpoints: ", hitpoints)

func destruir()->void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido",global_position)
	queue_free()
	


