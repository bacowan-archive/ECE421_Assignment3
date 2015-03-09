require './ParallelMergeSort.rb'
include ParaMergeSort
a = [54,56,67,87,90,654,67,98,90,2,36,87]
puts pMergeSort(a,0,a.size-1)