function testing_frame()
    frame = Frame()
    resize!(frame, 4)

    topology = Topology()
    add_atom!(topology, Atom("H"))
    add_atom!(topology, Atom("O"))
    add_atom!(topology, Atom("O"))
    add_atom!(topology, Atom("H"))

    add_bond!(topology, 0, 1)
    add_bond!(topology, 1, 2)
    add_bond!(topology, 2, 3)

    set_topology!(frame, topology)
    return frame
end

@testset "Selection" begin
    frame = testing_frame()
    selection = Selection("name O")
    @test size(selection) == 1

    matches = evaluate(selection, frame)
    @test size(matches, 1) == 2
    @test matches[1] == 1
    @test matches[2] == 2

    selection = Selection("bonds: all")
    @test size(selection) == 2

    matches = evaluate(selection, frame)
    @test size(matches, 1) == 3
    @test ((0, 1) in matches) == true
    @test ((1, 2) in matches) == true
    @test ((2, 3) in matches) == true

    selection = Selection("angles: all")
    @test size(selection) == 3

    matches = evaluate(selection, frame)
    @test size(matches, 1) == 2
    @test ((0, 1, 2) in matches) == true
    @test ((1, 2, 3) in matches) == true

    selection = Selection("dihedrals: all")
    @test size(selection) == 4

    matches = evaluate(selection, frame)
    @test size(matches, 1) == 1
    @test ((0, 1, 2, 3) in matches) == true

    @test selection_string(selection) == "dihedrals: all"

    copy = deepcopy(selection)
    @test selection_string(copy) == "dihedrals: all"
end
