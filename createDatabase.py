'''
Assignment 9
Group Member: Yan Chen, Haowei Wang
Last Modified: May 6th, 2023
This executable file sets up the library database. It creates the database and the schema and can only be runned once. 
'''

import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="LibraryDatabase"
)
mycursor = mydb.cursor()

mycursor.execute("CREATE DATABASE library")
mycursor.execute("USE library")
mycursor.execute("CREATE TABLE Catalog_Of_Book(ISBN varchar(17), Title varchar(255), Author varchar(255), Subject_Area varchar(255), Description varchar(255), Book_Type varchar(255), PRIMARY KEY(ISBN))")
mycursor.execute("CREATE TABLE Book(ISBN varchar(17), Volume_Number int, Book_Status varchar(40), PRIMARY KEY(ISBN, Volume_Number), FOREIGN KEY(ISBN) REFERENCES Catalog_Of_Book(ISBN))")
mycursor.execute("CREATE TABLE Person(SSN int, Name varchar(255), Home_Address varchar(255), Campus_Address varchar(255), PRIMARY KEY(SSN))")
mycursor.execute("CREATE TABLE Phone(SSN int, Phone_Number char(12), PRIMARY KEY(SSN, Phone_Number), FOREIGN KEY(SSN) REFERENCES Person(SSN))")
mycursor.execute("CREATE TABLE Member(SSN int, Member_Type varchar(40), Check_Out_Day_Allowed int, Grace_Period int, PRIMARY KEY(SSN), FOREIGN KEY(SSN) REFERENCES Person(SSN))")
mycursor.execute("CREATE TABLE Staff(SSN int, Staff_Type varchar(40), PRIMARY KEY(SSN), FOREIGN KEY(SSN) REFERENCES Person(SSN))")
mycursor.execute("CREATE TABLE Membership_Card(Card_Number int, Member_SSN int, Date_Issued date, Valid_Time int, Card_Status varchar(40), PRIMARY KEY(Card_Number), FOREIGN KEY(Member_SSN) REFERENCES Member(SSN))")
mycursor.execute("CREATE TABLE Borrowing_Activity(Receipt_Number varchar(255), Duration int, Check_Out_Date date, Return_Status varchar(40), Return_Date date, Amount_Due double, ISBN varchar(17), Volume_Number int, Card_Number int, Staff_SSN int, PRIMARY KEY(Receipt_Number), FOREIGN KEY(ISBN, Volume_Number) REFERENCES Book(ISBN, Volume_Number),FOREIGN KEY(Card_Number) REFERENCES Membership_Card(Card_Number), FOREIGN KEY(Staff_SSN) REFERENCES Staff(SSN))")
