struct radix_tree_root {
  unsigned int height;
  struct radix_tree_node __rcu *rnode;
};
radix_tree_insert:rcu_assign_pointer(root->rnode, item);
struct radix_tree_node {
  unsigned int height;
  void __rcu *slots[RADIX_TREE_MAP_SIZE];
};
radix_tree_insert:rcu_assign_pointer(node->slots[offset], item);
RADIX_TREE_MAP_SHIFT 6
RADIX_TREE_MAP_SIZE 64
RADIX_TREE_MAP_MASK (64-1)
RADIX_TREE_INDEX_BITS 32
RADIX_TREE_MAX_PATH 6
struct radix_tree_preload {
  int nr;
  struct radix_tree_node *nodes[6];
};
static unsigned long height_to_maxindex[7];
0
63	(0xFFFFFFFF >> 26)
4095	(0xFFFFFFFF >> 20)
262143
16777215
1073741823
4294967295
radix_tree_lookup
$ grep -n -R -i "radix" kernel/irq/*.c
alloc_desc
irq_desc_tree
radix_tree_lookup
request_threaded_irq
request_irq
$ grep -R "struct irq_chip" arch/x86/
