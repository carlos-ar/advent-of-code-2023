struct node_obj
    inlet::Tuple
    outlet::Tuple
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
                pipes[(r,c)] = node_obj(inlet, outlet)
            
                # println(val)
            elseif string(val) == "S"
                println("STARTING POINT $r, $c")
                starting_node = (r,c)
            end
        end
    end

    return pipes, starting_node

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
        nodes[start_node] = node_obj(neighbors[1], neighbors[2])
    end

    return nodes
end

function traverse_graph(nodes, start_node)
    found_end = false
    
    total_steps = 0

    current_inlet = nodes[start_node].inlet
    current_outlet = nodes[start_node].outlet
    traverse_start = [current_inlet, current_outlet] 

    # print(current_node,current_inlet, current_outlet)
    # outlet
    
    # for current_node in [traverse_start[1]]
    for current_node in traverse_start
        # next_node = nodes[start_node]
        previous_node = start_node
        current_ij = current_node[2:3]
        n_steps = 0
        while found_end == false
            next_node = nodes[current_ij]
            
            # println("prevsiou node: $previous_node")
            # println("curent node: $current_node")
            # println("next node: $next_node")
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
            
        end
        

    end
end


# pipe_network, start = parse_data("day_10/part1_sample.txt")
# pipe_network, start = parse_data("day_10/part1_sample_comp.txt")
pipe_network, start = parse_data("day_10/input.txt")

# display(pipe_network)
out_p = find_starting_node_neighbors(pipe_network, start)
# display(out_p)

traverse_graph(out_p, start)

# println(pipe_network)