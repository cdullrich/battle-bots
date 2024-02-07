import random
import time

# Define robot options
robot_options = ["Sniper", "Tanker", "Shielder", "Destroyer", "Blaster", "Stomper", "Slasher", "Random"]

# Define the robot data
dataset1 = """NAME,BOT_WEIGHT,TYPE
Slasher,1.4,melee
Blaster,0.72,ranged
Stomper,1.8,melee
Shielder,0.47,melee
Tanker,2.6,melee
Sniper,1.50,ranged
Destroyer,6.5,melee"""

dataset2 = """NAME,WEAPON_POWER,ARMOR_THICKNESS
Tanker,1.97,0.5
Sniper,1.70,0.3
Destroyer,4.76,0.7
Slasher,1.3,0.4
Blitz,1.11,0.2
Blaster,1.24,0.3
Stomper,2.62,0.6
Shielder,1.2,0.35"""

# Convert dataset strings to lists of dictionaries
dataset1_lines = dataset1.split("\n")[1:]
dataset2_lines = dataset2.split("\n")[1:]

dataset1_objects = []
for line in dataset1_lines:
    name, bot_weight, _ = line.split(",")
    dataset1_objects.append({"NAME": name, "BOT_WEIGHT": float(bot_weight)})

dataset2_objects = []
for line in dataset2_lines:
    name, weapon_power, armor_thickness = line.split(",")
    dataset2_objects.append({"NAME": name, "WEAPON_POWER": float(weapon_power), "ARMOR_THICKNESS": float(armor_thickness)})

# Merge dataset objects
combined_dataset = []
for robot1 in dataset1_objects:
    match = next((robot2 for robot2 in dataset2_objects if robot2["NAME"] == robot1["NAME"]), None)
    if match:
        robot1.update(match)
        combined_dataset.append(robot1)

# Calculate power levels
power_table = {}
for robot in combined_dataset:
    power_level = robot["WEAPON_POWER"] * (robot["ARMOR_THICKNESS"] / robot["BOT_WEIGHT"])
    power_table[robot["NAME"]] = power_level

# User input for robot selection
my_option = ""
while my_option not in robot_options:
    my_option = input(f"Choose your fighter: {', '.join(robot_options)}\n")
    if my_option not in robot_options:
        print(f"'{my_option}' is not in the list of available robots. Please try again")

if my_option == "Random":
    while my_option == "Random":
        my_option = random.choice(robot_options)

print(f"\nYour fighter is: {my_option}\n")

# User input for opponent selection
enemy_option = ""
while enemy_option not in robot_options:
    enemy_option = input(f"Choose your opponent: {', '.join(robot_options)}\n")
    if enemy_option not in robot_options:
        print(f"'{enemy_option}' is not in the list of available robots. Please try again")

if enemy_option == "Random":
    while enemy_option == "Random":
        enemy_option = random.choice(robot_options)

print(f"You choose to fight: {enemy_option}\n")
time.sleep(2)
print("LET THE BATTLE BEGIN!\n")
time.sleep(2)
print("BOOM!\n")
time.sleep(2)
print("BANG!\n")
time.sleep(2)
print("BLORP!\n")
time.sleep(2)

# Get power levels
my_power = power_table[my_option]
enemy_power = power_table[enemy_option]

print(f"With {my_option} at a power level of {my_power:.2f} and {enemy_option} at a power level of {enemy_power:.2f}...\n")
time.sleep(2)

# Determine battle outcome
if my_power > enemy_power:
    print(f"Your robot {my_option} has bested {enemy_option} in glorious robot battle!\n")
elif my_power < enemy_power:
    print(f"The crowd goes silent as your robot {my_option} falls crackling at the wheels of {enemy_option}\nBetter luck next time...\n")
else:
    print("Both robots go down in a heap of smoke with no true victor...\n")
    time.sleep(2)
    print("ONLY CARNAGE!\n")

input("Press enter to leave the robot coliseum\n")