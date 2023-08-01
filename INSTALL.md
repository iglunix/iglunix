# Iglunix Installation Guide

## Getting an installation image
The easiest way is to download the latest github actions artifact from
[iglunix-autobuild](https://github.com/iglunix/iglunix-autobuild/actions).
The artifcat is labled "boot-disk" and will download a zip containing the
image which can we writen to a USB stick. Currently only x86_64 images
are provided to save on CI time but aarch64 and riscv64 images will be
provided in the future.

## Running the installer
Type `installer`, press enter and follow the guided prompts carefully.

WARNING: you can easily end up deleting data that you might not want to.
We recomend removing and backing up any important data on the target machine.
