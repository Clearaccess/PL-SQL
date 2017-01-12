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

CREATE OR REPLACE PROCEDURE GreatestOrders
(year IN NUMBER, countRecord IN NUMBER)
IS
CURSOR cur_EmployeeOrders 
IS
(SELECT Orders.orderID, Orders.employeeID, t_products.price FROM Orders left outer join (SELECT Order_Details.orderId, SUM((unitPrice-unitPrice*discount)*quantity) as price 
FROM Order_Details 
GROUP BY Order_Details.orderId) t_products
ON Orders.orderID=t_products.orderID
WHERE TO_CHAR(Orders.orderDate,'YYYY')='1998')
ORDER BY Orders.employeeID, t_products.price DESC;

CURSOR cur_Employees 
IS 
SELECT * FROM Employees;

v_gtOrder cur_EmployeeOrders%ROWTYPE;
v_gtEmployee cur_Employees%ROWTYPE;
v_index NUMBER;
v_outStr VARCHAR2(100);

BEGIN

v_index:=0;

OPEN cur_Employees;
DBMS_OUTPUT.put_line('FirstName' || ' ' 
|| 'LastName' || ' ' 
||  'NumOrder' || ' ' 
|| 'Price');
LOOP
		
    FETCH cur_Employees INTO v_gtEmployee;			
		EXIT WHEN (cur_Employees%NOTFOUND OR v_index>=countRecord);
    v_outStr:='';
    
    OPEN cur_EmployeeOrders;
    LOOP  
      FETCH cur_EmployeeOrders INTO v_gtOrder;
      EXIT WHEN cur_EmployeeOrders%NOTFOUND;
      
      IF TO_CHAR(v_gtOrder.employeeID)=TO_CHAR(v_gtEmployee.employeeID) THEN
      v_outStr:=v_outStr || TO_CHAR(v_gtEmployee.firstName || ' ' || v_gtEmployee.lastName) || ' ' || v_gtOrder.orderID || ' ' || v_gtOrder.price;
      EXIT;
      END IF;
      END LOOP;
    CLOSE cur_EmployeeOrders;
      
    DBMS_OUTPUT.put_line(v_outStr);
    v_index:=v_index+1;
    END LOOP;

CLOSE cur_Employees;

END GreatestOrders;

/*13.2	
Написать процедуру, которая возвращает заказы в таблице Orders, согласно указанному сроку доставки в днях (разница между orderDate и shippedDate).  
В результатах должны быть возвращены заказы, срок которых превышает переданное значение или еще недоставленные заказы. 
Значению по умолчанию для передаваемого срока 35 дней. Название процедуры ShippedOrdersDiff. 
Процедура должна выводить следующие колонки: orderID, orderDate, shippedDate, ShippedDelay (разность в днях между shippedDate и orderDate), specifiedDelay (переданное в процедуру значение).  
Результат должен быть отсортирован по shippedDelay. 
Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
Необходимо продемонстрировать использование этой процедуры.
*/

create or replace PROCEDURE ShippedOrdersDiff
(deliveryTime IN NUMBER DEFAULT 35)
IS

CURSOR cur_orders 
IS 
SELECT orderID, orderDate, shippedDate, (shippedDate - orderDate) shippedDelay 
FROM Orders
WHERE shippedDate-orderDate > deliveryTime OR shippedDate IS NULL
ORDER BY shippedDelay DESC;

v_gtOrder cur_Orders%ROWTYPE;

BEGIN
OPEN cur_orders;

DBMS_OUTPUT.put_line('orderID' || ' ' || 
							 'orderDate' || ' ' || 
							 'shippedDate' || ' ' || 
							 'shippedDelay' || ' ' || 
							 'specifiedDelay');
FETCH cur_Orders INTO v_gtOrder;

WHILE(NOT cur_Orders%NOTFOUND)
LOOP

DBMS_OUTPUT.put_line(v_gtOrder.orderID || ' ' || 
								 v_gtOrder.orderDate ||  ' ' || 
								 v_gtOrder.shippedDate ||  ' ' || 
								 v_gtOrder.shippedDelay ||  ' ' || 
								 deliveryTime);
                 
FETCH cur_Orders INTO v_gtOrder;

END LOOP;
CLOSE cur_Orders;

END ShippedOrdersDiff;

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

create or replace PROCEDURE SubordinationInfo
(chiefID IN NUMBER)
IS
CURSOR cur_Employees IS 
		SELECT employeeID, firstName, level
		FROM Employees
		START WITH reportsTo = chiefID
		CONNECT BY PRIOR employeeID = reportsTo;

v_chief employees%ROWTYPE;
v_gtEmployee cur_Employees%ROWTYPE;

BEGIN
SELECT * INTO v_chief 
FROM Employees 
WHERE employeeID=chiefID;

DBMS_OUTPUT.put_line('Chief: ' ||
'ID: ' || TO_CHAR(v_chief.employeeID) || ' ' ||
'Name: ' || v_chief.lastName
);
OPEN cur_Employees;
FETCH cur_Employees INTO v_gtEmployee;
WHILE(NOT cur_Employees%NOTFOUND)
LOOP
DBMS_OUTPUT.put_line('EmployeeID: ' || TO_CHAR(v_gtEmployee.employeeID) || ' ' ||
'Name: ' || v_gtEmployee.firstName || ' ' ||
'Level: ' || TO_CHAR(v_gtEmployee.level));
FETCH cur_Employees INTO v_gtEmployee;
END LOOP;
CLOSE cur_Employees;
END SubordinationInfo;

/*13.4	
Написать функцию, которая определяет, есть ли у продавца подчиненные и возвращает их количество - тип данных INTEGER. 
В качестве входного параметра функции используется employeeID. 
Название функции IsBoss. 
Продемонстрировать использование функции для всех продавцов из таблицы Employees.
*/

create or replace FUNCTION IsBoss
(idBoss IN NUMBER, countReports OUT INTEGER)
RETURN BOOLEAN
IS
BEGIN
SELECT COUNT(*) INTO countReports
FROM Employees
START WITH reportsTo=idBoss
CONNECT BY PRIOR employeeID=reportsTo;
RETURN countReports!=0;
END IsBoss;