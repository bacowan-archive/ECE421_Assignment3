
require 'timeout'
require './ParallelMergeSort.rb'
include ParaMergeSort
class MyTimeOutException < Exception
end
def unlimited_Sort(my_list, duration)
  #preconditions
  raise 'Items to sort must implement .each' unless my_list.respond_to?(:each)
  raise 'Items to sort must implement <=>' unless my_list.each{|element| element.respond_to?(:<=>)}
  result = my_list
  begin
    status = Timeout::timeout(duration,MyTimeOutException){
      result = pMergeSort(my_list,0,my_list.size-1)
      return result
    }
  rescue MyTimeOutException
    puts 'rescued'
  end
  #return result
end

things = (1..1000000).to_a
puts things.size
puts unlimited_Sort(things,0.01)