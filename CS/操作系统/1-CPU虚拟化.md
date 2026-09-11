# 进程——CPU 虚拟化

## 一个进程的内容

- 程序代码（text segment / code）
- 数据区（data segment）
- 堆（heap）
- 栈（stack）
- PCB（管理信息）
- 地址空间（virtual memory）
- 打开的文件
- 信号处理状态
- 其他内核资源

其中前四项是用户空间的内容，后四项是内核空间的内容

PCB（Process Control Block）是操作系统用来管理进程的核心数据结构，大概就长这样

```c
struct PCB {
    int pid;                 // 进程 ID
    int state;               // 进程状态 running / ready / blocked
    struct CPUContext regs;  // CPU 寄存器现场
    void *page_table;        // 页表地址
    int priority;            // 调度优先级
    struct PCB *next;        // 链表指针
    struct File *files[10];  // 打开的文件
    int exit_code;           // 退出状态
};
```

## 进程 API

以 Linux 为例，进程 API 主要有三个：

### fork

### exec

### wait