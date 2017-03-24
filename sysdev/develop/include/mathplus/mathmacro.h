#ifndef _MATHMACRO_
#define _MATHMACRO_


#define 	max(a, b)		(((a) > (b)) ? (a) : (b))
#define 	min(a, b)		(((a) < (b)) ? (a) : (b))
#define 	avg(a, b)		(((a) + (b)) / 2)

#define 	max3(a, b, c)	max((a), 	max((b), (c)))
#define 	min3(a, b, c)	min((a), 	min((b), (c)))
#define 	avg3(a, b, c)	(((a) + (b) + (c)) / 3)

#define 	square(x)		(x) * (x)
#define 	cube(x)			square((x)) * (x)
#define 	cube_root(x)	pow((x), 1/3)
#define		pow10(n)		pow(10, (n))
#define		powe(n)			pow(E, (n))
#define		pow2(n)			(2 << (n))
#define		log2(n)			(log(n) / log(2))

#define 	sum_gauss(n)	(n * (n + 1) / 2)


#endif

