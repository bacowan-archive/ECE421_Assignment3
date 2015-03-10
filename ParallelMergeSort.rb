class ParaMergeSort

  def initialize(array)
    @array = array
  end

  def pMerge(left,right,from,to)
    if left == nil or left.size == 0
      @array[from..to] = right
      return
    elsif right == nil or right.size == 0
      @array[from..to] = left
      return
    end
    #returnArray = Array.new(left.size + right.size)
    thread_pool = Array.new
    if right.size > left.size
      thread_pool.push(Thread.new{pMerge(right,left,from,to)})
      thread_pool.each{|thread| thread.join}
    elsif from == to
      @array[from] = left[0]
    elsif left.size == 1
      if left[0] <= right[0]
        @array[from] = left[0]
        @array[to] = right[0]
      else
        @array[from] = right[0]
        @array[to] = left[0]
      end
    #elsif left.size == 0
    #  returnArray = []
    else
      # find j with binary search such that B[j] <= A[l/2] <= B[j+1]
      j = getMiddle(left,right)
      #lMerged = []
      #rMerged = []
      if j != nil # there exists a j that satisfies the conditions
        a = 1
        thread_pool <<
            Thread.new{
              pMerge(left[0..((left.size-1)/2)],
                               right[0..j],
                               from,
                               from+(left.size-1)/2+j+1
              )
            }

        thread_pool <<
            Thread.new{
              pMerge(left[((left.size-1)/2+1)..left.size-1],
                               right[j+1..right.size-1],
                               from+(left.size-1)/2+j+1+1,
                               to
              )
            }

      else # there is no such j that satisfies the condition. Try looking at it from the other directions
        k = getMiddle(right,left)
        if k != nil
          a  = 1
          thread_pool <<
              Thread.new{
                pMerge(right[0..((right.size-1)/2)],
                                 left[0..k],
                                 from,
                                 from+(right.size-1)/2+k+1
                )
              }

          thread_pool <<
              Thread.new{
                pMerge(right[((right.size-1)/2+1)..right.size-1],
                                 left[k+1..left.size-1],
                                 from+(right.size-1)/2+k+1+1,
                                 to
                )
              }
        elsif left.size == 0 or right.size == 0 or left[0] > right[0] # they are already sorted, and either right is bigger than left, or vice versa
          @array[from..from+right.size-1] = right
          @array[from+right.size..to] = left
          #lMerged = right
          #rMerged = left
        else
          @array[from..from+left.size-1] = left
          @array[from+left.size..to] = right
          #lMerged = left
          #rMerged = right
        end
      end
      thread_pool.each{|thread| thread.join}
      fromTo = @array[from..to]
      toFrom = true
      return true
      #@array[from..to] = lMerged + rMerged
    end
  end

  def pMergeSort(low,high)
    result = Array.new
    thread_pool = Array.new
    left = []
    right = []
    if low < high
      mid = ((low + high) / 2 ).floor

      thread_pool << Thread.new{pMergeSort(low,mid)}
      thread_pool << Thread.new{pMergeSort(mid + 1,high)}
      thread_pool.each{|thread|thread.join}
      pMerge(@array[low..mid],@array[mid+1..high],low,high)
    end
    fromTo = @array[low..high]
    return self
  end

  def getMiddle(left,right)
    begin
      return right.index{|e| e <= left[(left.size-1)/2] && right[right.index(e)+1] != nil && left[(left.size-1)/2] <= right[right.index(e)+1]}
    rescue
      return nil
    end
  end

  def getArray
    return @array
  end
end