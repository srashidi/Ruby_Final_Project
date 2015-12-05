require 'spec_helper'

describe Gameboard do

	before :each do
		@gameboard = Gameboard.new
	end

	it "returns a Gameboard object" do
		expect(@gameboard).to be_an_instance_of Gameboard
	end

	describe "#spaces" do

		it "returns an array of all coordinates on the Gameboard object" do
			expect(@gameboard.spaces).to eql [ [:A,1],[:A,2],[:A,3],[:A,4],
																				 [:A,5],[:A,6],[:A,7],[:A,8],
																				 [:B,1],[:B,2],[:B,3],[:B,4],
																				 [:B,5],[:B,6],[:B,7],[:B,8],
																				 [:C,1],[:C,2],[:C,3],[:C,4],
																				 [:C,5],[:C,6],[:C,7],[:C,8],
																				 [:D,1],[:D,2],[:D,3],[:D,4],
																				 [:D,5],[:D,6],[:D,7],[:D,8],
																				 [:E,1],[:E,2],[:E,3],[:E,4],
																				 [:E,5],[:E,6],[:E,7],[:E,8],
																				 [:F,1],[:F,2],[:F,3],[:F,4],
																				 [:F,5],[:F,6],[:F,7],[:F,8],
																				 [:G,1],[:G,2],[:G,3],[:G,4],
																				 [:G,5],[:G,6],[:G,7],[:G,8],
																				 [:H,1],[:H,2],[:H,3],[:H,4],
																				 [:H,5],[:H,6],[:H,7],[:H,8], ]
		end

	end

	describe "#occupied_spaces" do

		it "returns an empty array" do
			expect(@gameboard.occupied_spaces).to be_an_instance_of Array
			expect(@gameboard.occupied_spaces).to be_empty
		end

	end

end