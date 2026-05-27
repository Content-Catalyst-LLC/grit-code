package main

import "fmt"

func SelfControlScore(attentionRegulation float64, emotionRegulation float64, impulseControl float64) float64 {
	return 0.40*attentionRegulation + 0.30*emotionRegulation + 0.30*impulseControl
}

func GritScore(perseveranceEffort float64, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func main() {
	sc := SelfControlScore(0.74, 0.62, 0.81)
	g := GritScore(0.91, 0.68)

	fmt.Printf("Synthetic self-control score: %.3f\n", sc)
	fmt.Printf("Synthetic grit score: %.3f\n", g)
}
