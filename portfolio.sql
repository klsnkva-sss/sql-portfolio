-- ===============================================================
-- АНАЛИЗ 1. ТОП 5 ТОВАРОВ ПО ВЫРУЧКЕ
-- ===============================================================
-- Что делаю: соединяю products и sales через JOIN по product_id.
-- Считаю выручку: SUM(price * quantity).
-- Группирую по названию товара, сортирую по убыванию, беру 5.

select products.name as product_name,
       sum(price*quantity) as revenue
from products
join sales on products.product_id=sales.product_id
group by products.name
order by revenue desc
limit 5;

-- Результат:
-- DGX Station        | 49999.99
-- Tesla V100         | 26999.97
-- GeForce RTX 4090   | 25599.84
-- Quadro RTX 6000    | 19999.95
-- GeForce RTX 4070   | 19199.68

-- Вывод: DGX Station - лидер по выручке.

-- ===============================================================
-- АНАЛИЗ 2: Продажи по регионам
-- ===============================================================
-- Что делаю: группирую продажи по региону.
-- Считаю сумму проданных единиц: SUM(quantity).
-- Сортирую по убыванию.

select sales.region as region,
       SUM(quantity) as total_quantity
from sales
group by sales.region
order by total_quantity desc;

-- Результат:
-- Europe          | 128
-- North America   | 18

-- Вывод: Европа - основной рынок.

-- ================================================
-- АНАЛИЗ 3: Топ-5 клиентов по тратам
-- ================================================
-- Что делаю: соединяю три таблицы — customers, sales, products.
-- Считаю сумму покупок: SUM(price * quantity).
-- Группирую по клиенту, сортирую по убыванию, беру 5.

select customers.name as customer_name,
       sum(price*quantity) as total_spent
from customers
join sales on sales.customer_id = customers.customer_id
join products on sales.product_id = products.product_id
group by customers.name
order by total_spent desc
limit 5;

-- Результат:
-- SoftWorks     | 49999.99
-- GreenEnergy   | 25999.96
-- Tech Corp     | 24399.83
-- MedPlus       | 21599.74
-- EduWorld      | 20999.96

-- Вывод: SoftWorks - лидер по тратам.

-- ================================================
-- АНАЛИЗ 4: Средний чек по регионам
-- ================================================
-- Что делаю: соединяю sales и products.
-- Считаю средний чек: AVG(price * quantity), округляю до 2 знаков.
-- Группирую по региону, сортирую по убыванию.

select sales.region as region,
       round(avg(price*quantity), 2) as avg_check
from sales
join products on products.product_id = sales.product_id
group by sales.region
order by avg_check desc;

-- Результат:
-- North America   | 24799.94
-- Europe          | 8983.23

-- Вывод: в Северной Америке средний чек выше.

-- ================================================
-- АНАЛИЗ 5: Доля категорий в общей выручке
-- ================================================
-- Что делаю: использую подзапрос, чтобы получить общую выручку.
-- Основной запрос считает выручку по категориям и делит на общую.
-- Умножаю на 100, чтобы получить проценты. Округляю до 2 знаков.

select products.category as category,
       round(sum(price*quantity) * 100.0 /
             (select sum(price*quantity)
              from sales
              join products on products.product_id=sales.product_id), 2) as revenue_share
from products
join sales on products.product_id=sales.product_id
group by category
order by revenue_share desc;

-- Результат:
-- AI            | 42.26
-- GPU           | 32.49
-- Professional  | 20.86
-- Embedded      | 2.74
-- Consumer      | 1.65

-- Вывод: AI и GPU дают 74% выручки.

-- ================================================
-- АНАЛИЗ 6: Клиенты без покупок
-- ================================================
-- Что делаю: использую LEFT JOIN, чтобы оставить всех клиентов.
-- Фильтрую по sales.customer_id IS NULL - те, у кого нет продаж.

select customers.name as customer_name
from customers
left join sales on sales.customer_id = customers.customer_id
where sales.customer_id is null;

-- Результат: пусто (все клиенты покупали).

-- ================================================
-- АНАЛИЗ 7: Товары без продаж
-- ================================================
-- Что делаю: использую LEFT JOIN, чтобы оставить все товары.
-- Фильтрую по sales.product_id IS NULL - те, что не продавались.

select products.name as product_name
from products
left join sales on sales.product_id = products.product_id
where sales.product_id is null;

-- Результат: пусто (все товары продавались).

-- ================================================
-- АНАЛИЗ 8: Продажи по месяцам
-- ================================================
-- Что делаю: извлекаю номер месяца из даты через EXTRACT.
-- Считаю сумму проданных единиц: SUM(quantity).
-- Группирую по месяцу, сортирую по номеру месяца.

select extract(month from sale_date) as month,
       sum(quantity) as total_quantity
from sales
group by month
order by month;

-- Результат:
-- 1   | 15
-- 2   | 25
-- 3   | 78
-- 4   | 28

-- Вывод: пик продаж - в марте.

-- ================================================
-- ИНСТРУМЕНТЫ
-- PostgreSQL, DBeaver
-- ================================================
