import cv2
import numpy as np
import random as rng

rng.seed(12345)


# def draw_contour(image, c, i):
#     # compute the center of the contour area and draw a circle
#     # representing the center
#     M = cv2.moments(c)
#     cX = int(M["m10"] / M["m00"])
#     cY = int(M["m01"] / M["m00"])
#     # draw the contour number on the image
#     output_image = np.zeros((image.shape[0], image.shape[1], 3), dtype=np.uint8)
#     cv2.putText(output_image, "#{}".format(i + 1), (cX - 20, cY), cv2.FONT_HERSHEY_SIMPLEX,
#                 0.5, (255, 255, 255), 2)
#     # return the image with the contour number drawn on it
#     return output_image


def sort_contours(cnts, method="left-to-right"):
    # initialize the reverse flag and sort index
    reverse = False
    i = 0

    # handle if we need to sort in reverse
    if method == "right-to-left" or method == "bottom-to-top":
        reverse = True

    # handle if we are sorting against the y-coordinate rather than
    # the x-coordinate of the bounding box
    if method == "top-to-bottom" or method == "bottom-to-top":
        i = 1

    # construct the list of bounding boxes and sort them from top to
    # bottom
    boundingBoxes = [cv2.boundingRect(c) for c in cnts]
    (cnts, boundingBoxes) = zip(*sorted(zip(cnts, boundingBoxes),
                                        key=lambda b: b[1][i], reverse=reverse))

    # return the list of sorted contours and bounding boxes
    return (cnts)


def edge_detector(val, thresh1, sides):
    threshold = val


    if sides == 1:
        side = "Top"
    elif sides == 2:
        side = "Left"
    elif sides == 3:
        side = "Right"
    elif sides == 4:
        side = "Bottom"



    canny_output = cv2.Canny(thresh1, threshold, threshold * 2)

    # Bind rectangle to separate leads into 2 parts
    contours1, _ = cv2.findContours(thresh1, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    contours1_poly = [None] * len(contours1)
    boundRect1 = [None] * len(contours1)

    # Gets the x coordinate, y coordinate, width and height for the rectangle
    for j, c in enumerate(contours1):
        # Approximate a square to fit the contour
        contours1_poly[j] = cv2.approxPolyDP(c, 0, True)
        boundRect1[j] = cv2.boundingRect(contours1_poly[j])

        # Cuts the lead in half
        if sides == 1:
            thresh1[(boundRect1[j][1] + 39):(boundRect1[j][1] + 50),
            boundRect1[j][0]: int(boundRect1[j][0] + boundRect1[j][2])] = 0
            method = 'left-to-right'

        elif sides == 2:
            thresh1[(boundRect1[j][1]):(boundRect1[j][1] + boundRect1[j][3]),
            boundRect1[j][0] + 41: int(boundRect1[j][0] + 54)] = 0
            method = 'top-to-bottom'

        elif sides == 3:
            thresh1[(boundRect1[j][1]):(boundRect1[j][1] + boundRect1[j][3]),
            boundRect1[j][0] + 52: int(boundRect1[j][0] + 70)] = 0
            method = 'top-to-bottom'

        elif sides == 4:
            thresh1[(boundRect1[j][1] + 50):(boundRect1[j][1] + 70),
            boundRect1[j][0]: int(boundRect1[j][0] + boundRect1[j][2])] = 0
            method = 'left-to-right'

    cv2.imshow("After cut into half", thresh1)
    canny_output = cv2.Canny(thresh1, threshold, threshold * 2)
    cv2.imshow(f"Canny Edge Detection Row: {row + 1} Column: {column + 1} Side: {side} ", canny_output)

    # Find the contours
    contours, _ = cv2.findContours(canny_output, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    drawing = np.zeros((canny_output.shape[0], canny_output.shape[1], 3), dtype=np.uint8)

    # Sort contours
    contours = sort_contours(contours, method)

    contours_poly = [None] * len(contours)
    oldboundRect = [None] * len(contours)

    # Gets the x coordinate, y coordinate, width and height for the rectangle
    for i, c in enumerate(contours):
        # Approximate a square to fit the contour
        contours_poly[i] = cv2.approxPolyDP(c, 0, True)
        oldboundRect[i] = cv2.boundingRect(contours_poly[i])

        # area = cv2.contourArea(contours[i])
        # if area <= 100:
        #     continue

    for i in range(len(contours)):
        color = (rng.randint(0, 256), rng.randint(0, 256), rng.randint(0, 256))
        cv2.drawContours(drawing, contours_poly, i, color)
    cv2.imshow(f"Drawing Row: {row + 1} Column: {column + 1} Side: {side} ", drawing)

    boundRect = []

    for b in range(len(oldboundRect)):
        previous_x = oldboundRect[b - 1][0]
        previous_y = oldboundRect[b - 1][1]
        if oldboundRect[b][0] == oldboundRect[b - 1][0] and oldboundRect[b][1] == oldboundRect[b - 1][1] and \
                oldboundRect[b][2] == oldboundRect[b - 1][2] and oldboundRect[b - 1][3] == oldboundRect[b][3] \
                or (oldboundRect[b][2] <= 14 or oldboundRect[b][3] <= 14):
            continue
        boundRect.append(oldboundRect[b])

        # drawing = draw_contour(canny_output, c, i)
    pitch = []
    a = 1
    count = 1
    for i in range(len(boundRect)):
        # # Prevent labelling repetitive contour
        # previous_x = boundRect[i-1][0]
        # previous_y = boundRect[i-1][1]
        #
        # if boundRect[i][0] == previous_x and boundRect[i][1] == previous_y:
        #     continue

        height = boundRect[i][3]
        width = boundRect[i][2]

        print('-------------------------------------------------------------------------------------------------------')
        print("Lead no.", count)
        print(f"Height: {height} pixels")
        print(f"Width: {width} pixels ")
        print('-------------------------------------------------------------------------------------------------------')

        if 22 >= count > 2 and count % 2 == 0:
            if sides == 1 or sides == 4:
                first_edge = boundRect[i - 2][0] + boundRect[i - 2][2]
                second_edge = boundRect[i][0]
                result = second_edge - first_edge


            elif sides == 2 or sides == 3:
                first_edge = boundRect[i - 2][1] + boundRect[i - 2][3]
                second_edge = boundRect[i][1]
                result = second_edge - first_edge

            pitch.append(result)

        color = (rng.randint(0, 256), rng.randint(0, 256), rng.randint(0, 256))
        cv2.rectangle(drawing, (int(boundRect[i][0]), int(boundRect[i][1])),
                      (int(boundRect[i][0] + boundRect[i][2]), int(boundRect[i][1] + boundRect[i][3])), color, 2)

        # cv2.circle(drawing, (int(centers[i][0]), int(centers[i][1])), int(radius[i]), color, 2)

        count += 1

    for k in pitch:
        print(f"************** pitch {a} : {k} pixels ********************")
        print("\n")
        a += 1

    cv2.imshow(f'Contours Row: {row + 1} Column: {column + 1} Side: {side} ', drawing)


def preprocess_image(x1, x2, y1, y2, sides):
    img = cv2.imread('photo1.png', 0)
    slicedImage = img[y1:y2, x1:x2]
    slicedImage = cv2.medianBlur(slicedImage, 7)
    ret, thresh1 = cv2.threshold(slicedImage, 145, 255, cv2.THRESH_BINARY)

    # Erase all the noise and dust
    contours2, hierarchy = cv2.findContours(thresh1, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    max_threshold_blob_area = 300
    for i in range(1, len(contours2)):
        index_level = int(hierarchy[0][i][1])
        if index_level <= i:
            cnt = contours2[i]
            area = cv2.contourArea(cnt)

            if area <= max_threshold_blob_area:
                # Erase  small blobs
                cv2.drawContours(thresh1, [cnt], -1, 0, -1, 1)

    if sides == 1:
        side = "Top"
    elif sides == 2:
        side = "Left"
    elif sides == 3:
        side = "Right"
    elif sides == 4:
        side = "Bottom"

    source_window = f'Source Row: {row + 1} Column: {column + 1} Side: {side} '
    cv2.namedWindow(source_window)
    cv2.imshow(source_window, thresh1)
    thresh = 100
    edge_detector(thresh, thresh1, sides)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


# Code Starts here

# Slice the image 16 times based on the coordinate
for row in range(0, 4):
    if row != 0:
        y1 += 1168
        y2 += 1168

    for column in range(0, 4):
        # Display the threshold result
        print("$$$$$$$$$$$$$$$$$")
        print("The row:", row + 1)
        print("The column:", column + 1)
        print("$$$$$$$$$$$$$$$$$")

        for sides in range(1, 5):
            if sides == 1:  # Top
                print("Top")
                x1 = 260
                x2 = 1180
                y1 = 340
                y2 = 480
                if column != 0:
                    x1 += 1240
                    x2 += 1240

                    if row == 1 and column == 2:
                        y2 += 3

                    if row == 3 and column == 3:
                        y2 += 5



            # -------------------------------------------------------

            elif sides == 2:  # Left
                print("Left")
                x1 = 260
                x2 = 410
                y1 = 486
                y2 = 1084
                if column != 0:
                    x1 += 1240
                    x2 += 1240



            # -------------------------------------------------------

            elif sides == 3:  # Right
                print("Right")
                x1 = 1030
                x2 = 1195
                y1 = 489
                y2 = 1110
                if column != 0:
                    x1 += 1240
                    x2 += 1240



            # -------------------------------------------------------

            elif sides == 4:  # Bottom
                print("Bottom")
                x1 = 397
                x2 = 1195
                y1 = 1100
                y2 = 1269
                if column != 0:
                    x1 += 1240
                    x2 += 1240

            preprocess_image(x1, x2, y1, y2, sides)

    if column == 3:
        x1 = 260
        x2 = 1180

if row == 3:
    y1 = 340
    y2 = 480
