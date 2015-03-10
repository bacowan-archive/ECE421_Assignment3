
require 'timeout'
require_relative './ParallelMergeSort.rb'

class MyTimeOutException < Exception
end

class MyDecorator
  include Comparable
  @myObject
  @block
  def initialize(object,block)
    @myObject = object
    @block = block
  end
  def <=>(other)
    @block.call(@myObject,other.getObject)
  end
  def getObject
    return @myObject
  end
end

module Sorter
  def unlimited_Sort(my_list,duration,&block)

    #preconditions
    raise 'Items to sort must implement .each' unless my_list.respond_to?(:each)

    if(not block.nil?)
      my_list2 = Array.new
      my_list.each{|element| my_list2.push(MyDecorator.new(element,block)) }
    else
      my_list2 = my_list
    end

    result = my_list
    begin
      sorter = ParaMergeSort.new(my_list2)
      status = Timeout::timeout(duration,MyTimeOutException){
        sorter.pMergeSort(0,my_list.size-1)
      }
    rescue MyTimeOutException
      puts 'time ran out'
    end
    if sorter.getArray[0].is_a?(MyDecorator)
      finalList = Array.new
      sorter.getArray.each{|element| finalList.push(element.getObject) }
    else
      finalList = sorter.getArray
    end
    return finalList
  end
end