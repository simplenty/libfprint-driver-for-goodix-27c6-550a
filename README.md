## Installing the Goodix Fingerprint Driver (27c6:550a) on Debian 13

This guide details how to install the Goodix fingerprint sensor driver (ID 27c6:550a) on **Debian 13 (Trixie)**, a common component found in many Dell and Lenovo laptops. Since this sensor is not supported by the standard `libfprint` package, we'll use a specific driver package provided by Lenovo, along with its required dependencies from Ubuntu's Launchpad.

### 1\. Check Your Device ID

Before you begin, verify that your fingerprint sensor's device ID matches the one this guide addresses. Open your terminal and run the `lsusb` command.

```bash
$ lsusb
...
Bus 003 Device 004: ID 27c6:550a Shenzhen Goodix Technology Co.,Ltd. FingerPrint
...
```

If you see `27c6:550a` in the output, you can proceed.

### 2\. Obtain the Required Packages

The Goodix driver package, **`libfprint-2-tod-goodix_amd64.deb`**, is provided by Lenovo. While it's designed for a specific ThinkPad model, it can be used on other devices with the same sensor.

  * You can download the package directly from Lenovo's website: [Goodix FingerPrint Driver for Linux - ThinkPad E14 Gen 4, E15 Gen 4](https://support.lenovo.com/us/en/downloads/ds560884-goodix-fingerprint-driver-for-linux-thinkpad-e14-gen-4-e15-gen-4).

Because this driver relies on a special **Touch-Only Device (TOD)** version of `libfprint` that isn't available in Debian's official repositories, you'll need to download two additional dependency packages from Ubuntu's Launchpad:

  * **`libfprint-2-tod1.deb`**: This is the core TOD library. Get it from [libfprint-2-tod1 1:1.94.7+tod1-0ubuntu5\~24.04.4 (amd64 binary) in ubuntu noble](https://launchpad.net/ubuntu/noble/amd64/libfprint-2-tod1/1:1.94.7+tod1-0ubuntu5~24.04.4).
  * **`libfprint-2-2_1.94.9+tod1-1_amd64.deb`**: This is the main `libfprint` package with TOD support. Find it here: [libfprint 1:1.94.9+tod1-1 source package in Ubuntu](https://launchpad.net/ubuntu/+source/libfprint/1:1.94.9+tod1-1).

**Note: these packages have been prepared in this repository, you can download them in the releases page.**

### 3\. Install the Packages

Start by installing the dependency packages, followed by the Goodix driver itself. This order is crucial to satisfy the dependencies correctly.

First, install the TOD libraries:

```bash
sudo dpkg -i libfprint-2-tod1_1.94.7+tod1-0ubuntu5~24.04.4_amd64.deb
sudo dpkg -i libfprint-2-2_1.94.9+tod1-1_amd64.deb
```

Next, install the Goodix driver package you downloaded. This driver acts as the bridge between your specific hardware and the `libfprint` framework.

```bash
sudo dpkg -i libfprint-2-tod-goodix_amd64.deb
```

### 4\. Install Fingerprint Service and PAM Module

With the core driver and libraries in place, you can now install the remaining software components needed for fingerprint authentication.

  * **`fprintd`**: This is the daemon that manages fingerprint operations and provides a standard interface for other applications.
  * **`libpam-fprintd`**: This is the Pluggable Authentication Module (PAM) that integrates fingerprint authentication with system login and other services.

Install both packages using `apt`:

```bash
sudo apt install fprintd libpam-fprintd
```

### 5\. Enable Fingerprint Authentication

Finally, use the `pam-auth-update` utility to enable fingerprint authentication across your system. This tool simplifies the process of configuring PAM.

Run the following command in your terminal:

```bash
sudo pam-auth-update
```

A text-based interface will appear, allowing you to select **Fingerprint authentication**. Use the arrow keys and spacebar to select it, then press Enter to confirm.

After this step, your fingerprint sensor should be fully configured and ready to use for login and other system authentication tasks.
