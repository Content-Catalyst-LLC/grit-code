package main

import "fmt"

func EnvironmentDesignIndex(
	autonomy,
	competence,
	feedback,
	belonging,
	mentoring,
	recovery,
	resources,
	fairness,
	safety,
	adaptiveQuitting float64,
) float64 {
	return 0.13*autonomy +
		0.13*competence +
		0.13*feedback +
		0.12*belonging +
		0.10*mentoring +
		0.13*recovery +
		0.10*resources +
		0.11*fairness +
		0.10*safety +
		0.05*adaptiveQuitting
}

func main() {
	index := EnvironmentDesignIndex(4.2, 4.1, 4.3, 4.1, 3.9, 4.0, 3.8, 4.1, 4.2, 3.9)
	fmt.Printf("Synthetic environment design index: %.3f\n", index)
	fmt.Println("Professional caution: synthetic demonstration only.")
}
