#!/usr/bin/env ruby
# Copyright (c) 2011, Anatol Pomozov. All rights reserved.

# Possible flags are:
#   --release     this builds module for the final distribution
#   --root DIR    install the binary into this directory. If this flag is not set - the script
#                 redeploys kext to local machine and restarts it

CWD = File.dirname(__FILE__)
FRAMEWORKS_DIR = '/Library/Frameworks/'
Dir.chdir(CWD)

release = ARGV.include?('--release')
root_dir = ARGV.index('--root') ? ARGV[ARGV.index('--root') + 1] : nil

abort("root directory #{root_dir} does not exist") if ARGV.index('--root') and not File.exists?(root_dir)

system('git clean -xdf') if release

configuration = release ? 'Release' : 'Debug'
flags = '-configuration ' + configuration
if release then
  flags += ' MACOSX_DEPLOYMENT_TARGET=10.5'
else
  flags += ' ONLY_ACTIVE_ARCH=YES'
end

system("xcodebuild SYMROOT=build SHARED_PRECOMPS_DIR=build -PBXBuildsContinueAfterErrors=0 -parallelizeTargets -alltargets #{flags}") or abort("cannot build kext")

install_path = root_dir ? File.join(root_dir, FRAMEWORKS_DIR) : FRAMEWORKS_DIR
system("sudo mkdir -p #{install_path}") if root_dir

system("sudo cp -R build/#{configuration}/Fuse4X.framework #{install_path}") or abort

if release then
  system("cd #{install_path} && sudo ln -s Fuse4X.framework MacFUSE.framework") or abort
  system("cd #{install_path}/MacFUSE.framework/Versions/A/ && sudo ln -s Fuse4X MacFUSE") or abort
end

# TODO:
# Framework should use dylib/header files from root_dir
# Copy debug symbols?
# Copy project template
# Generate docmentation and put it both to distibution and the site
