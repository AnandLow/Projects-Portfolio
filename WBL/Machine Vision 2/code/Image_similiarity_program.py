import numpy as np
import sklearn.metrics
from sklearn.metrics import mean_squared_error
from skimage.metrics import structural_similarity
from math import sqrt
import imageio
import numpy as np
import os
import cv2
import glob
from PIL import Image
import csv
import re


def rmse(reference_volume, test_volume, common_range=True):
    if not common_range:
        reference_mean = np.mean(reference_volume)
        test_mean = np.mean(test_volume)
        # pull test_volume's dynamic range to be common with reference_volume
        test_volume = test_volume * reference_mean / test_mean
    reference_volume = np.ndarray.flatten(reference_volume)
    test_volume = np.ndarray.flatten(test_volume)
    return sqrt(mean_squared_error(reference_volume, test_volume))


def mi(reference_volume, test_volume, n_bins=256, common_range=True):
    """
    Compute the mutual information score between two volumes by assigning each voxel to a category by magnitude.
    reference_volume, test_volume : ndarrays containing the volumes to compare
    n_bins : an integer specifying the number of categories (bins) to create
    common_range : a boolean, if True, specifies to use the common minimum and maximum of both the reference and
                   test volumes
    """
    # bin each volume according to the requested number of bins and the the absolute or relative range selection
    reference_min = np.min(reference_volume)
    reference_max = np.max(reference_volume)
    test_min = np.min(test_volume)
    test_max = np.max(test_volume)
    if common_range:
        full_min = np.min([reference_min, test_min])
        full_max = np.max([reference_max, test_max])
        binning_range = full_max - full_min
        reference_bins = np.array((reference_volume - full_min) * (n_bins / binning_range), dtype=np.int)
        reference_bins = reference_bins.flatten()
        test_bins = np.array((test_volume - full_min) * (n_bins / binning_range), dtype=np.int)
        test_bins = test_bins.flatten()
    else:
        reference_binning_range = reference_max - reference_min
        reference_bins = np.array((reference_volume - reference_min) * (n_bins / reference_binning_range),
                                  dtype=np.int)
        reference_bins = reference_bins.flatten()
        test_binning_range = test_max - test_min
        test_bins = np.array((test_volume - test_min) * (n_bins / test_binning_range), dtype=np.int)
        test_bins = test_bins.flatten()
    mutual_information = sklearn.metrics.mutual_info_score(reference_bins, test_bins)
    return mutual_information


def ssim(reference_volume, test_volume):
    reference_volume = np.ndarray.flatten(reference_volume)
    test_volume = np.ndarray.flatten(test_volume)
    # return structural_similarity(reference_volume, test_volume, data_range=test_volume.max() - test_volume.min())
    # according to Rick's study, change the data_range to reference volume will provide consistent SSIM result regardless of magnitude
    return structural_similarity(reference_volume, test_volume, data_range=reference_volume.max() - reference_volume.min())

def write_csv(quality_list):
    with open('C:\\Users\\hong-ren.anand-low\\Documents\\image_quality.csv', mode  = 'a+') as quality_file:
        quality_writer = csv.writer(quality_file, delimiter =',', quotechar= '"', quoting = csv.QUOTE_MINIMAL)

        quality_writer.writerow(quality_list)

def title_csv():
    with open('C:\\Users\\hong-ren.anand-low\\Documents\\image_quality.csv', mode  = 'w') as title_file:
        title_writer = csv.writer(title_file, delimiter =',', quotechar= '"', quoting = csv.QUOTE_MINIMAL)
        title_writer.writerow(["count", "stepweight", "Delta T", "speed", "RMSE", "MI", "SSIM"])

def sorted_alphanumeric(data):
    convert = lambda text: int(text) if text.isdigit() else text.lower()
    alphanum_key = lambda key: [ convert(c) for c in re.split('([0-9]+)', key) ]
    return sorted(data, key=alphanum_key)

def load_images_from_folder(folder):
    # width = 91
    # height = 91
    # full_img_cum = np.zeros(shape=(height, width), dtype=int)
    # pixel_count_cum = np.zeros(shape=(height, width), dtype=int)
    # final_img = np.zeros(shape=(height, width), dtype=int)
    # full_img_temp = np.zeros(shape=(height, width), dtype=int)
    # pixel_count_temp = np.zeros(shape=(height, width), dtype=int)
    # img_stack = np.zeros(shape=(height, width), dtype=int)
    # cropped_img = np.zeros(shape=(height, width), dtype=int)
    #cropped_img = [[]]

    # --------------------------------------------------------------------
    # Vertical Image
    # test_img_vert = Image.open(folder + '\\reconstruction_plane_0.tiff')
    # print(test_img_vert.size)
    # half_width = int(test_img_vert.size[0] / 2 - 0.5 )
    # print(half_width)
    #
    #
    # arr =[]
    # count = 1
    # for filename in os.listdir(folder):
    #     if filename.endswith(".tiff"):
    #         count += 1
    #         # img = cv2.imread(folder + '\\' + filename, cv2.IMREAD_GRAYSCALE)
    #         img = Image.open(folder + '\\' + filename)
    #         numpy_img = np.array(img)
    #         cropped_img = numpy_img[:, : half_width]
    #         print(cropped_img)
    #         arr.append(cropped_img)
    # stacked_array = np.stack(arr)
    # print(stacked_array)

    # --------------------------------------------------------------------------------



    count = 1
    arr = []
    # filelist = os.listdir(folder)
    # filelist = filelist.sort()
    # print(f"filelist: {filelist}")

    for filename in sorted_alphanumeric(os.listdir(folder)):
        if filename.endswith(".tiff"):
            count += 1
            # img = cv2.imread(folder + '\\' + filename, cv2.IMREAD_GRAYSCALE)
            img = Image.open(folder + '\\' + filename)
            numpy_img = np.array(img)
            arr.append(numpy_img)

        else: continue
    stacked_array = np.stack(arr)



    return stacked_array

def main():
    # Reference volume
    sw_reference = "0.2"
    deltat_reference = "8.80e-9"
    speed_reference = "s1"
    region_id = "111" # run 30 already now 69
    reference_volume = load_images_from_folder(f"\\\\10.0.16.22\\g\\ReconstructionResult\\ScanningSpeedStudy\\WalkerPassM11\\G1\\{region_id}\\WalkerPass_M11_il2_{speed_reference}\\CBC\\{deltat_reference}\\revChambolle_295+ Non-Uni_CamByCam 3mm RRID{region_id} iter20 ROF {deltat_reference} -2.4639--1.1825mm sw{sw_reference} z0.011\\reconstruction\\tiff")

    # Test Volume
    stepweight = ["0.1", "0.2", "0.3", "0.4", "0.5", "0.6"]
    delta_t = [ "4.84e-8", "4.84e-9", "4.84e-10", "8.80e-7", "8.80e-8", "8.80e-9", "8.80e-10"]
    speed = ["s1", "s3", "s5"]

    title_csv()

    counting = 1

    for d in delta_t:
        for step in stepweight:
            test_volume = load_images_from_folder(
                f"\\\\10.0.16.22\\g\\ReconstructionResult\\ScanningSpeedStudy\\WalkerPassM11\\G1\\{region_id}\\WalkerPass_M11_il2_{speed_reference}\\CBC\\{d}\\revChambolle_295+ Non-Uni_CamByCam 3mm RRID{region_id} iter20 ROF {d} -2.4639--1.1825mm sw{step} z0.011\\reconstruction\\tiff")



            # Calculate and Display SSIM, MI and RMSE
            ssim_score = ssim(reference_volume, test_volume)
            mi_score = mi(reference_volume, test_volume)
            rms_error = rmse(reference_volume, test_volume, True)

            print(f"{counting}   Stepweight: {step}   Delta t: {d}  Speed: {speed_reference} ")
            print(f"ssim: {ssim_score} mi: {mi_score} rmse: {rms_error}")
            results = [counting, step, d,speed[0], rms_error, mi_score, ssim_score]

            # Write to CSV file
            write_csv(results)

            counting += 1




    # cv2.imshow("final image", average_pic)
    # cv2.waitKey(0)

    # ssim_score = ssim(reference_volume, test_volume)
    # print(ssim_score)

    # print(test_volume)
    # print(reference_volume)





if __name__ == "__main__":
    main()

# load_images_from_folder("\\\\10.0.16.22\\g\\ReconstructionResult\\ScanningSpeedStudy\\WalkerPassM11\\G1\\30\\WalkerPass_M11_il2_s1\\CBC\\4.84e-8\\revChambolle_295+ Non-Uni_CamByCam 3mm RRID30 iter20 ROF 4.84e-8 -2.4639--1.1825mm sw0.1 z0.011\\reconstruction\\tiff")