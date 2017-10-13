# STAT 37810 Statistical Computing
# HW3 Ex4
# @ author : Alice Mee Seon Chung

# create a variable called cars and assign value as interger 100
cars = 100
# create a variable called space_in_a_car and assign value as float 4.0
space_in_a_car = 4.0
# create a variable called drivers and assign value as interger 30
drivers = 30
# create a variable called passengers and assign value as interger 90
passengers = 90
# create a variable called cars_not_driven and  
# assign the result from the equation (cars - drivers)
cars_not_driven = cars - drivers
# create a variable called cars_driven and 
# re-assign the value from drivers into cars_driven
cars_driven = drivers
# create a variable called carpool_capacity and 
# assign the result from the equation (cars_driven * space_in_a_car)
carpool_capacity = cars_driven * space_in_a_car
# create a variable called average_passengers_per_car and 
# assign the result from the equation (passengers / cars_driven)
average_passengers_per_car = int(passengers / cars_driven)

# print a statement that says There are x cars avaiable. and 
# x will be called by the variable cars  
print ("There are", cars, "cars available.")
# print a statement that says There are only x drivers available. and 
# x will be called by the variable drivers 
print ("There are only", drivers, "drivers available.")
# print a statement that says There will be x empty cars today. and 
# x will be called by the variable cars_not_driven
print ("There will be", cars_not_driven, "empty cars today.")
# print a statement that says We can transport x people today. and 
# x will be called by carpool_capacity
print ("We can transport", carpool_capacity, "people today.")
# print a statement that says We have x to carpool today. and 
# x will be called by the variable passengers
print ("We have", passengers, "to carpool today.")
# print a statement that says We need to put about x in each car. and 
# x will be called by average_passengers_per_car
print ("We need to put about", average_passengers_per_car, "in each car.")

# Study drills
# The error line is saying that there is an error when python runs line 8 
# in ex4.py file. In line 8, you create the variable average_passengers_per_car
# and assign the result from the equation (car_pool_capapacity / passenger). 
# This equation calls two varaiable car_pool_capapacity and passenger and
# here, the variable car_pool_capapacity is not defined so it can't call
# the value of car_pool_capapacity. So here you did not assign any value to 
# the variable car_pool_capapacity in the file yet, so python can't run line 8. 

print()
print('More study drills')
print("1.")
# More study drills
# 1) No, it is not necessary since 4.0 and 4 have same numerical value but in 
# different data type in python. Below are lines for showing the changes 
# and results.
space_in_a_car = int(space_in_a_car)
print("I reassigned sapce_in_a_car into integer and space_in_a_car is ",
	   space_in_a_car)
print("Now let's call carpool_capacity variable again and see the result",
	   carpool_capacity)
# 4) "=" assignes right value to left variable name.

# 6)
i = 4
j = 8
x = 3.14
y = 100
print()
print('6.')
print("i % j is",i % j)
print("y // j is",y // j)
print("x * y is",x * y)





















