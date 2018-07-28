# Minimum assignment problem tests

@time @test minimumAssignmentProblem([1 4 5; 5 7 6; 5 8 8]) == [0 1 0; 0 0 1; 1 0 0]

@time @test minimumAssignmentProblem([9 2 7 8; 6 4 3 7; 5 8 1 8; 7 6 9 4]) == [0 1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1]
