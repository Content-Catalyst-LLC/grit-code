package main

import "fmt"

func AdaptivePersistenceIndex(grit, selfControl, practiceQuality, purpose, support, recovery, stress float64) float64 {
	return 0.22*grit +
		0.16*selfControl +
		0.16*practiceQuality +
		0.16*purpose +
		0.18*support +
		0.14*recovery -
		0.16*stress
}

func main() {
	index := AdaptivePersistenceIndex(4.2, 4.0, 4.1, 4.3, 4.0, 3.9, 2.4)
	fmt.Printf("Synthetic adaptive persistence index: %.3f\n", index)
	fmt.Println("Professional caution: synthetic demonstration only.")
}
