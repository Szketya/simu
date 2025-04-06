# simu

### Installation Guide for SkyDefender Simulations panels

**Step 1: Setting up the `Scripts` folder**

- **If you do not use any other program that requires the `Export.lua` file (e.g., SRS, Helios):**  
  Copy the contents of the `lua scripts` folder into the following directory:  
  `C:/Users/(your username)/Saved Games/DCS/Scripts`

- **If you do use such programs:**  
  1. Only copy the `[YourPanelName].lua` and `SDSsocket.lua` files into the directory:  
     `C:/Users/(your username)/Saved Games/DCS/Scripts`
  2. Navigate to the same directory (`C:/Users/(your username)/Saved Games/DCS/Scripts`) and open the `Export.lua` file in a text editor.  
  3. Add the following code snippet to the **end of the file**:  

     pcall(function()
         dofile(lfs.writedir()..[[Scripts\SDSsocket.lua]])
     end)
    

---

**Step 2: Configuring the correct COM port**

1. Open the **Device Manager** (search for "Device Manager" in the Start menu).  
2. Expand the **Ports (COM & LPT)** section and locate the panel (Arduino Pro Micro).  
3. Right-click on the panel in the Device Manager entry and select **Properties**.  
4. In the **Port Settings** tab, click the **Advanced** button.  
5. In the newly opened window, set the COM port number to **COM5** from the dropdown menu (even if COM5 is marked as "in use").  

---

**Step 3: Restart your computer**  
To ensure all settings are applied, restart your computer.  

---

**Step 4: Run the server application**  
Navigate to the **server** folder and run the `serproxy.exe` file.  

---

**Step 5: Launch DCS**  
Start Digital Combat Simulator (DCS) as usual.  

---

**Step 6: Enjoy the game!**  
Your SkyDef Sim panel is now ready to use. Dive into the action and have fun!
