
function get_numbers(line)
    raw_calibration = [filter(isdigit, s) for s in line]
    calibration = String[]
    for c in raw_calibration
        if length(c) < 2
            c = c*c
        elseif length(c) > 2
            c = c[1] * c[end]
        end
        push!(calibration ,c)
    end
    return calibration
end

function sum_calibration(calibration_array)
    calibration_floats = [parse(Int, c) for c in calibration_array]
    sum_calibration = sum(calibration_floats)
end

# lines = readlines("day_01/part1_sample.txt")
lines = readlines("day_01/input.txt")

numbers = get_numbers(lines)
sum_value = sum_calibration(numbers)
# println(numbers)
# println(sum_value)
println("done")