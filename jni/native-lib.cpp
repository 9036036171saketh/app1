#include <jni.h>
#include <string>
#include <android/log.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#define LOG_TAG "NativeLib"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)

extern "C" JNIEXPORT jstring JNICALL
Java_com_flamapp_rnd_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Hello from C++";
    LOGD("JNI function called successfully.");
    return env->NewStringUTF(hello.c_str());
}


extern "C" JNIEXPORT void JNICALL
Java_com_flamapp_rnd_gl_CameraRenderer_processFrame(
        JNIEnv *env,
        jobject,
        jint texIn,
        jint width,
        jint height) {

    if (width == 0 || height == 0) {
        return;
    }

    // 1. Read pixels from the input texture
    cv::Mat rgba(height, width, CV_8UC4);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, rgba.data);

    // 2. Process with OpenCV
    cv::Mat gray;
    cv::cvtColor(rgba, gray, cv::COLOR_RGBA2GRAY);

    cv::Mat edges;
    cv::Canny(gray, edges, 100, 200);

    // 3. Convert edges back to RGBA to upload to texture
    cv::Mat edges_rgba;
    cv::cvtColor(edges, edges_rgba, cv::COLOR_GRAY2RGBA);

    // 4. Upload the processed data back to the texture
    glBindTexture(GL_TEXTURE_2D, texIn);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, edges_rgba.data);
}