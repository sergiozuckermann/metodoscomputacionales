import random

def guess_number():
    secret_number = random.randint(1, 100)
    attempts = 0
    
    print("Welcome to Guess the Number!")
    print("I'm thinking of a number between 1 and 100.")
    
    while True:
        guess = int(input("Take a guess: "))
        attempts += 1
        
        if guess < secret_number:
            print("Too low!")
        elif guess > secret_number:
            print("Too high!")
        else:
            print("Congratulations! You guessed the number in", attempts, "attempts.")
            break

# Run the game
guess_number()
