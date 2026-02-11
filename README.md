# Lab: Computer Organization

* **Screen Configuration:** `640x480` pixels, 32-bit `ARGB` format.
* **Register `X0`:** Contains the base address of the FrameBuffer (Pixel 0).
* **Task Logic:** The code for each assignment is written in the `app.s` file.
* **Initialization:** The `start.s` file handles the FrameBuffer initialization and calls `app.s` upon completion.
* **Implementation:** The code renders an image composed of simple polygons on the screen.

## Project Structure

* **[app.s](app.s)**: Contains the application logic. All hardware is pre-initialized before this file runs.
* **[start.s](start.s)**: Handles the hardware initialization process.
* **[Makefile](Makefile)**: Script defining how to build the software (specifies the assembler, output formats, etc.).
* **[memmap](memmap)**: Linker script describing the program's memory layout and section placement.
* **README.md**: This file.

## Usage

The `Makefile` contains all the necessary rules to build the project. You may use additional **.s** files if needed to organize your code; the Makefile is configured to assemble them.

**To run the project, execute:**

```bash
$ make run

```

This will build the source code and launch the QEMU emulator.

## Requirements

On Ubuntu/Debian-based systems, you can install the dependencies using:

1. **AARCH64 TOOLCHAIN**
    ```bash
    $ sudo apt install gcc-aarch64-linux-gnu

    ```


2. **QEMU ARM**
    ```bash
    $ sudo apt install qemu-system-arm

    ```


3. **Install AARCH GDB**
    ```bash
    $ sudo apt install gdb-multiarch

    ```


4. **OPTIONAL: GDB "Friendly" Configuration**
    ```bash
    $ wget -P ~ git.io/.gdbinit

    ```