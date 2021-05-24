### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 2ad11ff8-b8c8-11eb-1c46-f3babe900e58
using Luxor

# ╔═╡ de5764b5-7203-41d5-94e1-438bcd8c75fb
md"Based on [inconvergent/differential](https://github.com/inconvergent/differential-line/tree/d951ed459a99fd87713b8b5a2aee06685119c007)"

# ╔═╡ 328c272f-4d85-4bb5-928a-8d95883498ba
function draw_points(points)
	for i in 1:length(points)
		next_i = i < length(points) ? i + 1 : 1
		line(points[i], points[next_i], :stroke)
		# circle(points[i], 1, :fill)
	end
end

# ╔═╡ 4b35feec-702d-402f-8015-5d77ea9a3b67
function attraction_step(points, farl, nearl, step)
	n_points = length(points)
	d_points = [Point(0, 0) for _ in 1:n_points]
	# for every point, attract and reject
	for i in 1:n_points
		next_i = i < n_points ? i + 1 : 1
		prev_i = i > 1 ? i - 1 : n_points
		
		v = points[i]
		
		# for every other point, attract or reject
		for j in 1:n_points
			w = points[j]
			diff = v - w
			norm = sqrt(v.x^2 + v.y^2)

			if j == next_i || j == prev_i
				# it is one of the neighbors
				# don't want to be too close
				if norm >= nearl
					# attract
					d_points[i] -= diff/norm*step
				end
			else
				# reject if not too far
				# closer points reject stronger
				if norm < farl
					d_points[i] += diff*(farl/norm-1)*step
				end
			end
		end
	end

	for i in 1:n_points
		points[i] += d_points[i]
	end
end

# ╔═╡ 4e291e01-6601-4102-8038-6f082e0ffedd
@draw begin
	n_init_points = 40
	radius = 100
	n_steps = 400
	draw_every = 10
	step = 10
	farl = 40
	nearl = 2
	setline(1)
	
	angles = sort(rand(n_init_points)*2pi)
	
	points = [Point(radius*cos(a), radius*sin(a)) for a in angles]
	
	draw_points(points)

	for i in 1:n_steps
		attraction_step(points, farl, nearl, step)
		if i % draw_every == 0
			draw_points(points)
		end
	end
end

# ╔═╡ Cell order:
# ╠═de5764b5-7203-41d5-94e1-438bcd8c75fb
# ╠═2ad11ff8-b8c8-11eb-1c46-f3babe900e58
# ╠═328c272f-4d85-4bb5-928a-8d95883498ba
# ╠═4b35feec-702d-402f-8015-5d77ea9a3b67
# ╠═4e291e01-6601-4102-8038-6f082e0ffedd
