# GarminBlendWatchFace
Garmin watchface example that shows color interpolation. It uses linear RGB interpolation, but with the ability to specify a middle color to imitate HSL style colorspace.
Supporting HSV / HSL directly would not be optimal for performance because of the calculations required to convert between colorspaces.
Hopefully someone will find this code useful and come up with some interesting uses, e.g. changing the color of a battery icon based on charge %, progress bars, etc.

![image](https://github.com/MrJacquers/GarminBlendWatchFace/assets/84329887/33c9c8de-bb27-428c-ab0b-d3df4d2cfa37)

![image](https://github.com/MrJacquers/GarminBlendWatchFace/assets/84329887/66bfe60f-1b23-4f36-aa13-a01ce52c49f6)

![image](https://github.com/MrJacquers/GarminBlendWatchFace/assets/84329887/839850d6-8ecd-4992-a1a3-478cfb557f9a)

![image](https://github.com/MrJacquers/GarminBlendWatchFace/assets/84329887/4263e8bf-a081-43a6-84d4-b2b8d7d505fa)

This site is useful to see how different colorspaces interpolate and finding a middle color:https://colordesigner.io/gradient-generator

![image](https://github.com/MrJacquers/GarminBlendWatchFace/assets/84329887/a50b3c5b-1da0-4b5f-a39f-d69466f6107d)
