import cv2
import matplotlib.pyplot as plt


def main():
    x1 = 260
    x2 = 1180
    y1 = 340
    y2 = 1270
    # Slice the image 16 times based on the coordinate
    for row in range(0, 4):
        if  row != 0:
            y1 += 1168
            y2 += 1168

        for column in range(0, 4):
            if column != 0:
                x1 += 1240
                x2 += 1240

            # Display the threshold result
            print("The row:", row + 1)
            print("The column:", column + 1)
            image_result(x1, x2, y1, y2)

            if column == 3:
                x1 = 260
                x2 = 1180

        if row == 3:
            y1 = 340
            y2 = 1270


def image_result(x1, x2, y1, y2):
    img = cv2.imread('photo1.png', 0)
    slicedImage = img[y1:y2, x1:x2]
    
    # Can apply blur here
    # slicedImage = cv2.GaussianBlur(slicedImage, (5, 5), 0)
    # slicedImage = cv2.medianBlur(slicedImage, 7)
    # slicedImage = cv2.bilateralFilter(slicedImage, 9, 75, 75)

    # Diff type of threshold 
    ret, thresh1 = cv2.threshold(slicedImage, 127, 255, cv2.THRESH_BINARY)
    ret, thresh2 = cv2.threshold(slicedImage, 127, 255, cv2.THRESH_BINARY_INV)
    ret, thresh3 = cv2.threshold(slicedImage, 127, 255, cv2.THRESH_TRUNC)
    ret, thresh4 = cv2.threshold(slicedImage, 127, 255, cv2.THRESH_TOZERO)
    ret, thresh5 = cv2.threshold(slicedImage, 127, 255, cv2.THRESH_TOZERO_INV)
    thresh6 = cv2.adaptiveThreshold(slicedImage, 255, cv2.ADAPTIVE_THRESH_MEAN_C, \
                                cv2.THRESH_BINARY, 11, 2)
    thresh7 = cv2.adaptiveThreshold(slicedImage, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, \
                                cv2.THRESH_BINARY, 11, 2)
    ret, thresh8 = cv2.threshold(slicedImage,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)

    titles = ['Original Image', 'BINARY', 'BINARY_INV', 'TRUNC', 'TOZERO', 'TOZERO_INV',
              'Adaptive Mean Thresholding', 'Adaptive Gaussian Thresholding', 'OTSU']
    images = [slicedImage, thresh1, thresh2, thresh3, thresh4, thresh5, thresh6, thresh7, thresh8]

    for i in range(9):
        plt.subplot(3, 3, i + 1), plt.imshow(images[i], 'gray')
        plt.title(titles[i])
        plt.xticks([]), plt.yticks([])

    plt.show()
    cv2.waitKey(0)
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()