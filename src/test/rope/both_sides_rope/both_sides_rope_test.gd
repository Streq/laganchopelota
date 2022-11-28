extends Node2D


"""
Bueno, la lógica en principio es como en both_sides_rope_sweep.gd:
cuando muevo ambos extremos de la soga, se forma un cuadrilatero (o un par de triangulos si es cruzado)
se buscan colisiones en esa área
para cada punto de la colision, se busca si está dentro del área
se ordenan los puntos por orden de chocada

el primer punto con el que se choca divide la soga en los dos extremos y el nuevo punto enroscado

mientras la soga tenga al menos un punto enroscado
el movimiento en los extremos se va a evaluar con la logica de los extremos triangulares


cuando ambos extremos se mueven habiendo mas de 2 puntos en la soga, se evalua primero uno, y luego el otro





"""
