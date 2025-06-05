import cv2
import torch


model = torch.hub.load('ultralytics/yolov5', 'yolov5s', pretrained=True)
model.conf = 0.5  # próg ufności

# Kamera
cap = cv2.VideoCapture(0)

# Flagi i zmienne
first_stream_frame_saved = False
first_apple_person_frame_saved = False
first_stream_frame = None
first_apple_person_frame = None
apple_detected_once = False  # flaga wykrycia jabłka kiedykolwiek

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # Zapisz pierwszą klatkę z całego streamu od razu (bez wyświetlania)
    if not first_stream_frame_saved:
        first_stream_frame = frame.copy()
        first_stream_frame_saved = True
        print("Zapisano pierwszą klatkę całego streamu")

    # Detekcja YOLO
    results = model(frame)
    labels = results.names
    detections = results.pred[0]

    person_detected = False
    apple_detected = False

    for *box, conf, cls in detections:
        label = labels[int(cls)]
        if label == 'person':
            person_detected = True
        if label == 'apple':
            apple_detected = True


    if apple_detected and not apple_detected_once:
        apple_detected_once = True



    if person_detected and apple_detected and not first_apple_person_frame_saved:
        first_apple_person_frame = frame.copy()
        first_apple_person_frame_saved = True
        print("Zapisano pierwszą klatkę z osobą i jabłkiem")

    # Wyświetlanie:
    # Pierwsza klatka streamu wyświetlana tylko po wykryciu jabłka
    if apple_detected_once and first_stream_frame is not None:
        cv2.imshow('Pierwsza klatka streamu (po jabłku)', first_stream_frame)

    if first_apple_person_frame is not None:
        cv2.imshow('Pierwsza klatka z osobą i jabłkiem', first_apple_person_frame)

    cv2.imshow('CCTV Stream', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
