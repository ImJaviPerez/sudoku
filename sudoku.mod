# GLPK Math program
#
# Conjunto de datos
set N := 1..9 ;

# Variables de decision x_ijk
# Hay 9*9*9 = 729 variables binarias de decision
var x {(i,j,k) in {N cross N cross N}} binary ;

# DATA[i,j] = informcion inicial del sudoku
param DATA {i in N, j in N}, default 0;

# En este problema no hay nada que minimizar ni maximizar
minimize nothing : 0;

# Regla I: rellenar con cifras del 1 al 9 cada una de las 81 celdas
subject to all_filled {i in N, j in N}:
sum {k in N} x[i,j,k] = 1;

# Regla II: no repetir ninguna cifra en una misma fila
subject to Rows {i in N, k in N}:
sum {j in N} x[i,j,k] = 1;

# Regla III: no repetir ninguna cifra en una misma columna
subject to Columns {j in N, k in N}:
sum {i in N} x[i,j,k] = 1;

# Bloques 3 x 3
set BLOCKS := {1, 4, 7} ;

# Regla IV: no repetir ninguna cifra en una misma caja
subject to Squares {k in N, i0 in BLOCKS, j0 in BLOCKS}:
sum {i in (i0..(i0+2))} sum {j in (j0..(j0+2))} x[i,j,k] = 1;

# Asignar los datos inicialmente conocidos del sudoku
subject to known {i in N, j in N : DATA[i,j] > 0}:
x[i,j,DATA[i,j]] = 1;

# RESOLUCION 
solve;

# MOSTRAR EL RESULTADO -----------------
printf "\n";
# Mostrar las filas y las columnas separando por bloques
for {bf in 0..2}
{
	for {i in 1..3}
	{
		# Mostar los columnas de una fila separadas por bloques
		for {bc in 0..2}
		{
			printf{j in 1..3} "%1d ", sum{k in N} k * x[3*bf+i,3*bc+j,k];
			printf " ";
		}
		printf "\n";
	}
	printf "\n";
}

printf "\n";
# Mostrar todas las filas sin separacion por  bloques
for {i in N}
{
	# Mostar los columnas de cada fila
	printf{j in N} "%1d ", sum{k in N} k * x[i,j,k];
	printf "\n";
}

# DATOS USADOS EN ESTE PROBLEMA ---------------
data;
# DATA: INFORMACION INICIAL DEL SUDOKU -----
# using the . character instead of a value in the matrix makes that particular value to be defaulted.
param DATA :	1 2 3   4 5 6   7 8 9 := 
             1	8 . .   6 . .   9 . 5
             2	. . .   . . .   . . .
             3	. . .   . 2 .   3 1 . 
			
             4	. . 7   3 1 8   . 6 .
             5	2 4 .   . . .   . 7 3
             6	. . .   . . .   . . .
			 
             7	. . 2   7 9 .   1 . .
             8	5 . .   . 8 .   . 3 6
             9	. . 3   . . .   . . . ;

end;
