# How to Use secureboot_nobara.sh



## Steps

1. **Save the Script**
   - Open a terminal and run:
     ```bash
     nano secureboot_nobara.sh
     ```
   - Paste the script content.
   - Press `Ctrl+O` (to save), `Enter` (to confirm), then `Ctrl+X` (to exit).

2. **Make the Script Executable**
   ```bash
   chmod +x secureboot_nobara.sh
   ```

3. **Run the Script as Root**
   ```bash
   sudo ./secureboot_nobara.sh
   ```

4. **Follow On-Screen Instructions**
   - Set a password for MOK enrollment (make sure to remember it!).

5. **Reboot After the Script Completes**

6. **Enroll the MOK**
   - During boot, the MOK Manager (blue screen) will appear.
   - Choose **Enroll MOK** and enter the password you set.

7. **Verify Secure Boot**
   - After rebooting, check Secure Boot status:
     ```bash
     mokutil --sb-state
    ```
 - Output should state: `SecureBoot enabled`  
---

   - > **⚠️ Warning & Important Notes**
> - If you get errors, ensure `shim` and `grub2-efi` are installed:
>   ```bash
>   sudo dnf install shim grub2-efi-x64
>   ```
> - If Secure Boot still fails, you may need to disable it in BIOS temporarily.
> - This script assumes Nobara uses the Fedora EFI path: `/boot/efi/EFI/fedora/`. If your system uses a different path, adjust the script accordingly!

