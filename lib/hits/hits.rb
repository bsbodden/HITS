module Hits

  class Hits
    
    attr_reader :authority_scores
    attr_reader :hub_scores

    def initialize(graph, use_weights = true)
      @graph = graph
      @use_weights = use_weights
      @hub_scores = {}
      @authority_scores = {}
      @graph.each_vertex do |vertex|
        @hub_scores[vertex] = 1.0
        @authority_scores[vertex] = 1.0
      end
    end
    
    def compute_hits(iterations = 25)
      (1..iterations).each do
        @graph.each_vertex do |vertex|
          authority_score = @graph.in_links(vertex).inject(0.0) { |sum, vertex| sum + @hub_scores[vertex] } if @graph.in_links(vertex)
          hub_score = @graph.out_links(vertex).inject(0.0) { |sum, vertex| sum + @authority_scores[vertex] } if @graph.out_links(vertex)
          @authority_scores[vertex] = authority_score || 0.0
          @hub_scores[vertex] = hub_score || 0.0
        end
        normalize_scores
      end
      apply_weighting if @use_weights
    end
    
    def top_hub_scores(how_many=5)
      @hub_scores.sort_by { |k,v| v }.map { |v| v[0] }.reverse.first(how_many)
    end
    
    def top_authority_scores(how_many=5)
      @authority_scores.sort_by { |k,v| v }.map { |v| v[0] }.reverse.first(how_many)
    end
    
    private 
    
    def normalize_scores
      sum_of_squares_for_authorities = @authority_scores.inject(0.0) { |sum, element| sum + element[1]**2 }
      sum_of_squares_for_hubs = @hub_scores.inject(0.0) { |sum, element| sum + element[1]**2 }
      @authority_scores.each { |key, value| @authority_scores[key] = value / sum_of_squares_for_authorities }
      @hub_scores.each { |key, value| @hub_scores[key] = value / sum_of_squares_for_hubs }
    end
    
    def apply_weighting
      sum = @graph.weights.inject(0.0) { |sum, weight| sum + weight } 
      max = @graph.max_weight
      min = @graph.min_weight
      @graph.each_vertex do |vertex|
        @authority_scores[vertex] = (@authority_scores[vertex] / sum) * (max - min) + min
        @hub_scores[vertex] = (@hub_scores[vertex] / sum) * (max - min) + min       
      end
    end

  end
     
end