create database BTProductManager;
use BTProductManager;
#vật tư
create table supplies
(
    id    int primary key,
    code  varchar(10),
    name  varchar(20),
    unit  varchar(20),
    price int
);
# phiếu xuất
create table bill
(
    id         int primary key,
    billCode   varchar(10),
    exportDate date,
    customer   varchar(20)
);
#nhà cung cấp
create table supplier
(
    id           int primary key,
    code         varchar(10),
    supplierName varchar(20),
    address      varchar(20),
    phone        varchar(10)
);

#Đơn đặt hàng
create table order1
(
    id         int primary key,
    orderCode  varchar(10),
    orderDate  date,
    supplierID int,
    foreign key (supplierID) references supplier (id)
);


#phiếu nhập
create table receipt
(
    id         int primary key,
    receipt    varchar(10),
    importDate date,
    orderID    int,
    foreign key (orderID) references order1 (id)
);
#Chi tiết đơn hàng
create table orderDetail
(
    id         int primary key,
    orderID    int,
    suppliesID int,
    quantity   int,
    foreign key (orderID) references order1 (id),
    foreign key (suppliesID) references supplies (id)
);

#Chi tiết phiếu nhập
create table receiptDetail
(
    id         int primary key,
    receiptID  int,
    suppliesID int,
    quantity   int,
    price      int,
    note       varchar(50),
    foreign key (receiptID) references receipt (id),
    foreign key (suppliesID) references supplies (id)
);

#chi tiết phiếu xuất
create table billDetail
(
    id         int primary key,
    billId     int,
    suppliesId int,
    quantity   int,
    price      int,
    note       varchar(50),
    foreign key (billId) references bill (id),
    foreign key (suppliesId) references supplies (id)
);

#Tồn kho
create table inventory
(
    id                      int primary key,
    suppliesID              int,
    total_original_quantity int,
    total_receipt_entered   int,
    total_export_quantity   int,
    foreign key (suppliesID) references supplies (id)
);
insert into supplies
values (1, '1A', 'Iphone6', 'chiếc', 5000000),
       (2, '2A', 'Iphone7', 'chiếc', 6000000),
       (3, '3A', 'Iphone8', 'chiếc', 7000000),
       (4, '4A', 'Iphone10', 'chiếc', 8000000),
       (5, '5A', 'Iphone11', 'chiếc', 9000000);

insert into inventory
values (1, 1, 100, 50, 50),
       (2, 2, 200, 50, 50),
       (3, 3, 300, 50, 50),
       (4, 4, 400, 50, 50),
       (5, 5, 500, 50, 50);

insert into supplier value
    (1, '1B', 'Công ty A', 'Hà Nội', '0123456'),
    (2, '2B', 'Công ty B', 'Hồ CHí Minh', '948'),
    (3, '3B', 'Công ty C', 'Đà Nẵng', '05489');

insert into order1 value
    (1, '1O', '2021-02-24', 1),
    (2, '2O', '2021-03-25', 2),
    (3, '3O', '2021-04-25', 3);
insert into receipt
values (1, '1R', '2021-05-12', 1),
       (2, '2R', '2021-06-12', 2),
       (3, '3R', '2021-07-12', 3);

insert into bill
values (1, '1B', '2021-05-12', 'customer1'),
       (2, '2B', '2021-06-12', 'customer2'),
       (3, '3B', '2021-07-12', 'customer3');

insert into orderdetail
values (1, 1, 1, 5),
       (2, 2, 2, 6),
       (3, 3, 3, 7),
       (4, 1, 4, 8),
       (5, 2, 5, 9),
       (6, 3, 4, 10);

insert into receiptDetail
values (1, 1, 1, 5, 500, 'good'),
       (2, 2, 2, 5, 600, 'good'),
       (3, 3, 3, 5, 700, 'good'),
       (4, 1, 4, 5, 800, 'good'),
       (5, 2, 5, 5, 900, 'good'),
       (6, 3, 2, 5, 1100, 'good');

insert into billdetail
values (1, 1, 1, 2, 600, 'sad'),
       (2, 2, 2, 3, 400, 'sad'),
       (3, 3, 3, 4, 500, 'sad'),
       (4, 1, 4, 5, 600, 'sad'),
       (5, 2, 5, 7, 800, 'sad'),
       (6, 3, 5, 3, 200, 'sad');

#Câu 1. Tạo view có tên vw_CTPNHAP bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPN4HAP AS
select R.receipt, s.code, rD.quantity, rD.price, (rD.quantity * rD.price) 'thành tiền'
from receipt R
         join receiptDetail rD on R.id = rD.receiptID
         join supplies s on rD.suppliesID = s.id;

select *
from vw_CTPNHAP;

#Câu 2. Tạo view có tên vw_CTPNHAP_VT bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT AS
select R.receipt, s.code, s.name, rD.quantity, rD.price, (rd.quantity * rd.price) 'thành tiền'
from receipt R
         join receiptDetail rD on R.id = rD.receiptID
         join supplies s on rD.suppliesID = s.id;

select *
from vw_CTPNHAP_VT;

#Câu 3. Tạo view có tên vw_CTPNHAP_VT_PN bao gồm các thông tin sau: số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT_PN AS
select R.receipt,
       R.importDate,
       O.orderCode,
       s.code,
       s.name,
       rD.quantity,
       rD.price,
       (rD.quantity * rD.price) 'thành tiền'
from receipt R
         join receiptDetail rD on R.id = rD.receiptID
         join supplies s on rD.suppliesID = s.id
         join order1 o on R.orderID = o.id;

select *
from vw_CTPNHAP_VT_PN;

#Câu 4. Tạo view có tên vw_CTPNHAP_VT_PN_DH bao gồm các thông tin sau: số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã nhà cung cấp, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.

create view vw_CTPNHAP_VT_PN_DH AS
select R.receipt,
       R.importDate,
       o.orderCode,
       s2.code                  'mã nhà cung cấp',
       s.code,
       s.name,
       rD.quantity,
       rd.price,
       (rD.quantity * rD.price) 'thành tiền'
from receipt R
         join receiptDetail rD on R.id = rD.receiptID
         join supplies s on rD.suppliesID = s.id
         join order1 o on R.orderID = o.id
         join supplier s2 on o.supplierID = s2.id;

select *
from vw_CTPNHAP_VT_PN_DH;

#Câu 5. Tạo view có tên vw_CTPNHAP_loc  bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập có số lượng nhập > 5.
create view vw_CTPNHAP_loc AS
select R.receipt, s.code, rd.quantity, rd.price, (rd.quantity * rd.price) 'thành tiền'
from receipt R
         join receiptDetail rD on R.id = rD.receiptID
         join supplies s on rD.suppliesID = s.id
where quantity >= 5;

select *
from vw_CTPNHAP_loc;

#Câu 6. Tạo view có tên vw_CTPNHAP_VT_loc bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là Bộ.

create view vw_CTPNHAP_VT_loc AS
select R.receipt, s.code, s.name, rD.quantity, rd.price, (rd.quantity * rd.price) 'thành tiền'
from receipt R
         join receiptDetail rD on R.id = rD.receiptID
         join supplies s on rD.suppliesID = s.id
where s.unit like 'bộ';

select *
from vw_CTPNHAP_VT_loc;

#Câu 7. Tạo view có tên vw_CTPXUAT bao gồm các thông tin sau: số phiếu xuất hàng, mã vật tư, số lượng xuất, đơn giá xuất, thành tiền xuất.
create view vw_CTPXUAT AS
select b.billCode, s.code, bd.quantity, bd.price, (bd.quantity * bd.price) 'thành tiền'
from bill b
         join billDetail bD on b.id = bD.billId
         join supplies s on bD.suppliesId = s.id;

select *
from vw_CTPXUAT;

#Câu 8. Tạo view có tên vw_CTPXUAT_VT bao gồm các thông tin sau: số phiếu xuất hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.

create view vw_CTPXUAT_VT AS
select b.billCode, s.code, s.name, bd.quantity 'số lượng xuất', bd.price 'đơn giá'
from bill b
         join billDetail bD on b.id = bD.billId
         join supplies s on bD.suppliesId = s.id;

select *
from vw_CTPXUAT_VT;

#Câu 9. Tạo view có tên vw_CTPXUAT_VT_PX bao gồm các thông tin sau: số phiếu xuất hàng, tên khách hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.

create view vw_CTPXUAT_VT_PX AS
select b.billCode, b.customer, s.code, s.name, bd.quantity, bd.price
from bill b
         join billDetail bD on b.id = bD.billId
         join supplies s on bD.suppliesId = s.id;

select *
from vw_CTPXUAT_VT_PX;

#Tạo các stored procedure sau
#Câu 1. Tạo Stored procedure (SP) cho biết tổng số lượng cuối của vật tư với mã vật tư là tham số vào.

DELIMITER //
create procedure totalSupplies(IN code varchar(10))
begin
    select s.name, sum(total_original_quantity + total_receipt_entered - total_export_quantity) 'Số lượng cuối'
    from inventory i
             join supplies s on s.id = i.suppliesID
    where s.code = code
    group by s.name;
end //
DELIMITER ;



#Câu 2. Tạo SP cho biết tổng tiền xuất của vật tư với mã vật tư là tham số vào.

DELIMITER //
create procedure totalPriceBill(IN code varchar(10))
begin
    select s.name, sum(bd.quantity * bd.price) 'thành tiền'
    from supplies s
             join billDetail bD on s.id = bD.suppliesId
             join bill b on b.id = bD.billId
    where s.code=code
    group by s.name;
  end //
DELIMITER ;
call totalPriceBill('2A');
#Câu 3. Tạo SP cho biết tổng số lượng đặt theo số đơn hàng với số đơn hàng là tham số vào.
DELIMITER //
create procedure totalReceipt(IN code int, OUT total int)
begin
    select sum(oD.quantity)
    INTO total
    from order1 o
             join orderDetail oD on o.id = oD.orderID
    group by o.id
    having o.id = code;
end //
DELIMITER ;

call totalReceipt(1, @total);
select @total;

#Câu 4. Tạo SP dùng để thêm một đơn đặt hàng.

DELIMITER //
create procedure createOrder(IN idn int, coden varchar(10), dateN date, Sid int)
begin
    insert into order1 value (id, coden, dateN, Sid);
end //
DELIMITER ;

call createOrder(4, '5A', '2021-01-10', 2);

#Câu 5. Tạo SP dùng để thêm một chi tiết đơn đặt hàng.

DELIMITER //
create procedure crateOrderDetail(IN idN int,Oid int,Sid int,quatity int)
begin
    insert into orderdetail value (idN,Oid,Sid,quantity);
end //
DELIMITER ;
 call crateOrderDetail(7,2,3,1)


