-- create database rortest;
-- use rortest;
use mobilebank_development;

create table customer(
	CustomerNo varchar(5) primary key,
    FirstName varchar(30) not null,
    LastName varchar(40) not null,
    Email varchar(50) not null,
    PhoneNo varchar(12)  not null,
    PIN INT(4) not null
);

create table accounts(
	AccountNo varchar(10)  not null primary key,
	CustomerNo varchar(5) not null,
    Balance decimal(12, 2) not null default 0,
    foreign key(CustomerNo) references customers(CustomerNo)
);


create table transactions(
	TID varchar(6) not null,
    REF VARChar(15) not null,
    AccountNo varchar(10) not null,
    `Date` date not null,
    `Time` time not null,
    Description varchar(70) not null,
    Amount double(12, 2) not null,
    `Type` varchar(2) not null,
    primary key(TID),
    foreign key(AccountNo) references accounts(AccountNo)
);