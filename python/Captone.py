def main():
    #escribe tu código abajo de esta línea
    pass
#In this activity I promise to apply my knowledge, to make an effort in its development and not to use unauthorized or illegal means to carry it out.
# Sergio Zuckermann A01024831 and Emiliano Villanueva A01782485


import csv 



def read_data(df):
    with open (df, newline='') as df:
        csv_reader = csv.reader(df)
        for line in csv_reader:
            print(line)
            menu()

            
def  search_League(df):
    league= input("Enter league: ")
    select_league(df, league)
    menu()

def select_league(df, league):
    for row in df:
        if row[0] == league:
            print (row)
            menu()

def Select_price(df):
    price= input("Choose price: (Options: 10,40,50,60)")
    for row in df:
        if row[3] == price:
            print (row)
            menu()

def  search_Brand(df):
    brand= input("Enter league: ")
    select_Brand(pd, brand)
    menu()
    
def select_Brand(df,Brand):
   for row in df:
        if row[2] == Brand:
            print (row)
            menu()

def buy_shirts(df):
    shirt_id = int(input("Enter Shirt index: "))
    totalshirts = int(input("How many shirts? "))
    pd[shirt_id][4]= pd[shirt_id][4] - totalshirts
    menu()
    
    

def menu():
        print("a. Check based on league")
        print("b. Check based on price")
        print("c. Check based on brand")
        print("d. Buy Shirts")
        print("e. Search League")
        print ("f. Search Brand")
        print("q. To exit the program")
        selection= input("Choose an option: ")
        if selection== "a":
            select_league()
        elif selection== "b":
            Select_price()
        elif selection == "c":
            select_Brand()
        elif selection == "d":
            buy_shirts()
        elif selection == "e":
            search_League()
        elif selection == "f":
            search_Brand()
        elif selection == "q":
            print("Goodbye")
        else:
            print("ERROR 404, TRY AGAIN")
            menu()


        
print("WELCOME TO INVENTORY CUCO ANGULO TM")

    

if __name__ == '__main__':
    main()
 
