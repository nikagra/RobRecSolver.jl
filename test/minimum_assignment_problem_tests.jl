# Minimum assignment problem tests

begin
    C = [1 4 5; 5 7 6; 5 8 8]
    x =  minimumAssignmentProblem(C)
    @time @test vecdot(C, x) == 15
end

begin
    C = [9 2 7 8; 6 4 3 7; 5 8 1 8; 7 6 9 4]
    x = minimumAssignmentProblem(C)
    @time @test vecdot(C, x) == 13
end
