'''
Assignment 9
Group Member: Yan Chen, Haowei Wang
Last Modified: May 6th, 2023
This file contains 9 functions manipulating the library database.
The main function contains a while loop that enables the menu.
Select a number to execute the corresponding function. 
'''
import mysql.connector
from datetime import datetime

def printMenu():
    print("Menu")
    print("--------------------")
    print("0. Exit the Program")
    print("1. Add a New Book to library database")
    print("2. Update the description of an existing book in the database")
    print("3. Search books by ISBN")
    print("4. Check out a book for a user")
    print("5. Check-in a book that was checked out")
    print("6. Calculate fines for overdue books based on the Card Number")
    print("7. Add a new Member")
    print("8. Add a new Staff")
    print("9. Activate Library Card for Member")

def addBook():
    ISBN = input("ISBN:")
    mycursor.execute("SELECT * FROM Catalog_Of_Book WHERE ISBN="+ISBN)
    result = mycursor.fetchall()
    print(result)
    if result != []:
        print("This Book has been added to the database.")
        return None
    title = input("Title:")
    author = input("Author:")
    subject = input("Subject Area:")
    description = input("Description:")
    book_type = input("Book Type:")
    copy = (int)(input("Number of Copies:"))

    sql = "INSERT INTO Catalog_Of_Book (ISBN, Title, Author, Subject_Area,Description, Book_Type) VALUES (%s, %s, %s, %s,%s, %s)"
    val = (ISBN, title, author, subject, description, book_type)

    mycursor.execute(sql, val)
    mydb.commit()
    print(mycursor.rowcount, "record inserted.")

    for i in range(copy):
        sql = "INSERT INTO Book(ISBN, Volume_Number, Book_Status) VALUES (%s, %s, %s)"
        val = (ISBN, i+1, "available")
        mycursor.execute(sql, val)
        mydb.commit()
        print(mycursor.rowcount, "record inserted.")

def update_description_by_ISBN():
    ISBN = input("ISBN:")
    description = input("Description:")
    mycursor.execute("SELECT * FROM Catalog_Of_Book WHERE ISBN = \'" +ISBN+"\'")
    result = mycursor.fetchone()
    if result == None:
        print("No Book Matched In The Database")
    else:
        mycursor.execute("UPDATE Catalog_Of_Book SET Description = \'"+description+"\' WHERE ISBN = \'"+ISBN+"\';")
        mydb.commit()
        print(mycursor.rowcount, "record updated.")

def search_book_by_ISBN():
    ISBN = input("ISBN:")
    mycursor.execute("SELECT * FROM Book WHERE ISBN = \'" +ISBN+"\'")
    result = mycursor.fetchall()
    if result == None:
        print("No Book Matched In The Database")
    else:
        for x in result:
            print(x)

def check_out():
    #get data from the user
    Card_Number = (int)(input("Card Number:"))
    ISBN = input("ISBN:")
    mycursor.execute("SELECT * FROM Catalog_Of_Book WHERE ISBN = \'" +ISBN+"\'")
    result = mycursor.fetchone()
    if result == None:
        print("No Book Matched In The Database.")
        return None
    Volume_Number = input("Volume Number:")
    Staff_SSN = (int)(input("Staff SSN:"))

    #generate receipt number based on current time
    receipt_num = datetime.now().strftime("%Y%m%d%H%M%S")
    check_out_date = datetime.now().date()
    return_status = "Not Returned"
    amount_due = 0
    return_date = None

    #check if user exceeds the borrowing limit
    mycursor.execute("SELECT count(Receipt_Number) FROM Borrowing_Activity WHERE Card_Number = "+str(Card_Number)+" AND Return_Status = 'Not Returned'")
    book_borrowed = (int)(mycursor.fetchone()[0])
    mycursor.execute("SELECT Book_Status FROM Book WHERE ISBN = \'"+ISBN+"\' AND Volume_Number =" + str(Volume_Number))
    book_status = mycursor.fetchone()[0]
    if book_borrowed >= 5:
        print("You've reached the borrowing limit!")
    elif book_status == "borrowed":
        print("This book has been borrowed!")
    else:
        #fetch the borrowing duration from database based on card number(user type)
        mycursor.execute("SELECT m.Check_Out_Day_Allowed FROM Member m, Membership_Card c WHERE m.SSN = c.Member_SSN AND c.Card_Number = \'"+str(Card_Number)+"\'")
        duration = mycursor.fetchone()[0]

        #pass the sql to database to insert borrowing activity info
        sql = "INSERT INTO Borrowing_Activity(Receipt_Number, Duration, Check_Out_Date, Return_Status, Return_Date, Amount_Due, ISBN, Volume_Number, Card_Number, Staff_SSN) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        val = (receipt_num, duration, check_out_date, return_status,return_date, amount_due, ISBN, Volume_Number, Card_Number, Staff_SSN)
        mycursor.execute(sql, val)

        #update the status of the copy of the book by ISBN
        mycursor.execute("UPDATE Book SET Book_Status = 'borrowed' WHERE ISBN = \'"+ISBN+"\' AND Volume_Number ="+ Volume_Number)
        mydb.commit()
        print(mycursor.rowcount, "record inserted.")

def check_in():
    #get data from the user
    receipt_num = input("Receipt Number:")
    return_date = datetime.now().date()

    #check if the borrowing activity exists in the database
    mycursor.execute("SELECT * FROM Borrowing_Activity WHERE Receipt_Number = \'" +receipt_num+"\'")
    result = mycursor.fetchone()
    if result == None:
        print("No Borrowing Activity Matched In The Database")
        return None
    #check if there is a return date to see if the book has been returned
    elif result[4] != None:
        print("Book has been checked in.")
        return None
    else:
        #update the status of borrowing activity and calculate fine
        print(result)
        ISBN = result[6]
        Volume_Number = result[7]
        check_out_date = result[2]
        duration = result[1]
        fine_per_day = 1
        amount_due = 0
        if (return_date - check_out_date).days > duration:
            amount_due = fine_per_day*((return_date - check_out_date).days - duration)
        print("Amount Due: ",amount_due)
        mycursor.execute("UPDATE Borrowing_Activity SET Return_Date = \'"+str(return_date)+"\', Amount_Due = \'"+str(amount_due)+"\', Return_Status = 'Returned' WHERE Receipt_Number = \'"+receipt_num+"\'")

        #update the status of the copy of book
        mycursor.execute("UPDATE Book SET Book_Status = 'available' WHERE ISBN = \'"+ISBN+"\' AND Volume_Number ="+ str(Volume_Number))

        #commit to the database
        mydb.commit()
        print(mycursor.rowcount, "record updated.")

def calculate_fine():
    Card_Number = (int)(input("Card Number:"))
    mycursor.execute("SELECT SUM(Amount_Due) FROM Borrowing_Activity WHERE Card_Number = \'"+str(Card_Number)+"\' AND Return_Status = 'Overdue'")
    fine = mycursor.fetchall()[0]
    fine_sum = 0
    print(fine)
    for x in fine:
        print(x)
        if x == None:
            pass
        else:
            fine_sum += x
    print("Fine Amount: ",fine_sum)

def add_a_new_member():
    name = input("Name:")
    ssn = (int)(input("SSN:"))
    home_address = input("Home Address:")
    campus_address = input("Campus Address:")
    member_type = input("Member Type(student or professor):")
    grace_period = 7
    check_out_day_allowed = 21
    if member_type == "professor":
        grace_period = 14
        check_out_day_allowed = 90
    sql = "INSERT INTO Person(SSN, Name, Home_Address, Campus_Address) VALUES(%s,%s,%s,%s)"
    val = (ssn, name, home_address, campus_address)
    mycursor.execute(sql,val)
    sql = "INSERT INTO Member(SSN, Member_Type, Check_Out_Day_Allowed, Grace_Period) VALUES(%s,%s,%s,%s)"
    val = (ssn, member_type, check_out_day_allowed, grace_period)
    mycursor.execute(sql,val)
    mydb.commit()
    print(mycursor.rowcount, "record inserted.")

def add_a_new_staff():
    name = input("Name:")
    ssn = (int)(input("SSN:"))
    home_address = input("Home Address:")
    campus_address = input("Campus Address:")
    staff_type = input("Staff Type:")
    sql = "INSERT INTO Person(SSN, Name, Home_Address, Campus_Address) VALUES(%s,%s,%s,%s)"
    val = (ssn, name, home_address, campus_address)
    mycursor.execute(sql,val)
    sql = "INSERT INTO Staff(SSN, Staff_Type) VALUES(%s,%s)"
    val = (ssn, staff_type)
    mycursor.execute(sql,val)
    mydb.commit()
    print(mycursor.rowcount, "record inserted.")

def activate_card():
    Card_Number = (int)(input("Card Number:"))
    ssn = (int)(input("Member SSN:"))
    date_issued = datetime.now().date()
    valid_time = 4
    card_status = "active"
    sql = "INSERT INTO Membership_Card(Card_Number, Member_SSN, Date_Issued, Valid_Time, Card_Status) VALUES(%s, %s, %s, %s, %s)"
    val = (Card_Number, ssn, date_issued, valid_time, card_status)
    mycursor.execute(sql, val)
    mydb.commit()
    print(mycursor.rowcount, "record inserted.")

if __name__=="__main__":
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="LibraryDatabase",
        database="library"
    )
    mycursor = mydb.cursor()

    while(True):
        printMenu()
        menu = (int)(input())
        if menu == 0:
            exit()
        elif menu == 1:
            addBook()
        elif menu == 2:
            update_description_by_ISBN()
        elif menu == 3:
            search_book_by_ISBN()
        elif menu == 4:
            check_out()
        elif menu == 5:
            check_in()
        elif menu == 6:
            calculate_fine()
        elif menu == 7:
            add_a_new_member()
        elif menu == 8:
            add_a_new_staff()
        elif menu == 9:
            activate_card()