# GCC

记录了适用于算法竞赛的 GCC 编译器的一些特性和用法

## __int128

分为 `__int128` 和 `unsigned __int128` 两种类型，分别表示有符号和无符号的 128 位整数，最大值约为 1.7e38 和 3.4e38，但需要手动实现输入输出函数。

```C++
// 输入__int128
void scan(__int128 &x) {
    x = 0;
    int f = 1;
    char ch;
    if((ch = getchar()) == '-') f = -f;
    else x = x * 10 + ch-'0';
    while((ch = getchar()) >= '0' && ch <= '9')
        x = x * 10 + ch-'0';
    x *= f;
}
// 输出__int128
void print(__int128 x) {
    if(x < 0) {
        x = -x;
        putchar('-');
    }
    if(x > 9) print(x / 10);
    putchar(x % 10 + '0');
}
```

## PBDS 库

全称 Policy Based Data Structures，是 GNU C++ 标准库的一个扩展，提供了一些基于平衡树的数据结构，如 `tree` 和 `priority_queue`，支持快速的插入、删除和查询操作，常用于算法竞赛中。

### tree

一个基于红黑树实现的有序集合，需要包含如下头文件和命名空间

```C++
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
```

定义一个 `tree` 类型的变量繁多

```C++
typedef tree<
    int,                    // Key: 存储的元素类型
    null_type,              // Mapped: 映射类型。如果是 set 写 null_type，如果是 map 写映射值类型
    std::less<int>,         // Compare: 比较规则
    rb_tree_tag,            // Tag: 树的类型
    tree_order_statistics_node_update // Policy: 核心！节点更新策略，支持排名查询
> os;
```

如果要定义一个类 `multiset` 的数据结构建议将类型改为 `pair<int, int>`，并将第二位作为计数器

`tree` 的增删查改和 `set` 类似，另外还支持两个特殊操作：

```C++
os.insert(x);    // 插入元素 x
os.erase(x);     // 删除元素 x
os.find_by_order(k); // 返回第 k 小的元素的迭代器，k 从 0 开始
os.order_of_key(x);  // 返回集合中严格小于 x 的元素个数
```

下面给一个常用的模板

```C++
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;

typedef tree<int, null_type, std::less<int>, rb_tree_tag,
          tree_order_statistics_node_update> ordered_set;
ordered_set s;

s.size() - s.order_of_key(x + 1);  // 返回集合中大于等于 x 的元素个数
s.order_of_key(x);                 // 返回集合中严格小于 x 的元素个数
s.find_by_order(k);                // 返回第 k 小的元素的迭代器，从 0 开始
```

