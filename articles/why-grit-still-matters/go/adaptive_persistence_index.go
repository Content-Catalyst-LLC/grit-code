package main

import "fmt"

func AdaptivePersistenceIndex(grit, purpose, feedback, practice, recovery, environment, support, stress, blocked float64) float64 {
	return 0.22*grit +
		0.16*purpose +
		0.16*feedback +
		0.14*practice +
		0.16*recovery +
		0.18*environment +
		0.12*support -
		0.14*stress -
		0.12*blocked
}

func main() {
	index := AdaptivePersistenceIndex(4.2, 4.5, 4.3, 4.2, 4.0, 4.1, 4.2, 2.4, 2.0)
	fmt.Printf("Synthetic adaptive persistence index: %.3f\n", index)
	fmt.Println("Professional caution: synthetic demonstration only.")
}
