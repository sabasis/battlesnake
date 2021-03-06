class Snake
	attr_accessor :head, :body, :id, :health
	def initialize id:, coords:, health:
		@head = Coordinate.new(coords.first)
		@body = coords.collect{|c| Coordinate.new(c)}.drop(1)
		@id = id
		@health = health
	end

	def paintable_directions body_part

		directions = []

		# relevant x values
		x_values = [@head.x] + @body.select{|p|p.y==body_part.y}.collect(&:x)
		
		# relevant y values
		y_values = [@head.y] + @body.select{|p|p.x==body_part.x}.collect(&:y)
		
		unless x_values.include?(body_part.x-1) # left
			directions << "left"
		end

		unless x_values.include?(body_part.x+1) # right
			directions << "right"
		end

		unless y_values.include?(body_part.y-1) # up
			directions << "up"
		end

		unless y_values.include?(body_part.y+1) # down
			directions << "down"
		end

		if directions.include?("left") && directions.include?("up")
			directions << "leftup"
		end
		if directions.include?("left") && directions.include?("down")
			directions << "leftdown"
		end
		if directions.include?("right") && directions.include?("up")
			directions << "rightup"
		end
		if directions.include?("right") && directions.include?("down")
			directions << "rightdown"
		end

		return directions
	end

end