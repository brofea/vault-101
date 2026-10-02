= 字符串
== KMP

伪代码
- 输入主串s，模式串p，改为下标从1开始
- 计算next数组。i是模式串的指针，每次循环计算next[i]的值，j可以理解为当前已经匹配的字符数量
  - 每当失配时，指针就跳转到next[j]的位置，下标从1开始，略过next[j]个字符，所以直接匹配了j个字符
  - 匹配成功，则匹配成功的字符数量+1
  - 记录匹配成功的字符数量
- KMP算法。i是主串的指针，j+1是模式串的指针，j也可以理解为当前已经匹配的字符数量
  - 每当失配时，j+1就跳转到next[j]+1的位置继续匹配，也相当于略过next[j]个字符
  - 匹配成功，则匹配成功的字符数量+1，模式串指针后移
  - 如果匹配数量等于模式串长度，说明匹配成功
    - 匹配成功后可以进行一些操作，例如输出匹配成功的位置
    - i-lenp+1 是匹配成功开始的位置，i 是匹配成功结束的位置
```cpp
// 返回模式串的 next 数组
vector<int> get_next(const string& p) {
    vector<int> nxt(p.size());
    for (int i = 1, j = 0; i < p.size(); ++i) {
        while (j && p[i] != p[j]) j = nxt[j - 1];
        if (p[i] == p[j]) ++j;
        nxt[i] = j;
    }
    return nxt;
}
// 返回模式串 p 在文本串 s 中所有匹配位置，下标从 0 开始
vector<int> kmp(const string& s, const string& p) {
    vector<int> nxt = get_next(p), res;
    if (p.empty()) return res;

    for (int i = 0, j = 0; i < s.size(); ++i) {
        while (j && s[i] != p[j]) j = nxt[j - 1];
        if (s[i] == p[j]) ++j;
        if (j == p.size()) {
            res.push_back(i - p.size() + 1);
            j = nxt[j - 1];
        }
    }
    return res;
}
```
== 字典树 Trie
```cpp  
int son[N][26], cnt[N], idx;
// 0号点既是根节点，又是空节点
// son[][]存储树中每个节点的子节点，cnt[]存储以每个节点结尾的单词数量
// 插入一个字符串
void insert(char *str) {
    in p = 0;
    for (int i = 0; str[i]; i++) {
        int u = str[i] - 'a';
        if (!son[p][u])
            son[p][u] = ++idx;
        p = son[p][u];
    }
    cnt[p]++;
}
// 查询字符串出现的次数
int query(char *str) {
    int p = 0;
    for (int i = 0; str[i]; i++) {
        int u = str[i] - 'a';
        if (!son[p][u])
            return 0;
        p = son[p][u];
    }
    return cnt[p];
}
```
== AC自动机
insert 所有模式串，调用 build 然后 find 文本串，返回匹配数量
```cpp
struct Trie {  // Trie树
    int son[26], cnt, fail;
} tr[N];
int tot = 0;
// 插入模式串
inline void insert(const string &s) {
    int u = 0;
    for (int i = 0; s[i]; i++) {
        int v = s[i] - 'a';
        if (!tr[u].son[v])
            tr[u].son[v] = ++tot;
        u = tr[u].son[v];
    }
    tr[u].cnt++;
}
void build() {  // 构建fail边
    queue<int> q;
    for (int v = 0; v < 26; v++) {
        int c = tr[0].son[v];
        if (c) {
            tr[c].fail = 0;
            q.push(c);
        }
    }
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        int f = tr[u].fail;
        for (int v = 0; v < 26; v++) {
            int c = tr[u].son[v];
            if (c) {
                tr[c].fail = tr[f].son[v];
                q.push(c);
            } else
                tr[u].son[v] = tr[f].son[v];
        }
    }
}
// 计算模式串在文本串中出现的次数
inline int find(const string &s) {
    int u = 0, sum = 0;
    for (int i = 0; s[i]; i++) {
        int v = s[i] - 'a';
        int c = tr[u].son[v];
        while (c && tr[c].cnt != -1) {
            sum += tr[c].cnt;
            tr[c].cnt = -1;
            c = tr[c].fail;
        }
        u = tr[u].son[v];
    }
    return sum;
}
```

== Manacher

求字符串的最长回文子串长度

```cpp
char a[N], b[N];
int p[N * 2], n;
// a[]为原串，b[]为插入'#'后的新串
// p[i]表示以b[i]为中心的回文串半径
void init() {
    n = strlen(a);
    int k = 0;
    b[k++] = '$', b[k++] = '#';
    for (int i = 0; i < n; i++)
        b[k++] = a[i], b[k++] = '#';
    b[k++] = '^';
    n = k;
}
void manacher() {
    int mr = 0, mid;
    for (int i = 1; i < n; i++) {
        if (i < mr)
            p[i] = min(p[mid * 2 - i], mr - i);
        else
            p[i] = 1;
        while (b[i - p[i]] == b[i + p[i]])
            p[i]++;
        if (i + p[i] > mr) {
            mr = i + p[i];
            mid = i;
        }
    }
}
// 最长回文串长度
*max_element(p, p + n) - 1
```