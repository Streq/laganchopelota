extends Node
"""
la soga arranca con 2 puntos, cuando se mueve, se genera un triangulo 


```
		
A0---------------A1
		._____.
		|     |    B1
B0		|     | 
		._____.
```

```
para ordenar los puntos hay que ubicar el valor de t0 para el cual, si
f(t) = A0*(1-t)+B0*t
g(t) = A1*(1-t)+B1*t
P está en el segmento FG, es decir
cross(G-F,P-F) == 0
con
F = f(t0) 
G = g(t0)
0 <= t0 <= 1

reemplazando queda
cross(G-F,P-F) == 0
cross(A1*(1-t) + B1*t - A0*(1-t) - B0*t, P - A0*(1-t) + B0*t) == 0

(A1*(1-t) + B1*t - A0*(1-t) - B0*t).x * (P - A0*(1-t) + B0*t)).y -
(A1*(1-t) + B1*t - A0*(1-t) - B0*t).y * (P - A0*(1-t) + B0*t)).x == 0

+ (A1.x*(1-t) + B1.x*t - A0.x*(1-t) - B0.x*t) * (P.y - A0.y*(1-t) + B0.y*t) 
- (A1.y*(1-t) + B1.y*t - A0.y*(1-t) - B0.y*t) * (P.x - A0.x*(1-t) + B0.x*t)) == 0

A0x = a
A0y = b
A1x = c
A1y = d
B0x = e
B0y = f
B1x = g
B1y = h

+ (c*(1-t) + g*t - a*(1-t) - e*t) * (i - b*(1-t) + f*t) 
- (d*(1-t) + h*t - b*(1-t) - f*t) * (j - a*(1-t) + e*t)) == 0

+ (A1.x*(1-t) + B1.x*t - A0.x*(1-t) - B0.x*t) * (P.y)
- (A1.x*(1-t) + B1.x*t - A0.x*(1-t) - B0.x*t) * (A0.y*(1-t))
+ (A1.x*(1-t) + B1.x*t - A0.x*(1-t) - B0.x*t) * (B0.y*t)
- (A1.y*(1-t) + B1.y*t - A0.y*(1-t) - B0.y*t) * (P.x)
+ (A1.y*(1-t) + B1.y*t - A0.y*(1-t) - B0.y*t) * (A0.x*(1-t))
- (A1.y*(1-t) + B1.y*t - A0.y*(1-t) - B0.y*t) * (t*B0.x)

+ (A1.x*(1-t)*(P.y) + B1.x*t*(P.y) - A0.x*(1-t)*(P.y) - B0.x*t*(P.y))
- (A1.x*(1-t)*(A0.y*(1-t)) + B1.x*t*(A0.y*(1-t)) - A0.x*(1-t)*(A0.y*(1-t)) - B0.x*t*(A0.y*(1-t)))
+ (A1.x*(1-t)*(B0.y*t) + B1.x*t*(B0.y*t) - A0.x*(1-t)*(B0.y*t) - B0.x*t*(B0.y*t))
- (A1.y*(1-t)*(P.x) + B1.y*t*(P.x) - A0.y*(1-t)*(P.x) - B0.y*t*(P.x))
+ (A1.y*(1-t)*(A0.x*(1-t)) + B1.y*t*(A0.x*(1-t)) - A0.y*(1-t)*(A0.x*(1-t)) - B0.y*t*(A0.x*(1-t)))
- (A1.y*(1-t)*(t*B0.x) + B1.y*t*(t*B0.x) - A0.y*(1-t)*(t*B0.x) - B0.y*t*(t*B0.x))

+ A1.x*(1-t)*(P.y) + B1.x*t*(P.y) - A0.x*(1-t)*(P.y) - B0.x*t*(P.y)
- A1.x*(1-t)*(A0.y*(1-t)) - B1.x*t*(A0.y*(1-t)) + A0.x*(1-t)*(A0.y*(1-t)) + B0.x*t*(A0.y*(1-t))
+ A1.x*(1-t)*(B0.y*t) + B1.x*t*(B0.y*t) - A0.x*(1-t)*(B0.y*t) - B0.x*t*(B0.y*t)
- A1.y*(1-t)*(P.x) - B1.y*t*(P.x) + A0.y*(1-t)*(P.x) + B0.y*t*(P.x)
+ A1.y*(1-t)*(A0.x*(1-t)) + B1.y*t*(A0.x*(1-t)) - A0.y*(1-t)*(A0.x*(1-t)) - B0.y*t*(A0.x*(1-t))
- A1.y*(1-t)*(t*B0.x) - B1.y*t*(t*B0.x) + A0.y*(1-t)*(t*B0.x) + B0.y*t*(t*B0.x)

+ A1.x*(P.y) - t*A1.x*(P.y) + t*B1.x*(P.y) - A0.x*(P.y) + t*A0.x*(P.y) - t*B0.x*(P.y) (A)
- A1.x*(1-t)*(A0.y - t*A0.y) - B1.x*t*(A0.y - t*A0.y) + A0.x*(1-t)*(A0.y - t*A0.y) + B0.x*t*(A0.y - t*A0.y) (B)
+ A1.x*(1-t)*(B0.y*t) + B1.x*t*(B0.y*t) - A0.x*(1-t)*(B0.y*t) - B0.x*t*(B0.y*t) (C)
- A1.y*(1-t)*(P.x) - B1.y*t*(P.x) + A0.y*(1-t)*(P.x) + B0.y*t*(P.x) (D)
+ A1.y*(1-t)*(A0.x*(1-t)) + B1.y*t*(A0.x*(1-t)) - A0.y*(1-t)*(A0.x*(1-t)) - B0.y*t*(A0.x*(1-t)) (E)
- A1.y*(1-t)*(t*B0.x) - B1.y*t*(t*B0.x) + A0.y*(1-t)*(t*B0.x) + B0.y*t*(t*B0.x) (F)


A = + A1.x*(P.y) - t*A1.x*(P.y) + t*B1.x*(P.y) - A0.x*(P.y) + t*A0.x*(P.y) - t*B0.x*(P.y)
A = (A1.x*P.y - A0.x*P.y) + t*(-A1.x*P.y + B1.x*P.y + A0.x*P.y - B0.x*P.y)


B = - A1.x*(1-t)*(A0.y - t*A0.y) - B1.x*t*(A0.y - t*A0.y) + A0.x*(1-t)*(A0.y - t*A0.y) + B0.x*t*(A0.y - t*A0.y)
B = - A1.x*(A0.y - t*A0.y) + t*A1.x*(A0.y - t*A0.y) - B1.x*t*(A0.y - t*A0.y) + A0.x*(A0.y - t*A0.y) - t*A0.x*(A0.y - t*A0.y) + B0.x*t*(A0.y - t*A0.y)
B = - A1.x*A0.y + t*A1.x*A0.y + t*A1.x*A0.y - t*t*A1.x*A0.y - t*B1.x*A0.y + t*t*B1.x*A0.y + A0.x*A0.y - t*A0.x*A0.y - t*A0.x*A0.y + t*t*A0.x*A0.y + t*B0.x*A0.y - t*t*B0.x*A0.y
B = (- A1.x*A0.y + A0.x*A0.y) + t*(A1.x*A0.y + A1.x*A0.y - B1.x*A0.y - A0.x*A0.y + B0.x*A0.y - A0.x*A0.y)   t*t*(-A1.x*A0.y + B1.x*A0.y + A0.x*A0.y - B0.x*A0.y) 


C = + A1.x*(1-t)*(B0.y*t) + B1.x*t*(B0.y*t) - A0.x*(1-t)*(B0.y*t) - B0.x*t*(B0.y*t)
C = + t*A1.x*B0.y - t*t*A1.x*B0.y + t*t*B1.x*B0.y - t*A0.x*B0.y + t*t*A0.x*B0.y - t*t*B0.x*B0.y
C = t*(A1.x*B0.y - A0.x*B0.y) + t*t*(- A1.x*B0.y + B1.x*B0.y + A0.x*B0.y - B0.x*B0.y)

D = - (1-t)*A1.y*(P.x) - t*B1.y*(P.x) + (1-t)*A0.y*(P.x) + t*B0.y*(P.x)
D = - A1.y*(P.x) + t*A1.y*(P.x) - t*B1.y*(P.x) + A0.y*(P.x) - t*A0.y*(P.x) + t*B0.y*(P.x)
D = (- A1.y*P.x + A0.y*P.x)  + t*(A1.y*P.x - B1.y*P.x - A0.y*P.x + B0.y*P.x)

E = + A1.y*(1-t)*(A0.x*(1-t)) + B1.y*t*(A0.x*(1-t)) - A0.y*(1-t)*(A0.x*(1-t)) - B0.y*t*(A0.x*(1-t))
E = + A1.y*(1-t)*(A0.x-t*A0.x) + B1.y*t*(A0.x-t*A0.x) - A0.y*(1-t)*(A0.x-t*A0.x) - B0.y*t*(A0.x-t*A0.x)
E = + (1-t)*A1.y*(A0.x-t*A0.x) + t*B1.y*(A0.x-t*A0.x) - (1-t)*A0.y*(A0.x-t*A0.x) - t*B0.y*(A0.x-t*A0.x)
E = + A1.y*(A0.x-t*A0.x) - t*A1.y*(A0.x-t*A0.x) + t*B1.y*(A0.x-t*A0.x) - A0.y*(A0.x-t*A0.x) + A0.y*(A0.x-t*A0.x) - t*B0.y*(A0.x-t*A0.x)
E = + A1.y*A0.x - t*A0.x*A1.y - t*A1.y*A0.x + t*t*A1.y*A0.x + t*B1.y*A0.x - t*t*B1.y*A0.x - A0.y*A0.x + t*A0.y*A0.x + A0.y*A0.x - t*A0.y*A0.x - t*B0.y*A0.x + t*t*B0.y*A0.x

F = - A1.y*(1-t)*(t*B0.x) - B1.y*t*(t*B0.x) + A0.y*(1-t)*(t*B0.x) + B0.y*t*(t*B0.x)
F = - (1-t)*t*A1.y*B0.x - t*t*B1.y*B0.x + (1-t)*t*B0.x*A0.y + t*t*B0.x*B0.y
F = - (t*A1.y*B0.x - t*t*A1.y*B0.x) - t*t*B1.y*B0.x + (t*B0.x*A0.y - t*t*B0.x*A0.y) + t*t*B0.x*B0.y
F = - t*A1.y*B0.x + t*t*A1.y*B0.x - t*t*B1.y*B0.x + t*B0.x*A0.y - t*t*B0.x*A0.y + t*t*B0.x*B0.y



```
"""
