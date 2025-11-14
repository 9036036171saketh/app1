"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
const video = document.getElementById('video');
const canvas = document.getElementById('canvas');
const statsElement = document.getElementById('stats');
const ctx = canvas.getContext('2d', { willReadFrequently: true });
let lastTime = 0;
let frameCount = 0;
function setupCamera() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const stream = yield navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' } });
            video.srcObject = stream;
            // Programmatically play the video to ensure it starts
            video.play();
            video.addEventListener('playing', () => {
                canvas.width = video.videoWidth;
                canvas.height = video.videoHeight;
                requestAnimationFrame(processFrame);
            });
        }
        catch (err) {
            console.error("Error accessing camera: ", err);
            alert("Could not access the camera. Please ensure you have granted permission.");
        }
    });
}
function processFrame(now) {
    if (!ctx)
        return;
    // Calculate FPS
    const deltaTime = now - lastTime;
    lastTime = now;
    const fps = 1000 / deltaTime;
    frameCount++;
    if (frameCount % 15 === 0) {
        statsElement.innerText = `Resolution: ${video.videoWidth}x${video.videoHeight} | FPS: ${fps.toFixed(1)}`;
    }
    // Draw video frame to canvas
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const data = imageData.data;
    const grayData = new Uint8ClampedArray(data.length / 4);
    const edgeData = new Uint8ClampedArray(data.length);
    edgeData.fill(255); // Start with a white background
    // 1. Convert to grayscale
    for (let i = 0; i < data.length; i += 4) {
        const gray = data[i] * 0.21 + data[i + 1] * 0.71 + data[i + 2] * 0.07;
        grayData[i / 4] = gray;
    }
    // 2. Apply Sobel edge detection
    const width = canvas.width;
    const height = canvas.height;
    const threshold = 20; // Lowered threshold for more sensitivity
    const sobelX = [
        [-1, 0, 1],
        [-2, 0, 2],
        [-1, 0, 1]
    ];
    const sobelY = [
        [-1, -2, -1],
        [0, 0, 0],
        [1, 2, 1]
    ];
    for (let y = 1; y < height - 1; y++) {
        for (let x = 1; x < width - 1; x++) {
            let pixelX = 0;
            let pixelY = 0;
            for (let j = -1; j <= 1; j++) {
                for (let i = -1; i <= 1; i++) {
                    const pixel = grayData[(y + j) * width + (x + i)];
                    pixelX += pixel * sobelX[j + 1][i + 1];
                    pixelY += pixel * sobelY[j + 1][i + 1];
                }
            }
            const magnitude = Math.sqrt(pixelX * pixelX + pixelY * pixelY);
            if (magnitude > threshold) {
                const outputIndex = (y * width + x) * 4;
                edgeData[outputIndex] = 0;
                edgeData[outputIndex + 1] = 0;
                edgeData[outputIndex + 2] = 0;
            }
        }
    }
    imageData.data.set(edgeData);
    ctx.putImageData(imageData, 0, 0);
    requestAnimationFrame(processFrame);
}
document.addEventListener('DOMContentLoaded', setupCamera);
