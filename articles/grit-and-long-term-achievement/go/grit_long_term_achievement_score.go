package main

import "fmt"

func GritScore(perseveranceEffort, consistencyInterests float64) float64 {
	return 0.60*perseveranceEffort + 0.40*consistencyInterests
}

func AchievementReadinessIndex(
	grit,
	deliberatePractice,
	feedbackQuality,
	socialSupport,
	opportunityAccess,
	burnout float64,
) float64 {
	return 0.18*grit +
		0.28*deliberatePractice +
		0.18*feedbackQuality +
		0.18*socialSupport +
		0.22*opportunityAccess -
		0.16*burnout
}

func main() {
	grit := GritScore(0.82, 0.64)
	readiness := AchievementReadinessIndex(grit, 0.86, 0.61, 0.58, 0.70, -0.28)

	fmt.Printf("Synthetic grit score: %.3f\n", grit)
	fmt.Printf("Synthetic achievement readiness index: %.3f\n", readiness)
}
