= 基础算法
== 排序
快速排序
```cpp
void quick_sort(int q[], int l, int r) {
  if (l >= r) return;
  int i = l - 1, j = r + 1, x = q[(l + r) >> 1];
  // 随机选取q，用双指针法将将小于q的数放在q的左边，将大于q的数放在q右边
  while (i < j) {
    do i++; while (q[i] < x);
    do j--; while (q[j] > x);
    if (i < j) swap(q[i], q[j]);
  }
  // 递归完成两个区间
  quick_sort(q, l, j), quick_sort(q, j + 1, r);
}
```
归并排序
```cpp
void merge_sort(int q[], int l, int r) {
  static int tmp[1000000]; // 临时数组
  if (l >= r) return;
  int mid = (l + r) >> 1;
  // 递归成两个区间直到区间长度为1
  merge_sort(q, l, mid);
  merge_sort(q, mid + 1, r);
  // 合并区间
  int k = 0, i = l, j = mid + 1;
  while (i <= mid && j <= r)
    if (q[i] <= q[j]) tmp[k ++ ] = q[i ++ ];
    else tmp[k ++ ] = q[j ++ ];

  while (i <= mid) tmp[k ++ ] = q[i ++ ];
  while (j <= r) tmp[k ++ ] = q[j ++ ];

  for (i = l, j = 0; i <= r; i ++, j ++ ) q[i] = tmp[j];
}
```
== 二分查找

寻找第一个满足 check 的值
```cpp
int bsearch_1(int l, int r) { 
  while (l < r) {
    int mid = (l + r) >> 1;
    if (check(mid)) r = mid;
    else l = mid + 1;
  }
  return l;
}
```
寻找最后一个满足 check 的值
```cpp
int bsearch_2(int l, int r) {
  while (l < r) {
    int mid = (l + r + 1) >> 1;
    if (check(mid)) l = mid;
    else r = mid - 1;
  }
  return l;
}
```
== 高精度

```cpp
// 高精加
vector<int> add(vector<int> &A, vector<int> &B) {
  if (A.size() < B.size()) return add(B, A);

  vector<int> C;
  int t = 0;
  for (int i = 0; i < A.size(); i++ ) {
    t += A[i];
    if (i < B.size()) t += B[i];
    C.push_back(t % 10);
    t /= 10;
  }

  if (t) C.push_back(t);
  return C;
}
// 高精减
vector<int> sub(vector<int> &A, vector<int> &B) {
  vector<int> C;
  for (int i = 0, t = 0; i < A.size(); i++ ) {
    t = A[i] - t;
    if (i < B.size()) t -= B[i];
    C.push_back((t + 10) % 10);
    if (t < 0) t = -1;
    else t = 0;
  }

  while (C.size() > 1 && C.back() == 0) C.pop_back();
  return C;
}
// 高精乘低精
vector<int> mul(vector<int> &A, int b) {
  vector<int> C;

  int t = 0;
  for (int i = 0; i < A.size() || t; i ++ ) {
    if (i < A.size()) t += A[i] * b;
    C.push_back(t % 10);
    t /= 10;
  }

  while (C.size() > 1 && C.back() == 0) C.pop_back();

  return C;
}
// 高精除低精
vector<int> div(vector<int> &A, int b, int &r) {
  vector<int> C;
  r = 0;
  for (int i = A.size() - 1; i >= 0; i -- ) {
    r = r * 10 + A[i];
    C.push_back(r / b);
    r %= b;
  }
  reverse(C.begin(), C.end());
  while (C.size() > 1 && C.back() == 0) C.pop_back();
  return C;
}
```
== 位运算
返回 x 的最低位 1 包括后面的 0
```cpp
int lowbit(int x) {
  return x & -x;
}
```

== 贪心
=== 区间问题
\
*区间选点*

给定 n 个区间，取数量最少的点使得每一个区间内至少有一个点，输出最少点数

+ 将每个区间按右端点从小到大排序
+ 从小到大枚举区间
  + 如果当前区间已经包含点，跳过
  + 否则，选择当前区间的右端点

*区间选择*

给定 n 个区间，要求选择最多的区间使得这些区间两两之间没有交集，求选择的数量最大

+ 将每个区间按右端点从小到大排序
+ 从左到右枚举区间
  + 如果该区间的左端点大于上一次选择区间的右端点，加入

*区间分组*

给定 n 个区间，将这些区间分成若干组使得组内部的区间没有交集且组数最少，也就是说有交集的区间一定要分在不同的组内，输出最少组数

+ 将所有区间按左端点从小到大排序
+ 从前往后枚举区间，每次判断是否能放入现有的组（判断该区间左端点是否大于组的右端点）
  + 如果可以则放入（更新组的右端点）
  + 如果不行则新开组

*区间覆盖*

给定 n 个区间和一个额外的区间 $[l, r]$，在 n 个区间中选择尽量少的区间将这个额外区间完全覆盖，输出最少区间数

+ 将区间按照左端点从小到大排序
+ 从前往后枚举区间，在所有能覆盖 $l$ 的区间中选一个右端点最大的，然后将 $l$ 更新为该区间的右端点