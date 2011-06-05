/*
 * Copyright (C) 2006-2008 Google. All Rights Reserved.
 * Amit Singh <singh@>
 */

/*
 * Keep the probes defined here in sync with the dummy ones in GMDTrace.h
 */

provider fuse4x_objc {
    probe delegate__entry(char*);
    probe delegate__return(int);
};

#pragma D attributes Evolving/Evolving/Common provider fuse4x_objc provider
#pragma D attributes Evolving/Evolving/Common provider fuse4x_objc module
#pragma D attributes Evolving/Evolving/Common provider fuse4x_objc function
#pragma D attributes Evolving/Evolving/Common provider fuse4x_objc name
#pragma D attributes Evolving/Evolving/Common provider fuse4x_objc args
