
# Lab Demos

This repository is just a collection of the demonstrations presented in lab, where applicable and/or useful.

Copyright Puh P

## Sub-Directories

Each subdirectory is its own demonstration and should contain all files needed for that demo. Use the Makefile inside to run building commands.

Students won't need to use the Makefile at the root of this repository. It's just for me. Feel free to study it for your own learning.

### libPuhfessorP.so

Some subdirectory demos make use of the libPuhfessorP shared object. However, those shared objects are setup to be ignored by git. Therefore, a simple clone of this repository might not work as-is.

You'll find each demo utilizing libPuhfessorP.so has a symlink inside that points to *libPuhfessorP.so* at the root of this repository. In turn, *libPuhfessorP.so* at the root of this repository is actually just another symlink which points to a specific version of that library.

It is that specific version that should be downloaded and placed at the root of this repository for the demos to work. For example, at the time of this writing the latest SO file is *libPuhfessorP.v0.11.2.so*, which can be downloaded from the [Deploy Repository](TODO). You may download older versions of the SO by sifting through the list of commits.

## Git Tags

You may notice this repository also contains "git tags". You can view them with the following command:

```console
$ git tag
```

Git tags allow you to assign human-readable labels to specific commits in the repository. Usually, a tag might look like *v1.12.6*. In this class, we'll use git tags that correspond to the date we did something in lab, so you can better see the power of git with respect to looking back on the state of your repository at a previous point in time.

For example, suppose we had lab on September 9th, 2021 and you see there is a tag labeled `2021-09-02`. If you'd like to see what this repo looked like on that day, you can use the following command:

```console
$ git checkout 2021-09-02
```

When you are finished, get back to the current state by checking out the master branch with:

```console
$ git checkout master
```

## Topics Covered

This section contains topics that were already covered, as a reminder to myself.

* Basic pure assembly program w/ message output

## Topics to Cover

This section contains some future topics that will be covered if time permits.

* TBD

### Unfinished Demos

The following demos still have things left (notes are inside their sub-folders):

* Nada








