struct node_obj
    name::String
    data::Int
    children
end

function get_node_tuple(line)
    split_line = split(line," = ")
    nodes = split_line[end]
    nodes = replace(nodes, "(" => "")
    nodes = replace(nodes, ")" => "")
    nodes = split(nodes, ", ")

    lnode = nodes[1]; rnode = nodes[2]
    return lnode, rnode
end
function create_network(input)



    
    lines = readlines(input)
    nodes = Dict()

    step_order = lines[1]

    start_nodes = String[]
    for line in lines[3:end]
        # println(line)
        node = line[1:3]
        left_node, right_node = get_node_tuple(line)
        nodes[string(node)] = node_obj(node, 1, [left_node, right_node])

        if node[end] == 'A'
            push!(start_nodes, node)
        end
    end

    tree = nodes

    # for 
    # F1 = element("F1", 1, nothing)
    # F2 = element("F2", 2, nothing)
    # F3 = element("F3", 3, nothing)
    # D4 = element("D4", 0, [F1, F2])
    # D5 = element("D5", 0, [F3])
    # D6 = element("D6", 0, [D4, D5])

    return tree, step_order, start_nodes
end

function traverse_network(tree, steps, current_tree)
# trying some other maths
# function traverse_network(tree, steps, single_tree)
        # starting at node AAA
    found_end = false
    total_steps = 0
    current_step = 1
    max_step = length(steps)
    # current_tree = ["AAA"]
    while found_end == false

        total_steps = total_steps + 1

        if steps[current_step] == 'R'
            indx = 2
        else
            indx = 1
        end

        # println("starting tree")
        # println(tree[current_tree])
        ends_with_z = Bool[]
        next_tree = String[]
        for start_node in current_tree
            child = tree[start_node].children[indx]
            if child[end] == 'Z'
                push!(ends_with_z, true)
            else
                push!(ends_with_z, false)
            end
            push!(next_tree, child)
        end

        # next_tree = tree[current_tree].children[indx]

        # print("took left or right child")
        # println(next_tree)
        
        # if next_tree == "ZZZ"
        if all(ends_with_z)
            found_end = true
        elseif current_step < max_step
            # go to next step
            current_step = current_step + 1
            current_tree = next_tree
        else
            # reached the end, restart steps
            current_step = 1
            current_tree = next_tree
        end

        # println("next iter tree")
        # println(tree[current_tree])

        # # c = readline()
        # wait_for_key(prompt) = (print(stdout, prompt); read(stdin, 1); nothing)
        # wait_for_key("continue")
        # if mod(total_steps,1000) == 0
        #     println("steps: $total_steps")
        #     println("tree: $next_tree")
        # end
    end
    println("child found: $current_tree")

    return total_steps
end

# tree, steps, start_nodes = create_network("day_08/part2_sample.txt")
# tree, steps = create_network("day_08/part1_sample_edit.txt")
tree, steps, start_nodes = create_network("day_08/input.txt")

array_steps = Int[]
for single_node in start_nodes
    start_node = [single_node]
    steps_taken = traverse_network(tree, steps, start_node)
    println("steps taken: $steps_taken, for node: $start_node")
    push!(array_steps, steps_taken)
    
    # how many times did i go through the steps
    num_step_loops = mod(steps_taken, length(steps) )
    println("loop through the step list: $num_step_loops")
end

println("number of steps: ", length(steps))
# println(tree)
# display(tree)
# print("steps taken: $steps_taken")
