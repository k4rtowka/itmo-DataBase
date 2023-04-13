--#1
select Н_ОЦЕНКИ.ПРИМЕЧАНИЕ, Н_ВЕДОМОСТИ.ИД
from Н_ОЦЕНКИ
right join Н_ВЕДОМОСТИ on КОД = ОЦЕНКА
where Н_ОЦЕНКИ.КОД < '5' and Н_ВЕДОМОСТИ.ДАТА > '2010-06-18';

--#2
select people.ИД, study.ЧЛВК_ИД, student.ГРУППА
from Н_ЛЮДИ as people
left join Н_ОБУЧЕНИЯ as study on ИД = ЧЛВК_ИД
left join Н_УЧЕНИКИ  as student using(ЧЛВК_ИД)
where people.ОТЧЕСТВО < 'Сергеевич' and study.НЗК > '933232' and student.ИД > '150308';

--#3
select
	(select count(*) from
        	(select ФАМИЛИЯ from Н_ЛЮДИ group by ФАМИЛИЯ) t) as surname_cnt,
	(select count(*) from
        	(select ОТЧЕСТВО from Н_ЛЮДИ group by ОТЧЕСТВО) t) as patronymic_cnt;
			
--#4
select ГРУППА, count(*)
from Н_УЧЕНИКИ
where ПЛАН_ИД in (select ПЛАН_ИД
					from Н_ПЛАНЫ
					where ОТД_ИД in (
							select ИД 
							from Н_ОТДЕЛЫ 
							where КОРОТКОЕ_ИМЯ = 'КТиУ'))
AND (НАЧАЛО < '01-01-2011' AND КОНЕЦ > '01-01-2011')
group by ГРУППА
having count(*) >= 5
order by count(*);

--#5
select p.ФАМИЛИЯ, p.ИМЯ, p.ОТЧЕСТВО, trunc(avg(cast(v.ОЦЕНКА as integer))) as СРЕДНЯЯ_ОЦЕНКА
from Н_ЛЮДИ as p
	join Н_ВЕДОМОСТИ as v on p.ИД = v.ЧЛВК_ИД
	join Н_УЧЕНИКИ  as student on student.ЧЛВК_ИД = p.ИД
where (v.ОЦЕНКА <= '5') and (ГРУППА = '4100')
	group by p.ФАМИЛИЯ, p.ИМЯ, p.ОТЧЕСТВО
having (trunc(avg(cast(v.ОЦЕНКА as integer))) = 
		(select trunc(avg(cast(v.ОЦЕНКА as integer)))
			from Н_ЛЮДИ as p
			join Н_ВЕДОМОСТИ as v on p.ИД = v.ЧЛВК_ИД
			join Н_УЧЕНИКИ  as student on student.ЧЛВК_ИД = p.ИД
				where (v.ОЦЕНКА <= '5') and (ГРУППА = '1101')))
order by p.ФАМИЛИЯ, p.ИМЯ, p.ОТЧЕСТВО;


--#6  Не хватает "Номер пункта приказа"
select  p.ФАМИЛИЯ, 
		p.ИМЯ, 
		p.ОТЧЕСТВО,  
		stud.ГРУППА 
from Н_ЛЮДИ as p
	join Н_УЧЕНИКИ  as stud on stud.ЧЛВК_ИД = p.ИД
where EXISTS (select ИД
       from Н_ПЛАНЫ
       where ФО_ИД in (select ИД
                        from Н_ФОРМЫ_ОБУЧЕНИЯ
                        where НАИМЕНОВАНИЕ in ('Очная', 'Заочная'))
			 and НАПС_ИД in (select ИД
								from Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ
								where НС_ИД in (select ИД
											   	from Н_НАПР_СПЕЦ
											   	where КОД_НАПРСПЕЦ = '230101')))
	   and stud."ПРИЗНАК" = 'отчисл'
  	   and stud."КОНЕЦ" > '2012-09-01'
order by p.ФАМИЛИЯ, p.ИМЯ, p.ОТЧЕСТВО;
		
--#7
select ФАМИЛИЯ, ИД
from Н_ЛЮДИ
where ФАМИЛИЯ in (select ФАМИЛИЯ
                    from Н_ЛЮДИ
                    group by ФАМИЛИЯ
                    having count(distinct ИД) > 1)
order by ФАМИЛИЯ;