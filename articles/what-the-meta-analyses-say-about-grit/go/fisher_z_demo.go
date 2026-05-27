package main

import (
	"fmt"
	"math"
)

func FisherZ(r float64) float64 {
	return 0.5 * math.Log((1.0+r)/(1.0-r))
}

func InverseFisherZ(z float64) float64 {
	e := math.Exp(2.0 * z)
	return (e - 1.0) / (e + 1.0)
}

func main() {
	r := 0.22
	z := FisherZ(r)
	fmt.Printf("r: %.3f\n", r)
	fmt.Printf("Fisher z: %.3f\n", z)
	fmt.Printf("Back-transformed r: %.3f\n", InverseFisherZ(z))
}
