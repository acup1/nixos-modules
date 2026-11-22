-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
  hl.exec_cmd("bluetoothctl power off")
  if dmsEnabled then
    hl.exec_cmd("dms run")
  end
  if iioEnabled then
    hl.exec_cmd("iio-hyprland")
  end
end)
