
using Printf
using DelimitedFiles

struct node_obj
    inlet::Tuple
    outlet::Tuple
    pipe::String
end

function return_inlet_outlet(r_in,c_in,directions)
    neighbors = []
    for direction in directions
        r = r_in; c=c_in
        if direction == "N"
            r = r - 1
        elseif direction == "S"
            r = r + 1
        elseif direction == "W"
            c = c - 1
        elseif direction == "E"
            c = c + 1
        else
            r = r; c = c
        end
        push!(neighbors, (direction, r,c))
    end

    inlet = neighbors[1]; outlet = neighbors[2]
    return inlet, outlet
end 

function parse_data(input)
    lines = readlines(input)

    rows = countlines(input)
    cols = length(lines[1])
    dims = (rows, cols)
"""
    | is a vertical pipe connecting north and south.
    - is a horizontal pipe connecting east and west.
    L is a 90-degree bend connecting north and east.
    J is a 90-degree bend connecting north and west.
    7 is a 90-degree bend connecting south and west.
    F is a 90-degree bend connecting south and east.
    . is ground; there is no pipe in this tile.
    S is the starting position of the animal; there is a pipe on this
"""
    directions = Dict([
        ("|",("N", "S")),
        ("-",("E", "W")),
        ("L",("N", "E")),
        ("J",("N", "W")),
        ("7",("S", "W")),
        ("F",("S", "E")),
        # (".",("","")),
        # ("S",("","")),
        ]
    )

    
    pipes = Dict()
    starting_node = ()
    for (r, line) in enumerate(lines)
        for (c,val) in enumerate(line)
            if haskey(directions, string(val)) 
                inlet, outlet = return_inlet_outlet(r,c, directions[string(val)])
                # println("inlet $inlet outlet $outlet")
                pipes[(r,c)] = node_obj(inlet, outlet, string(val))
            
                # println(val)
            elseif string(val) == "S"
                println("STARTING POINT $r, $c")
                starting_node = (r,c)
            end
        end
    end

    return pipes, starting_node, dims

end

function find_starting_node_neighbors(nodes, start_node)
    neighbor_indices = [("S", 1, 0), ("N", -1, 0), ("W", 0, -1), ("E", 0, 1)]
    neighbors = []
    for ij in neighbor_indices
        i = ij[2]; j = ij[3]
        r = start_node[1] + i
        c = start_node[2] + j
        # println("loop $r, $c")
        if haskey(nodes, (r,c))
            # println("FOUND")
            # println("inlet is: ",nodes[(r,c)].inlet, " does it match $ij?")
            # println("outlet is: ",nodes[(r,c)].outlet, " does it match $ij?")
            # println(nodes[(r,c)].inlet[2:3])

            if nodes[(r,c)].inlet[2:3] == start_node
                neighbor = (ij[1], r,c)
                push!(neighbors, neighbor)
            elseif nodes[(r,c)].outlet[2:3] == start_node
                neighbor = (ij[1], r,c)
                push!(neighbors, neighbor)
            end
            # println("neighbor was set: ",neighbor)
            # println("---")
        end
        # println("neighboors are $neighbors")
    end
    if length(neighbors) == 2
        nodes[start_node] = node_obj(neighbors[1], neighbors[2], "S")
    end

    return nodes
end

function pipe_split(previous_node, current_node, next_node)
    matrix_neighbors = [
        (-1, -1), (-1,  0), (-1,  1),
        ( 0, -1), ( 0,  0), ( 0,  1),
        ( 1, -1), ( 1,  0), ( 1,  1),
    ]


    matrix_indices = Dict([
        ("NS", [3,6,9]), # |
        ("SN", [1,4,7]), # |
        ("EW", [7,8,9]), # -
        ("WE", [1,2,3]), # -
        ("NE", [3]), # L
        ("EN", [1,4,7,8,9]), # L
        ("NW", [3,6,7,8,9]), # J
        ("WN", [1]), # J
        ("SW", [7]), # 7
        ("WS", [1,2,3,6,9]), # 7
        ("SE", [1,2,3,4,7]), # F
        ("ES", [9]), # F
        ]
    )
    # println("prevsiou node: $previous_node")
    # println("curent node: $current_node")
    # println("next node: $next_node")
    if next_node.inlet[2:3] == previous_node
        # println("coming from inlet")
        direction = next_node.inlet[1] * next_node.outlet[1]
    elseif next_node.outlet[2:3] == previous_node
        # println("coming from outlet")
        direction = next_node.outlet[1] * next_node.inlet[1]

    end

    
    neighbor_direction = matrix_indices[direction]
    neighbor_array = matrix_neighbors[neighbor_direction]
    # return inside, outside
    # println("direction $direction")
    # println("indices $neighbor_array")
    return neighbor_array
end


function traverse_graph(nodes, start_node, dims)
    out_matrix = zeros(dims)
    out_matrix_path = zeros(dims) .+ 1
    found_end = false
    
    current_inlet = nodes[start_node].inlet
    current_outlet = nodes[start_node].outlet
    traverse_start = [current_inlet, current_outlet] 

    # print(current_node,current_inlet, current_outlet)
    
    for current_node in [traverse_start[2]]
    # for current_node in traverse_start
        previous_node = start_node
        current_ij = current_node[2:3]
        n_steps = 0
        # println()
        # println("starting traversal from $current_node")
        # println()
        while found_end == false
            
            next_node = nodes[current_ij]
            
            # println("prevsiou node: $previous_node")
            # println("curent node: $current_node")
            # println("next node: $next_node")

            neighbor_array = pipe_split(previous_node,
            current_node, next_node)

            # now add to matrix rep
            for neighbor_rc in neighbor_array
                xi, yi = current_node[2:3]
                ri = xi + neighbor_rc[1]
                ci = yi + neighbor_rc[2]
                if ri != 0 && ci != 0 && ri != dims[1]+1 && ci != dims[2]+1
                    # println("row $ri col $ci")

                    out_matrix[ri, ci] = out_matrix[ri, ci] + 1 
                end
            end

            xii, yii = current_node[2:3]
            out_matrix_path[xii, yii] = 0#n_steps
            # first check if current node is in starting node
            if previous_node == start_node && n_steps > 0
                println("back at start node: $start_node")
                println("took me $n_steps")
                found_end = true
            else
                # first check if current node is in the in/outlet of next node
                if previous_node == next_node.inlet[2:3]
                    previous_node = current_node[2:3]
                    current_node = next_node.outlet
                elseif previous_node == next_node.outlet[2:3]
                    previous_node = current_node[2:3]
                    current_node = next_node.inlet
                end


            end
            current_ij = current_node[2:3]
            # wait_for_key(prompt) = (print(stdout, prompt); read(stdin, 1); nothing)
            # wait_for_key("continue")
            
            n_steps = n_steps + 1
            # update next node as the current node
            # if haskey(nodes, current_ij)
            #     # println(current_ij)
            #     out_matrix[current_ij[1], current_ij[2]]= 0
            # end
        end
        


        

    end
    return out_matrix, out_matrix_path
end

function flood_fill(arr, (x, y))
    # check every element in the neighborhood of the element at (x, y) in arr
    for x_off in -1:1
        for y_off in -1:1
            # put the next part in a try-catch block so that if any index
            # is outside the array, we move on to the next element.
            try
                # if the element is a 1, change it to an 8 and call flood_fill 
                # on it so it fills it's neighbors
                if arr[x + x_off, y + y_off] == 1
                    arr[x + x_off, y + y_off] = 8
                    flood_fill(arr, (x + x_off, y + y_off))
                end
            catch
                continue
            end
        end
    end
end


# pipe_network, start, dims = parse_data("day_10/part2_sample.txt")
# pipe_network, start, dims = parse_data("day_10/part2_sample_comp.txt")
# pipe_network, start, dims = parse_data("day_10/part2_sample_comp2.txt")
pipe_network, start, dims = parse_data("day_10/input.txt")

# display(pipe_network)
out_p = find_starting_node_neighbors(pipe_network, start)
# display(out_p)

out_m, path_matrix = traverse_graph(out_p, start, dims)
# display(out_m)

# println(pipe_network)

# m = (a->(@sprintf "%4d" a)).(out_m)
# writedlm("./loopy.txt", m, "" , quotes=false)
nonzero = out_m.*path_matrix
bit_nonzero = (nonzero .> 0)
fl_path_matrix = path_matriz
flood_fill(fl_path_matrix, (75,75))

sum_sol = sum(bit_nonzero)
println()
println("Solution should be: $sum_sol")
plot_network = false
plot_network = true
if plot_network == true
    using Plots

    p1 = heatmap(out_m)
    p2 = heatmap(path_matrix)
    p3 = heatmap(nonzero)
    p4 = heatmap(bit_nonzero)
    # p4 = heatmap(fl)
    plot(p1, p2, p3, p4,  layout=(2,2))
    # plot(p1,p2,  layout=(2,2))

end