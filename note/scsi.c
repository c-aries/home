disk_map_sector_rcu ()
hd_struct 			/* one partition */
struct disk_part_tbl {
  struct hd_struct __rcu *lask_lookup; /* one partition */
  struct hd_struct __rcu *part[];
};
struct gendisk {
  struct disk_part_tbl __rcu *part_tbl; /* partition table */
};

kernel_thread_helper -> kthread_worker_fn -> kthread -> \
__do_softirq -> run_ksoftirqd -> __do_softirq -> blk_done_softirq -> \
scsi_softirq_done -> scsi_finish_command -> sici_io_sompletion -> scsi_next_command -> \
scsi_run_queue -> blk_run_queue -> _raw_spin_lock_irqsave -> notify_page_fault -> \
init_amd -> error_code -> notify_page_fault -> irq_to_desc -> ttwu_post_activation -> \
do_page_fault -> bad_area_nosemaphore -> no_context -> oops_end -> panic
