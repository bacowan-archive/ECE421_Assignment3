require './ParallelMergeSort.rb'

a = [54,34,56,101,67,87,90,3,654,67,98,90,2,36,87,234,567,890,753,125,127,567,432,243]
#a = [1,5,3,2,0]
sorter = ParaMergeSort.new(a)
puts sorter.pMergeSort(0,a.size-1).getArray