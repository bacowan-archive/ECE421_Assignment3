require './ParallelMergeSort.rb'

a = [2,2,1]
sorter = ParaMergeSort.new(a)
puts sorter.pMergeSort(0,a.size-1).getArray