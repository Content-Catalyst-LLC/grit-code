package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func PracticeQualityIndex(deliberatePractice, feedbackQuality, coachingAccess float64) float64 {
	return 0.50*deliberatePractice + 0.30*feedbackQuality + 0.20*coachingAccess
}

func main() {
	grit := GritScore(0.82, 0.64)
	practiceQuality := PracticeQualityIndex(0.86, 0.61, 0.55)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic practice quality index: %.3f\n", practiceQuality)
}
