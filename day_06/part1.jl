using Plots
function parse_lines(input)
    println("Parsing data")
    lines = readlines(input)
    times_ = split(lines[1],":")
    times = Int[];distance = Int[]
    for t in split(times_[end], " ")
        if t != ""
            push!(times,parse(Int,t))
        end
    end
    distance_ = split(lines[2],":")
    for t in split(distance_[end], " ")
        if t != ""
            push!(distance,parse(Int,t))
        end
    end
    # distance = split(lines_[2],":")
    # distance = [parse(Int, t) for t in split(times[end], " ")]

    return times, distance
end 
function calculate(time_, distance)
    
    # println(time_)
    number_winners = Int[]
    for (t, dis) in zip(time_, distance)
        t_val = range(0, t)
        # println(t_val)
        d = t_val.*(t .- t_val)
        winners = d .> dis
        # println(winners)
        push!(number_winners, sum(winners))

        plot(t_val, d)
    end


    product_all_winners = prod(number_winners)
    println("Solution $product_all_winners")

end

# times, distance = parse_lines("day_06/part1_sample_edit.txt")
times, distance = parse_lines("day_06/part1_sample.txt")
# times, distance = parse_lines("day_06/input.txt")
calculate(times,distance)
    
# print(times, distance)

println("Done")