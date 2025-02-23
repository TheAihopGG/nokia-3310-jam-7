extends Node2D

# Время роста
@export var time_growth    : float = 5
# Цена продавца
@export var seller_price   : float = 1
# Ресурс который будет вырастать
@export var fetus          : PackedScene
# Сколько очков к прокачке уровня фермера он будет давать при сборе урожая
@export var points_collect : float 
