def main():
    # Create a list called people with "Me" as the first item
    people = ["Me"]
    print("SplitR")
    print("Splitr makes it simple to split bills, track shared expenses, and settle up with friends — without the awkward math.")
    print("Whether you're sharing rent, planning a trip, or just grabbing dinner, Splitr keeps everyone on the same page.")
    print()

    # Get names of friends
    while True:
        friend = input("Enter friend name (leave blank to start entering expenses): ")
        if friend == "":
            break
        people.append(friend)
    expense_dict = {}

    # Initialise Dictionary
    for i in range(len(people)):
        expense_dict[people[i]]=0
    
    display_people(people)

    # Get expenses till the person enters a blank
    while True:
        while True:
            valid_input = True
            spender = input("Enter the number of the person spending (blank to exit the program): ")
            if spender == "":
                break
            spender = spender.strip() # Trim
            if not spender.isdigit() or not (1 <= int(spender) <= len(people)):
                valid_input = False
            if valid_input:
                break
            else:
                print("Invalid input, please enter numbers from the list above.")
        # Break out of main loop
        if spender == "":
                break
        spender = int(spender.strip())
        amount = float(input("Enter amount: "))

        print("Select friends sharing this expense by entering numbers separated by commas: ")
        # Following input and check provided by AI
        while True:
            selected_numbers = input("Enter numbers: ").split(",")
            valid_input = True
            # Check each number
            for num in selected_numbers:
                # Trim spaces and check if it's a digit
                num = num.strip()
                if not num.isdigit() or not (1 <= int(num) <= len(people)):
                    valid_input = False
                    break        
            # Break the loop if input is valid
            if valid_input:
                break
            else:
                print("Invalid input, please enter numbers from the list above.")
        selected_people = [people[int(num) - 1] for num in selected_numbers]
        # display_people(selected_people)
        # Calculate everyone's share
        expense_dict[people[spender - 1]] += amount
        for num in selected_numbers:
            expense_dict[people[int(num) -1]] -= round(amount / len(selected_numbers),2)
        print_money_owed(expense_dict)

def print_money_owed(expense_dict):
    print("Amounts to be collected by each (positive means to be collected, negative means to be paid)")
    for key,value in expense_dict.items():
        print(f"{key} : {value}")
    

def display_people(people):
    # Display options with numbers
    for i, friend in enumerate(people):
        print(f"{i + 1}. {friend}")


if __name__ == "__main__":
    main()
