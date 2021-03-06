  ▄   ▄
 ▄██▄▄██▄          ╔╗ ┌─┐┌┐┌┌─┐█
 ███▀██▀██         ╠╩╗├─┤│││├┤ █
 ▀███████▀         ╚═╝┴ ┴┘└┘└─┘█
   ▀███████▄▄      ▀▀▀▀▀▀▀▀▀▀▀▀█▀
    ██████████▄    I look better in monospace
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█▀

Thanks for considering these shaders for
your use!

To use the shader in the Camera folder, 
simply apply the ScanlineCameraShader 
script to the camera. 
From there, drag the ScanlineCamera 
material into the Post Process Mat slot.
Lastly, enable the shader.
You are free to change the values on the 
material as you see fit. 

To use the shader in the Material folder,
create a Unity plane that is a child of
your Camera. 
Ensure its transforms are 
zeroed out, then rotate the plane on the X
axis to -90. You may need to move the 
plane on the Z axis until your camera can 
see it.
Apply the ScanlineMaterial material to the
plane, and that's it. 
Again, you are free to change the values
on the material as you see fit. 
Instead of creating a new plane, there is
one provided in the prefab folder, along
with a pre-made camera prefab with the 
plane already attached. 

If for some reason the texture is not
applied to the material automatically, you
can simply drag in the Scanlines texture
from the root folder of this package.