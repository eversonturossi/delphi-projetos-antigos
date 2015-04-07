procedure UnMinimizeAll; 
//
// Restaura a minimização de todas as janelas do windows
//
begin 
  keybd_event(VK_LWIN, MapvirtualKey(VK_LWIN, 0), 0, 0); 
  keybd_event(VK_SHIFT, MapvirtualKey(VK_SHIFT, 0), 0, 0); 
  keybd_event(Ord('M'), MapvirtualKey(Ord('M'), 0), 0, 0); 
  keybd_event(Ord('M'), MapvirtualKey(Ord('M'), 0), KEYEVENTF_KEYUP, 0); 
  keybd_event(VK_SHIFT, MapvirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0); 
  keybd_event(VK_LWIN, MapvirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0); 
end; 