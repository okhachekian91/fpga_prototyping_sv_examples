f = 0;

with open("celcius_to_fahrenheit.data", "w") as d:
	for i in range(0,100):
		f = int(round((9.0/5) * i + 32))
		d.write(f"{f:08b}\n")

with open("fahrenheit_to_celcius.data", "w") as e:
	for j in range (32,212):
		c = int(round((j-32) * (5.0/9)))
		e.write(f"{c:08b}\n")
