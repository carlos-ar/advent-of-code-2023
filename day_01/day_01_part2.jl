# All the string to number mappings
global string_dict = [("one", "1"), ("two", "2"),
    ("three", "3"), ("four", "4"),
    ("five", "5"), ("six", "6"), 
    ("seven", "7"), ("eight", "8"),
    ("nine", "9")]

function get_indices(line)
    # create vector of ints from each line
    # each vector contains (Index, Number) pair
    string_indices = Vector{Int}[]
    # iterate through all string-number pairs
    for (string_number, number) in string_dict
        # and find indices where the string-number occurs
        check_string = findall(string_number, line)
        # and number-number occurs
        check_num = findall(number, line)

        # if its not empty create vector of indice string-numbers
        if !isempty(check_string)
            # since you may have more than one of the same
            # string - numbers you need to add all index positions
            for cs in check_string
                index_string = [cs[1], parse(Int,number)]
                push!(string_indices , index_string)
            end
        end
        # and for the number-numbers
        if !isempty(check_num)
            # same for number-numbers
            for cn in check_num
                index_number = [cn[1], parse(Int,number)]
                push!(string_indices , index_number)
            end
        end
    end

    return string_indices
end

function return_vector_string(test_index, index_vector)
    # retun corresponding number from index
    value = 0
    for v in index_vector
        if v[1] == test_index
            value = string(v[2])
        end
    end
    return value
end

function return_min_max_indices(index_vector)
    # get min and max index values
    min_index = minimum([v[1] for v in index_vector])
    max_index = maximum([v[1] for v in index_vector])

    return min_index, max_index
end

function create_calibration(vector)
    # go from number to string+string concate to number
    min_index, max_index = return_min_max_indices(vector)
    calibration = parse(Int,
        string(
            return_vector_string(min_index, vector),
            return_vector_string(max_index, vector)
        )
    )
    return calibration
end

function sum_calibrations(lines)
    # loop through each line and add them up!
    calibration_total = 0
    for line in lines
        s = get_indices(line)
        calibration = create_calibration(s)
        calibration_total+=calibration
    end
    return calibration_total
end

# lines = readlines("day_01/part1_sample.txt")
# lines = readlines("day_01/part2_sample.txt")
lines = readlines("day_01/input.txt")

total = sum_calibrations(lines)
println(total)
println("done")