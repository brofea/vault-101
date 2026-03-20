= 技巧和STL

== 环境配置
VS Code 配置
+ 安装扩展：Chinese (Simplified)、C/C++、C/C++ Extension Pack、Code Runner、cph，选装：CodeLLDB、clangd
+ 设置编译和调试选项
 - 创建新 task.json 并在 arg 中加入 `"-std=c++17"` 和 `"-O2"`
 - 设置 Code Runner：启用 Run in Terminal 和 Save File Before Run
 - 设置 Code Runner：在 Excuter Map 中 cpp 键中添加 `-std=c++17 -O2`
 - 设置 cph：在 Cpp: Args 中添加 `-std=c++17 -O2`


== 基本语法

宏、关流和别名

```cpp
#define int long long                       // 小心使用
#define endl '\n'  

#define PII pair<int, int>
#define uset unordered_set
#define umap unordered_map
#define iter iterator
using uint = unsigned int; 
using ll = long long;

ios::sync_with_stdio(0);                    // 关闭 C++ & C 标准流同步
cin.tie(NULL);                              // 取消 cin 和其他流绑定
cout.tie(NULL);                             // 取消 cout 和其他流绑定
```

内建函数和常量

```cpp
__builtin_popcount(x)      // 计算 x 中 1 的个数
__builtin_ctz(x)           // 计算 x 末尾零的个数
__builtin_clz(x)           // 计算 x 前导零的个数，可用于获得最高位 1 的位置
__builtin_parity(x)        // 计算 x 中 1 的个数的奇偶性（返回 1 或 0）
__builtin_ffs(x)           // 返回 x 最低位的 1 的位置（从 1 开始计数）
                           // 上述函数在函数名后加 ll 即为 long long 版本
__INT_MAX__	               // int 最大值 2147483647
__LONG_LONG_MAX__	         // long long 最大值 9223372036854775807
                           // min 通常为 -max-1，如：
#define __INT_MIN__ (-__INT_MAX__ - 1)
```

初始化数组
```cpp
int arr[100];
vector<int> vec(100);

fill(arr, arr + 100, 1);           // 把所有元素设为 1
fill(vec.begin(), vec.end(), 1);   // 把所有元素设为 1
memset(arr, 0, sizeof(arr));       // 把所有字节设为 0
memset(arr, 0x3f, sizeof(arr));    // 把所有字节设为 0x3f3f3f3f
memset(arr, -1, sizeof(arr));      // 把所有字节设为 0xffffffff（仅限 int、short、ll）
```

输入输出
```cpp
cout << setfill('0') << left << setw(5) << a;   // 带填充的左对齐固定宽度（默认右）
cout << fixed << setprecision(3) << f;          // 设置小数点位数

cin >> n       
cin.ignore();                                   // cin 后使用 getline
getline(cin, s); 
scanf("%[^\n]", str);                           // 忽略空格输入字符数组
```
== STL 函数
常量和数学函数
```cpp
INT_MAX                                         // 2147483647  
INT_MIN                                         // -2147483648
LLONG_MAX                                       // 9223372036854775807
LLONG_MIN                                       // -9223372036854775808
DBL_MAX                                         // 1.79769e+308
DBL_MIN                                         // 2.22507e-308
M_PI                                            // 3.14159265358979323846
powl(a, b)                                      // pow 的 long double 版本
round(p, (1.0/n))                               // p 的 n 次方根
```
非方法 STL 函数
```cpp
shuffle(v.begin(), v.end(), std::default_random_engine());  // 随机打乱
copy(v.begin(), v.end(), dest.begin());                     // 复制区间内的元素到 dest
swap_ranges(v1.begin(), v1.end(), v2.begin());              // 交换等长区间内的元素
reverse(v.begin(), v.end());                                // 反转区间内的元素
replace(v.begin(), v.end(), a, b);                          // 替换区间内所有 a 为 b
replace_if(v.begin(), v.end(), pred, b);    // 替换满足 pred 条件的值为 b, pred 是 bool 函数

merge(a.begin(), a.end(), b.begin(), b.end(), result.begin());      // 合并两个有序区间
set_union(a.begin(), a.end(), b.begin(), b.end(), result.begin());          // 取并集
set_intersection(a.begin(), a.end(), b.begin(), b.end(), result.begin());   // 取交集
set_difference(a.begin(), a.end(), b.begin(), b.end(), result.begin());     // 取差集
// 上述四个函数都可在末尾增加 comp 参数，comp 是一个 bool 类型的比较函数

sort(v.begin(), v.end());                        // 升序
sort(v.begin(), v.end(), greater<int>());        // 降序
sort(v.begin(), v.end(), cmp);                   // 自定义排序，cmp 是一个 bool 类型的比较函数
stable_sort();              // 稳定排序，使用归并排序实现 O(nlogn)，用法同 sort
partial_sort(v.begin(), v.begin() + k, v.end()); // 将前 k 小的元素放在前面 O(nlogk)
is_sorted(v.begin(), v.end());                   // 判断是否为升序
is_sorted(w.begin(), w.end(), greater<int>());   // 判断是否为降序
is_sorted_until(v.begin(), v.end());             // 返回第一个不满足升序的迭代器

next_permutation(a.begin(), a.end()); // 下一个字典序排列，如果已是最大排列则返回 false O(n)
prev_permutation(a.begin(), a.end()); // 上一个字典序排列，如果已是最小排列则返回 false O(n)

auto it = find(v.begin(), v.end(), k);          // 查找值为 k 的元素，返回迭代器
auto it = find_if(v.begin(), v.end(), pred);          // 查找满足 pred 条件的元素，返回迭代器

it2 - it1                            // 计算两个迭代器之间的距离，仅用于 vector, deque, array
distance(it1, it2);                  // 计算两个迭代器之间的距离，可用于 list, set, map

*max_element(a, a + n)               // 返回数组最大值
*max_element(a.begin(), a.end())     // 返回vector最大值
// min_element 用法同上

// 排序后去重
sort(a.begin(), a.end());
a.erase(unique(a.begin(), a.end()), a.end());
// C风格排序后去重
sort(a, a + n);
n = unique(a, a + n) - a;


```
== STL 容器和方法

字符串
```cpp
uint find(string &s2, uint pos = 0);                // 正序查找子串
uint rfind(string &s2, uint pos = end);             // 反序查找子串
uint find_first_of(string &s2, uint pos = 0);       // 正序查找在 s2 中的字符
uint find_last_of(string &s2, uint pos = end);      // 反序查找在 s2 中的字符
uint find_first_not_of(string &s2, uint pos = 0);   // 正序查找不在 s2 中的字符
uint find_last_not_of(string &s2, uint pos = end);  // 反序查找不在 s2 中的字符
string& insert(uint pos, string &s2);               // 在 pos 位置插入 str
string& substr(uint pos = 0, uint len = npos)       // 返回 pos 开始长度为 len 的子串
string& erase(uint pos = 0, uint len = npos);       // 删除 pos 开始长度为 len 的子串
string& replace(uint pos, uint len1, string &s2);   // 替换 pos 开始长度为 len 的子串
string& insert(uint pos, uint repetitions, char c); // 在 pos 位置插入 repetitions 个 c
// 替换 pos 开始长度为 len 的子串为 repetitions 个 c
string& replace(uint pos, uint len1, uint repetitions, char c);
```

增删查改

```cpp
// 查找，注意 list 中为 O(n)
lower_bound(x)              // 返回第一个大于等于 x 的数的迭代器
upper_bound(x)              // 返回第一个大于 x 的数的迭代器

// set / multiset
it++, it--                   // 迭代器支持双向迭代
insert(int x)                     // 插入 x，返回 pair<iter, bool>，后者表示插入成功/已经存在
find(int x)                      // 查找 x，返回迭代器，没找到返回 end()
count(int x)                     // 返回 x 的个数
erase(int x)                     // 删除所有 x

// map/multimap
insert(PII x)                      // 插入键值对 x
erase(PII x)                       // 删除键值对 x
find(int x)                        // 查找键 x，返回迭代器，没找到返回 end()
// unordered 系类似，但不支持迭代器和二分查找
```

数据结构

```cpp
priority_queue<int, vector<int>, greater<int>>      // 小根堆
a.erase(unique(a.begin(), a.end()), a.end());       // 数组去重
```
== 复杂度
\
*空间复杂度 Tips*

- 64 MB 可以存 1e7 个 int

- 可以输出 `sizeof arr / 1024` 检查数组内存占用，单位是 KB


*用数据规模猜算法*

$n≤30$, 指数级别, dfs+剪枝，状态压缩dp

$n≤100 => O(n^3)$，floyd，dp，高斯消元

$n≤1000 => O(n^2)$，$O(n^2 log n)$，dp，二分，朴素版Dijkstra、朴素版Prim、Bellman-Ford

$n≤10000 => O(n sqrt(n))$，块状链表、分块、莫队

$n≤100000 => O(n log n)$ => 各种sort，线段树、树状数组、set/map、heap、拓扑排序、dijkstra+heap、prim+heap、Kruskal、spfa、求凸包、求半平面交、二分、CDQ分治、整体二分、后缀数组、树链剖分、动态树

$n≤1000000 => O(n)$, 以及常数较小的 $O(n log n)$ 算法 => 单调队列、 hash、双指针扫描、BFS、并查集，kmp、AC自动机，常数比较小的 $O(n log n)$ 的做法：sort、树状数组、heap、dijkstra、spfa

$n≤10000000 => O(n)$，双指针扫描、kmp、AC自动机、线性筛素数

$n≤10^9 => O( sqrt(n))$，判断质数

$n≤10^{18} => O( log n)$，最大公约数，快速幂，数位DP

$n≤10^{1000} => O(log^2 n)$，高精度加减乘除

$n≤10^{100000} => O(log k log log k)$，k表示位数，高精度加减、FFT/NTT
