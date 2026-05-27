package main

import "fmt"

func CohensD(meanTreatment, meanControl, pooledSD float64) float64 {
	if pooledSD == 0 {
		return 0
	}
	return (meanTreatment - meanControl) / pooledSD
}

func main() {
	d := CohensD(4.2, 3.6, 0.8)
	fmt.Printf("Synthetic intervention effect size estimate: %.3f\n", d)
	fmt.Println("Professional caution: synthetic demonstration only.")
}
