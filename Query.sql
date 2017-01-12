/*1.1	
Выбрать из таблицы Orders заказы, которые были доставлены после 5 мая 1998 года (колонка shippedDate) включительно и которые доставлены с shipVia >= 2. 
Формат указания даты должен быть верным при любых региональных настройках. 
Этот метод использовать далее для всех заданий. 
Запрос должен выбирать только колонки orderID, shippedDate и shipVia. 
Пояснить, почему сюда не попали заказы с NULL-ом в колонке shippedDate. */

SELECT orderID, shippedDate, shipVia
FROM Orders 
WHERE TO_DATE(TO_CHAR(shippedDate,'DD.MM.YYYY'),'DD.MM.YYYY')>=TO_DATE('05.05.1998', 'DD.MM.YYYY') AND shipVia>=2;

/*1.2	
Написать запрос, который выводит только недоставленные заказы из таблицы Orders. 
В результатах запроса высвечивать для колонки shippedDate вместо значений NULL строку ‘Not Shipped’ – необходимо использовать CASЕ выражение. 
Запрос должен выбирать только колонки orderID и shippedDate.*/

SELECT orderID, 
CASE 
WHEN shippedDate IS NULL THEN 'Not Shipped'
ELSE TO_CHAR(shippedDate)
END
FROM Orders 
WHERE shippedDate IS NULL;

/*1.3	
Выбрать из таблици Orders заказы, которые были доставлены после 5 мая 1998 года (shippedDate), не включая эту дату, или которые еще не доставлены. 
Запрос должен выбирать только колонки orderID (переименовать в Order Number) и shippedDate (переименовать в Shipped Date). 
В результатах запроса  для колонки shippedDate вместо значений NULL выводить строку ‘Not Shipped’ (необходимо использовать функцию NVL), для остальных значений высвечивать дату в формате “ДД.ММ.ГГГГ”.
*/

SELECT orderID as "Order Number", NVL(TO_CHAR(shippedDate,'DD.MM.YYYY'),'Not Shipped') as "Shipped Date"
FROM ORDERS
WHERE (shippedDate IS NULL) OR (TO_DATE(TO_CHAR(shippedDate,'DD.MM.YYYY'),'DD.MM.YYYY')>TO_DATE('05.05.1998', 'DD.MM.YYYY'));

/*2.1
Выбрать из таблицы Customers всех заказчиков, проживающих в USA или Canada. 
Запрос сделать с только помощью оператора IN. 
Запрос должен выбирать колонки с именем пользователя и названием страны. 
Упорядочить результаты запроса по имени заказчиков и по месту проживания.
*/

SELECT contactName, country
FROM Customers
WHERE country IN ('USA','Canada')
ORDER BY contactName, country;

/*2.2
Выбрать из таблицы Customers всех заказчиков, не проживающих в USA и Canada. 
Запрос сделать с помощью оператора IN. 
Запрос должен выбирать колонки с именем пользователя и названием страны а. 
Упорядочить результаты запроса по имени заказчиков в порядке убывания.
*/

SELECT contactName, country
FROM Customers
WHERE NOT country IN ('USA','Canada')
ORDER BY contactName DESC;

/*2.3
Выбрать из таблицы Customers все страны, в которых проживают заказчики. 
Страна должна быть упомянута только один раз, Результат должен быть отсортирован по убыванию. 
Не использовать предложение GROUP BY.  
*/

SELECT DISTINCT country
FROM customers
ORDER BY country DESC;

/*3.1
Выбрать все заказы из таблицы Order_Details (заказы не должны повторяться), где встречаются продукты с количеством от 3 до 10 включительно – это колонка Quantity в таблице Order_Details. 
Использовать оператор BETWEEN. 
Запрос должен выбирать только колонку идентификаторы заказов.
*/

SELECT DISTINCT orderID
FROM Order_Details
WHERE quantity BETWEEN 3 AND 10;

/*3.2
Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона B и G. 
Использовать оператор BETWEEN. 
Проверить, что в результаты запроса попадает Germany. 
Запрос должен выбирать только колонки сustomerID  и сountry. 
Результат должен быть отсортирован по значению столбца сountry
*/

SELECT customerID, country
FROM Customers
WHERE SUBSTR(country,0,1) BETWEEN 'B' AND 'G'
ORDER BY country;

/*3.3
Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона B и G, не используя оператор BETWEEN. 
Запрос должен выбирать только колонки сustomerID  и сountry. 
Результат должен быть отсортирован по значению столбца сountry. 
С помощью опции “Execute Explain Plan” определить какой запрос предпочтительнее 3.2 или 3.3. 
В комментариях к текущему запросу необходимо объяснить результат.
ОТВЕТ: "Execute Explain Plan" - позволяет нам понять каким образом выполняется запрос, какие запрос использует индексы и использует ли их вообще, какие методы доступа применяет оптимизатор Oracle при выполнении SQL запроса.
При рассмотрении зароса 3.2 и 3.3 в планировщике можно заметить что констуркция between эквивалентна записи с AND 
*/

SELECT customerID, country
FROM Customers
WHERE 'B'<=SUBSTR(country,0,1) AND SUBSTR(country,0,1)<='G'
ORDER BY country;

/*4.1	
В таблице Products найти все продукты (колонка productName), где встречается подстрока 'chocolade'. 
Известно, что в подстроке 'chocolade' может быть изменена одна буква 'c' в середине - найти все продукты, которые удовлетворяют этому условию. 
Подсказка: в результате должны быть найдены 2 строки.
*/

SELECT productName
FROM Products
WHERE LOWER(productName) LIKE ('%cho_olade%');

/*5.1	
Найти общую сумму всех заказов из таблицы Order_Details с учетом количества закупленных товаров и скидок по ним. 
Результат округлить до сотых и отобразить в стиле: $X,XXX.XX, где “$” - валюта доллары, “,” – разделитель групп разрядов, “.” – разделитель целой и дробной части, при этом дробная часть должна содержать цифры до сотых, пример: $1,234.00. 
Скидка (колонка Discount) составляет процент из стоимости для данного товара. Для определения действительной цены на проданный продукт надо вычесть скидку из указанной в колонке unitPrice цены. 
Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.
*/

SELECT TO_CHAR(SUM((unitPrice-unitPrice*discount)*quantity),'$9,999,999.99') AS Totals
FROM Order_Details;

/*5.2
По таблице Orders найти количество заказов, которые еще не были доставлены (т.е. в колонке shippedDate нет значения даты доставки). 
Использовать при этом запросе только оператор COUNT. 
Не использовать предложения WHERE и GROUP.
*/

SELECT COUNT(shippedDate)
FROM Orders;

/*5.3
По таблице Orders найти количество различных покупателей (сustomerID), сделавших заказы. 
Использовать функцию COUNT и не использовать предложения WHERE и GROUP.
*/

SELECT COUNT(DISTINCT customerID)
FROM Orders;

/*6.1	
По таблице Orders найти количество заказов с группировкой по годам. 
Запрос должен выбирать две колонки c названиями Year и Total. 
Написать проверочный запрос, который вычисляет количество всех заказов.
*/

SELECT TO_CHAR(orderDate,'YYYY') as "Year", COUNT(orderID) as "Total"
FROM Orders
GROUP BY TO_CHAR(orderDate,'YYYY');

/*6.2	
По таблице Orders найти количество заказов, cделанных каждым продавцом. 
Заказ для указанного продавца – это любая запись в таблице Orders, где в колонке employeeID задано значение для данного продавца. 
Запрос должен выбирать колонку с полным именем продавца (получается конкатенацией lastName & firstName из таблицы Employees)  с названием колонки ‘Seller’ и колонку c количеством заказов с названием 'Amount'. 
Полное имя продавца должно быть получено отдельным запросом в колонке основного запроса (после SELECT, до FROM). 
Результаты запроса должны быть упорядочены по убыванию количества заказов. 
*/

SELECT (SELECT CONCAT(CONCAT(lastName, ' '),firstName) 
FROM Employees 
WHERE Employees.employeeID=Orders.employeeID) as "Seller", COUNT(employeeID) as "Amount"
FROM Orders
GROUP BY employeeID
ORDER BY "Amount" DESC;

/*6.3	
Выбрать 5 стран, в которых проживает наибольшее количество заказчиков. 
Список должен быть отсортирован по убыванию популярности. 
Запрос должен выбирать два столбца - сountry и Count (количество заказчиков).
*/

SELECT "country","Count"
FROM (SELECT shipCountry as "country", COUNT(shipCountry) as "Count"
FROM Orders
GROUP BY shipCountry
ORDER BY "Count" DESC)
WHERE ROWNUM<=5;

/*
6.4	По таблице Orders найти количество заказов, cделанных каждым продавцом и для каждого покупателя. 
Необходимо определить это только для заказов, сделанных в 1998 году. 
Запрос должен выбирать колонку с именем продавца (название колонки ‘Seller’), колонку с именем покупателя (название колонки ‘Customer’) и колонку c количеством заказов высвечивать с названием 'Amount'. 
В запросе необходимо использовать специальный оператор языка PL/SQL для работы с выражением GROUP (Этот же оператор поможет выводить строку “ALL” в результатах запроса). 
Группировки должны быть сделаны по ID продавца и покупателя. 
Результаты запроса должны быть упорядочены по продавцу, покупателю и по убыванию количества продаж. 
В результатах должна быть сводная информация по продажам. Т.е. в результирующем наборе должны присутствовать дополнительно к информации о продажах продавца для каждого покупателя следующие строчки:
Seller	Customer	Amount
ALL 	ALL         <общее число продаж>
<имя>	ALL	        <число продаж для данного продавца>
ALL     <имя>	    <число продаж для данного покупателя>
<имя>	<имя>	    <число продаж данного продавца для даннного покупателя>
*/

SELECT 'ALL' as "Seller", 'ALL' as "Customer", COUNT(orderID) as "Amount"
FROM Orders
UNION
SELECT 
(SELECT CONCAT(CONCAT(lastName,' '), firstName) FROM Employees WHERE Employees.employeeID=Orders.employeeID) as "Seller", 
'ALL' as "Customer",
COUNT(orderID) as "Amount"
FROM Orders
GROUP BY employeeID
UNION
SELECT 
'ALL' as "Seller",
(SELECT contactName FROM Customers WHERE Customers.customerID=Orders.customerID) as "Customer",
COUNT(orderID) as "Amount"
FROM Orders
GROUP BY customerID
UNION
SELECT 
(SELECT CONCAT(CONCAT(lastName,' '), firstName) FROM Employees WHERE Employees.employeeID=Orders.employeeID) as "Seller",
(SELECT contactName FROM Customers WHERE Customers.customerID=Orders.customerID) as "Customer",
COUNT(orderID) as "Amount"
FROM Orders
GROUP BY employeeID, customerID
ORDER BY "Seller", "Customer", "Amount" DESC;

/*6.5	
Найти покупателей и продавцов, которые живут в одном городе. 
Если в городе живут только продавцы или только покупатели, то информация о таких покупателях и продавцах не должна попадать в результирующий набор. 
Не использовать конструкцию JOIN или декартово произведение. 
В результатах запроса необходимо вывести следующие заголовки для результатов запроса: ‘Person’, ‘Type’ (здесь надо выводить строку ‘Customer’ или  ‘Seller’ в зависимости от типа записи), ‘City’. 
Отсортировать результаты запроса по колонкам ‘City’ и ‘Person’.
*/

SELECT 
firstName as "Person", 
'Seller' as "Type",
city as "City"
FROM Employees
WHERE city=ANY(SELECT city FROM Customers)
UNION
SELECT 
contactName as "Person", 
'Customer' as "Type",
city as "City"
FROM Customers
WHERE city=ANY(SELECT city FROM Employees)
ORDER BY "City", "Person";

/*6.6	
Найти всех покупателей, которые живут в одном городе. 
В запросе использовать соединение таблицы Customers c собой - самосоединение. 
Высветить колонки сustomerID  и City. Запрос не должен выбирать дублируемые записи. 
Отсортировать результаты запроса по колонке City. 
Для проверки написать запрос, который выбирает города, которые встречаются более одного раза в таблице Customers. 
Это позволит проверить правильность запроса.
*/

SELECT DISTINCT c1.customerId, c1.city
FROM Customers c1, Customers c2
WHERE c1.city=c2.city AND c1.customerID!=c2.customerID
ORDER BY c1.city;

SELECT COUNT(*) 
FROM 
(SELECT Customers.city
FROM customers 
GROUP BY customers.city
HAVING COUNT(*) > 1);

/*6.7	
По таблице Employees найти для каждого продавца его руководителя, т.е. кому он делает репорты. 
Высветить колонки с именами 'User Name' (lastName) и 'Boss'. 
Имена должны выбираться из колонки lastName. 
Выбираются ли все продавцы в этом запросе?
Ответ: выбираются не все продавцы.
*/

SELECT 
emp1.lastName as "User Name",
emp2.lastName as "Boss"
FROM Employees emp1 inner join Employees emp2
on emp1.reportsTo=emp2.employeeID;

/*7.1	
Определить продавцов, которые обслуживают регион 'Western' (таблица Region). 
Запрос должен выбирать: 'lastName' продавца и название обслуживаемой территории (столбец territoryDescription из таблицы Territories). 
Запрос должен использовать JOIN в предложении FROM. 
Для определения связей между таблицами Employees и Territories надо использовать графическую схему для базы Southwind.
*/

SELECT Employees.lastName, Territories.territoryDescription
FROM 
Employees inner join EmployeeTerritories 
on Employees.employeeID=EmployeeTerritories.employeeID
inner join Territories
on Territories.territoryID=EmployeeTerritories.territoryID
inner join Region
on Region.regionID=Territories.regionID
WHERE Region.regionDescription='Western';

/*8.1	
Запрос должен выбирать имена всех заказчиков из таблицы Customers и суммарное количество их заказов из таблицы Orders. 
Принять во внимание, что у некоторых заказчиков нет заказов, но они также должны быть выведены в результатах запроса. 
Упорядочить результаты запроса по возрастанию количества заказов.
*/

SELECT Customers.contactName as "Name", COUNT(Orders.orderID) as "Amount"
FROM 
Customers left outer join Orders
on Customers.customerID=Orders.customerID
GROUP BY Customers.customerID, Customers.contactName
ORDER BY "Amount" DESC;

/*9.1	
Запрос должен выбирать всех поставщиков (колонка companyName в таблице Suppliers), у которых нет хотя бы одного продукта на складе (unitsInStock в таблице Products равно 0). 
Использовать вложенный SELECT для этого запроса с использованием оператора IN. 
Можно ли использовать вместо оператора IN оператор '='?
Ответ: оператор = нельзя ипользовать вместо оперетора IN так как SELECT вернет нам множество значений, и оперетор = не сможет произвести сравнение. 
Что касаемо оперетора IN, то он как раз и создан для таких ситуаций.
*/

SELECT companyName
FROM Suppliers
WHERE 0 IN (SELECT unitsInStock FROM Products WHERE Products.supplierID=Suppliers.supplierID);

/*10.1	
Запрос должен выбирать имена всех продавцов, которые имеют более 150 заказов. 
Использовать вложенный коррелированный SELECT.
*/

SELECT lastName
FROM Employees
WHERE (SELECT COUNT(*) FROM Orders WHERE Orders.employeeID=Employees.employeeID)>150;

/*11.1	
Запрос должен выбирать имена заказчиков (таблица Customers), которые не имеют ни одного заказа (подзапрос по таблице Orders). 
Использовать коррелированный SELECT и оператор EXISTS.
*/

SELECT contactName
FROM Customers
WHERE NOT EXISTS(SELECT * FROM Orders WHERE Orders.customerID=Customers.customerID);

/*12.1	
Для формирования алфавитного указателя Employees необходимо написать запрос должен выбирать из таблицы Employees список только тех букв алфавита, с которых начинаются фамилии Employees (колонка lastName) из этой таблицы.  
Алфавитный список должен быть отсортирован по возрастанию.
*/

SELECT SUBSTR(lastName,0,1) as "Alph"
FROM Employees
ORDER BY "Alph";

SET SERVEROUTPUT ON

/*13.1	
Написать процедуру, которая возвращает самый крупный заказ для каждого из продавцов за определенный год. 
В результатах не может быть несколько заказов одного продавца, должен быть только один и самый крупный. 
В результатах запроса должны быть выведены следующие колонки: колонка с именем и фамилией продавца (firstName и lastName – пример: Nancy Davolio), номер заказа и его стоимость. 
В запросе надо учитывать Discount при продаже товаров. 
Процедуре передается год, за который надо сделать отчет, и количество возвращаемых записей. 
Результаты запроса должны быть упорядочены по убыванию суммы заказа. Название процедуры GreatestOrders. 
Необходимо продемонстрировать использование этой процедуры.
Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
Также помимо демонстрации вызова процедуры в скрипте Query.sql надо написать отдельный ДОПОЛНИТЕЛЬНЫЙ проверочный запрос для тестирования правильности работы процедуры GreatestOrders. 
Проверочный запрос должен выводить в удобном для сравнения с результатами работы процедур виде для определенного продавца для всех его заказов за определенный указанный год в результатах следующие колонки: имя продавца, номер заказа, сумму заказа. 
Проверочный запрос не должен повторять запрос, написанный в процедуре, - он должен выполнять только то, что описано в требованиях по нему.*/

EXECUTE GREATESTORDERS(1998,3);

SELECT Employees.firstName || ' '||  Employees.lastName as "Name", t_orders.orderID as "Number", t_orders.price as "Price" FROM Employees left outer join ((SELECT Orders.employeeID, Orders.orderID, t_products.price FROM Orders left outer join (SELECT Order_Details.orderId, SUM((unitPrice-unitPrice*discount)*quantity) as price 
FROM Order_Details 
GROUP BY Order_Details.orderId) t_products
ON Orders.orderID=t_products.orderID
WHERE TO_CHAR(Orders.orderDate,'YYYY')='1998')
ORDER BY Orders.employeeID, t_products.price DESC) t_orders
on Employees.employeeID=t_orders.employeeID;

/*13.2	
Написать процедуру, которая возвращает заказы в таблице Orders, согласно указанному сроку доставки в днях (разница между orderDate и shippedDate).  
В результатах должны быть возвращены заказы, срок которых превышает переданное значение или еще недоставленные заказы. 
Значению по умолчанию для передаваемого срока 35 дней. Название процедуры ShippedOrdersDiff. 
Процедура должна выводить следующие колонки: orderID, orderDate, shippedDate, ShippedDelay (разность в днях между shippedDate и orderDate), specifiedDelay (переданное в процедуру значение).  
Результат должен быть отсортирован по shippedDelay. 
Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
Необходимо продемонстрировать использование этой процедуры.
*/

EXECUTE SHIPPEDORDERSDIFF(25);

/*13.3	
Написать процедуру, которая выводит всех подчиненных заданного продавца, как непосредственных, так и подчиненных его подчиненных. 
В качестве входного параметра процедуры используется employeeID. 
Необходимо вывести столбцы employeeID, имена подчиненных и уровень вложенности согласно иерархии подчинения. 
Продавец, для которого надо найти подчиненных также должен быть высвечен. Название процедуры SubordinationInfo. 
Необходимо использовать конструкцию START WITH … CONNECT BY. 
Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
Продемонстрировать использование процедуры. 
Написать проверочный запрос, который вывод всё дерево продавцов.
*/

EXECUTE SUBORDINATIONINFO(2);

SELECT LPAD(' ', 2 * level) || firstName as Tree 
FROM Employees
START WITH reportsTo is null 
CONNECT BY PRIOR employeeID = reportsTo;

/*13.4	
Написать функцию, которая определяет, есть ли у продавца подчиненные и возвращает их количество - тип данных INTEGER. 
В качестве входного параметра функции используется employeeID. 
Название функции IsBoss. 
Продемонстрировать использование функции для всех продавцов из таблицы Employees.
*/

DECLARE 

CURSOR cur_Employee
IS
SELECT employeeID, firstName FROM Employees;

v_gtEmployee cur_Employee%ROWTYPE;
v_isBoss BOOLEAN DEFAULT(FALSE);
v_count INTEGER;

BEGIN

OPEN cur_Employee;
FETCH cur_Employee INTO v_gtEmployee;
WHILE(NOT cur_Employee%NOTFOUND)
LOOP
  v_isBoss:=ISBOSS(v_gtEmployee.employeeID, v_count);  
  IF(v_isBoss) THEN
  dbms_output.put_line(v_gtEmployee.firstName || ' has ' || v_count ||' subordinates.' );
  ELSE
  dbms_output.put_line(v_gtEmployee.firstName || ' has not subordinates.' );
  END IF;
  FETCH cur_Employee INTO v_gtEmployee;
END LOOP;
CLOSE cur_Employee;

END;



