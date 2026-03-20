int bsearch_1(int l, int r) 
{ // 寻找第一个满足 check 的值
  while (l < r) {
    int mid = (l + r) >> 1;
    if (check(mid))
      r = mid;
    else
      l = mid + 1;
  }
  return l;
}