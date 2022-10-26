import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt
from scipy import fftpack
import os

# Read files from the wavy folder
file_list = os.listdir('wavy/')


for files in file_list:

    img = cv.imread(f"wavy\\{files}", cv.IMREAD_GRAYSCALE)


    f = np.fft.fft2(img)
    im_fft = fftpack.fft2(img)

    # Can be used to shift high frequency to the middle
    # im_fft = np.fft.fftshift(f)


    def plot_spectrum(im_fft):
        from matplotlib.colors import LogNorm
        # A logarithmic colormap
        plt.imshow(np.abs(im_fft), norm=LogNorm(vmin=5))
        plt.colorbar()


    # plt.figure()
    # plot_spectrum(im_fft)
    # plt.title('Fourier transform')
    # plt.show()

    # Call ff a copy of the original transform. Numpy arrays have a copy
    # method for this purpose.
    im_fft2 = im_fft.copy()

    # Crop unwanted frequency
    im_fft2[1: 200 , : 700] = 0

    # Show the cropped magnitude spectrum
    plt.figure()
    plot_spectrum(im_fft2)
    plt.title('Filtered Spectrum')
    plt.show()

    # Reconstruct the denoised image from the filtered spectrum, keep only the
    # real part for display.
    im_new = fftpack.ifft2(im_fft2).real

    fig = plt.figure()
    ax1 = fig.add_subplot(1, 2, 1)
    ax1.imshow(img, plt.cm.gray)
    plt.title('Original Image')

    ax2 = fig.add_subplot(1, 2, 2)
    ax2.imshow(im_new, plt.cm.gray)
    plt.title('Reconstructed Image')
    plt.show()

