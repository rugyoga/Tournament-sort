def quicksort(container)
  bottom, top = [], []
  top[0] = 0
  bottom[0] = container.size
  i = 0
  while i >= 0 do
    l = top[i]
    r = bottom[i] - 1;
    if l < r
      pivot = container[l]
      while l < r do
        r -= 1 while (container[r] >= pivot && l < r)
        if (l < r)
          container[l] = container[r]
          l += 1
        end
        l += 1 while (container[l] <= pivot && l < r)
        if (l < r)
          container[r] = container[l]
          r -= 1
        end
      end
      container[l] = pivot
      top[i+1] = l + 1
      bottom[i+1] = bottom[i]
      bottom[i] = l
      i += 1
    else
      i -= 1
    end
  end
  container
end