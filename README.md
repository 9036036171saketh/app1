# Flamapp AI - Real-Time Edge Detection Viewer

This project is a technical assessment for the RnD Intern position at Flamapp.AI. It implements a real-time edge detection viewer for Android, processing camera frames with OpenCV in C++ and rendering them with OpenGL ES. It also includes a minimal web-based viewer using TypeScript.

## Features Implemented

### Android
-  Real-time camera feed capture using `CameraX`.
-  Frame processing via JNI to a native C++ layer.
-  Canny Edge Detection using OpenCV in C++.
-  Real-time rendering of processed frames using OpenGL ES.
-  (Bonus) FPS counter for performance monitoring.

### Web
- Minimal web page built with TypeScript and HTML.
- Displays a static, pre-processed sample frame.
- Displays mock frame statistics (e.g., resolution, FPS).

---

## Screenshots & GIFs



**Android App in Action:**
<img width="1440" height="900" alt="Screenshot 2025-11-14 at 2 03 49 AM" src="https://github.com/user-attachments/assets/1a014fc0-d192-4dd0-a41b-c5b233b4b60e" />



**Web Viewer:**

<img width="1440" height="900" alt="Screenshot 2025-11-14 at 2 07 28 AM" src="https://github.com/user-attachments/assets/577023b8-44ad-4071-91c8-4954abc8c255" />

---

##  Setup Instructions

### Prerequisites
- Android Studio with NDK (Native Development Kit) installed.
- OpenCV for Android SDK.

### Steps
1.  **Clone the repository:**
    ```bash
    git clone <your-repo-link>
    cd <repo-directory>
    ```
2.  **Configure OpenCV:**
    - Download the [OpenCV Android SDK](https://opencv.org/releases/).
    - Place the extracted SDK into a known directory.
    - Create a `local.properties` file in the project's root directory and add the following line, replacing `/path/to/your/OpenCV-android-sdk` with the actual path:
      ```
      opencv.dir=/path/to/your/OpenCV-android-sdk/sdk
      ```
3.  **Build and Run Android App:**
    - Open the project in Android Studio.
    - Let Gradle sync and build the project.
    - Run the `app` configuration on a connected Android device or emulator.

4.  **Run the Web Viewer:**
    - Navigate to the `web` directory.
    - Compile the TypeScript file:
      ```bash
      tsc
      ```
    - Open the `index.html` file in your web browser.

---

##  Architecture Explained

### Frame Flow (Android)
1.  **Camera Capture:** The `CameraX` API is used to capture frames from the device's camera efficiently. These frames are directed to a `SurfaceTexture`.
2.  **OpenGL Texture:** The `SurfaceTexture` is attached to an OpenGL ES texture. This allows the camera frames to be directly accessible by the GPU.
3.  **JNI Bridge:** For each frame, a call is made through the Java Native Interface (JNI) to a C++ function. The OpenGL texture ID is passed to the native layer.
4.  **OpenCV Processing:** In C++, the frame (represented by the texture) is processed using OpenCV's Canny edge detection algorithm. The processing happens in place or on a secondary texture.
5.  **OpenGL Rendering:** The final processed texture is rendered onto a simple 2D quad that fills the screen, using a custom GLSL shader.

### TypeScript Part (Web)
The web viewer is a minimal, standalone single-page application.
-   **`index.html`**: Contains the basic structure, including an `<img>` tag for the processed frame and a `<div>` for stats.
-   **`src/main.ts`**: A TypeScript file responsible for:
    -   Loading a static base64 encoded or image file representing a processed frame.
    -   Updating the `src` of the `<img>` tag.
    -   Displaying mock hardcoded frame statistics (e.g., "Resolution: 1280x720", "FPS: ~15").
    -   It is compiled to plain JavaScript using `tsc`.
