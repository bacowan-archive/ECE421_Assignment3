
require 'timeout'
require './ParallelMergeSort.rb'

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
def unlimited_Sort(my_list,duration,&block)

  #preconditions
  raise 'Items to sort must implement .each' unless my_list.respond_to?(:each)

  if(not block.nil?)
    my_list2 = Array.new
    my_list.each{|element| my_list2.push(MyDecorator.new(element,block)) }
    #my_list = my_list2
  end

  result = my_list
  begin
    sorter = ParaMergeSort.new(my_list2)
    status = Timeout::timeout(duration,MyTimeOutException){
      sorter.pMergeSort(0,my_list.size-1)
    }
  rescue MyTimeOutException
      puts 'time ran out'
  ensure
    if sorter.getArray[0].is_a?(MyDecorator)
      finalList = Array.new
      sorter.getArray.each{|element| finalList.push(element.getObject) }
    else
      finalList = sorter.getArray
    end
    return finalList
  end
end

things = [54,34,56,101,67,87,90,3,654,67,98,90,2,36,87,234,567,890,753,125,127,567,432,243]
#things = [1,1,2]

def makeDec(obj,&block)
  return MyDecorator.new(obj,block)
end

z = makeDec(1){|a,b| b <=> a}
q = makeDec(12){|a,b| b <=> a}
s = makeDec(2){|a,b| b <=> a}

puts unlimited_Sort(things,10000){|a,b| b <=> a}