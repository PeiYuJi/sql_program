create database `sql_basic`;
use `sql_basic`;
drop `sql_basic`:
create table `employee` (
   `emp_id` int primary key,
   `name` varchar(20) character set utf8mb4,
   `birth_date` date,
   `sex` varchar(1) character set utf8mb4,
   `salary` int,
   `branch_id` int,
   `sup_id` int
);
drop table `employee`;

-- on delete set null 意思 : 如果`employee`.`emp_id`＝207被刪掉，則 `branch`.`manager_id`＝207會變成null
create table `branch`(
   `branch_id` int primary key,
   `branch_name` varchar(20) character set utf8mb4,
   `manager_id` int,
   foreign key (`manager_id`) references `employee` (`emp_id`) on delete set null
);
drop table `branch`;

alter table `employee`
add foreign key (`branch_id`)
references `branch`(`branch_id`)
on delete set null;

alter table `employee`
add foreign key (`sup_id`)
references 	`employee`(`emp_id`)
on delete set null;

create table `client`(
`client_id` int primary key,
`client_name` varchar(20),
`phone` varchar(20)
);

-- on delete cascade 意思 ：`employee`.`emp_id` = 207被刪掉，則`works_with`.`emp_id`＝207也一起被刪除
create table `works_with`(
`emp_id` int,
`client_id` int,
`total_sales` int,
primary key (`emp_id`,`client_id`),
foreign key (`emp_id`) references `employee`(`emp_id`) on delete cascade,
foreign key (`client_id`) references `client`(`client_id`) on delete cascade
);

delete from `employee` where `emp_id` = 207;
select * from `branch`;
select * from `works_with`;



insert into `branch` values (1 , '研發',  null );
insert into `branch` values (2 , '行政',  null );
insert into `branch` values (3 , '資訊',  null );

insert into `employee` values (206, '小黃', '1998-10-08' , 'F', 50000, 1, NULL);
insert into `employee` values (207, '小綠', '1985-09-16' , 'M', 40000, 1, 206);
insert into `employee` values (208, '小黑', '2000-12-19' , 'M', 60000, 1, 206);
insert into `employee` values (209, '小白', '1997-01-22' , 'F', 70000, 1, 207);
insert into `employee` values (210, '小藍', '1925-11-10' , 'F', 80000, 1, 207);

update `branch` 
set `manager_id` = 206
where `branch_id` = 1;

update `branch` 
set `manager_id` = 207
where `branch_id` = 2;

update `branch` 
set `manager_id` = 208
where `branch_id` = 3;

insert into `client` values (400, '阿狗', '254354355');
insert into `client` values (401, '阿貓', '25633899');
insert into `client` values (402, '旺來', '4535');
insert into `client` values (403, '露西', '54545');
insert into `client` values (404, '艾瑞克', '18783783');

insert into `works_with` values (206, 400, '70000');
insert into `works_with` values (207, 401, '24000');
insert into `works_with` values (208, 402, '9800');
insert into `works_with` values (209, 403, '24000');
insert into `works_with` values (210, 404, '87940');

-- 1.取得所有員工資料
select *  from `employee`;

-- 2.取得所有客戶資料
select *  from `client`;

-- 3.按薪水高到低取得員工資料
select *  from `employee` order by `salary` desc;

-- 4.取得薪水前三高的員工
select *  from `employee` order by `salary` desc limit 3;

-- 5.取得所有員工的名字
select distinct`name` from `employee`;

-- aggregate function 聚合函數

-- 1.取得員工人數
select count(*) from `employee`;
select count(`sup_id`) from `employee`;

-- 2.取得所有出生於1970-01-01 之後的女性員工人數
select count(*) 
from `employee` 
where `birth_date` > '1970-01-01' and `sex`='F';

-- 3.取得所有員工的平均薪水
select avg(`salary`) from `employee`;

-- 4.取得所有員工薪水的總和
select sum(`salary`) from `employee`;

-- 5.取得薪水最高的員工
select max(`salary`) from `employee`;

-- 6. 取得薪水最低的員工
select min(`salary`) from `employee`;

-- wildcard 萬用字元  ％代表多個字元  ＿代表一個字元

-- 1.取得電話號碼尾數是355的客戶
select * from `client` where `phone` like '%355';
select * from `client` where `phone` like '254%';
select * from `client` where `phone` like '%354%';

-- 2.取得姓艾的客戶
select * from `client` where `client_name` like '艾%';

-- 3.取得生日在12月的員工
select * from `employee` where `birth_date` like '_____12%';

-- union 聯集

-- 1.員工名字 union 客戶名字
select `name` from `employee` 
union
select `client_name` from `client`
union
select `branch_name` from `branch`;

-- 2.員工id + 員工名字 union 客戶id + 客戶名字
select `emp_id` as `total_id` ,`name` as `total_name`
from `employee`
union
select `client_id`,`client_name`
from `client`;

-- 3. 員工薪水 union 銷售金額
select `salary` as `total_money` from `employee`
union
select `total_sales` from`works_with`;

-- join 連接
insert into `branch` values (4,'偷懶',null);
select * from `employee` left join `branch` on `emp_id` = `manager_id`;

select `employee`.`emp_id`,`employee`.`name`,`branch`.`branch_name` 
from `employee` left join `branch` 
on `employee`.`emp_id` = `branch`.`manager_id`;

-- subquery 	子查詢
-- 1.找出研發部門的經理名字
select `name` 
from `employee` where `emp_id`= (
select `manager_id` 
from `branch`
where `branch_name` = '研發'
);
-- 2.找出對單一位客戶銷售金額超過5000以上員工的名字
select `name` 
from `employee` where `emp_id` in (
select `emp_id` 
from `works_with`
where `total_sales` > 50000
);






