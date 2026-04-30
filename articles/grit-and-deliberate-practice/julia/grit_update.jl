# Toy grit dynamic update model.

goal_progress = 0.20
perseverance = 0.75
commitment = 0.70
meaning = 0.80
support = 0.60
friction = 0.35
learning_rate = 0.08

for t in 1:16
    goal_progress = goal_progress + learning_rate * (0.30 * perseverance + 0.25 * commitment + 0.25 * meaning + 0.15 * support - 0.25 * friction)
    goal_progress = clamp(goal_progress, 0.0, 1.0)
    println("Time ", t, ": goal progress = ", round(goal_progress, digits=3))
end
