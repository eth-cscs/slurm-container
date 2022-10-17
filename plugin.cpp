#include <optional>
#include <string>

#include <err.h>
#include <libmount/libmount.h>
#include <linux/loop.h>
#include <sched.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/types.h>

extern "C" {
#include <slurm/spank.h>
}

//
// Forward declare the implementation of the plugin callbacks.
//

namespace impl {
    int slurm_spank_init(spank_t sp, int ac, char **av);
    int slurm_spank_init_post_opt(spank_t sp, int ac, char **av);
    int slurm_spank_exit(spank_t sp, int ac, char **av);
} // namespace impl

//
// Implement the SPANK plugin C interface.
//

extern "C" {
    extern const char plugin_name [] = "example";
    extern const char plugin_type [] = "spank";
    extern const unsigned int plugin_version = SLURM_VERSION_NUMBER;

    // Called from both srun and slurmd.
    int slurm_spank_init(spank_t sp, int ac, char **av) {
        return impl::slurm_spank_init(sp, ac, av);
    }

    int slurm_spank_init_post_opt(spank_t sp, int ac, char **av) {
        return impl::slurm_spank_init_post_opt(sp, ac, av);
    }

    int slurm_spank_exit(spank_t sp, int ac, char **av) {
        return impl::slurm_spank_exit(sp, ac, av);
    }
} // extern "C"

//
// Implementation
//

namespace impl {

    int slurm_spank_init(spank_t sp, int ac, char **av) {
        slurm_spank_log("In slurm_spank_init()");
        return ESPANK_SUCCESS;
    }

    int slurm_spank_init_post_opt(spank_t sp, int ac, char **av) {
        slurm_spank_log("In slurm_spank_init_post_opt()");
        return ESPANK_SUCCESS;
    }

    int slurm_spank_exit(spank_t sp, int ac, char **av) {
        slurm_spank_log("In slurm_spank_exit()");
        return ESPANK_SUCCESS;
    }

} // namespace impl

