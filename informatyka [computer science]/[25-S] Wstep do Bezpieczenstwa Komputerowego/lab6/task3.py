import cv2
import torch
import face_recognition
import numpy as np

# ==== YOLOv5 (lightweight) ====
model = torch.hub.load('ultralytics/yolov5', 'yolov5n', pretrained=True)
device = 'cuda' if torch.cuda.is_available() else 'cpu'
model.to(device)
model.conf = 0.5

# ==== Twoja twarz ====
my_image = face_recognition.load_image_file("my_face.jpg")
my_face_encoding = face_recognition.face_encodings(my_image)[0]

# ==== Kamera ====
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

# ==== Parametry ====
frame_count = 0
check_face_every = 10
detect_every = 2

# ==== Zmienne do zapisu klatek ====
first_stream_frame_saved = False
first_stream_frame = None
apple_ever_detected = False

first_person_apple_frame = None
first_person_apple_saved = False

# ==== Ostatnie detekcje ====
last_detections = []

# ==== Ostatnie wykryte twarze i enkodingi ====
last_face_locations = []
last_face_encodings = []

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_count += 1

    # Detekcja YOLO co 'detect_every' klatek
    if frame_count % detect_every == 0:
        results = model(frame)
        last_detections = results.pred[0]
    detections = last_detections
    labels = model.names

    person_detected = False
    apple_detected = False

    for *box, conf, cls in detections:
        label = labels[int(cls)]
        if label == 'person':
            person_detected = True
        if label == 'apple':
            apple_detected = True

    # Aktualizacja twarzy i enkodingów co 'check_face_every' klatek
    if frame_count % check_face_every == 0:
        rgb_small = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        last_face_locations = face_recognition.face_locations(rgb_small)
        last_face_encodings = face_recognition.face_encodings(rgb_small, last_face_locations)

    ignore_detection = False

    # Rozmywanie Twojej twarzy na każdej klatce
    for face_encoding, (top, right, bottom, left) in zip(last_face_encodings, last_face_locations):
        matches = face_recognition.compare_faces([my_face_encoding], face_encoding, tolerance=0.5)
        if True in matches:
            ignore_detection = True
            face_roi = frame[top:bottom, left:right]
            if face_roi.size > 0:
                blurred = cv2.GaussianBlur(face_roi, (99, 99), 30)
                frame[top:bottom, left:right] = blurred

    # Ustaw flagę wykrycia jabłka kiedykolwiek
    if apple_detected:
        apple_ever_detected = True

    # Zapisz pierwszą klatkę całego streamu - ale wyświetlaj ją dopiero po wykryciu jabłka
    if not first_stream_frame_saved:
        first_stream_frame = frame.copy()
        first_stream_frame_saved = True
        print("Zapisano pierwszą klatkę całego streamu")

    # Zapisz pierwszą klatkę z osobą i jabłkiem
    if person_detected and apple_detected and not first_person_apple_saved:
        first_person_apple_frame = frame.copy()
        first_person_apple_saved = True
        print("Zapisano pierwszą klatkę z osobą i jabłkiem")

    # ==== Wyświetlanie ====
    cv2.imshow('CCTV', frame)

    if apple_ever_detected and first_stream_frame is not None:
        cv2.imshow('Pierwsza klatka streamu (po wykryciu jabłka)', first_stream_frame)

    if first_person_apple_frame is not None:
        cv2.imshow('Pierwsza klatka z osobą i jabłkiem', first_person_apple_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
