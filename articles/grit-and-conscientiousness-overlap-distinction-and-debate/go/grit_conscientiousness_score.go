package main

import "fmt"

func ConscientiousnessScore(industriousness, orderliness, dependability, responsibility, achievementStriving float64) float64 {
	return 0.30*industriousness +
		0.18*orderliness +
		0.18*dependability +
		0.17*responsibility +
		0.17*achievementStriving
}

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func main() {
	c := ConscientiousnessScore(0.81, 0.52, 0.67, 0.74, 0.79)
	g := GritScore(0.91, 0.63)

	fmt.Printf("Synthetic conscientiousness score: %.3f\n", c)
	fmt.Printf("Synthetic grit score: %.3f\n", g)
}
