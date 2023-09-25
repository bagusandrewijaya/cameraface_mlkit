# face_camera
THIS CODE REFERENCE FROM 
https://github.com/Conezi/face_camera


| Name                  | Type                    | Description                                                                   |
|-----------------------|-------------------------|-------------------------------------------------------------------------------|
| onCapture             | Function(File?)         | callback invoked when camera captured image                                   |
| onFaceDetected        | Function(DetectedFace?) | callback invoked when camera detects face                                     |
| imageResolution       | ImageResolution         | used this to set image resolution                                             |
| defaultCameraLens     | CameraLens              | used this to set initial camera lens direction                                |
| defaultFlashMode      | CameraFlashMode         | used this to set initial flash mode                                           |
| enableAudio           | bool                    | set false to disable capture sound                                            |
| autoCapture           | bool                    | set true to capture image on face detected                                    |
| showControls          | bool                    | set false to hide all controls                                                |
| showCaptureControl    | bool                    | set false to hide capture control icon                                        |
| showFlashControl      | bool                    | set false to hide flash control control icon                                  |
| showCameraLensControl | bool                    | set false to hide camera lens control icon                                    |
| message               | String                  | use this pass a message above the camera                                      |
| messageStyle          | TextStyle               | style applied to the message widget                                           |
| orientation           | CameraOrientation       | use this to lock camera orientation                                           |
| captureControlIcon    | Widget                  | use this to render a custom widget for capture control                        |
| lensControlIcon       | Widget                  | use this to render a custom widget for camera lens control                    |
| flashControlBuilder   | FlashControlBuilder     | use this to build custom widgets for flash control based on camera flash mode |
| messageBuilder        | MessageBuilder          | use this to build custom messages based on face position                      |
| indicatorShape        | IndicatorShape          | use this to change the shape of the face indicator                            |
| indicatorAssetImage   | String                  | use this to pass an asset image when IndicatorShape is set to image           |
| indicatorBuilder      | IndicatorBuilder        | use this to build custom widgets for the face indicator                       |

### Contributions
---  

Contributions of any kind are more than welcome! Feel free to fork and improve `face_camera` in any way you want, make a pull request, or open an issue.

### Support the Library
---  

You can support the library by liking it on pub, staring in on Github and reporting any bugs you encounter.
