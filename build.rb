#!/usr/bin/env ruby
# Possible flags are:
#   --debug       this builds distribuition with debug flags enabled
#   --root DIR    install the binary into this directory. If this flag is not set - the script
#                 redeploys kext to local machine and restarts it
#   --clean       clean before build

CWD = File.dirname(__FILE__)
FRAMEWORKS_DIR = '/Library/Frameworks/'
Dir.chdir(CWD)

debug = ARGV.include?('--debug')
clean = ARGV.include?('--clean')
root_dir = ARGV.index('--root') ? ARGV[ARGV.index('--root') + 1] : nil

abort("root directory #{root_dir} does not exist") if ARGV.index('--root') and not File.exists?(root_dir)

system('git clean -xdf') if clean

configuration = debug ? 'Debug' : 'Release'
system("xcodebuild -parallelizeTargets -configuration #{configuration} -alltargets") or abort("cannot build kext")

install_path = root_dir ? File.join(root_dir, FRAMEWORKS_DIR) : FRAMEWORKS_DIR
system("sudo mkdir -p #{install_path}") if root_dir

system("sudo cp -R build/#{configuration}/Fuse4X.framework #{install_path}") or abort


# TODO:
# Framework should use dylib/header files from root_dir
# Copy debug symbols?
# Copy project template
# Generate docmentation and put it both to distibution and the site
