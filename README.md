A program that uses interrupts to address incoming streams of data from a numberpad.

This program uses interrupts and a custom "search map" to correctly output a number pressed on the chosen numberpad. First, the numberpad's unique data had to be gathered, that is each numberpad has its own encoder. After experimenting, each number's output is treated as displacement within the "search map" array. Thus, the actual values of the numberpad are stored in the order of their corresponding displacement.

Finally, pin 5 of port B has its rising interrupt enabled that senses any incoming stream of data.
