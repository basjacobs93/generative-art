### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 13e5b5ba-9f66-46a8-81cc-44a985163243
using Luxor

# ╔═╡ 546912b4-9af8-47d9-8b13-14abee56f9fd
RULES = Dict('X' => ["F+[[X]-X]-F[-FX]+X"],
			 'F' => ["F[+F]F[−-F][F]", "F[+F]F[--F]F", "FF-[-F+F+F]+[+F-F-F]"])

# ╔═╡ bb2287e2-aad1-4134-8048-cf70c9c1cfe3
function apply_rule(char)
	if char in keys(RULES)
		new_char = RULES[char]
		new_char[rand(1:length(new_char))]
	else
		string(char)
	end
end

# ╔═╡ 8ed3d85d-b975-4ebe-9703-d2febf294733
function rewrite_l(word)
	join([apply_rule(c) for c in word])
end

# ╔═╡ f105753b-5cb6-428b-a888-e28972a57775
function transform_l_tree(axiom, iterations)
	
	word = axiom
	
	for i = 1:iterations
		word = rewrite_l(word)
	end
	
	word
end

# ╔═╡ 0bac16c7-d7ca-44a4-a0c6-c31e1f3d344f
trees = [transform_l_tree("F", rand(3:6)) for i in 1:1]

# ╔═╡ d8d971c8-6d4d-40c9-8d01-7640804f28ba
@png begin
	background("lightgray")

	🐢 = Turtle()
	Pencolor(🐢, "black")
	Penwidth(🐢, 0.4)
	
	for tree in trees
		Reposition(🐢, rand(-200:200), rand(150:200))
		Orientation(🐢, -90)
		for i in tree
			if i == 'F'
				Forward(🐢, 1)
			elseif i == '-'
				Turn(🐢, -30)
			elseif i == '+'
				Turn(🐢, +30)
			elseif i == '['
				Push(🐢)
			elseif i == ']'
				# Pencolor(🐢, "green")
				# Forward(🐢, 1)
				# Pencolor(🐢, "black")
				Pop(🐢)
			end
		end
	end
	
	finish()
end 400 400 "turtle.png"

# ╔═╡ Cell order:
# ╠═13e5b5ba-9f66-46a8-81cc-44a985163243
# ╠═546912b4-9af8-47d9-8b13-14abee56f9fd
# ╠═bb2287e2-aad1-4134-8048-cf70c9c1cfe3
# ╠═8ed3d85d-b975-4ebe-9703-d2febf294733
# ╠═f105753b-5cb6-428b-a888-e28972a57775
# ╠═0bac16c7-d7ca-44a4-a0c6-c31e1f3d344f
# ╠═d8d971c8-6d4d-40c9-8d01-7640804f28ba
