# gluster-changelog-parser

A tool to parse Gluster Changelogs and display in human readable format for easy read and debugging.

Input format:

```
GlusterFS Changelog | version: v1.2 | encoding : 2
Ed38f2230-dfb3-41ad-bb0a-a0e823cab858^@23^@33188^@0^@0^@00000000-0000-0000-0000-000000000001/f3^@Dd38f2230-dfb3-41ad-bb0a-a0e823cab858^@Ed38f2230-dfb3-41ad-bb0a-a0e823cab858^@8^@00000000-0000-0000-0000-000000000001/f3^@00000000-0000-0000-0000-000000000001/f4^@
```

Converted format:

```
E d38f2230-dfb3-41ad-bb0a-a0e823cab858 CREATE   33188 0 0 00000000-0000-0000-0000-000000000001/f3
D d38f2230-dfb3-41ad-bb0a-a0e823cab858 
E d38f2230-dfb3-41ad-bb0a-a0e823cab858 RENAME   00000000-0000-0000-0000-000000000001/f3 00000000-0000-0000-0000-000000000001/f4
```

# Install

Download the binary from the releases page.

```
wget https://github.com/aravindavk/gluster-changelog-parser/releases/download/0.1.1/gluster-changelog-parser-0.1.1-linux-x86_64.tar.xz
tar xvf gluster-changelog-parser-0.1.1-linux-x86_64.tar.xz

# Copy to /usr/local/bin or any other directory which is available in environment variable `PATH`
cp gluster-changelog-parser /usr/local/bin/
```

## Usage

```
cd <brickpath>/.glusterfs/changelogs
gluster-changelog-parser <changelog-file-name>
```

For example,

```
cd /exports/bricks/gv1/brick1/brick/.glusterfs/changelogs
gluster-changelog-parser CHANGELOG.1511530728
```
