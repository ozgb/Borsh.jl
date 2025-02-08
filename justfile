export JULIA_LOAD_PATH := x'$PWD/dev:${JULIA_LOAD_PATH:-}'

test:
    #!/usr/bin/env -S julia --project=.
    using Pkg;
    Pkg.test()

format:
    #!/usr/bin/env -S julia --project=.
    using JuliaFormatter
    result = format(".", verbose=true, overwrite=true)
    exit(Int(!result))
