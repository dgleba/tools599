import argparse
from pathlib import Path
import tensorflow as tf
from PIL import Image
import numpy as np
from time import time
import csv
import shutil
import os
import datetime
import os.path
import itertools


session = None
tensor_dict = None
image_tensor = None


def get_defect_type_name(defect_id):
    if defect_id == 1:
        return 'Crack'
    elif defect_id == 2:
        return 'Chip'
    elif defect_id == 3:
        return 'Contamination'
    elif defect_id == 4:
        return 'Excess Powder'
    elif defect_id == 5:
        return 'Void'
    elif defect_id == 6:
        return 'Unknown'
    elif defect_id == 7:
        return 'Misload'
    elif defect_id == 8:
        return 'Discoloration'
    else:
        return 'Unkown'


def get_box_position(box_list, height, width):
    return (
        int(box_list[1] * width),   # X min
        int(box_list[0] * height),  # Y min
        int(box_list[3] * width),   # X max
        int(box_list[2] * height)   # Y max
    )


def open_model(model_path, gpu_memory_fraction):
    global session, tensor_dict, image_tensor

    detection_graph = tf.Graph()
    with detection_graph.as_default():
        graph_def = tf.compat.v1.GraphDef()
        with tf.io.gfile.GFile(model_path, 'rb') as graph_file:
            graph_def.ParseFromString(graph_file.read())
            tf.import_graph_def(graph_def, name='')

        config = tf.ConfigProto()
        config.gpu_options.per_process_gpu_memory_fraction = gpu_memory_fraction
        session = tf.Session(graph=detection_graph, config=config)
        ops = tf.get_default_graph().get_operations()
        all_tensor_names = {output.name for op in ops for output in op.outputs}
        tensor_dict = {}
        for key in ['num_detections', 'detection_boxes', 'detection_scores', 'detection_classes', 'detection_masks']:
            tensor_name = key + ':0'
            if tensor_name in all_tensor_names:
                tensor_dict[key] = tf.get_default_graph().get_tensor_by_name(tensor_name)

        image_tensor = tf.get_default_graph().get_tensor_by_name('image_tensor:0')


def close_model():
    global session, tensor_dict, image_tensor
    if session is not None and tensor_dict is not None and image_tensor is not None:
        session.close()
        session = None
        tensor_dict = None
        image_tensor = None


def run_inference(image):
    if session is not None and tensor_dict is not None and image_tensor is not None:
        # Format image (convert type if needed)
        if isinstance(image, list):
            image = np.array(image)
        height, width = image.shape
        image_reshaped = np.expand_dims(np.expand_dims(image, 0), 3).repeat(3, axis=3)

        # Run inference and return defects found
        output_dict = session.run(tensor_dict, feed_dict={image_tensor: image_reshaped})
        boxes = [get_box_position(box, height, width) for box in output_dict['detection_boxes'][0]]
        scores = output_dict['detection_scores'][0]
        classes = map(get_defect_type_name, output_dict['detection_classes'][0].astype('int32'))
        return sorted(list(zip(classes, scores, boxes)), key=lambda tup: tup[1], reverse=True)


if __name__ == "__main__":
    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--model_path",
        help="Path to with model file",
        required=True
    )
    parser.add_argument(
        "--image_paths",
        nargs='+',
        help="Paths to images",
        required=True
    )
    parser.add_argument(
        "--mem_frac",
        type=float,
        help="Fraction of GPU memory to use",
        required=True
    )
    args = parser.parse_args()
    image_paths = map(Path, args.image_paths)
    model_path = Path(args.model_path)
    csv_path = str(os.path.dirname(args.model_path))
    print(args.image_paths)

    
    # kludge for now to get ilst of all files in folder. David Gleba. 2022-07-15.
    imgs =list(Path(args.image_paths[0]).glob('*.*'))
    print(imgs)


    # Load model
    start = time()
    open_model(model_path.as_posix(), args.mem_frac)
    time_dif = time() - start
    print('Load Model: {} ms'.format(round(time_dif*1000)))

    # Load images
    images = []
    pics = []
    cam_name = []
    #for image_path in image_paths:
    for image_path in imgs:
        pic = os.path.basename(image_path)
        pics.append(str(image_path))
        start = time()
        image = Image.open(image_path).convert('L')
        (im_width, im_height) = image.size
        images.append(np.array(image.getdata()).reshape((im_height, im_width)).astype(np.uint8))
        time_dif = time() - start
        print('Load Image: {} ms'.format(round(time_dif*1000)))

    for n in pic:
        if n != '2':
            cam_name.append(n)
        else:
            break
    
    cam_name = ''.join(cam_name)
    datetime_now = datetime.datetime.now()
    datetime_now_format = datetime_now.strftime('%Y-%m-%d-%H-%M-%S')
    csv_filename = str(cam_name) + 'inference_' + str(datetime_now_format) + '.csv'
    csv_filepath = Path(csv_path + '\\' + csv_filename)
    csv_file = open(csv_filepath, 'w', newline='')
    csvwriter = csv.writer(csv_file)
    header = []
    Files = header.append('Filepath')
    Defecttype = header.append('Defect Type')
    Score = header.append('Score')
    Xmin = header.append('xmin')
    Ymin = header.append('ymin')
    Xmax = header.append('xmax')
    Ymax = header.append('ymax')




    csvwriter.writerow(header)
    defect_row = []
    i = 0

    # Run inference
    for image in images:
        start = time()
        defects = run_inference(image)
        for defect in defects:
            defect_row = [pics[i], defect[0], defect[1], defect[2][0],
                          defect[2][1],defect[2][2],defect[2][3]]
            csvwriter.writerow(defect_row)
            
        i = i + 1
        print(defects)
        time_dif = time() - start
        print('Inference: {} ms'.format(round(time_dif*1000)))

    # Close model
    start = time()
    close_model()
    time_dif = time() - start
    print('Close Model: {} ms'.format(round(time_dif*1000)))
    
# How to run - Python run_inference.py --model_path C:\Users\Vision\Desktop\Models\s2_top_view.pb --image_paths C:\Users\Vision\Desktop\Models\Image1.png --mem_frac 0.55






