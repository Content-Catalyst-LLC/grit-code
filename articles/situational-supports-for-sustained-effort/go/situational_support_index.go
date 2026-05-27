package main

import "fmt"

func SupportIndex(autonomy, feedback, belonging, mentoring, recovery, resources, fairness, safety float64) float64 {
	return 0.16*autonomy +
		0.16*feedback +
		0.16*belonging +
		0.12*mentoring +
		0.14*recovery +
		0.14*resources +
		0.12*fairness +
		0.10*safety
}

func main() {
	index := SupportIndex(4.2, 4.3, 4.1, 3.9, 4.0, 3.8, 4.1, 4.2)
	fmt.Printf("Synthetic situational support index: %.3f\n", index)
	fmt.Println("Professional caution: synthetic demonstration only.")
}
