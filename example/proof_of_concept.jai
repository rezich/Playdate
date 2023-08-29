#run {
    w := compiler_create_workspace(name="Playdate");

    llvm: Llvm_Options;
    llvm.target_system_triple      = "arm-none-eabi";
    llvm.target_system_cpu         = "cortex-m7";
    llvm.enable_split_modules      = false;
    //llvm.target_system_features    = 
    llvm.output_bitcode            = true;

    opts := get_build_options(w);
    opts.backend                                = .LLVM;
    opts.output_type                            = .STATIC_LIBRARY;
    opts.os_target                              = .NONE;
    opts.llvm_options                           = llvm;
    opts.output_executable_name                 = "proof_of_concept";
    opts.backtrace_on_crash                     = .OFF;

    set_build_options(opts, w);
    set_build_options_dc(.{do_output=false});

    compiler_begin_intercept(w);
    add_build_file(tprint("%hello_world.jai", #filepath), w);
    compiler_end_intercept(w);
}


#import "Basic";
#import "Compiler";
