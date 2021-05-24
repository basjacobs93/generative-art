### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 2ad11ff8-b8c8-11eb-1c46-f3babe900e58
using Luxor

# ╔═╡ de5764b5-7203-41d5-94e1-438bcd8c75fb
md"Based on [inconvergent/differential](https://github.com/inconvergent/differential-line/tree/d951ed459a99fd87713b8b5a2aee06685119c007)"

# ╔═╡ 328c272f-4d85-4bb5-928a-8d95883498ba
function draw_points(points, fix_first_last)
	n_points = length(points)
	for i in 1:length(points)
		# don't draw circular
		if fix_first_last & (i == n_points)
			continue
		end
		
		next_i = i < length(points) ? i + 1 : 1
		line(points[i], points[next_i], :stroke)
	end
end

# ╔═╡ 4b35feec-702d-402f-8015-5d77ea9a3b67
function attraction_step(points, farl, nearl, step, fix_first_last)
	n_points = length(points)
	d_points = [Point(0, 0) for _ in 1:n_points]
	# for every point, attract and reject
	for i in 1:n_points
		if fix_first_last & ((i == 1) | (i == n_points))
			continue
		end
				
		next_i = i < n_points ? i + 1 : 1
		prev_i = i > 1 ? i - 1 : n_points
		
		v = points[i]
		
		# for every other point, attract or reject
		for j in 1:n_points
			w = points[j]
			diff = v - w
			norm = sqrt(diff.x^2 + diff.y^2)
			if j == i
				continue
			end

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
					# reject
					d_points[i] += diff*(farl/norm-1)*step
				end
			end
		end
	end
	
	for i in 1:n_points
		points[i] += d_points[i]
	end
end

# ╔═╡ 9d425a51-74a4-416e-a61a-39da78af1649
function add_points(points, nearl, limit, fix_first_last)
	n_points = length(points)
		
	# random points
	for i in 1:n_points
		if rand() > limit
			continue
		end
		
		# don't add point before first
		if fix_first_last & (i == 1)
			continue
		end
		
		# split between i-1 and i
		prev_i = i > 1 ? i - 1 : n_points

		v = points[i]
		w = points[prev_i]
		diff = v - w
		norm = sqrt(diff.x^2 + diff.y^2)
		if norm >= nearl
			# split edge if it is long enough
			midpoint = w + (diff/2)
			insert!(points, i, midpoint)
		end
	end
end

# ╔═╡ 3b64b5ea-d488-4092-ad65-f4f692df53c6
function start_circle(radius, n_init_points)
	angles = sort(rand(n_init_points)*2pi)
	
	[Point(radius*cos(a), radius*sin(a)) for a in angles]
end

# ╔═╡ 542a45f3-cdee-4724-bf77-e2178b0fe8fb
function start_sinusoid(size, n_init_points)
	xs = sort(rand(n_init_points)*2pi)
	
	[Point(size*(x-pi), size*sin(x)) for x in xs]
end

# ╔═╡ 4fd4ddd5-7a1c-454f-938b-328205aa63dd
function start_line(size, n_init_points)
	xs = sort(rand(n_init_points)*size)
	
	[Point(x, x + rand()/10) for x in xs]
end

# ╔═╡ 4e291e01-6601-4102-8038-6f082e0ffedd
@draw begin
	n_init_points = 40
	n_max_points = 10000
	n_steps = 4000
	draw_every = 30
	stepsize = 0.1
	farl = 40 # maximum distance to be considered 'far'
	nearl = 2 # maximum distance to be considered 'near'
	setline(0.1)
	
	result = []
	
	# points = start_circle(10, n_init_points)
	# points = start_sinusoid(20, n_init_points)
	points = start_line(20, n_init_points)
	fix_first_last = true # not circular: first and last point are fixed

	draw_points(points, fix_first_last)

	for i in 1:n_steps
		attraction_step(points, farl, nearl, stepsize, fix_first_last)
		if length(points) < n_max_points
			add_points(points, nearl, 0.001, fix_first_last)
		end
		if i % draw_every == 0
			draw_points(points, fix_first_last)
			append!(result, [points])
		end
	end
	draw_points(points, fix_first_last)
	append!(result, [points])	
end 2000 2000

# ╔═╡ Cell order:
# ╠═de5764b5-7203-41d5-94e1-438bcd8c75fb
# ╠═2ad11ff8-b8c8-11eb-1c46-f3babe900e58
# ╠═328c272f-4d85-4bb5-928a-8d95883498ba
# ╠═4b35feec-702d-402f-8015-5d77ea9a3b67
# ╠═9d425a51-74a4-416e-a61a-39da78af1649
# ╠═3b64b5ea-d488-4092-ad65-f4f692df53c6
# ╠═542a45f3-cdee-4724-bf77-e2178b0fe8fb
# ╠═4fd4ddd5-7a1c-454f-938b-328205aa63dd
# ╠═4e291e01-6601-4102-8038-6f082e0ffedd
