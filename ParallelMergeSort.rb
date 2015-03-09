module ParaMergeSort
  def pMerge(left,right)
    if left == nil
      return right
    elsif right == nil
      return left
    end
    returnArray = Array.new(left.size + right.size)
    thread_pool = Array.new
    if right.size > left.size
      thread_pool.push(Thread.new{returnArray = pMerge(right,left)})
      thread_pool.each{|thread| thread.join}
    elsif right.size + left.size == 1
      returnArray[0] = left[0]
    elsif left.size == 1
      if left[0] <= right[0]
        returnArray[0] = left[0]
        returnArray[1] = right[0]
      else
        returnArray[0] = right[0]
        returnArray[1] = left[0]
      end
    elsif left.size == 0
      returnArray = []
    else
      # find j with binary search such that B[j] <= A[l/2] <= B[j+1]
      j = getMiddle(left,right)
      lMerged = []
      rMerged = []
      if j != nil # there exists a j that satisfies the conditions
        thread_pool <<
            Thread.new{
              lMerged = pMerge(left[0..(left.size/2-1)],
                               right[0..j]
              )
            }

        thread_pool <<
            Thread.new{
              rMerged = pMerge(left[(left.size/2)..left.size-1],
                               right[j+1..right.size-1]
              )
            }

      else # there is no such j that satisfies the condition. Try looking at it from the other directions
        k = getMiddle(right,left)
        if k != nil
          thread_pool <<
              Thread.new{
                lMerged = pMerge(right[0..(right.size/2-1)],
                                 left[0..k]
                )
              }

          thread_pool <<
              Thread.new{
                rMerged = pMerge(right[(right.size/2)..right.size-1],
                                 left[k+1..left.size-1]
                )
              }
        elsif left.size == 0 or right.size == 0 or left[0] > right[0] # they are already sorted, and either right is bigger than left, or vice versa
          lMerged = right
          rMerged = left
        else
          lMerged = left
          rMerged = right
        end
      end
      thread_pool.each{|thread| thread.join}
      returnArray = lMerged + rMerged
    end

    return returnArray
  end

  def pMergeSort(array,low,high)
    result = Array.new
    thread_pool = Array.new
    left = []
    right = []
    if low < high
      mid = ((low + high) / 2 ).floor

      thread_pool << Thread.new{left = pMergeSort(array,low,mid)}
      thread_pool << Thread.new{right = pMergeSort(array,mid + 1,high)}
      thread_pool.each{|thread|thread.join}
      result = pMerge(left, right)
    else
      result << array[low]
    end
    return result
  end

  def getMiddle(left,right)
    begin
      return right.index{|e| e <= left[left.size/2-1] && right[right.index(e)+1] != nil && left[left.size/2-1] <= right[right.index(e)+1]}
    rescue
      return nil
    end
  end
end