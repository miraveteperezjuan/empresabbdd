-- 1. Crear una vista y ejecutadla para en cada departamento con presupuesto inferior a 35.000 €, 
-- hallar le nombre del Centro donde está ubicado y el máximo salario de sus empleados 
-- (si dicho máximo excede de 1.500 €). Clasificar alfabéticamente por nombre de departamento.

Create or replace view VistaDepartamentos as
select nomde, presu, direc
from departamentos
where presu <= 35
order by nomde asc;

-- 2. Crear una consulta para hallar por orden alfabético los nombres de los departamentos que dependen de los que tienen un presupuesto inferior a 30.000 €. 
-- También queremos conocer el nombre del departamento del que dependen y su presupuesto.
select nomde, presu
from departamentos
where presu <= 30
order by nomde asc;


--  3. Crear una consulta para obtener los nombres y los salarios medios de los departamentos cuyo salario medio supera al salario medio de la empresa.
select nomde, presu
from departamentos
where presu > ( select avg(presu)
				from departamentos);
                
-- 4. Crear una vista y ejecutadla para para los departamentos cuyo director lo sea en funciones, 
-- hallar el número de empleados y la suma de sus salarios, comisiones y número de hijos.

Create or replace view VistaDirector as


-- 5. Crear una consulta para los departamentos cuyo presupuesto anual supera los 35.000 €, hallar cuantos empleados hay por cada extensión telefónica.

select nomde as nombre_departamento, presu as presupuesto
from departamentos
where presu> 35 
and nomde = (select extel
				from empleados
                group by extel
                having count(extel));

-- 6. Crear una consulta para hallar por orden alfabético los nombres de los empleados y su número de hijos para aquellos que son directores en funciones.

select nomem as nombre, numhi as numeroHijos
from empleados
where tidir = (select tidir
				from departamentos
                where tidir = 'F')
order by nomem asc;

-- 7. Crear una vista y ejecutadla para hallar si hay algún departamento 
-- (suponemos que sería de reciente creación) que aún no tenga empleados asignados ni director en propiedad.

Create or replace view VistaNuevoDepartamentos as
select NOMDE as nombre, direc as director, NUMCE as centro
from departamentos
where nomde is null and direc is null and numce is null; -- no hay nada por tanto nulo. 


-- 9. Crear una consulta para mostrar los departamentos que no tienen empleados.
select numde, nomde
from departamentos 
where numde = (select numem
				from empleados
				where numem is not null );
                
-- 10. Crear una consulta para mostrar los nombres de departamentos que no tienen empleados haciendo uso la combinación externa LEFT JOIN. 
-- Muestra una segunda columna con los nombres de empleados para asegurarnos que realmente está a NULL.                

select departamentos.nomde as NombreDepartamento, empleados.nomem as NombreEmpleado
from departamentos left outer join empleados
on departamentos.numde = empleados.numde
where numem = (select numen
				from empleados
                where numen is null);

-- 11. Crear una consulta para mostrar los nombres de departamentos que no tienen empleados haciendo 
-- uso la combinación externa RIGH JOIN. Muestra una segunda columna con los nombres de empleados para asegurarnos que realmente está a NULL.

select nomde as NombreDepartamento, empleados.nomem as NombreEmpleado
from departamentos right outer join empleados
on departamentos.numde = empleados.numde
where numem = (select numem
				from empleados
                where numem is null);
                
-- 12. Crear una consulta que actualice el sueldo de los empleados del departamento SECTOR SERVICIOS en un 15% y cuya sede sea la SEDE CENTRAL 
-- y que se controle mediante una transacción, dando el commit después del borrado; verifica antes el estado del autocommit de la BBDD.

start transaction;
update empleados
set salar = salar*1.15
where numde = (select numde
				from departamentos
                where nomde like 'SEDE CENTRAL');
